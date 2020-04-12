Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36C121A5E4F
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 13:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbgDLLhv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Apr 2020 07:37:51 -0400
Received: from mga06.intel.com ([134.134.136.31]:32792 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725903AbgDLLhu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 Apr 2020 07:37:50 -0400
IronPort-SDR: K+L7Tp0Z4JqKxB00W3kohZfcPctqAcsHs81rWpgspblyx/JmEpLpTvfsPVkKiS2vS3wa+pgpK6
 0a2tFWpuVwKw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2020 04:37:49 -0700
IronPort-SDR: bzZN2hoGmr0W+9u3F2AbvIgYKZgRA0SCXSIEktmFICpyxDqcCLvaIZSTrgupvo1QwFerYNxlaH
 G1EtNLeuj7oA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,374,1580803200"; 
   d="scan'208";a="453948217"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga006.fm.intel.com with ESMTP; 12 Apr 2020 04:37:47 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1jNavr-0001aT-9R; Sun, 12 Apr 2020 19:37:47 +0800
Date:   Sun, 12 Apr 2020 19:37:20 +0800
From:   kbuild test robot <lkp@intel.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     kbuild-all@lists.01.org, clang-built-linux@googlegroups.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org
Subject: [vhost:vhost 54/54] drivers/virtio/Kconfig:49: syntax error
Message-ID: <202004121907.Djq7hPBe%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git vhost
head:   e282a85dc20e6d5da055e65c48aae15cc14897c7
commit: e282a85dc20e6d5da055e65c48aae15cc14897c7 [54/54] vdpa: make vhost, virtio depend on menu
config: powerpc-defconfig
compiler: clang version 11.0.0 (https://github.com/llvm/llvm-project 4e86e5eedc684453fe0af6eca2ebdbff33db012c)
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        git checkout e282a85dc20e6d5da055e65c48aae15cc14897c7
        COMPILER=clang make.cross ARCH=powerpc  defconfig
        COMPILER=clang make.cross ARCH=powerpc 

If you fix the issue, kindly add following tag as appropriate
Reported-by: kbuild test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> drivers/virtio/Kconfig:49: syntax error
>> drivers/virtio/Kconfig:48: unknown statement "depend"
>> drivers/virtio/Kconfig:49: invalid statement
   drivers/virtio/Kconfig:50: invalid statement
>> drivers/virtio/Kconfig:51: unknown statement "This"
   drivers/virtio/Kconfig:52:warning: ignoring unsupported character '.'
   drivers/virtio/Kconfig:52:warning: ignoring unsupported character ','
>> drivers/virtio/Kconfig:52: unknown statement "device"
>> drivers/virtio/Kconfig:53: unknown statement "an"
>> drivers/virtio/Kconfig:54: unknown statement "physical"
   drivers/virtio/Kconfig:55:warning: ignoring unsupported character '.'
>> drivers/virtio/Kconfig:55: unknown statement "offloaded"
   drivers/virtio/Kconfig:57:warning: ignoring unsupported character ','
   drivers/virtio/Kconfig:57:warning: ignoring unsupported character '.'
>> drivers/virtio/Kconfig:57: unknown statement "If"
   make[2]: *** [scripts/kconfig/Makefile:85: defconfig] Error 1
   make[1]: *** [Makefile:568: defconfig] Error 2
   make: *** [Makefile:180: sub-make] Error 2
   4 real  1 user  1 sys  59.31% cpu 	make defconfig
--
>> drivers/virtio/Kconfig:49: syntax error
>> drivers/virtio/Kconfig:48: unknown statement "depend"
>> drivers/virtio/Kconfig:49: invalid statement
   drivers/virtio/Kconfig:50: invalid statement
>> drivers/virtio/Kconfig:51: unknown statement "This"
   drivers/virtio/Kconfig:52:warning: ignoring unsupported character '.'
   drivers/virtio/Kconfig:52:warning: ignoring unsupported character ','
>> drivers/virtio/Kconfig:52: unknown statement "device"
>> drivers/virtio/Kconfig:53: unknown statement "an"
>> drivers/virtio/Kconfig:54: unknown statement "physical"
   drivers/virtio/Kconfig:55:warning: ignoring unsupported character '.'
>> drivers/virtio/Kconfig:55: unknown statement "offloaded"
   drivers/virtio/Kconfig:57:warning: ignoring unsupported character ','
   drivers/virtio/Kconfig:57:warning: ignoring unsupported character '.'
>> drivers/virtio/Kconfig:57: unknown statement "If"
   make[2]: *** [scripts/kconfig/Makefile:75: oldconfig] Error 1
   make[1]: *** [Makefile:568: oldconfig] Error 2
   make: *** [Makefile:180: sub-make] Error 2
   4 real  1 user  1 sys  66.71% cpu 	make oldconfig
--
>> drivers/virtio/Kconfig:49: syntax error
>> drivers/virtio/Kconfig:48: unknown statement "depend"
>> drivers/virtio/Kconfig:49: invalid statement
   drivers/virtio/Kconfig:50: invalid statement
>> drivers/virtio/Kconfig:51: unknown statement "This"
   drivers/virtio/Kconfig:52:warning: ignoring unsupported character '.'
   drivers/virtio/Kconfig:52:warning: ignoring unsupported character ','
>> drivers/virtio/Kconfig:52: unknown statement "device"
>> drivers/virtio/Kconfig:53: unknown statement "an"
>> drivers/virtio/Kconfig:54: unknown statement "physical"
   drivers/virtio/Kconfig:55:warning: ignoring unsupported character '.'
>> drivers/virtio/Kconfig:55: unknown statement "offloaded"
   drivers/virtio/Kconfig:57:warning: ignoring unsupported character ','
   drivers/virtio/Kconfig:57:warning: ignoring unsupported character '.'
>> drivers/virtio/Kconfig:57: unknown statement "If"
   make[2]: *** [scripts/kconfig/Makefile:75: olddefconfig] Error 1
   make[1]: *** [Makefile:568: olddefconfig] Error 2
   make: *** [Makefile:180: sub-make] Error 2
   4 real  1 user  1 sys  66.26% cpu 	make olddefconfig

vim +49 drivers/virtio/Kconfig

e72542191cbba4 Ohad Ben-Cohen     2011-07-05  14  
3343660d8c62c6 Anthony Liguori    2007-11-12  15  config VIRTIO_PCI
d72c5a8c8c57cb Kees Cook          2012-10-02  16  	tristate "PCI driver for virtio devices"
d72c5a8c8c57cb Kees Cook          2012-10-02  17  	depends on PCI
3343660d8c62c6 Anthony Liguori    2007-11-12  18  	select VIRTIO
3343660d8c62c6 Anthony Liguori    2007-11-12  19  	---help---
b2a6d51ddf7b23 Michael S. Tsirkin 2015-01-15  20  	  This driver provides support for virtio based paravirtual device
3343660d8c62c6 Anthony Liguori    2007-11-12  21  	  drivers over PCI.  This requires that your VMM has appropriate PCI
3343660d8c62c6 Anthony Liguori    2007-11-12  22  	  virtio backends.  Most QEMU based VMMs should support these devices
3343660d8c62c6 Anthony Liguori    2007-11-12  23  	  (like KVM or Xen).
3343660d8c62c6 Anthony Liguori    2007-11-12  24  
3343660d8c62c6 Anthony Liguori    2007-11-12  25  	  If unsure, say M.
3343660d8c62c6 Anthony Liguori    2007-11-12  26  
46506da5f365ef Michael S. Tsirkin 2015-01-15  27  config VIRTIO_PCI_LEGACY
46506da5f365ef Michael S. Tsirkin 2015-01-15  28  	bool "Support for legacy virtio draft 0.9.X and older devices"
46506da5f365ef Michael S. Tsirkin 2015-01-15  29  	default y
46506da5f365ef Michael S. Tsirkin 2015-01-15  30  	depends on VIRTIO_PCI
46506da5f365ef Michael S. Tsirkin 2015-01-15  31  	---help---
46506da5f365ef Michael S. Tsirkin 2015-01-15  32            Virtio PCI Card 0.9.X Draft (circa 2014) and older device support.
46506da5f365ef Michael S. Tsirkin 2015-01-15  33  
46506da5f365ef Michael S. Tsirkin 2015-01-15  34  	  This option enables building a transitional driver, supporting
46506da5f365ef Michael S. Tsirkin 2015-01-15  35  	  both devices conforming to Virtio 1 specification, and legacy devices.
46506da5f365ef Michael S. Tsirkin 2015-01-15  36  	  If disabled, you get a slightly smaller, non-transitional driver,
46506da5f365ef Michael S. Tsirkin 2015-01-15  37  	  with no legacy compatibility.
46506da5f365ef Michael S. Tsirkin 2015-01-15  38  
46506da5f365ef Michael S. Tsirkin 2015-01-15  39            So look out into your driveway.  Do you have a flying car?  If
46506da5f365ef Michael S. Tsirkin 2015-01-15  40            so, you can happily disable this option and virtio will not
46506da5f365ef Michael S. Tsirkin 2015-01-15  41            break.  Otherwise, leave it set.  Unless you're testing what
46506da5f365ef Michael S. Tsirkin 2015-01-15  42            life will be like in The Future.
46506da5f365ef Michael S. Tsirkin 2015-01-15  43  
46506da5f365ef Michael S. Tsirkin 2015-01-15  44  	  If unsure, say Y.
46506da5f365ef Michael S. Tsirkin 2015-01-15  45  
c043b4a8cf3b16 Jason Wang         2020-03-26  46  config VIRTIO_VDPA
c043b4a8cf3b16 Jason Wang         2020-03-26  47  	tristate "vDPA driver for virtio devices"
e282a85dc20e6d Michael S. Tsirkin 2020-04-12 @48  	depend on VDPA
c043b4a8cf3b16 Jason Wang         2020-03-26 @49  	select VIRTIO
c043b4a8cf3b16 Jason Wang         2020-03-26  50  	help
c043b4a8cf3b16 Jason Wang         2020-03-26 @51  	  This driver provides support for virtio based paravirtual
c043b4a8cf3b16 Jason Wang         2020-03-26 @52  	  device driver over vDPA bus. For this to be useful, you need
c043b4a8cf3b16 Jason Wang         2020-03-26 @53  	  an appropriate vDPA device implementation that operates on a
c043b4a8cf3b16 Jason Wang         2020-03-26 @54  	  physical device to allow the datapath of virtio to be
c043b4a8cf3b16 Jason Wang         2020-03-26 @55  	  offloaded to hardware.
c043b4a8cf3b16 Jason Wang         2020-03-26  56  
c043b4a8cf3b16 Jason Wang         2020-03-26 @57  	  If unsure, say M.
c043b4a8cf3b16 Jason Wang         2020-03-26  58  

:::::: The code at line 49 was first introduced by commit
:::::: c043b4a8cf3b16fbdcaec1126841431c33b16e98 virtio: introduce a vDPA based transport

:::::: TO: Jason Wang <jasowang@redhat.com>
:::::: CC: Michael S. Tsirkin <mst@redhat.com>

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
