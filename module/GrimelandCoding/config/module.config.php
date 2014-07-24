<?php

return array(
    'router' => array(
        'routes' => array(
         'home' => array(
                'type' => 'segment',
                'options' => array(
                    'route'    => '/[:lang]',
                    'defaults' => array(
                        'controller' => 'GrimelandCoding\Controller\Index',
                        'action'     => 'index',
			'lang'       => 'no',
                    ),
                ),
            ),
            // The following is a route to simplify getting started creating
            // new controllers and actions without needing to create a new
            // module. Simply drop new controllers in, and you can access them
            // using the path /corvax-home/:controller/:action
            'grimeland-home' => array(
                'type'    => 'segment',
                'options' => array(
                    'route'    => '[/:lang]/grimeland-coding',
                    'defaults' => array(
                        '__NAMESPACE__' => 'GrimelandCoding\Controller',
                        'controller'    => 'Index',
                        'action'        => 'index',
			'lang'          => 'no',
                    ),
                ),
                'may_terminate' => true,
                'child_routes' => array(
                    'default' => array(
                        'type'    => 'Segment',
                        'options' => array(
                            'route'    => '/[:controller[/:action]]',
                            'constraints' => array(
                                'controller' => '[a-zA-Z][a-zA-Z0-9_-]*',
                                'action'     => '[a-zA-Z][a-zA-Z0-9_-]*',
                            ),
                        ),
                    ),
                ),
            ),
        ),
    ),
    'service_manager' => array(
        'abstract_factories' => array(
            'Zend\Cache\Service\StorageCacheAbstractServiceFactory',
            'Zend\Log\LoggerAbstractServiceFactory',
        ),
        'aliases' => array(
            'translator' => 'MvcTranslator',
        ),
    ),
    'translator' => array(
        'translation_file_patterns' => array(
            array(
                'type'     => 'gettext',
                'base_dir' => __DIR__ . '/../language',
                'pattern'  => '%s.mo',
            ),
        ),
    ),
    'controllers' => array(
        'invokables' => array(
            'GrimelandCoding\Controller\Index' => 'GrimelandCoding\Controller\IndexController',
            'GrimelandCoding\Controller\Grayscale' => 'GrimelandCoding\Controller\GrayscaleController'
        ),
    ),
     'view_helpers' => array(
        'invokables'=> array(
            'get_language_parameter' => 'GrimelandCoding\View\Helper\LanguageSniffer'  
        )
    ),
    'view_manager' => array(
        'display_not_found_reason' => true,
        'display_exceptions'       => true,
        'doctype'                  => 'HTML5',
        'not_found_template'       => 'error/404',
        'exception_template'       => 'error/index',
        'template_map' => array(
            'layout/layout'           => __DIR__ . '/../view/layout/layout.phtml',
            'grimeland-coding/index/index' => __DIR__ . '/../view/grimeland-coding/index/index.phtml',
            'error/404'               => __DIR__ . '/../view/error/404.phtml',
            'error/index'             => __DIR__ . '/../view/error/index.phtml',
        ),
        'template_path_stack' => array(
            __DIR__ . '/../view',
        ),
    ),

    // Placeholder for console routes
    'console' => array(
        'router' => array(
            'routes' => array(
            ),
        ),
    ),
);
