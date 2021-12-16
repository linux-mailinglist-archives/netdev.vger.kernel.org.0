Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4A95476E8B
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 11:09:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235717AbhLPKJA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 05:09:00 -0500
Received: from mga05.intel.com ([192.55.52.43]:21580 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235690AbhLPKJA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Dec 2021 05:09:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639649340; x=1671185340;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=tqah6DYJkyMXNTY6GJFvv3m8z80hgcgkKkPwKQQ0upY=;
  b=QVdyg9O/Z5eDKPDZMzckj1S5zbBsSmNmPOYuFeNY/YlQlwq2suAX97HO
   b+Dvb74YBp8TbSvdMdza1WYaoqfV6hwSAG/SZ3TE3sw8jgnNucCWnPYaL
   OAsFzdEVEYe/7K+dRklySo3QJVEQ/1L4R7P7x6ia2BNNh98ki/2m7Y/pt
   NBlm+A8q6jVzwaOkXhtpwOURySyedDRQVa9FQSlBowUBpIgO9lFtqFK1c
   dyI0p1iboQwdC88RHxWW1m/Lujr6PYykHgrPNfIq3NouPh6HKRZ9qhl3z
   3yOLUj84z5YcHaqhUWrcflFdP17JdvGMwKmQDMyu9G+jymOEJBpWpoSxg
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10199"; a="325735012"
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="325735012"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2021 02:08:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="464620434"
Received: from lkp-server02.sh.intel.com (HELO 9f38c0981d9f) ([10.239.97.151])
  by orsmga003.jf.intel.com with ESMTP; 16 Dec 2021 02:08:56 -0800
Received: from kbuild by 9f38c0981d9f with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1mxnh1-00030I-KV; Thu, 16 Dec 2021 10:08:55 +0000
Date:   Thu, 16 Dec 2021 18:08:46 +0800
From:   kernel test robot <lkp@intel.com>
To:     Manish Mandlik <mmandlik@google.com>, marcel@holtmann.org,
        luiz.dentz@gmail.com
Cc:     kbuild-all@lists.01.org,
        chromeos-bluetooth-upstreaming@chromium.org,
        linux-bluetooth@vger.kernel.org,
        Manish Mandlik <mmandlik@google.com>,
        Miao-chen Chou <mcchou@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v8 1/3] bluetooth: msft: Handle MSFT Monitor Device Event
Message-ID: <202112161736.WMgjxclO-lkp@intel.com>
References: <20211215203919.v8.1.Ic0a40b84dee3825302890aaea690e73165c71820@changeid>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211215203919.v8.1.Ic0a40b84dee3825302890aaea690e73165c71820@changeid>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Manish,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on bluetooth-next/master]
[also build test ERROR on next-20211215]
[cannot apply to bluetooth/master v5.16-rc5]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Manish-Mandlik/bluetooth-msft-Handle-MSFT-Monitor-Device-Event/20211216-124056
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git master
config: arc-randconfig-r043-20211216 (https://download.01.org/0day-ci/archive/20211216/202112161736.WMgjxclO-lkp@intel.com/config)
compiler: arc-elf-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/db0604d7b0d0308963bdc1465b486be11d5fdcb6
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Manish-Mandlik/bluetooth-msft-Handle-MSFT-Monitor-Device-Event/20211216-124056
        git checkout db0604d7b0d0308963bdc1465b486be11d5fdcb6
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=arc SHELL=/bin/bash net/bluetooth/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from include/linux/wait.h:7,
                    from include/linux/poll.h:8,
                    from include/net/bluetooth/bluetooth.h:28,
                    from net/bluetooth/msft.c:6:
   net/bluetooth/msft.c: In function 'msft_le_cancel_monitor_advertisement_cb':
>> net/bluetooth/msft.c:306:42: error: 'dev' undeclared (first use in this function); did you mean 'hdev'?
     306 |                 list_for_each_entry_safe(dev, tmp, &hdev->monitored_devices,
         |                                          ^~~
   include/linux/list.h:717:14: note: in definition of macro 'list_for_each_entry_safe'
     717 |         for (pos = list_first_entry(head, typeof(*pos), member),        \
         |              ^~~
   net/bluetooth/msft.c:306:42: note: each undeclared identifier is reported only once for each function it appears in
     306 |                 list_for_each_entry_safe(dev, tmp, &hdev->monitored_devices,
         |                                          ^~~
   include/linux/list.h:717:14: note: in definition of macro 'list_for_each_entry_safe'
     717 |         for (pos = list_first_entry(head, typeof(*pos), member),        \
         |              ^~~
   In file included from arch/arc/include/asm/cache.h:28,
                    from include/linux/cache.h:6,
                    from include/linux/time.h:5,
                    from include/linux/ktime.h:24,
                    from include/linux/poll.h:7,
                    from include/net/bluetooth/bluetooth.h:28,
                    from net/bluetooth/msft.c:6:
   include/linux/compiler_types.h:276:27: error: expression in static assertion is not an integer
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
   include/linux/list.h:513:9: note: in expansion of macro 'container_of'
     513 |         container_of(ptr, type, member)
         |         ^~~~~~~~~~~~
   include/linux/list.h:524:9: note: in expansion of macro 'list_entry'
     524 |         list_entry((ptr)->next, type, member)
         |         ^~~~~~~~~~
   include/linux/list.h:717:20: note: in expansion of macro 'list_first_entry'
     717 |         for (pos = list_first_entry(head, typeof(*pos), member),        \
         |                    ^~~~~~~~~~~~~~~~
   net/bluetooth/msft.c:306:17: note: in expansion of macro 'list_for_each_entry_safe'
     306 |                 list_for_each_entry_safe(dev, tmp, &hdev->monitored_devices,
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~
   In file included from include/linux/wait.h:7,
                    from include/linux/poll.h:8,
                    from include/net/bluetooth/bluetooth.h:28,
                    from net/bluetooth/msft.c:6:
>> net/bluetooth/msft.c:306:47: error: 'tmp' undeclared (first use in this function); did you mean 'tm'?
     306 |                 list_for_each_entry_safe(dev, tmp, &hdev->monitored_devices,
         |                                               ^~~
   include/linux/list.h:718:17: note: in definition of macro 'list_for_each_entry_safe'
     718 |                 n = list_next_entry(pos, member);                       \
         |                 ^
   In file included from arch/arc/include/asm/cache.h:28,
                    from include/linux/cache.h:6,
                    from include/linux/time.h:5,
                    from include/linux/ktime.h:24,
                    from include/linux/poll.h:7,
                    from include/net/bluetooth/bluetooth.h:28,
                    from net/bluetooth/msft.c:6:
   include/linux/compiler_types.h:276:27: error: expression in static assertion is not an integer
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
   include/linux/list.h:513:9: note: in expansion of macro 'container_of'
     513 |         container_of(ptr, type, member)
         |         ^~~~~~~~~~~~
   include/linux/list.h:557:9: note: in expansion of macro 'list_entry'
     557 |         list_entry((pos)->member.next, typeof(*(pos)), member)
         |         ^~~~~~~~~~
   include/linux/list.h:718:21: note: in expansion of macro 'list_next_entry'
     718 |                 n = list_next_entry(pos, member);                       \
         |                     ^~~~~~~~~~~~~~~
   net/bluetooth/msft.c:306:17: note: in expansion of macro 'list_for_each_entry_safe'
     306 |                 list_for_each_entry_safe(dev, tmp, &hdev->monitored_devices,
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~
   In file included from include/linux/wait.h:7,
                    from include/linux/poll.h:8,
                    from include/net/bluetooth/bluetooth.h:28,
                    from net/bluetooth/msft.c:6:
   include/linux/list.h:717:64: warning: left-hand operand of comma expression has no effect [-Wunused-value]
     717 |         for (pos = list_first_entry(head, typeof(*pos), member),        \
         |                                                                ^
   net/bluetooth/msft.c:306:17: note: in expansion of macro 'list_for_each_entry_safe'
     306 |                 list_for_each_entry_safe(dev, tmp, &hdev->monitored_devices,
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~
   In file included from arch/arc/include/asm/cache.h:28,
                    from include/linux/cache.h:6,
                    from include/linux/time.h:5,
                    from include/linux/ktime.h:24,
                    from include/linux/poll.h:7,
                    from include/net/bluetooth/bluetooth.h:28,
                    from net/bluetooth/msft.c:6:
   include/linux/compiler_types.h:276:27: error: expression in static assertion is not an integer
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
   include/linux/list.h:513:9: note: in expansion of macro 'container_of'
     513 |         container_of(ptr, type, member)
         |         ^~~~~~~~~~~~
   include/linux/list.h:557:9: note: in expansion of macro 'list_entry'
     557 |         list_entry((pos)->member.next, typeof(*(pos)), member)
         |         ^~~~~~~~~~
   include/linux/list.h:720:27: note: in expansion of macro 'list_next_entry'
     720 |              pos = n, n = list_next_entry(n, member))
         |                           ^~~~~~~~~~~~~~~
   net/bluetooth/msft.c:306:17: note: in expansion of macro 'list_for_each_entry_safe'
     306 |                 list_for_each_entry_safe(dev, tmp, &hdev->monitored_devices,
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~
   In file included from include/linux/wait.h:7,
                    from include/linux/poll.h:8,
                    from include/net/bluetooth/bluetooth.h:28,
                    from net/bluetooth/msft.c:6:
   include/linux/list.h:720:21: warning: left-hand operand of comma expression has no effect [-Wunused-value]
     720 |              pos = n, n = list_next_entry(n, member))
         |                     ^
   net/bluetooth/msft.c:306:17: note: in expansion of macro 'list_for_each_entry_safe'
     306 |                 list_for_each_entry_safe(dev, tmp, &hdev->monitored_devices,
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~


vim +306 net/bluetooth/msft.c

   265	
   266	static void msft_le_cancel_monitor_advertisement_cb(struct hci_dev *hdev,
   267							    u8 status, u16 opcode,
   268							    struct sk_buff *skb)
   269	{
   270		struct msft_cp_le_cancel_monitor_advertisement *cp;
   271		struct msft_rp_le_cancel_monitor_advertisement *rp;
   272		struct adv_monitor *monitor;
   273		struct msft_monitor_advertisement_handle_data *handle_data;
   274		struct msft_data *msft = hdev->msft_data;
   275		int err;
   276		bool pending;
   277	
   278		if (status)
   279			goto done;
   280	
   281		rp = (struct msft_rp_le_cancel_monitor_advertisement *)skb->data;
   282		if (skb->len < sizeof(*rp)) {
   283			status = HCI_ERROR_UNSPECIFIED;
   284			goto done;
   285		}
   286	
   287		hci_dev_lock(hdev);
   288	
   289		cp = hci_sent_cmd_data(hdev, hdev->msft_opcode);
   290		handle_data = msft_find_handle_data(hdev, cp->handle, false);
   291	
   292		if (handle_data) {
   293			monitor = idr_find(&hdev->adv_monitors_idr,
   294					   handle_data->mgmt_handle);
   295	
   296			if (monitor && monitor->state == ADV_MONITOR_STATE_OFFLOADED)
   297				monitor->state = ADV_MONITOR_STATE_REGISTERED;
   298	
   299			/* Do not free the monitor if it is being removed due to
   300			 * suspend. It will be re-monitored on resume.
   301			 */
   302			if (monitor && !msft->suspending)
   303				hci_free_adv_monitor(hdev, monitor);
   304	
   305			/* Clear any monitored devices by this Adv Monitor */
 > 306			list_for_each_entry_safe(dev, tmp, &hdev->monitored_devices,
   307						 list) {
   308				if (dev->handle == handle_data->mgmt_handle) {
   309					list_del(&dev->list);
   310					kfree(dev);
   311				}
   312			}
   313	
   314			list_del(&handle_data->list);
   315			kfree(handle_data);
   316		}
   317	
   318		/* If remove all monitors is required, we need to continue the process
   319		 * here because the earlier it was paused when waiting for the
   320		 * response from controller.
   321		 */
   322		if (msft->pending_remove_handle == 0) {
   323			pending = hci_remove_all_adv_monitor(hdev, &err);
   324			if (pending) {
   325				hci_dev_unlock(hdev);
   326				return;
   327			}
   328	
   329			if (err)
   330				status = HCI_ERROR_UNSPECIFIED;
   331		}
   332	
   333		hci_dev_unlock(hdev);
   334	
   335	done:
   336		if (!msft->suspending)
   337			hci_remove_adv_monitor_complete(hdev, status);
   338	}
   339	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
