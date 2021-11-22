Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BDFA459511
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 19:49:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233166AbhKVSwc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 13:52:32 -0500
Received: from mga04.intel.com ([192.55.52.120]:52768 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234243AbhKVSw3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Nov 2021 13:52:29 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10176"; a="233571917"
X-IronPort-AV: E=Sophos;i="5.87,255,1631602800"; 
   d="gz'50?scan'50,208,50";a="233571917"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2021 10:49:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,255,1631602800"; 
   d="gz'50?scan'50,208,50";a="537978157"
Received: from lkp-server02.sh.intel.com (HELO 9e1e9f9b3bcb) ([10.239.97.151])
  by orsmga001.jf.intel.com with ESMTP; 22 Nov 2021 10:49:00 -0800
Received: from kbuild by 9e1e9f9b3bcb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1mpEN9-0000YP-Le; Mon, 22 Nov 2021 18:48:59 +0000
Date:   Tue, 23 Nov 2021 02:48:02 +0800
From:   kernel test robot <lkp@intel.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org
Subject: Re: [PATCH v5 4/8] leds: trigger: netdev: rename and expose NETDEV
 trigger enum and struct
Message-ID: <202111230225.mS4BKY1u-lkp@intel.com>
References: <20211112153557.26941-5-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="LZvS9be/3tNcYl/X"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211112153557.26941-5-ansuelsmth@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi Ansuel,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on net/master]
[also build test ERROR on linus/master v5.16-rc2 next-20211118]
[cannot apply to pavel-leds/for-next robh/for-next net-next/master]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Ansuel-Smith/Adds-support-for-PHY-LEDs-with-offload-triggers/20211112-233807
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git 5833291ab6de9c3e2374336b51c814e515e8f3a5
config: arc-randconfig-r043-20211115 (attached as .config)
compiler: arceb-elf-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/4aa7005c8428f867be20ecd0afe4bc2ccdf6da4a
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Ansuel-Smith/Adds-support-for-PHY-LEDs-with-offload-triggers/20211112-233807
        git checkout 4aa7005c8428f867be20ecd0afe4bc2ccdf6da4a
        # save the attached .config to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=arc SHELL=/bin/bash drivers/leds/trigger/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All error/warnings (new ones prefixed by >>):

>> drivers/leds/trigger/ledtrig-netdev.c:45:39: warning: 'struct led_netdev_data' declared inside parameter list will not be visible outside of this definition or declaration
      45 | static void set_baseline_state(struct led_netdev_data *trigger_data)
         |                                       ^~~~~~~~~~~~~~~
   drivers/leds/trigger/ledtrig-netdev.c: In function 'set_baseline_state':
>> drivers/leds/trigger/ledtrig-netdev.c:48:53: error: invalid use of undefined type 'struct led_netdev_data'
      48 |         struct led_classdev *led_cdev = trigger_data->led_cdev;
         |                                                     ^~
   drivers/leds/trigger/ledtrig-netdev.c:56:26: error: invalid use of undefined type 'struct led_netdev_data'
      56 |         if (!trigger_data->carrier_link_up) {
         |                          ^~
>> drivers/leds/trigger/ledtrig-netdev.c:59:30: error: 'TRIGGER_NETDEV_LINK' undeclared (first use in this function)
      59 |                 if (test_bit(TRIGGER_NETDEV_LINK, &trigger_data->mode))
         |                              ^~~~~~~~~~~~~~~~~~~
   drivers/leds/trigger/ledtrig-netdev.c:59:30: note: each undeclared identifier is reported only once for each function it appears in
   drivers/leds/trigger/ledtrig-netdev.c:59:64: error: invalid use of undefined type 'struct led_netdev_data'
      59 |                 if (test_bit(TRIGGER_NETDEV_LINK, &trigger_data->mode))
         |                                                                ^~
>> drivers/leds/trigger/ledtrig-netdev.c:68:30: error: 'TRIGGER_NETDEV_TX' undeclared (first use in this function)
      68 |                 if (test_bit(TRIGGER_NETDEV_TX, &trigger_data->mode) ||
         |                              ^~~~~~~~~~~~~~~~~
   drivers/leds/trigger/ledtrig-netdev.c:68:62: error: invalid use of undefined type 'struct led_netdev_data'
      68 |                 if (test_bit(TRIGGER_NETDEV_TX, &trigger_data->mode) ||
         |                                                              ^~
>> drivers/leds/trigger/ledtrig-netdev.c:69:30: error: 'TRIGGER_NETDEV_RX' undeclared (first use in this function)
      69 |                     test_bit(TRIGGER_NETDEV_RX, &trigger_data->mode))
         |                              ^~~~~~~~~~~~~~~~~
   drivers/leds/trigger/ledtrig-netdev.c:69:62: error: invalid use of undefined type 'struct led_netdev_data'
      69 |                     test_bit(TRIGGER_NETDEV_RX, &trigger_data->mode))
         |                                                              ^~
   drivers/leds/trigger/ledtrig-netdev.c:70:60: error: invalid use of undefined type 'struct led_netdev_data'
      70 |                         schedule_delayed_work(&trigger_data->work, 0);
         |                                                            ^~
   drivers/leds/trigger/ledtrig-netdev.c: In function 'device_name_show':
   drivers/leds/trigger/ledtrig-netdev.c:80:35: error: invalid use of undefined type 'struct led_netdev_data'
      80 |         spin_lock_bh(&trigger_data->lock);
         |                                   ^~
   drivers/leds/trigger/ledtrig-netdev.c:81:48: error: invalid use of undefined type 'struct led_netdev_data'
      81 |         len = sprintf(buf, "%s\n", trigger_data->device_name);
         |                                                ^~
   drivers/leds/trigger/ledtrig-netdev.c:82:37: error: invalid use of undefined type 'struct led_netdev_data'
      82 |         spin_unlock_bh(&trigger_data->lock);
         |                                     ^~
   drivers/leds/trigger/ledtrig-netdev.c: In function 'device_name_store':
   drivers/leds/trigger/ledtrig-netdev.c:96:47: error: invalid use of undefined type 'struct led_netdev_data'
      96 |         cancel_delayed_work_sync(&trigger_data->work);
         |                                               ^~
   drivers/leds/trigger/ledtrig-netdev.c:98:35: error: invalid use of undefined type 'struct led_netdev_data'
      98 |         spin_lock_bh(&trigger_data->lock);
         |                                   ^~
   drivers/leds/trigger/ledtrig-netdev.c:100:25: error: invalid use of undefined type 'struct led_netdev_data'
     100 |         if (trigger_data->net_dev) {
         |                         ^~
   drivers/leds/trigger/ledtrig-netdev.c:101:37: error: invalid use of undefined type 'struct led_netdev_data'
     101 |                 dev_put(trigger_data->net_dev);
         |                                     ^~
   drivers/leds/trigger/ledtrig-netdev.c:102:29: error: invalid use of undefined type 'struct led_netdev_data'
     102 |                 trigger_data->net_dev = NULL;
         |                             ^~
   drivers/leds/trigger/ledtrig-netdev.c:105:28: error: invalid use of undefined type 'struct led_netdev_data'
     105 |         memcpy(trigger_data->device_name, buf, size);
         |                            ^~
   drivers/leds/trigger/ledtrig-netdev.c:106:21: error: invalid use of undefined type 'struct led_netdev_data'
     106 |         trigger_data->device_name[size] = 0;
         |                     ^~
   drivers/leds/trigger/ledtrig-netdev.c:107:37: error: invalid use of undefined type 'struct led_netdev_data'
     107 |         if (size > 0 && trigger_data->device_name[size - 1] == '\n')
         |                                     ^~
   drivers/leds/trigger/ledtrig-netdev.c:108:29: error: invalid use of undefined type 'struct led_netdev_data'
     108 |                 trigger_data->device_name[size - 1] = 0;
         |                             ^~
   drivers/leds/trigger/ledtrig-netdev.c:110:25: error: invalid use of undefined type 'struct led_netdev_data'
     110 |         if (trigger_data->device_name[0] != 0)
         |                         ^~
   drivers/leds/trigger/ledtrig-netdev.c:111:29: error: invalid use of undefined type 'struct led_netdev_data'
     111 |                 trigger_data->net_dev =
         |                             ^~
   drivers/leds/trigger/ledtrig-netdev.c:112:60: error: invalid use of undefined type 'struct led_netdev_data'
     112 |                     dev_get_by_name(&init_net, trigger_data->device_name);
         |                                                            ^~
   drivers/leds/trigger/ledtrig-netdev.c:114:21: error: invalid use of undefined type 'struct led_netdev_data'
     114 |         trigger_data->carrier_link_up = false;
         |                     ^~
   drivers/leds/trigger/ledtrig-netdev.c:115:25: error: invalid use of undefined type 'struct led_netdev_data'
     115 |         if (trigger_data->net_dev != NULL)
         |                         ^~
   drivers/leds/trigger/ledtrig-netdev.c:116:29: error: invalid use of undefined type 'struct led_netdev_data'
     116 |                 trigger_data->carrier_link_up = netif_carrier_ok(trigger_data->net_dev);
         |                             ^~
   drivers/leds/trigger/ledtrig-netdev.c:116:78: error: invalid use of undefined type 'struct led_netdev_data'
     116 |                 trigger_data->carrier_link_up = netif_carrier_ok(trigger_data->net_dev);
         |                                                                              ^~
   drivers/leds/trigger/ledtrig-netdev.c:118:21: error: invalid use of undefined type 'struct led_netdev_data'
     118 |         trigger_data->last_activity = 0;
         |                     ^~
>> drivers/leds/trigger/ledtrig-netdev.c:120:28: error: passing argument 1 of 'set_baseline_state' from incompatible pointer type [-Werror=incompatible-pointer-types]
     120 |         set_baseline_state(trigger_data);
         |                            ^~~~~~~~~~~~
         |                            |
         |                            struct led_netdev_data *
   drivers/leds/trigger/ledtrig-netdev.c:45:56: note: expected 'struct led_netdev_data *' but argument is of type 'struct led_netdev_data *'
      45 | static void set_baseline_state(struct led_netdev_data *trigger_data)
         |                                ~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~
   drivers/leds/trigger/ledtrig-netdev.c:121:37: error: invalid use of undefined type 'struct led_netdev_data'
     121 |         spin_unlock_bh(&trigger_data->lock);
         |                                     ^~
   drivers/leds/trigger/ledtrig-netdev.c: In function 'netdev_led_attr_show':
   drivers/leds/trigger/ledtrig-netdev.c:136:23: error: 'TRIGGER_NETDEV_LINK' undeclared (first use in this function)
     136 |                 bit = TRIGGER_NETDEV_LINK;
         |                       ^~~~~~~~~~~~~~~~~~~
   drivers/leds/trigger/ledtrig-netdev.c:139:23: error: 'TRIGGER_NETDEV_TX' undeclared (first use in this function)
     139 |                 bit = TRIGGER_NETDEV_TX;
         |                       ^~~~~~~~~~~~~~~~~
   drivers/leds/trigger/ledtrig-netdev.c:142:23: error: 'TRIGGER_NETDEV_RX' undeclared (first use in this function)
     142 |                 bit = TRIGGER_NETDEV_RX;
         |                       ^~~~~~~~~~~~~~~~~
   drivers/leds/trigger/ledtrig-netdev.c:148:64: error: invalid use of undefined type 'struct led_netdev_data'
     148 |         return sprintf(buf, "%u\n", test_bit(bit, &trigger_data->mode));
         |                                                                ^~
   drivers/leds/trigger/ledtrig-netdev.c: In function 'netdev_led_attr_store':
   drivers/leds/trigger/ledtrig-netdev.c:165:23: error: 'TRIGGER_NETDEV_LINK' undeclared (first use in this function)
     165 |                 bit = TRIGGER_NETDEV_LINK;
         |                       ^~~~~~~~~~~~~~~~~~~
   drivers/leds/trigger/ledtrig-netdev.c:168:23: error: 'TRIGGER_NETDEV_TX' undeclared (first use in this function)
     168 |                 bit = TRIGGER_NETDEV_TX;
         |                       ^~~~~~~~~~~~~~~~~
   drivers/leds/trigger/ledtrig-netdev.c:171:23: error: 'TRIGGER_NETDEV_RX' undeclared (first use in this function)
     171 |                 bit = TRIGGER_NETDEV_RX;
         |                       ^~~~~~~~~~~~~~~~~
   drivers/leds/trigger/ledtrig-netdev.c:177:47: error: invalid use of undefined type 'struct led_netdev_data'
     177 |         cancel_delayed_work_sync(&trigger_data->work);
         |                                               ^~
   drivers/leds/trigger/ledtrig-netdev.c:180:43: error: invalid use of undefined type 'struct led_netdev_data'
     180 |                 set_bit(bit, &trigger_data->mode);
         |                                           ^~
   drivers/leds/trigger/ledtrig-netdev.c:182:45: error: invalid use of undefined type 'struct led_netdev_data'
     182 |                 clear_bit(bit, &trigger_data->mode);
         |                                             ^~
   drivers/leds/trigger/ledtrig-netdev.c:184:28: error: passing argument 1 of 'set_baseline_state' from incompatible pointer type [-Werror=incompatible-pointer-types]
     184 |         set_baseline_state(trigger_data);
         |                            ^~~~~~~~~~~~
         |                            |
         |                            struct led_netdev_data *
   drivers/leds/trigger/ledtrig-netdev.c:45:56: note: expected 'struct led_netdev_data *' but argument is of type 'struct led_netdev_data *'
      45 | static void set_baseline_state(struct led_netdev_data *trigger_data)
         |                                ~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~
   drivers/leds/trigger/ledtrig-netdev.c: In function 'interval_show':
   drivers/leds/trigger/ledtrig-netdev.c:237:66: error: invalid use of undefined type 'struct led_netdev_data'
     237 |                        jiffies_to_msecs(atomic_read(&trigger_data->interval)));
         |                                                                  ^~
   drivers/leds/trigger/ledtrig-netdev.c: In function 'interval_store':
   drivers/leds/trigger/ledtrig-netdev.c:254:55: error: invalid use of undefined type 'struct led_netdev_data'
     254 |                 cancel_delayed_work_sync(&trigger_data->work);
         |                                                       ^~
   drivers/leds/trigger/ledtrig-netdev.c:256:41: error: invalid use of undefined type 'struct led_netdev_data'
     256 |                 atomic_set(&trigger_data->interval, msecs_to_jiffies(value));
         |                                         ^~
   drivers/leds/trigger/ledtrig-netdev.c:257:36: error: passing argument 1 of 'set_baseline_state' from incompatible pointer type [-Werror=incompatible-pointer-types]
     257 |                 set_baseline_state(trigger_data);       /* resets timer */
         |                                    ^~~~~~~~~~~~
         |                                    |
         |                                    struct led_netdev_data *
   drivers/leds/trigger/ledtrig-netdev.c:45:56: note: expected 'struct led_netdev_data *' but argument is of type 'struct led_netdev_data *'
      45 | static void set_baseline_state(struct led_netdev_data *trigger_data)
         |                                ~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~
   In file included from arch/arc/include/asm/cmpxchg.h:9,
                    from arch/arc/include/asm/atomic.h:13,
                    from include/linux/atomic.h:7,
                    from drivers/leds/trigger/ledtrig-netdev.c:13:
   drivers/leds/trigger/ledtrig-netdev.c: In function 'netdev_trig_notify':
>> include/linux/container_of.h:19:54: error: invalid use of undefined type 'struct led_netdev_data'
      19 |         static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
         |                                                      ^~
   include/linux/build_bug.h:78:56: note: in definition of macro '__static_assert'
      78 | #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
         |                                                        ^~~~
   include/linux/container_of.h:19:9: note: in expansion of macro 'static_assert'
      19 |         static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
         |         ^~~~~~~~~~~~~
   include/linux/container_of.h:19:23: note: in expansion of macro '__same_type'
      19 |         static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
         |                       ^~~~~~~~~~~
   drivers/leds/trigger/ledtrig-netdev.c:281:17: note: in expansion of macro 'container_of'
     281 |                 container_of(nb, struct led_netdev_data, notifier);
         |                 ^~~~~~~~~~~~
>> include/linux/compiler_types.h:276:27: error: expression in static assertion is not an integer
     276 | #define __same_type(a, b) __builtin_types_compatible_p(typeof(a), typeof(b))
         |                           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:78:56: note: in definition of macro '__static_assert'
      78 | #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
         |                                                        ^~~~
   include/linux/container_of.h:19:9: note: in expansion of macro 'static_assert'
      19 |         static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
         |         ^~~~~~~~~~~~~
   include/linux/container_of.h:19:23: note: in expansion of macro '__same_type'
      19 |         static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
         |                       ^~~~~~~~~~~
   drivers/leds/trigger/ledtrig-netdev.c:281:17: note: in expansion of macro 'container_of'
     281 |                 container_of(nb, struct led_netdev_data, notifier);
         |                 ^~~~~~~~~~~~
   In file included from <command-line>:
>> include/linux/compiler_types.h:140:41: error: invalid use of undefined type 'struct led_netdev_data'
     140 | #define __compiler_offsetof(a, b)       __builtin_offsetof(a, b)
         |                                         ^~~~~~~~~~~~~~~~~~
   include/linux/stddef.h:17:33: note: in expansion of macro '__compiler_offsetof'
      17 | #define offsetof(TYPE, MEMBER)  __compiler_offsetof(TYPE, MEMBER)
         |                                 ^~~~~~~~~~~~~~~~~~~
   include/linux/container_of.h:22:28: note: in expansion of macro 'offsetof'
      22 |         ((type *)(__mptr - offsetof(type, member))); })
         |                            ^~~~~~~~
   drivers/leds/trigger/ledtrig-netdev.c:281:17: note: in expansion of macro 'container_of'
     281 |                 container_of(nb, struct led_netdev_data, notifier);
         |                 ^~~~~~~~~~~~
   drivers/leds/trigger/ledtrig-netdev.c:288:34: error: invalid use of undefined type 'struct led_netdev_data'
     288 |         if (!(dev == trigger_data->net_dev ||
         |                                  ^~
   drivers/leds/trigger/ledtrig-netdev.c:289:75: error: invalid use of undefined type 'struct led_netdev_data'
     289 |               (evt == NETDEV_CHANGENAME && !strcmp(dev->name, trigger_data->device_name)) ||
         |                                                                           ^~
   drivers/leds/trigger/ledtrig-netdev.c:290:73: error: invalid use of undefined type 'struct led_netdev_data'
     290 |               (evt == NETDEV_REGISTER && !strcmp(dev->name, trigger_data->device_name))))
         |                                                                         ^~
   drivers/leds/trigger/ledtrig-netdev.c:293:47: error: invalid use of undefined type 'struct led_netdev_data'
     293 |         cancel_delayed_work_sync(&trigger_data->work);
         |                                               ^~
   drivers/leds/trigger/ledtrig-netdev.c:295:35: error: invalid use of undefined type 'struct led_netdev_data'
     295 |         spin_lock_bh(&trigger_data->lock);
         |                                   ^~
   drivers/leds/trigger/ledtrig-netdev.c:297:21: error: invalid use of undefined type 'struct led_netdev_data'
     297 |         trigger_data->carrier_link_up = false;
         |                     ^~
   drivers/leds/trigger/ledtrig-netdev.c:301:33: error: invalid use of undefined type 'struct led_netdev_data'
     301 |                 if (trigger_data->net_dev)
         |                                 ^~
   drivers/leds/trigger/ledtrig-netdev.c:302:45: error: invalid use of undefined type 'struct led_netdev_data'
     302 |                         dev_put(trigger_data->net_dev);
         |                                             ^~
   drivers/leds/trigger/ledtrig-netdev.c:304:29: error: invalid use of undefined type 'struct led_netdev_data'
     304 |                 trigger_data->net_dev = dev;
         |                             ^~
   drivers/leds/trigger/ledtrig-netdev.c:307:37: error: invalid use of undefined type 'struct led_netdev_data'
     307 |                 dev_put(trigger_data->net_dev);
         |                                     ^~
   drivers/leds/trigger/ledtrig-netdev.c:308:29: error: invalid use of undefined type 'struct led_netdev_data'
     308 |                 trigger_data->net_dev = NULL;
         |                             ^~
   drivers/leds/trigger/ledtrig-netdev.c:312:29: error: invalid use of undefined type 'struct led_netdev_data'
     312 |                 trigger_data->carrier_link_up = netif_carrier_ok(dev);
         |                             ^~
   drivers/leds/trigger/ledtrig-netdev.c:316:28: error: passing argument 1 of 'set_baseline_state' from incompatible pointer type [-Werror=incompatible-pointer-types]
     316 |         set_baseline_state(trigger_data);
         |                            ^~~~~~~~~~~~
         |                            |
         |                            struct led_netdev_data *
   drivers/leds/trigger/ledtrig-netdev.c:45:56: note: expected 'struct led_netdev_data *' but argument is of type 'struct led_netdev_data *'
      45 | static void set_baseline_state(struct led_netdev_data *trigger_data)
         |                                ~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~
   drivers/leds/trigger/ledtrig-netdev.c:318:37: error: invalid use of undefined type 'struct led_netdev_data'
     318 |         spin_unlock_bh(&trigger_data->lock);
         |                                     ^~
   In file included from arch/arc/include/asm/cmpxchg.h:9,
                    from arch/arc/include/asm/atomic.h:13,
                    from include/linux/atomic.h:7,
                    from drivers/leds/trigger/ledtrig-netdev.c:13:
   drivers/leds/trigger/ledtrig-netdev.c: In function 'netdev_trig_work':
>> include/linux/container_of.h:19:54: error: invalid use of undefined type 'struct led_netdev_data'
      19 |         static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
         |                                                      ^~
   include/linux/build_bug.h:78:56: note: in definition of macro '__static_assert'
      78 | #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
         |                                                        ^~~~
   include/linux/container_of.h:19:9: note: in expansion of macro 'static_assert'
      19 |         static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
         |         ^~~~~~~~~~~~~
   include/linux/container_of.h:19:23: note: in expansion of macro '__same_type'
      19 |         static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
         |                       ^~~~~~~~~~~
   drivers/leds/trigger/ledtrig-netdev.c:327:17: note: in expansion of macro 'container_of'
     327 |                 container_of(work, struct led_netdev_data, work.work);
         |                 ^~~~~~~~~~~~
>> include/linux/compiler_types.h:276:27: error: expression in static assertion is not an integer
     276 | #define __same_type(a, b) __builtin_types_compatible_p(typeof(a), typeof(b))
         |                           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:78:56: note: in definition of macro '__static_assert'
      78 | #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
         |                                                        ^~~~
   include/linux/container_of.h:19:9: note: in expansion of macro 'static_assert'
      19 |         static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
         |         ^~~~~~~~~~~~~
   include/linux/container_of.h:19:23: note: in expansion of macro '__same_type'
      19 |         static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
         |                       ^~~~~~~~~~~
   drivers/leds/trigger/ledtrig-netdev.c:327:17: note: in expansion of macro 'container_of'
     327 |                 container_of(work, struct led_netdev_data, work.work);
         |                 ^~~~~~~~~~~~
   In file included from <command-line>:
>> include/linux/compiler_types.h:140:41: error: invalid use of undefined type 'struct led_netdev_data'
     140 | #define __compiler_offsetof(a, b)       __builtin_offsetof(a, b)
         |                                         ^~~~~~~~~~~~~~~~~~
   include/linux/stddef.h:17:33: note: in expansion of macro '__compiler_offsetof'
      17 | #define offsetof(TYPE, MEMBER)  __compiler_offsetof(TYPE, MEMBER)
         |                                 ^~~~~~~~~~~~~~~~~~~
   include/linux/container_of.h:22:28: note: in expansion of macro 'offsetof'
      22 |         ((type *)(__mptr - offsetof(type, member))); })
         |                            ^~~~~~~~
   drivers/leds/trigger/ledtrig-netdev.c:327:17: note: in expansion of macro 'container_of'
     327 |                 container_of(work, struct led_netdev_data, work.work);
         |                 ^~~~~~~~~~~~
   drivers/leds/trigger/ledtrig-netdev.c:335:26: error: invalid use of undefined type 'struct led_netdev_data'
     335 |         if (!trigger_data->net_dev) {
         |                          ^~
   drivers/leds/trigger/ledtrig-netdev.c:336:48: error: invalid use of undefined type 'struct led_netdev_data'
     336 |                 led_set_brightness(trigger_data->led_cdev, LED_OFF);
         |                                                ^~
   drivers/leds/trigger/ledtrig-netdev.c:341:23: error: 'TRIGGER_NETDEV_TX' undeclared (first use in this function)
     341 |         if (!test_bit(TRIGGER_NETDEV_TX, &trigger_data->mode) &&
         |                       ^~~~~~~~~~~~~~~~~
   drivers/leds/trigger/ledtrig-netdev.c:341:55: error: invalid use of undefined type 'struct led_netdev_data'
     341 |         if (!test_bit(TRIGGER_NETDEV_TX, &trigger_data->mode) &&
         |                                                       ^~
   drivers/leds/trigger/ledtrig-netdev.c:342:23: error: 'TRIGGER_NETDEV_RX' undeclared (first use in this function)
     342 |             !test_bit(TRIGGER_NETDEV_RX, &trigger_data->mode))
         |                       ^~~~~~~~~~~~~~~~~
   drivers/leds/trigger/ledtrig-netdev.c:342:55: error: invalid use of undefined type 'struct led_netdev_data'
     342 |             !test_bit(TRIGGER_NETDEV_RX, &trigger_data->mode))
         |                                                       ^~
   drivers/leds/trigger/ledtrig-netdev.c:345:47: error: invalid use of undefined type 'struct led_netdev_data'
     345 |         dev_stats = dev_get_stats(trigger_data->net_dev, &temp);
         |                                               ^~
   drivers/leds/trigger/ledtrig-netdev.c:347:55: error: invalid use of undefined type 'struct led_netdev_data'
     347 |             (test_bit(TRIGGER_NETDEV_TX, &trigger_data->mode) ?
         |                                                       ^~
   drivers/leds/trigger/ledtrig-netdev.c:349:55: error: invalid use of undefined type 'struct led_netdev_data'
     349 |             (test_bit(TRIGGER_NETDEV_RX, &trigger_data->mode) ?
         |                                                       ^~
   drivers/leds/trigger/ledtrig-netdev.c:352:25: error: invalid use of undefined type 'struct led_netdev_data'
     352 |         if (trigger_data->last_activity != new_activity) {
         |                         ^~
   drivers/leds/trigger/ledtrig-netdev.c:353:53: error: invalid use of undefined type 'struct led_netdev_data'
     353 |                 led_stop_software_blink(trigger_data->led_cdev);
         |                                                     ^~
   drivers/leds/trigger/ledtrig-netdev.c:355:35: error: 'TRIGGER_NETDEV_LINK' undeclared (first use in this function)
     355 |                 invert = test_bit(TRIGGER_NETDEV_LINK, &trigger_data->mode);
         |                                   ^~~~~~~~~~~~~~~~~~~
   drivers/leds/trigger/ledtrig-netdev.c:355:69: error: invalid use of undefined type 'struct led_netdev_data'
     355 |                 invert = test_bit(TRIGGER_NETDEV_LINK, &trigger_data->mode);
         |                                                                     ^~
   drivers/leds/trigger/ledtrig-netdev.c:357:58: error: invalid use of undefined type 'struct led_netdev_data'
     357 |                                 atomic_read(&trigger_data->interval));
         |                                                          ^~
   drivers/leds/trigger/ledtrig-netdev.c:359:51: error: invalid use of undefined type 'struct led_netdev_data'
     359 |                 led_blink_set_oneshot(trigger_data->led_cdev,
         |                                                   ^~
   drivers/leds/trigger/ledtrig-netdev.c:363:29: error: invalid use of undefined type 'struct led_netdev_data'
     363 |                 trigger_data->last_activity = new_activity;
         |                             ^~
   drivers/leds/trigger/ledtrig-netdev.c:366:44: error: invalid use of undefined type 'struct led_netdev_data'
     366 |         schedule_delayed_work(&trigger_data->work,
         |                                            ^~
   drivers/leds/trigger/ledtrig-netdev.c:367:51: error: invalid use of undefined type 'struct led_netdev_data'
     367 |                         (atomic_read(&trigger_data->interval)*2));
         |                                                   ^~
   drivers/leds/trigger/ledtrig-netdev.c: In function 'netdev_trig_activate':
>> drivers/leds/trigger/ledtrig-netdev.c:375:39: error: invalid application of 'sizeof' to incomplete type 'struct led_netdev_data'
     375 |         trigger_data = kzalloc(sizeof(struct led_netdev_data), GFP_KERNEL);
         |                                       ^~~~~~
   In file included from include/linux/wait.h:9,
                    from include/linux/pid.h:6,
                    from include/linux/sched.h:14,
                    from include/linux/ratelimit.h:6,
                    from include/linux/dev_printk.h:16,
                    from include/linux/device.h:15,
                    from drivers/leds/trigger/ledtrig-netdev.c:15:
   drivers/leds/trigger/ledtrig-netdev.c:379:37: error: invalid use of undefined type 'struct led_netdev_data'
     379 |         spin_lock_init(&trigger_data->lock);
         |                                     ^~
   include/linux/spinlock.h:333:45: note: in definition of macro 'spin_lock_init'
     333 |         __raw_spin_lock_init(spinlock_check(lock),              \
         |                                             ^~~~
   drivers/leds/trigger/ledtrig-netdev.c:381:21: error: invalid use of undefined type 'struct led_netdev_data'
     381 |         trigger_data->notifier.notifier_call = netdev_trig_notify;
         |                     ^~
   drivers/leds/trigger/ledtrig-netdev.c:382:21: error: invalid use of undefined type 'struct led_netdev_data'
     382 |         trigger_data->notifier.priority = 10;
         |                     ^~
   In file included from include/linux/rhashtable-types.h:15,
                    from include/linux/ipc.h:7,
                    from include/uapi/linux/sem.h:5,
                    from include/linux/sem.h:5,
                    from include/linux/sched.h:15,
                    from include/linux/ratelimit.h:6,
                    from include/linux/dev_printk.h:16,
                    from include/linux/device.h:15,
                    from drivers/leds/trigger/ledtrig-netdev.c:15:
   drivers/leds/trigger/ledtrig-netdev.c:384:40: error: invalid use of undefined type 'struct led_netdev_data'
     384 |         INIT_DELAYED_WORK(&trigger_data->work, netdev_trig_work);
         |                                        ^~
   include/linux/workqueue.h:228:30: note: in definition of macro '__INIT_WORK'
     228 |                 __init_work((_work), _onstack);                         \
         |                              ^~~~~
   include/linux/workqueue.h:252:17: note: in expansion of macro 'INIT_WORK'
     252 |                 INIT_WORK(&(_work)->work, (_func));                     \
         |                 ^~~~~~~~~
   include/linux/workqueue.h:267:9: note: in expansion of macro '__INIT_DELAYED_WORK'
     267 |         __INIT_DELAYED_WORK(_work, _func, 0)
         |         ^~~~~~~~~~~~~~~~~~~
   drivers/leds/trigger/ledtrig-netdev.c:384:9: note: in expansion of macro 'INIT_DELAYED_WORK'
     384 |         INIT_DELAYED_WORK(&trigger_data->work, netdev_trig_work);
         |         ^~~~~~~~~~~~~~~~~
   drivers/leds/trigger/ledtrig-netdev.c:384:40: error: invalid use of undefined type 'struct led_netdev_data'
     384 |         INIT_DELAYED_WORK(&trigger_data->work, netdev_trig_work);
         |                                        ^~
   include/linux/workqueue.h:229:18: note: in definition of macro '__INIT_WORK'
     229 |                 (_work)->data = (atomic_long_t) WORK_DATA_INIT();       \
         |                  ^~~~~
   include/linux/workqueue.h:252:17: note: in expansion of macro 'INIT_WORK'
     252 |                 INIT_WORK(&(_work)->work, (_func));                     \
         |                 ^~~~~~~~~
   include/linux/workqueue.h:267:9: note: in expansion of macro '__INIT_DELAYED_WORK'
     267 |         __INIT_DELAYED_WORK(_work, _func, 0)
         |         ^~~~~~~~~~~~~~~~~~~
   drivers/leds/trigger/ledtrig-netdev.c:384:9: note: in expansion of macro 'INIT_DELAYED_WORK'
     384 |         INIT_DELAYED_WORK(&trigger_data->work, netdev_trig_work);
         |         ^~~~~~~~~~~~~~~~~
   drivers/leds/trigger/ledtrig-netdev.c:384:40: error: invalid use of undefined type 'struct led_netdev_data'
     384 |         INIT_DELAYED_WORK(&trigger_data->work, netdev_trig_work);
         |                                        ^~
   include/linux/workqueue.h:230:36: note: in definition of macro '__INIT_WORK'
     230 |                 lockdep_init_map(&(_work)->lockdep_map, "(work_completion)"#_work, &__key, 0); \
         |                                    ^~~~~
   include/linux/workqueue.h:252:17: note: in expansion of macro 'INIT_WORK'
     252 |                 INIT_WORK(&(_work)->work, (_func));                     \
         |                 ^~~~~~~~~
   include/linux/workqueue.h:267:9: note: in expansion of macro '__INIT_DELAYED_WORK'
     267 |         __INIT_DELAYED_WORK(_work, _func, 0)
         |         ^~~~~~~~~~~~~~~~~~~
   drivers/leds/trigger/ledtrig-netdev.c:384:9: note: in expansion of macro 'INIT_DELAYED_WORK'
     384 |         INIT_DELAYED_WORK(&trigger_data->work, netdev_trig_work);
         |         ^~~~~~~~~~~~~~~~~
   drivers/leds/trigger/ledtrig-netdev.c:384:40: error: invalid use of undefined type 'struct led_netdev_data'
     384 |         INIT_DELAYED_WORK(&trigger_data->work, netdev_trig_work);
         |                                        ^~
   include/linux/workqueue.h:231:34: note: in definition of macro '__INIT_WORK'
     231 |                 INIT_LIST_HEAD(&(_work)->entry);                        \
         |                                  ^~~~~
   include/linux/workqueue.h:252:17: note: in expansion of macro 'INIT_WORK'
     252 |                 INIT_WORK(&(_work)->work, (_func));                     \
         |                 ^~~~~~~~~
   include/linux/workqueue.h:267:9: note: in expansion of macro '__INIT_DELAYED_WORK'
     267 |         __INIT_DELAYED_WORK(_work, _func, 0)
         |         ^~~~~~~~~~~~~~~~~~~
   drivers/leds/trigger/ledtrig-netdev.c:384:9: note: in expansion of macro 'INIT_DELAYED_WORK'
     384 |         INIT_DELAYED_WORK(&trigger_data->work, netdev_trig_work);
         |         ^~~~~~~~~~~~~~~~~
   drivers/leds/trigger/ledtrig-netdev.c:384:40: error: invalid use of undefined type 'struct led_netdev_data'
     384 |         INIT_DELAYED_WORK(&trigger_data->work, netdev_trig_work);
         |                                        ^~
   include/linux/workqueue.h:232:18: note: in definition of macro '__INIT_WORK'
     232 |                 (_work)->func = (_func);                                \
         |                  ^~~~~
   include/linux/workqueue.h:252:17: note: in expansion of macro 'INIT_WORK'
     252 |                 INIT_WORK(&(_work)->work, (_func));                     \
         |                 ^~~~~~~~~
   include/linux/workqueue.h:267:9: note: in expansion of macro '__INIT_DELAYED_WORK'


vim +48 drivers/leds/trigger/ledtrig-netdev.c

06f502f57d0d77 Ben Whitten      2017-12-10   44  
06f502f57d0d77 Ben Whitten      2017-12-10  @45  static void set_baseline_state(struct led_netdev_data *trigger_data)
06f502f57d0d77 Ben Whitten      2017-12-10   46  {
06f502f57d0d77 Ben Whitten      2017-12-10   47  	int current_brightness;
06f502f57d0d77 Ben Whitten      2017-12-10  @48  	struct led_classdev *led_cdev = trigger_data->led_cdev;
06f502f57d0d77 Ben Whitten      2017-12-10   49  
06f502f57d0d77 Ben Whitten      2017-12-10   50  	current_brightness = led_cdev->brightness;
06f502f57d0d77 Ben Whitten      2017-12-10   51  	if (current_brightness)
06f502f57d0d77 Ben Whitten      2017-12-10   52  		led_cdev->blink_brightness = current_brightness;
06f502f57d0d77 Ben Whitten      2017-12-10   53  	if (!led_cdev->blink_brightness)
06f502f57d0d77 Ben Whitten      2017-12-10   54  		led_cdev->blink_brightness = led_cdev->max_brightness;
06f502f57d0d77 Ben Whitten      2017-12-10   55  
df437de7347286 Ansuel Smith     2021-11-12   56  	if (!trigger_data->carrier_link_up) {
06f502f57d0d77 Ben Whitten      2017-12-10   57  		led_set_brightness(led_cdev, LED_OFF);
df437de7347286 Ansuel Smith     2021-11-12   58  	} else {
4aa7005c8428f8 Ansuel Smith     2021-11-12  @59  		if (test_bit(TRIGGER_NETDEV_LINK, &trigger_data->mode))
06f502f57d0d77 Ben Whitten      2017-12-10   60  			led_set_brightness(led_cdev,
06f502f57d0d77 Ben Whitten      2017-12-10   61  					   led_cdev->blink_brightness);
06f502f57d0d77 Ben Whitten      2017-12-10   62  		else
06f502f57d0d77 Ben Whitten      2017-12-10   63  			led_set_brightness(led_cdev, LED_OFF);
06f502f57d0d77 Ben Whitten      2017-12-10   64  
06f502f57d0d77 Ben Whitten      2017-12-10   65  		/* If we are looking for RX/TX start periodically
06f502f57d0d77 Ben Whitten      2017-12-10   66  		 * checking stats
06f502f57d0d77 Ben Whitten      2017-12-10   67  		 */
4aa7005c8428f8 Ansuel Smith     2021-11-12  @68  		if (test_bit(TRIGGER_NETDEV_TX, &trigger_data->mode) ||
4aa7005c8428f8 Ansuel Smith     2021-11-12  @69  		    test_bit(TRIGGER_NETDEV_RX, &trigger_data->mode))
06f502f57d0d77 Ben Whitten      2017-12-10   70  			schedule_delayed_work(&trigger_data->work, 0);
06f502f57d0d77 Ben Whitten      2017-12-10   71  	}
06f502f57d0d77 Ben Whitten      2017-12-10   72  }
06f502f57d0d77 Ben Whitten      2017-12-10   73  
06f502f57d0d77 Ben Whitten      2017-12-10   74  static ssize_t device_name_show(struct device *dev,
06f502f57d0d77 Ben Whitten      2017-12-10   75  				struct device_attribute *attr, char *buf)
06f502f57d0d77 Ben Whitten      2017-12-10   76  {
f8112a1de1a728 Uwe Kleine-König 2018-07-02   77  	struct led_netdev_data *trigger_data = led_trigger_get_drvdata(dev);
06f502f57d0d77 Ben Whitten      2017-12-10   78  	ssize_t len;
06f502f57d0d77 Ben Whitten      2017-12-10   79  
06f502f57d0d77 Ben Whitten      2017-12-10   80  	spin_lock_bh(&trigger_data->lock);
06f502f57d0d77 Ben Whitten      2017-12-10   81  	len = sprintf(buf, "%s\n", trigger_data->device_name);
06f502f57d0d77 Ben Whitten      2017-12-10   82  	spin_unlock_bh(&trigger_data->lock);
06f502f57d0d77 Ben Whitten      2017-12-10   83  
06f502f57d0d77 Ben Whitten      2017-12-10   84  	return len;
06f502f57d0d77 Ben Whitten      2017-12-10   85  }
06f502f57d0d77 Ben Whitten      2017-12-10   86  
06f502f57d0d77 Ben Whitten      2017-12-10   87  static ssize_t device_name_store(struct device *dev,
06f502f57d0d77 Ben Whitten      2017-12-10   88  				 struct device_attribute *attr, const char *buf,
06f502f57d0d77 Ben Whitten      2017-12-10   89  				 size_t size)
06f502f57d0d77 Ben Whitten      2017-12-10   90  {
f8112a1de1a728 Uwe Kleine-König 2018-07-02   91  	struct led_netdev_data *trigger_data = led_trigger_get_drvdata(dev);
06f502f57d0d77 Ben Whitten      2017-12-10   92  
06f502f57d0d77 Ben Whitten      2017-12-10   93  	if (size >= IFNAMSIZ)
06f502f57d0d77 Ben Whitten      2017-12-10   94  		return -EINVAL;
06f502f57d0d77 Ben Whitten      2017-12-10   95  
06f502f57d0d77 Ben Whitten      2017-12-10   96  	cancel_delayed_work_sync(&trigger_data->work);
06f502f57d0d77 Ben Whitten      2017-12-10   97  
06f502f57d0d77 Ben Whitten      2017-12-10   98  	spin_lock_bh(&trigger_data->lock);
06f502f57d0d77 Ben Whitten      2017-12-10   99  
06f502f57d0d77 Ben Whitten      2017-12-10  100  	if (trigger_data->net_dev) {
06f502f57d0d77 Ben Whitten      2017-12-10  101  		dev_put(trigger_data->net_dev);
06f502f57d0d77 Ben Whitten      2017-12-10  102  		trigger_data->net_dev = NULL;
06f502f57d0d77 Ben Whitten      2017-12-10  103  	}
06f502f57d0d77 Ben Whitten      2017-12-10  104  
909346433064b8 Rasmus Villemoes 2019-03-14  105  	memcpy(trigger_data->device_name, buf, size);
909346433064b8 Rasmus Villemoes 2019-03-14  106  	trigger_data->device_name[size] = 0;
06f502f57d0d77 Ben Whitten      2017-12-10  107  	if (size > 0 && trigger_data->device_name[size - 1] == '\n')
06f502f57d0d77 Ben Whitten      2017-12-10  108  		trigger_data->device_name[size - 1] = 0;
06f502f57d0d77 Ben Whitten      2017-12-10  109  
06f502f57d0d77 Ben Whitten      2017-12-10  110  	if (trigger_data->device_name[0] != 0)
06f502f57d0d77 Ben Whitten      2017-12-10  111  		trigger_data->net_dev =
06f502f57d0d77 Ben Whitten      2017-12-10  112  		    dev_get_by_name(&init_net, trigger_data->device_name);
06f502f57d0d77 Ben Whitten      2017-12-10  113  
df437de7347286 Ansuel Smith     2021-11-12  114  	trigger_data->carrier_link_up = false;
06f502f57d0d77 Ben Whitten      2017-12-10  115  	if (trigger_data->net_dev != NULL)
df437de7347286 Ansuel Smith     2021-11-12  116  		trigger_data->carrier_link_up = netif_carrier_ok(trigger_data->net_dev);
06f502f57d0d77 Ben Whitten      2017-12-10  117  
06f502f57d0d77 Ben Whitten      2017-12-10  118  	trigger_data->last_activity = 0;
06f502f57d0d77 Ben Whitten      2017-12-10  119  
06f502f57d0d77 Ben Whitten      2017-12-10 @120  	set_baseline_state(trigger_data);
06f502f57d0d77 Ben Whitten      2017-12-10  121  	spin_unlock_bh(&trigger_data->lock);
06f502f57d0d77 Ben Whitten      2017-12-10  122  
06f502f57d0d77 Ben Whitten      2017-12-10  123  	return size;
06f502f57d0d77 Ben Whitten      2017-12-10  124  }
06f502f57d0d77 Ben Whitten      2017-12-10  125  

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--LZvS9be/3tNcYl/X
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
nOT/D4o1qcZBqgIA

--LZvS9be/3tNcYl/X--
