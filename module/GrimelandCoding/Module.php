<?php

namespace GrimelandCoding;

use Zend\Mvc\ModuleRouteListener;
use Zend\Mvc\MvcEvent;

class Module
{
    public function onBootstrap(MvcEvent $e)
    {
	$eventManagerWithCallback = $this->setRouteCallback($e);
        $moduleRouteListener = new ModuleRouteListener();
        $moduleRouteListener->attach($eventManagerWithCallback);
    }

    private function setRouteCallback($e) 
    {
        $eventManager = $e->getApplication()->getEventManager();
        $routeCallback = function ($e) {
            $availableLanguages = array ('no' => 'nb_NO', 
	    			  	 'en' => 'en_GB' );
            $defaultLanguage = 'en';
            $language = "";
            $fromRoute = false;
            //see if language could be find in url
            if ($e->getRouteMatch()->getParam('lang')) {
                $language = $e->getRouteMatch()->getParam('lang');
                $fromRoute = true;
                //or use language from http accept
            } else {
                $headers = $e->getApplication()->getRequest()->getHeaders();
                if ($headers->has('Accept-Language')) {
                    $headerLocale = $headers->get('Accept-Language')->getPrioritized();
                    $language = substr($headerLocale[0]->getLanguage(), 0,2);
                }
            }
            if(!$availableLanguages[$language]) {
                $language = $defaultLanguage;
            }
	    $locale = $availableLanguages[$language];
	    $translator = $e->getApplication()->getServiceManager()->get('translator');
	    $translator->setLocale($locale);
        };

        $eventManager->attach(\Zend\Mvc\MvcEvent::EVENT_ROUTE, $routeCallback);
	return $eventManager;
    }

    public function getConfig()
    {
        return include __DIR__ . '/config/module.config.php';
    }

    public function getAutoloaderConfig()
    {
        return array(
            'Zend\Loader\StandardAutoloader' => array(
                'namespaces' => array(
                    __NAMESPACE__ => __DIR__ . '/src/' . __NAMESPACE__,
                ),
            ),
        );
    }
}
