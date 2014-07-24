<?php

namespace GrimelandCoding\View\Helper;
use Zend\View\Helper\AbstractHelper;
use Zend\ServiceManager\ServiceLocatorInterface;
use Zend\ServiceManager\ServiceLocatorAwareInterface;
 
class LanguageSniffer extends AbstractHelper implements ServiceLocatorAwareInterface 
{
	protected $serviceLocator;
	
    public function __invoke()
    {	
	$router = $this->getServiceLocator()->get('router');
	$request = $this->getServiceLocator()->get('request');
	$routeMatch = $router->match($request);
	$languageKey = $routeMatch->getParam('lang') == 'en' ? 'gb' : $routeMatch->getParam('lang');
	return $languageKey;
    }

    public function setServiceLocator(ServiceLocatorInterface $helperPluginManager)
    {
	$this->serviceLocator = $helperPluginManager->getServiceLocator();  
    }

    public function getServiceLocator()
    {	
        return $this->serviceLocator;
    }
 
}
