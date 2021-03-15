Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C06233C8BC
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 22:48:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233357AbhCOVsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 17:48:17 -0400
Received: from mga07.intel.com ([134.134.136.100]:37185 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230078AbhCOVrz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 17:47:55 -0400
IronPort-SDR: rBFPTddOHidBt7uhUiDu+atpEBLTuNIXZvzVasJzBN90ngAbEVVio1ywBKUkI6i7atK3aT+dXg
 xk+Q0f8+HGKg==
X-IronPort-AV: E=McAfee;i="6000,8403,9924"; a="253175854"
X-IronPort-AV: E=Sophos;i="5.81,251,1610438400"; 
   d="gz'50?scan'50,208,50";a="253175854"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2021 14:47:53 -0700
IronPort-SDR: f+WrUBfP5NSis5u4WQsn938QHpBAzyyRsDyi9A0ypxHASKOpgiAnqu1t0ywNoMmptYlBUwjOrT
 xks9avcfEIrg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,251,1610438400"; 
   d="gz'50?scan'50,208,50";a="411985727"
Received: from lkp-server02.sh.intel.com (HELO 1dc5e1a854f4) ([10.239.97.151])
  by orsmga008.jf.intel.com with ESMTP; 15 Mar 2021 14:47:49 -0700
Received: from kbuild by 1dc5e1a854f4 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1lLv40-0000fB-Lr; Mon, 15 Mar 2021 21:47:48 +0000
Date:   Tue, 16 Mar 2021 05:46:59 +0800
From:   kernel test robot <lkp@intel.com>
To:     hildawu@realtek.com, marcel@holtmann.org
Cc:     kbuild-all@lists.01.org, clang-built-linux@googlegroups.com,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com, davem@davemloft.net,
        kuba@kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        tientzu@chromium.org, max.chou@realtek.com
Subject: Re: [PATCH] Bluetooth: hci_h5: btrtl: Add quirk for keep power
 during suspend/resume for specific devices
Message-ID: <202103160536.A91xlNfY-lkp@intel.com>
References: <20210315085840.4424-1-hildawu@realtek.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ZGiS0Q5IWpPtfppv"
Content-Disposition: inline
In-Reply-To: <20210315085840.4424-1-hildawu@realtek.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on bluetooth-next/master]
[also build test ERROR on net-next/master net/master v5.12-rc3 next-20210315]
[cannot apply to sparc-next/master]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/hildawu-realtek-com/Bluetooth-hci_h5-btrtl-Add-quirk-for-keep-power-during-suspend-resume-for-specific-devices/20210315-170101
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git master
config: powerpc64-randconfig-r016-20210315 (attached as .config)
compiler: clang version 13.0.0 (https://github.com/llvm/llvm-project a28facba1ccdc957f386b7753f4958307f1bfde8)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install powerpc64 cross compiling tool for clang build
        # apt-get install binutils-powerpc64-linux-gnu
        # https://github.com/0day-ci/linux/commit/c97383d88c50364f4451a74ac4d3ad7b3605c20b
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review hildawu-realtek-com/Bluetooth-hci_h5-btrtl-Add-quirk-for-keep-power-during-suspend-resume-for-specific-devices/20210315-170101
        git checkout c97383d88c50364f4451a74ac4d3ad7b3605c20b
        # save the attached .config to linux build tree
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross ARCH=powerpc64 

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from drivers/bluetooth/btrtl.c:11:
   In file included from include/linux/usb.h:16:
   In file included from include/linux/interrupt.h:11:
   In file included from include/linux/hardirq.h:10:
   In file included from arch/powerpc/include/asm/hardirq.h:6:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:13:
   In file included from arch/powerpc/include/asm/io.h:619:
   arch/powerpc/include/asm/io-defs.h:45:1: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
   DEF_PCI_AC_NORET(insw, (unsigned long p, void *b, unsigned long c),
   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/powerpc/include/asm/io.h:616:3: note: expanded from macro 'DEF_PCI_AC_NORET'
                   __do_##name al;                                 \
                   ^~~~~~~~~~~~~~
   <scratch space>:33:1: note: expanded from here
   __do_insw
   ^
   arch/powerpc/include/asm/io.h:557:56: note: expanded from macro '__do_insw'
   #define __do_insw(p, b, n)      readsw((PCI_IO_ADDR)_IO_BASE+(p), (b), (n))
                                          ~~~~~~~~~~~~~~~~~~~~~^
   In file included from drivers/bluetooth/btrtl.c:11:
   In file included from include/linux/usb.h:16:
   In file included from include/linux/interrupt.h:11:
   In file included from include/linux/hardirq.h:10:
   In file included from arch/powerpc/include/asm/hardirq.h:6:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:13:
   In file included from arch/powerpc/include/asm/io.h:619:
   arch/powerpc/include/asm/io-defs.h:47:1: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
   DEF_PCI_AC_NORET(insl, (unsigned long p, void *b, unsigned long c),
   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/powerpc/include/asm/io.h:616:3: note: expanded from macro 'DEF_PCI_AC_NORET'
                   __do_##name al;                                 \
                   ^~~~~~~~~~~~~~
   <scratch space>:35:1: note: expanded from here
   __do_insl
   ^
   arch/powerpc/include/asm/io.h:558:56: note: expanded from macro '__do_insl'
   #define __do_insl(p, b, n)      readsl((PCI_IO_ADDR)_IO_BASE+(p), (b), (n))
                                          ~~~~~~~~~~~~~~~~~~~~~^
   In file included from drivers/bluetooth/btrtl.c:11:
   In file included from include/linux/usb.h:16:
   In file included from include/linux/interrupt.h:11:
   In file included from include/linux/hardirq.h:10:
   In file included from arch/powerpc/include/asm/hardirq.h:6:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:13:
   In file included from arch/powerpc/include/asm/io.h:619:
   arch/powerpc/include/asm/io-defs.h:49:1: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
   DEF_PCI_AC_NORET(outsb, (unsigned long p, const void *b, unsigned long c),
   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/powerpc/include/asm/io.h:616:3: note: expanded from macro 'DEF_PCI_AC_NORET'
                   __do_##name al;                                 \
                   ^~~~~~~~~~~~~~
   <scratch space>:37:1: note: expanded from here
   __do_outsb
   ^
   arch/powerpc/include/asm/io.h:559:58: note: expanded from macro '__do_outsb'
   #define __do_outsb(p, b, n)     writesb((PCI_IO_ADDR)_IO_BASE+(p),(b),(n))
                                           ~~~~~~~~~~~~~~~~~~~~~^
   In file included from drivers/bluetooth/btrtl.c:11:
   In file included from include/linux/usb.h:16:
   In file included from include/linux/interrupt.h:11:
   In file included from include/linux/hardirq.h:10:
   In file included from arch/powerpc/include/asm/hardirq.h:6:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:13:
   In file included from arch/powerpc/include/asm/io.h:619:
   arch/powerpc/include/asm/io-defs.h:51:1: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
   DEF_PCI_AC_NORET(outsw, (unsigned long p, const void *b, unsigned long c),
   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/powerpc/include/asm/io.h:616:3: note: expanded from macro 'DEF_PCI_AC_NORET'
                   __do_##name al;                                 \
                   ^~~~~~~~~~~~~~
   <scratch space>:39:1: note: expanded from here
   __do_outsw
   ^
   arch/powerpc/include/asm/io.h:560:58: note: expanded from macro '__do_outsw'
   #define __do_outsw(p, b, n)     writesw((PCI_IO_ADDR)_IO_BASE+(p),(b),(n))
                                           ~~~~~~~~~~~~~~~~~~~~~^
   In file included from drivers/bluetooth/btrtl.c:11:
   In file included from include/linux/usb.h:16:
   In file included from include/linux/interrupt.h:11:
   In file included from include/linux/hardirq.h:10:
   In file included from arch/powerpc/include/asm/hardirq.h:6:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:13:
   In file included from arch/powerpc/include/asm/io.h:619:
   arch/powerpc/include/asm/io-defs.h:53:1: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
   DEF_PCI_AC_NORET(outsl, (unsigned long p, const void *b, unsigned long c),
   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/powerpc/include/asm/io.h:616:3: note: expanded from macro 'DEF_PCI_AC_NORET'
                   __do_##name al;                                 \
                   ^~~~~~~~~~~~~~
   <scratch space>:41:1: note: expanded from here
   __do_outsl
   ^
   arch/powerpc/include/asm/io.h:561:58: note: expanded from macro '__do_outsl'
   #define __do_outsl(p, b, n)     writesl((PCI_IO_ADDR)_IO_BASE+(p),(b),(n))
                                           ~~~~~~~~~~~~~~~~~~~~~^
>> drivers/bluetooth/btrtl.c:556:14: error: no member named 'drop_fw' in 'struct btrtl_device_info'
                   btrtl_dev->drop_fw = true;
                   ~~~~~~~~~  ^
   drivers/bluetooth/btrtl.c:558:17: error: no member named 'drop_fw' in 'struct btrtl_device_info'
           if (btrtl_dev->drop_fw) {
               ~~~~~~~~~  ^
   12 warnings and 2 errors generated.


vim +556 drivers/bluetooth/btrtl.c

26503ad25de8c7 Martin Blumenstingl 2018-08-02  519  
1cc194caaffbe0 Hans de Goede       2018-08-02  520  struct btrtl_device_info *btrtl_initialize(struct hci_dev *hdev,
1cc194caaffbe0 Hans de Goede       2018-08-02  521  					   const char *postfix)
db33c77dddc2ed Carlo Caione        2015-05-14  522  {
26503ad25de8c7 Martin Blumenstingl 2018-08-02  523  	struct btrtl_device_info *btrtl_dev;
db33c77dddc2ed Carlo Caione        2015-05-14  524  	struct sk_buff *skb;
db33c77dddc2ed Carlo Caione        2015-05-14  525  	struct hci_rp_read_local_version *resp;
1cc194caaffbe0 Hans de Goede       2018-08-02  526  	char cfg_name[40];
907f84990924bf Alex Lu             2018-02-11  527  	u16 hci_rev, lmp_subver;
c50903e3ee1b55 Martin Blumenstingl 2018-08-02  528  	u8 hci_ver;
26503ad25de8c7 Martin Blumenstingl 2018-08-02  529  	int ret;
1996d9cad6ad48 Kai-Heng Feng       2020-10-26  530  	u16 opcode;
1996d9cad6ad48 Kai-Heng Feng       2020-10-26  531  	u8 cmd[2];
26503ad25de8c7 Martin Blumenstingl 2018-08-02  532  
26503ad25de8c7 Martin Blumenstingl 2018-08-02  533  	btrtl_dev = kzalloc(sizeof(*btrtl_dev), GFP_KERNEL);
26503ad25de8c7 Martin Blumenstingl 2018-08-02  534  	if (!btrtl_dev) {
26503ad25de8c7 Martin Blumenstingl 2018-08-02  535  		ret = -ENOMEM;
26503ad25de8c7 Martin Blumenstingl 2018-08-02  536  		goto err_alloc;
26503ad25de8c7 Martin Blumenstingl 2018-08-02  537  	}
db33c77dddc2ed Carlo Caione        2015-05-14  538  
db33c77dddc2ed Carlo Caione        2015-05-14  539  	skb = btrtl_read_local_version(hdev);
26503ad25de8c7 Martin Blumenstingl 2018-08-02  540  	if (IS_ERR(skb)) {
26503ad25de8c7 Martin Blumenstingl 2018-08-02  541  		ret = PTR_ERR(skb);
26503ad25de8c7 Martin Blumenstingl 2018-08-02  542  		goto err_free;
26503ad25de8c7 Martin Blumenstingl 2018-08-02  543  	}
db33c77dddc2ed Carlo Caione        2015-05-14  544  
db33c77dddc2ed Carlo Caione        2015-05-14  545  	resp = (struct hci_rp_read_local_version *)skb->data;
f1300c0340872d Alex Lu             2019-08-31  546  	rtl_dev_info(hdev, "examining hci_ver=%02x hci_rev=%04x lmp_ver=%02x lmp_subver=%04x",
2064ee332e4c1b Marcel Holtmann     2017-10-30  547  		     resp->hci_ver, resp->hci_rev,
db33c77dddc2ed Carlo Caione        2015-05-14  548  		     resp->lmp_ver, resp->lmp_subver);
db33c77dddc2ed Carlo Caione        2015-05-14  549  
c50903e3ee1b55 Martin Blumenstingl 2018-08-02  550  	hci_ver = resp->hci_ver;
907f84990924bf Alex Lu             2018-02-11  551  	hci_rev = le16_to_cpu(resp->hci_rev);
db33c77dddc2ed Carlo Caione        2015-05-14  552  	lmp_subver = le16_to_cpu(resp->lmp_subver);
1996d9cad6ad48 Kai-Heng Feng       2020-10-26  553  
1996d9cad6ad48 Kai-Heng Feng       2020-10-26  554  	if (resp->hci_ver == 0x8 && le16_to_cpu(resp->hci_rev) == 0x826c &&
1996d9cad6ad48 Kai-Heng Feng       2020-10-26  555  	    resp->lmp_ver == 0x8 && le16_to_cpu(resp->lmp_subver) == 0xa99e)
1996d9cad6ad48 Kai-Heng Feng       2020-10-26 @556  		btrtl_dev->drop_fw = true;
1996d9cad6ad48 Kai-Heng Feng       2020-10-26  557  
1996d9cad6ad48 Kai-Heng Feng       2020-10-26  558  	if (btrtl_dev->drop_fw) {
1996d9cad6ad48 Kai-Heng Feng       2020-10-26  559  		opcode = hci_opcode_pack(0x3f, 0x66);
1996d9cad6ad48 Kai-Heng Feng       2020-10-26  560  		cmd[0] = opcode & 0xff;
1996d9cad6ad48 Kai-Heng Feng       2020-10-26  561  		cmd[1] = opcode >> 8;
1996d9cad6ad48 Kai-Heng Feng       2020-10-26  562  
1996d9cad6ad48 Kai-Heng Feng       2020-10-26  563  		skb = bt_skb_alloc(sizeof(cmd), GFP_KERNEL);
f5e8e215869eed Colin Ian King      2020-11-10  564  		if (!skb)
1996d9cad6ad48 Kai-Heng Feng       2020-10-26  565  			goto out_free;
1996d9cad6ad48 Kai-Heng Feng       2020-10-26  566  
1996d9cad6ad48 Kai-Heng Feng       2020-10-26  567  		skb_put_data(skb, cmd, sizeof(cmd));
1996d9cad6ad48 Kai-Heng Feng       2020-10-26  568  		hci_skb_pkt_type(skb) = HCI_COMMAND_PKT;
1996d9cad6ad48 Kai-Heng Feng       2020-10-26  569  
1996d9cad6ad48 Kai-Heng Feng       2020-10-26  570  		hdev->send(hdev, skb);
1996d9cad6ad48 Kai-Heng Feng       2020-10-26  571  
1996d9cad6ad48 Kai-Heng Feng       2020-10-26  572  		/* Ensure the above vendor command is sent to controller and
1996d9cad6ad48 Kai-Heng Feng       2020-10-26  573  		 * process has done.
1996d9cad6ad48 Kai-Heng Feng       2020-10-26  574  		 */
1996d9cad6ad48 Kai-Heng Feng       2020-10-26  575  		msleep(200);
1996d9cad6ad48 Kai-Heng Feng       2020-10-26  576  
1996d9cad6ad48 Kai-Heng Feng       2020-10-26  577  		/* Read the local version again. Expect to have the vanilla
1996d9cad6ad48 Kai-Heng Feng       2020-10-26  578  		 * version as cold boot.
1996d9cad6ad48 Kai-Heng Feng       2020-10-26  579  		 */
1996d9cad6ad48 Kai-Heng Feng       2020-10-26  580  		skb = btrtl_read_local_version(hdev);
1996d9cad6ad48 Kai-Heng Feng       2020-10-26  581  		if (IS_ERR(skb)) {
1996d9cad6ad48 Kai-Heng Feng       2020-10-26  582  			ret = PTR_ERR(skb);
1996d9cad6ad48 Kai-Heng Feng       2020-10-26  583  			goto err_free;
1996d9cad6ad48 Kai-Heng Feng       2020-10-26  584  		}
1996d9cad6ad48 Kai-Heng Feng       2020-10-26  585  
1996d9cad6ad48 Kai-Heng Feng       2020-10-26  586  		resp = (struct hci_rp_read_local_version *)skb->data;
1996d9cad6ad48 Kai-Heng Feng       2020-10-26  587  		rtl_dev_info(hdev, "examining hci_ver=%02x hci_rev=%04x lmp_ver=%02x lmp_subver=%04x",
1996d9cad6ad48 Kai-Heng Feng       2020-10-26  588  			     resp->hci_ver, resp->hci_rev,
1996d9cad6ad48 Kai-Heng Feng       2020-10-26  589  			     resp->lmp_ver, resp->lmp_subver);
1996d9cad6ad48 Kai-Heng Feng       2020-10-26  590  
1996d9cad6ad48 Kai-Heng Feng       2020-10-26  591  		hci_ver = resp->hci_ver;
1996d9cad6ad48 Kai-Heng Feng       2020-10-26  592  		hci_rev = le16_to_cpu(resp->hci_rev);
1996d9cad6ad48 Kai-Heng Feng       2020-10-26  593  		lmp_subver = le16_to_cpu(resp->lmp_subver);
1996d9cad6ad48 Kai-Heng Feng       2020-10-26  594  	}
1996d9cad6ad48 Kai-Heng Feng       2020-10-26  595  out_free:
db33c77dddc2ed Carlo Caione        2015-05-14  596  	kfree_skb(skb);
db33c77dddc2ed Carlo Caione        2015-05-14  597  
c50903e3ee1b55 Martin Blumenstingl 2018-08-02  598  	btrtl_dev->ic_info = btrtl_match_ic(lmp_subver, hci_rev, hci_ver,
c50903e3ee1b55 Martin Blumenstingl 2018-08-02  599  					    hdev->bus);
c50903e3ee1b55 Martin Blumenstingl 2018-08-02  600  
26503ad25de8c7 Martin Blumenstingl 2018-08-02  601  	if (!btrtl_dev->ic_info) {
d182215d2fb9e5 Alex Lu             2019-08-31  602  		rtl_dev_info(hdev, "unknown IC info, lmp subver %04x, hci rev %04x, hci ver %04x",
c50903e3ee1b55 Martin Blumenstingl 2018-08-02  603  			    lmp_subver, hci_rev, hci_ver);
00df214b1faae5 Kai-Heng Feng       2019-01-27  604  		return btrtl_dev;
26503ad25de8c7 Martin Blumenstingl 2018-08-02  605  	}
26503ad25de8c7 Martin Blumenstingl 2018-08-02  606  
26503ad25de8c7 Martin Blumenstingl 2018-08-02  607  	if (btrtl_dev->ic_info->has_rom_version) {
26503ad25de8c7 Martin Blumenstingl 2018-08-02  608  		ret = rtl_read_rom_version(hdev, &btrtl_dev->rom_version);
26503ad25de8c7 Martin Blumenstingl 2018-08-02  609  		if (ret)
26503ad25de8c7 Martin Blumenstingl 2018-08-02  610  			goto err_free;
26503ad25de8c7 Martin Blumenstingl 2018-08-02  611  	}
26503ad25de8c7 Martin Blumenstingl 2018-08-02  612  
26503ad25de8c7 Martin Blumenstingl 2018-08-02  613  	btrtl_dev->fw_len = rtl_load_file(hdev, btrtl_dev->ic_info->fw_name,
26503ad25de8c7 Martin Blumenstingl 2018-08-02  614  					  &btrtl_dev->fw_data);
26503ad25de8c7 Martin Blumenstingl 2018-08-02  615  	if (btrtl_dev->fw_len < 0) {
f1300c0340872d Alex Lu             2019-08-31  616  		rtl_dev_err(hdev, "firmware file %s not found",
26503ad25de8c7 Martin Blumenstingl 2018-08-02  617  			    btrtl_dev->ic_info->fw_name);
26503ad25de8c7 Martin Blumenstingl 2018-08-02  618  		ret = btrtl_dev->fw_len;
26503ad25de8c7 Martin Blumenstingl 2018-08-02  619  		goto err_free;
26503ad25de8c7 Martin Blumenstingl 2018-08-02  620  	}
26503ad25de8c7 Martin Blumenstingl 2018-08-02  621  
26503ad25de8c7 Martin Blumenstingl 2018-08-02  622  	if (btrtl_dev->ic_info->cfg_name) {
1cc194caaffbe0 Hans de Goede       2018-08-02  623  		if (postfix) {
1cc194caaffbe0 Hans de Goede       2018-08-02  624  			snprintf(cfg_name, sizeof(cfg_name), "%s-%s.bin",
1cc194caaffbe0 Hans de Goede       2018-08-02  625  				 btrtl_dev->ic_info->cfg_name, postfix);
1cc194caaffbe0 Hans de Goede       2018-08-02  626  		} else {
1cc194caaffbe0 Hans de Goede       2018-08-02  627  			snprintf(cfg_name, sizeof(cfg_name), "%s.bin",
1cc194caaffbe0 Hans de Goede       2018-08-02  628  				 btrtl_dev->ic_info->cfg_name);
1cc194caaffbe0 Hans de Goede       2018-08-02  629  		}
1cc194caaffbe0 Hans de Goede       2018-08-02  630  		btrtl_dev->cfg_len = rtl_load_file(hdev, cfg_name,
26503ad25de8c7 Martin Blumenstingl 2018-08-02  631  						   &btrtl_dev->cfg_data);
26503ad25de8c7 Martin Blumenstingl 2018-08-02  632  		if (btrtl_dev->ic_info->config_needed &&
26503ad25de8c7 Martin Blumenstingl 2018-08-02  633  		    btrtl_dev->cfg_len <= 0) {
f1300c0340872d Alex Lu             2019-08-31  634  			rtl_dev_err(hdev, "mandatory config file %s not found",
26503ad25de8c7 Martin Blumenstingl 2018-08-02  635  				    btrtl_dev->ic_info->cfg_name);
26503ad25de8c7 Martin Blumenstingl 2018-08-02  636  			ret = btrtl_dev->cfg_len;
26503ad25de8c7 Martin Blumenstingl 2018-08-02  637  			goto err_free;
26503ad25de8c7 Martin Blumenstingl 2018-08-02  638  		}
26503ad25de8c7 Martin Blumenstingl 2018-08-02  639  	}
26503ad25de8c7 Martin Blumenstingl 2018-08-02  640  
673fae14f24052 Miao-chen Chou      2020-12-17  641  	/* RTL8822CE supports the Microsoft vendor extension and uses 0xFCF0
673fae14f24052 Miao-chen Chou      2020-12-17  642  	 * for VsMsftOpCode.
673fae14f24052 Miao-chen Chou      2020-12-17  643  	 */
673fae14f24052 Miao-chen Chou      2020-12-17  644  	if (lmp_subver == RTL_ROM_LMP_8822B)
673fae14f24052 Miao-chen Chou      2020-12-17  645  		hci_set_msft_opcode(hdev, 0xFCF0);
673fae14f24052 Miao-chen Chou      2020-12-17  646  
26503ad25de8c7 Martin Blumenstingl 2018-08-02  647  	return btrtl_dev;
26503ad25de8c7 Martin Blumenstingl 2018-08-02  648  
26503ad25de8c7 Martin Blumenstingl 2018-08-02  649  err_free:
26503ad25de8c7 Martin Blumenstingl 2018-08-02  650  	btrtl_free(btrtl_dev);
26503ad25de8c7 Martin Blumenstingl 2018-08-02  651  err_alloc:
26503ad25de8c7 Martin Blumenstingl 2018-08-02  652  	return ERR_PTR(ret);
26503ad25de8c7 Martin Blumenstingl 2018-08-02  653  }
26503ad25de8c7 Martin Blumenstingl 2018-08-02  654  EXPORT_SYMBOL_GPL(btrtl_initialize);
26503ad25de8c7 Martin Blumenstingl 2018-08-02  655  

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--ZGiS0Q5IWpPtfppv
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

H4sICCnMT2AAAy5jb25maWcAjDzLduM2svt8hU5nM7OYxK9WOnOPFxAJSohIgg2Qku0Nj1qW
O564LY+sziR/f6sAPgCwKDuLjllVKBaAegPUjz/8OGHfj/tvm+PjdvP09Pfk6+55d9gcd/eT
h8en3f9NYjnJZTnhsSh/AuL08fn7Xz+/7P+3O7xsJx9/Oj//6Wyy3B2ed0+TaP/88Pj1O4x+
3D//8OMPkcwTMa+jqF5xpYXM65LflNcftk+b56+TP3eHV6CbnF/+dAY8/vH18fjvn3+Gf789
Hg77w89PT39+q18O+//stsfJ5uLTw2b7ZXO+3d5vf/34y8Plp+mXX375ePlw9evHT5dnvzyc
f3m4333654f2rfP+tddnLTCNhzCgE7qOUpbPr/92CAGYpnEPMhTd8PPLM/ivI3cY+xjgvmC6
Zjqr57KUDjsfUcuqLKqSxIs8FTl3UDLXpaqiUirdQ4X6XK+lWvaQWSXSuBQZr0s2S3mtpXJe
UC4UZzDNPJHwD5BoHArb9uNkbnTgafK6O35/6TdS5KKseb6qmYIpi0yU15cXvVBZIeAlJdfO
S1IZsbRdmQ8fPMlqzdLSAS7YitdLrnKe1vM7UfRcSGDME1alpZHK4dKCF1KXOcv49Yd/PO+f
d6AYP04aEn2rV6KIJo+vk+f9EWfZDi6kFjd19rniFa53N2LNymhRGzAxKlJS6zrjmVS3NStL
Fi3cwZXmqZi54zoUq8CsCI5mKZiCdxoKEBiWMW23B3Z68vr9y+vfr8fdt3575jznSkRGEfRC
rvulCjF1ylc8pfGZmCtW4naRaJH/xqNxdLRwtwghscyYyH2YFhlFVC8EVzjrWx+bSBXxuFFY
4ZqpLpjSHIlocWI+q+aJNruxe76f7B+CxQsHGWtZ9esdoCPQ5yWsXV46hmf2CW21FNGyninJ
4oi5RkCMPkmWSV1XRcxK3u54+fgNvCW16Yu7uoBRMhaRq3O5RIyIU07qnUUnVZqOo0nMQswX
teLaLJTSPk2zwgNh++GF4jwrSnhBTgvWEqxkWuUlU7eUkVqafuHaQZGEMQOw1VWzjFFR/Vxu
Xv+YHEHEyQbEfT1ujq+TzXa7//58fHz+2i+s2UwYULPI8LV61wm6EqoM0HUOdrOi50WRw34T
s0O1NVrovdf1CzpagDWw1dzX+0IL76HzhLHQ6P5j1wresRKddwOphZYpc1dSRdVED7WxhCWv
ATfcGwvs1gMea34Dmkt5P+1xMDwDEMQqbXg0NkOgBqAq5hS8VCwKEMhYl+AAMKhlrqtDTM5h
9TWfR7NUGPPtFtVflH6yYmn/oHZ7uQCfxt04nkqMjwk4apGU1+e/uHDci4zduPiLfqVFXi4h
qCY85HFpN01vf9/df3/aHSYPu83x+2H3asCN9AQ2yEWA//nFJycPmStZFdrdVwiCETVPS2pV
t2eQMKFqH9NxihJwkiyP1yIuF6RNgUU5Y0mS5rWFiPW4UCrOWDipOgGtu+PKgRcQx123XygZ
IecG48luecR8JSLaHzQUMBTMvDwpO1fJuOyzIiFfDGGPMiyJPq2hYSXzhi54tCwk7DH6d0gt
qUyncT1VKQ0TdzzETNixmIPBRxC5YmK04im7dcfM0iUukknhFL2DMynRsYfm04sd1RJ8fCbu
OOYJZrmkylgekZlaQK3hj8C7Ql4aY14cSfAXuEg1x1Q3D3Ki95NJVSxYDimkcuCYYZQpuMCI
mwhl3ZCTupt9bR6so/TMDPy6AK1T1B7NeZmBa6v7LCbYpAZBjE1AUsgZHCU3CbEN9q7qo6sJ
n+s8E97uVvSW8TSBZSP1a8Ygm8O0xPERFRSNwSOYnfsiXkhyNlrMc5YmnlsxU0ko7TSJmU+s
F+DP6MRdSMqby7pSXsBm8UrAlJoVd5YQGM+YUsJ1MUskuc30EFJ72WgHNcuFVoV5h6c89SCF
RW3JjLIqIFY+wiQKieOZu5y2l7NGfjMWLanU1yHTt3lk9tcJm5o7iYrxTi2s38RsxuOY9BvG
LtGw6y717hPG6Pzsyh1jQlrTkCh2h4f94dvmebub8D93z5DgMAh2EaY4kKL2eUvIvAmJ72Tj
pHmZ5WJT0UGC3HohKJVZCSXAklLalM08HUwrunbUqZyNjIftUHPeJoA+N8BibMPcpVZg7ZJW
cJ9wwVQMmRbtovWiShKo/AsG7wQdgZIfwgcl2q0ueWa9JaigSEQUuEuIqYlI21S72QW/G9GR
FtH0qk1Hi8N+u3t93R+g6nh52R+ONt3vKDGMLC91Pb0ixOrwvDYcw3KscNPZjtaHJZCYKT7X
A6hjlTAsGJVlkE5KsJ8F9QZEe6oO1MaBU0ubOWV3rkxO4jRnkGkspZrxJh40Sztct3bEKtby
8sJLf+oZmmkeC+bs2PRqJpyay4rseocsY5Bi5TGMhrIXkldHLIpA5Nfnn2iC1m5aRn1ufIIO
+Z379RMvbV5lCzLFnezPJPctyrikOhEKLCBaVPlyhM4oPk2msEbT1x/7NB2CZC0Kp1SDSiNa
2ipEV0Xh9+gMGFgkKZvrIR4bCpByDRGt8iLBDGa4HKIWaw7FfOlpnpNzMJXeDgM9y5smiayg
rvjUtznNkjuTMomizEQJToRBNWsySzfsmMaW2bgwnIgZVzaPwvRDi5mbkBiSZrrYJVFyxgOr
g5jbxpiBRfY4wSJ9fUHj4lO4FeDOPMNia2dedzIHz+tWFMXctl9N001fXzUu62lzxKhCeSwN
y9n2rkiXm+gUk3nrU0iKJYSieQWJPJXpFKyATJkphm0Jf4FkYlNu0LwM0iqv74x4cDSQfd7A
5lolbvsqk+Sw++/33fP278nrdvPktVLQRiCUfPa9CULquVxhx1TVtoKi0GEN3iHBcPyqq0W0
jQ8cPVIPvDFIriF2s5FeDjkEsyhdMLrqoAbIPOYgVvzmDAAHvFfjvSVylDHAqhRUXuwtr7NA
IxvQrcYIvpv6CN6ZKb2//fzIxRidTqd7D6HuTe4Pj3/aDM9teRFK2vIQ90+7ZhSAOs4Idi3T
NMMGXVXnDXaAA3EZ93zACdeqjEg2A8/gprT7Fzxce3VlWtzV52dndLv2rr74OIq69Ed57M6c
svjuGgFO9cnKBQTHyrYESe5Q92JjC2y0mkHhUEZ0Cwc9ijlVAcpC5BitqOzGOH2eGy/aHLMs
ZFmk1TwIDAMaBX/5arXkNzyiXSZiII6nlA1DlYV5LbPBqO9B9WBz8kWeDkF+V8dV5rVLsM1r
OoyQqBGD8sqNIDnUbbpp5nW5EZgdGi9qJFIbItDNoJ1hlyLlWlsuYSTlKY/KdsGwPkxDCnPE
AgTN4vZokaZ8ztI2tNcrllb8+uyvj/e7zf2X3e7hzP7nJ2n2TSZu+5HlamkSqSBgm9wqbHU2
R5cN+KorLLGwCGnN4ZFpmmJkllDHKGyIenmKztzgk8Um7PVHivwGomFdMqipoD7s4UXmp+ej
fTdAtVmXPenyStj1Z+tia55ARSSwfGw8+btYQch20jZAzfuNDCvZ1nsY9zH7/uq4EyezSGeR
O9al6zUyx/ALUtizWTdFhA2TSYIB/eyv7Zn/X9fCsCe6wEOdIisWtxqKxJ6wI/BOViqWiruB
M/KOsjeH7e+Px90WG9v/ut+9wNygkKfc6W9gqTVUv5wKncam+n2qcnjzPMeeaBSBjQW2gyaK
R92lyOuZXrMiME4hwT9B0QLWUAaoZZjZWqjiJYmQBQ1v2EAMrpOgxWjwSZWb09yaKyUVdbpr
yGxnz4WY+RmOC8hBh9UF5okYKBtbJVpGYJilSG4hj63UQC689gBK3NwcCGeFeX0NGYWtnZq1
r1kRCun3ncI2EjEr7HNgEDI99JLjDQszgmLiFxc9HNOhRrDG6Q/WrVcxr3Ku5xBYYbANJ9h8
IdF4CPUGifWaXnPbvHjNQGmxIkULhXWDnIuV2GgY7I/ddHuaFGXFTbQIY+0aqkqMfxybkCz6
XAlFv854cTymb++BEERNyf4uWpnGDj21vppHSHAChWHelqN90WUxY0YPf+PtJaPzy+GhLKgy
tnLuAjBx7vs2BRpR6CnePBUGa2kDNo+wteYohowryACMO8LmO3aMCf78BgpycAXmhgbqL2G0
ZrjpGg5PTobdnFOtIKfLQ4x2WjhjTFySoMNjCPMVlLDgGB0GUYrFOfaw12DoDgJVSou5rmDx
vELFvqNBs8A1NtjLC5DB7A6xYBjB6lI2HYE+P8aTOKdVPJr1Go0fnCLZ0BbJ1b++bF5395M/
bHh/OewfHv3aG4kGMbqTzmBt05XXzO8NnmQf9mbfCK9dFg2pJh7guHHKHGLoDN/u1hhWZ4ll
abXZ3AtIIfj455AzXFoqcWLNiWe7Bjo/75+q3F6yM2UIPCGTsaYTK0H7o1plzg0rMys7GCxI
rnO31aXWkECPIY0mjOD645VMyPXMdfX+c0eYIxPwnSkrCvQkLI4VxsagPu9Pt40m8b922+/H
zReoVPHS58ScdhydrHAm8iQr0foH2k+h4ME/AGqIdKRE4fVsGkQmNHUdD5l0hVOjcWOymolk
u2/7w9+TbPO8+br75id4nZs/UfH0xU7GcsgqCUzQAzYnsQVYT1BdOWXTDVahnEKt4B90Z2Fl
NaAIszamy3peFYECLDkvzEmcr72mOmxxeN3T0SO7Cu71Hvc92AlEKcwdUZzgYOSgDPfhzUzc
HQ8I2p6VNOZHmfuwlu9WKQW/W5TGgsyBx1VwxhaN9idMgqQ4GjSYCfXa4TVI48rRoOqyO/bo
mwc6I7i0szO7DGtvhl9fnf067UMSZ3nEoAz1el8ZI7jdFVI6Knk3q5xQdXeZSPe68p1xqTIa
QtrGaZCx245/U5L0aJgC1AZYJJsrx3blzJ1bt5sRt+d/bXpEXS4wBwErk1U7q2pbGCiTVxWD
eo91VPrgWnKb7jAvco17gd503bOK5QyNlOdtqWFcSb47/m9/+AObiQMfApq1dDnY5zoWzLsj
CEHlhhC/dO8BwENzT8gdidBSUuZwkyjHBeETpvKpdEssA2XpXAYgrEwCkOncJMx/u8Hoalbj
AUBEXcE0FNZEeMDRtAV0KSIdCrQIAFwXoTSFn7bDNoHj8q4MNaD25ZRscWEuOnFfnxyw2Sjq
+oanFqKwzt2/pAtQFq+wWx7XSlbekZbAsmIGJiD4UJ9bdhgrTPVGn+wAmWHbEDP/7ltIBJF+
JjX3RLCYKGVaiziQoMip+gbXVBQiWHhRzBXeIciqmxBRl1XuJZQdPcXCversLYeRlLwnkIP/
lkvhBlTLb1UKH1TFtDSJrAaAXnL3swlEurppAJ5uthDH0vp5NDgwpIhaW2Hl9vXaAI3Gh6Ib
DAlsnItHFxUDnyPaRTmh41DBremBCIQtB1cvKbPHF8Kf884EHD/WombebdwWGlUz/4J6h1nD
29ZSUvd+OpoF/EUOXmh61XuC25lb63bwFZ8zTbLMV6Rddni8VoXme5oqPSkV1H2SEOqWu3rY
gUUKqZEUtLhx9MYKRPGc2qWZ1/to8xTYJHJeLd5s40mKRSDOkAB35CSF2Zs3KHLq+l0nZTwn
JzdTJ7mq01zbtbv+sL3/+sFd0Sz+qIVrnMVq6vu61bQJFngfPhlx/EBkL6di9KxjRpkEWunU
uivPcqfog0bpO//jvy0TxZSMLoATrtlYLqMOa9pD/ReAtx7jr4MEsoHVU0VOG9F5DFWiKUPK
24L7yz2UC4FeQDIQLyy0EHpwEK0DLKRH2IDQw0Udi2p2GJ9P63RNvtDgFhmLKHhw0duqVJF2
vEidygraOcCe4ZeC2PLMmPKuNWFBVTTZQxJmXmYQlEGm2QUZTlbQmT6Qdv3VEOTGjr4NoEQM
xUNHNDzl3x92mJJDyX/cHQZfmrpCNq8BybDzcUo6/Atc65KSMmGZgHLICnaCgKmCwjacsV1b
nsK3XxqOEqRyfgottacWOd6sznNThFEzT+xXJMGNmgYMPKES8cCh6negNld239xgLBvy7SX2
IrzmNsKau7I+txJFGmFiPz31eAwdEELl7LfA3TrIcOkNSLotQgQpjidiFCwoF+xMmltwnhR4
v3NEBigXQmqsIJAz/WFeYvPGEXa2vvFlshriLlWh5M0tpVQ33XYbk7oxXbbXyXb/7cvj8+5+
8m2P3wc5dbA7tG48iTf0uDl83R3HRtgTdfvlia4yWqSOqndJJ6hiHZH22FMs0sCpDSlwJvTy
E9TY+jAfFZz0ND196mbNJAFt8T1Bs9AnpcqTEfMhaUe9UE+Exbb3ZTdFVHL+lmBW+94pWXBi
TZH0Iez0a6MieyMYeMSQiEERZEpiT6G/bY7b33evdMgxRoAfimOXD3OUt95nqb1vfQh81H5r
dYIEPDrPy9FVaKiK6n0SxdGoFTUEfPW2UI0tnpKIR3R7liIl81uCEN1tGCEIqnE3YAlszvxe
6UShWD5/54anF+VbC5PyfE62fijaZrKn+EFW+T5mg3xwQGDSYu+yOUGVJ03mc0ooCE3vEyo4
FiMobKfyNMmy9OsGgiZMAIYUp/1gQ8NZmr0xd8UjMNj3TV9H5WlLG8R9gqRty75B5X++RpBY
T/rG7DAgvm9ulfnIpL8weyrP97qHmlOrB4hV2HZdaVMujVHbW3teCxWAkAo1Vwsumh/dKFZ6
cjxsnl/xTi6ehR/32/3T5Gm/uZ982Txtnrd4VkDc5rcM8Y6XrEeahA5FFRehLBbBFkFX0sGN
IoJOgYNBpRqUWWaSr+2H4M4vv5iBSg2ZrRWV+FhcGoVCrYcgcxwZMJWrsR6JYTtLKWfWI1X4
jngRQvQAkhErpcnPES0u/zykhwJZ02sKFcDosupFr22fnDHZiTGZHSPymN/4Krp5eXl63BqD
mfy+e3rp77OL4t8nSui+jot5ophpMThfwwHcepkh3KZ0BLypFAN4Xz8NEHFVEFBTEY0w98vv
xOXglqZY3gLpeEk84E/KCGsPKFEMO0IIb3K/UI86TJDsEBSqGF5Lc/FlSd1JtRRhw8VC2+w9
qGJbpvncv87uDTolb5spl2nIVLF1CIKVp1eMORMOEa507U/3nFDgRsP/nL5Px3tdno7o8nRE
l6djujwldXlK6vKUUtrpiAL68EZbp+6STcfUchroJYXglZhejeDQEYygsEIaQS3SEQTKbX/v
ZIQgGxOSUhQXHTSTHZRW9AnqlDaaKWU1Q86omuNsrQ04entKLUnPO20Lz5hHz7vjO5QaCHNT
zNdzxWb4bY5UrhBvMRoqe9f79NpPTas24yV9iuPQ2PUbd7phc7XtAic1n4W63OAAgefJVenJ
5SDLethBpqhy9wqMg/l0dlFfkhiWSf8noFwcGVscAvdw3QNPRziaou40T79UcxCDSsfB6ZKW
ZJW6X3X7U1O8SG9H5IxhId8Wsy5HhiseC8VHfgHHFfvN19i2GTV2rBc2o4KP3/qwh+JRf85u
bRIAkygS8ev4QUTDqkayi+GHQSTdJfk54Ojbelmar3sWm+0f3uXflnlb4fg8g1HOoKbg7K/G
w3Mdz+bYUI/IqtVStOev5u6GOcrCs9EhJ4JOL9g5uUCjI8LfkHPp35Lg1JvdrbcvD25KKPLH
pEr7LUJ/Qo/fMmSg3gxLupEBdaRuC/dXQQ3Qv+rBSq+XAI91lAqKI6LAjLk3ts4KyXzITF1M
P11RMNj80CaaZpXz5P2qogtfXVL7MXQ4hJ2KeQZql0s5cqLYkKGXahy8IJ1xpuiWXYOOEuro
xH7tYk4P/OZPA/AunwEIAiSWE79eXlKK4xLNVJQNj9sCgnEM3hZoPkggZVjwFKpdzkdPKzrK
uV6TKuPS4P9PyUqtjkHwUUxWLmnEUt/RCFWmV/XoosuIp3LkaGxAhrH8/PMbk/4cjYgOmvbr
5dnlmCT6N3b+/5xdSZPkto7+KxU+vXeYeLkvBx+YlDKTndpKVGaq+qKoaZejK6bd9vTy/H7+
AKQWggJVFXNouxKASIriAoDAx/ls/WZTqlKoJOYDT1y5utTb2YwLFzVj3ryK25aB2pxugUHv
yKQ3VkOxSuPQAa0S6Qc2Jq7bBn4s6IIkEu6wuV6snYdE4aQrFOecVLtJ8ntBUGUsgVtpOlZ2
5gORVBzH+M5rDurHrukWadBsn48/X36+wO73rxb9kGyfrXQjD490jCDxXB0Y4lHLMdWu4B6x
KFXuDy7d+dcfg+NFG98xD8TU8fWRA4YauI9cvVX8GACD7QQOAW9920e+T9iQ44r35PWFCuyH
iXJPZTxa/rQ5XPJPaT0B+H/sO+Htk2V4NpoP8PhGk/TlEPp48uzhsXj8R77vEURwuvOPj+8Q
kmKycr7u83n6CxUqACHc8ifjbGwJyfXEj42ppxjwsk4LPHKLesf0hndHBr3mmJvEmYln27p/
/eX77//7Sxt49OX5+/fX31uPKl0bZOLFJwMB09m8QxZDrqT11Y4YZq1djenH+5h2JYhcltDl
J/dv3NEn5oepV98KpjVA3fgfyzQHlt2J0uQID7TvjyK0bHTFekd7hm58NwS/EDmxIXO0NmF1
uaANaJkyfJDbiWSHJzZqzxEhve/Q0RXiv3nLwozht2pWReAY0HSE8OLHkGBPO+Mx/USkT0a0
zA9jwVSVpReHYuhapEXix3AYTriVyCXelL6VeGcEU4fyUzwM9XLgxaWNDBo1CBrKBwl3Aqj9
TDTZj7roWpHmTL+oI9PbNuaMS1Cx3yI4nqA0U9Mo9LJltLvLmDEsIqS6SnY5TFOrv6InbZHk
lIQo0wj/mycEIvQAGozA5LUbR+v+DDATMjkcTiQCbp9BJOMO+hx+SpNz3MLpoW4OZtQNbCCy
fDhEGip8G/KHPIpnm/fkBCzXg02ZH9RvVVYq72U41Z5KcNaXifKkleLIp8MDKWDieYMmcw85
z9pbZe1724BPMpqSJay+Gg/pvTDOXuqxrALRbvDBNIHmxd9NHqeIqtPY4DXuk5Zuln551AbS
w82+xRTPsrYxm1CGSW4e2DVJ8rf41tgaOpEcxpAd5bS9RFx1/YSrq1P14dH9gci6VRmL1MJU
eH2Ku1kfjuNmET78ePneXi9A+rq4VN4tAL2LbvSkx3ATEwdHRlqKyLyzxRh8/vQ/Lz8eyuff
Xv/sIxZI8JoAK439xpJdPA/Uj4u++Dhife0Y6Oj0W+XYeO7zScw609BtrI/mtiC3jMEcHGg6
To7tnTNuwR25iWXEY4+5Qjodx0Icvvx8+fHnnz8+P/z28u/XTy8OptxQAuZPJqQ9B9ehgx7u
ivKJwwF+n6U6VFd98NrfkQ3YeotLwXdUL2lrZgtJK04VdCX8ZhqGjqiZY+lXUQYWbvuYTBez
ZT0lUYg56+po2UfbHYR4g3+Elpa3xGsbkhpsM1+0qM7Li/9IdQk/8AjrsU7JvRnBQdE9Jo6w
jpQuLE1HGaUFDQyDugR7CGtG9WLellbWF5qKCIIXyfk3AysWnkWXV3LKdlcI6OPiWMnjCb0p
c7KoJ4Zk0rMRQIFfQNoHcReJkxyxchG8BNZt9iqGTlrGiArVAkM3eXYlboVerIwN3pCBeMdM
3PgUceqMIw8/4iS5JqJszorc30OEEBunxgtwVMlW3NuTk28xWqiG9ysj4cD1jiu482oc7Jvd
d/AoJhO+lAyjlIg5gF8/4bk9PMF7pH795Y/Xr99/fHv50nz+4dym1YumseZX2l7CX+3HEgzo
LVON7pAGvEMAWgxIZlzAcy8FNqOJFjbogAYtywGgKY8XFboeCXbuPedOlUJRUxx+B0EBDTPz
cm4MkSx/Mi4wxJeh4OlAVT15y0LPRbQnT513DunZ289684+aHgPByVwbjn5aWsDSjxAVu8W3
aEmgh5nJ6MKloIJ3E4nCW6+a2o/etvxU09BUXFpo/paBoKAoGUehkpxYM3F1rkCk064dHdmA
+6GO92HQ4CK7zkcOoGxXmZSCZisOiIOvn9onHvIxwuDVAj+d46QInAzAi1VpEQB/hmGbRSLh
jz9hTJjCj6pMYb21+IO9u/v4+u2Pv5+/vZioVTeq8Ah6a04DcyzqZVcOwl72LeilLdjdxIsM
khhN7zsK+23Vb1e/HwkDhnmjSEDdfpeguu1yA31pYLvNrRes78+w41vpboSWanRD+2Tjo884
1wMYHc1DNIW9hMCo2N8I9DSi3ecjEuI7jYjktq8oRahTgcAsh+vxSKc3Mo9xJu0iyYMVB4Zp
jwxq9RtqLLSAIYi8kZdNwt8ccajmjSj4OysMr1b8HpDXVSDt7ay0ShT8aBL22kZU1GDiKsc/
h14mxKRJ0aZz+wYBTlOJVL4VZzXmOUCoXbf0y20Oa5/sYq36SZjLFmSSae0po/HzacVp9lHl
bOkuxGt+RGCZit6zCUREE46qgybEY4Lo6i5KJBAt0g/LuuSHD27bgBQ9ZSJVXLdjpRZfjJRB
xmlu9jjyGx6IyxtiZ7loWpaBO5VXv4Uz41LGsHEw0ofgkHNcxu4NgBYwEG85aPE5Dbqkr3q1
pNFCnt3S+EE78fydAe7SLezY6/dPzoTphmCc6bzUsBnrZXKbLVwQ1Gi9WNdNVOSkJQ4ZVwpu
VFzT9In2sKhSRNJ1Dx5h6oMxcUX9GHpaSZqmbmaLzFWGezDv4EEJPCspC/6QFYcOFAvGdbFk
bufqOqAUxCKt8WoX0LSiYwCBu7gVeMFEcA2A/yD2D+hHnD61aD+shbSLYRKmXDqG5UC3Uc8H
5e6XsibGWk+v69WGXR28Gu29nS//ef7+oFBt/vmHuTjo+2fY5n5zEkm+vH4FKxIG0Otf+Kfb
0ko1umLr+n+Uy43KdjsydQqMCX1+OBYn8fB7tx3/9uffX02Ci039ffgH4ue/fnuBuhfyn8NQ
j+WZOAoQz68pK13732rA6HKnDFHAVNRfe6qlVp2hPXzJ7kXQtWi99cMdhswDNjI8juOH+XK/
evgH6Bovd/j3z3GRoOzEdwtjO+wXLQ2XMfZNJosmtgnsnTlCwRuFInD2abHA3IvCFHWooveS
vzwNw7jassnqYBcNSvIAdayhMm6X1YBfYZi9/vdPvBNc//3649PnB+HAfTJ+sbUbQbs2w2x0
7RjS00jlPAP1nZ4xqA9YVikOjDZHZeIyYrFDu4ibg0wbffSO85CBfny/uw0dFFH1+GYYVVpt
18sZV0B62+3izWzDX8bQSykJqsNZFRggtV9tt++X3m333HpG66/r0eERYSL4x2SV46i3kch7
IqPaaCczACYa/SjFjgkgw/zKKr40OlVjpk5h6RmCtya4pnauO24KlCvEoNZyC+u9vxW/KV/A
9oh3qrDLxXtnk2OtInqvn0uLGEgRKOEiEbKE+iWX5YDdhDcXaM+m755NxUc/2K9Gu4YhNbcF
X8bjFaeG4JmuWwp+4JG3fzdgR3a0FxSCgX2hl4k75VpEudx1tK+cEAqY3av9bIeXIVSEevIo
J1Kv+dl/PLe/7cV1vpLIfQ4Jti5/9ahZuEVSxxEMf1oxef6mPCSMnmWwSp2OPiGaq2IHSJTu
Z4ErYaKMTZx1Koo/0o63v5uswLCMTEC16GCIw2PyKEoRUY2dFUP8JOiSUG+1Yqc8P41jElpm
bxlOl3G+ins82kdbpjnDmX4+FWCwuKeC6W2zwqkOne8S2xWl/53Fbjp5eisKEjppCP6a2+nC
tZhvdm0FjmUZ49Eshw7rNhc2Buqku+jdbs2v25bVpBPOTqdYs9+8S1DD8JxuZiYqFAp8Fviz
zLM8lEjei9HnFS5X/jidLmG33Du3HYl6B1spPaixJGsU8PYQWJZ+RYPpUJ3zAPpC14QClHJE
1WcnPqywCUYGDEzYF7fkiqaWQN1L1itCVpoyzTycgK4SMJxjLVyP7Nkfe6W48V4dtxiMZAjH
V7ZSWqT6GkIO64XieBSw2LHyRJRH+BcOTewkUxZYnJQlVZ6Rk2YNo4hcd4YEeETHMtSgygz5
N2p6yvICthKyUN9lUycnLyqCq+Km3pj0d/WRfFz7u7mv5+5I6anLGdFTW/rhiiEuwYwsR0pl
Y7mxlMie+BbRoeq8hnUSMG4DHMmJqvhP3sqIWhm5KZkkaSpfpltdz0/eeQISnKMXfQcKOfyI
I8T7PZ0Q2vHMOamOCi9LtI9ZZ5FSDygaiioQaSfe7RKxzrPmVCeNV7mIVBaotVPLaEntQnbw
C+r0Kb+wQUCm69V8NZsS2BjVl20NcLe15ZJqZbpb7XbzqVJ326lSG/l0yq6aviXSTXCN9/Gk
Au1M+I1o1apAHRHoY23HuA8pWSS2WuaZpK5G8qhiNPVdPAXfNdGoys1n87kMlNsqId7gaInz
2cljGB1gTLMGY4BczRkO7tGUbG9nFaMBmdVQBJp/wW8mqt1sWdPSHscVdBaeV367SQXK7kwG
WpSx+LxyQIWaz2pejUHtCkaPkqNqhkW72C13i0VoyAC3krv53K/VPLbaTTy222zZhzb7wEOd
5UneuF3nTrDQLMqT9R/RQQEq336/dm8YtJ6YDofeJdrjk5aSHxtPxW2fK6mL2ZBhi19xGqBh
dnYmfUToImYxV2xTVHUQbtyfpUoEji/dmw56+jVTRP8xDN/GMsRTMXot43E+tgoUbWd6G/k1
CVtLDL1Q/AGZFclrL4zK5eayivNsVK0qHlez+T5cKgjsZvSSc7vnoJ8l/fnlx+tfX17+451j
d58Z7/UdejNcSSeKXfa2VAejWwfUQiqc4v0Tp1H7C6nH+6VzEK+bGkU4fwvzaL+7F46VCz+a
g458oGQkRzGelbGn7UUxwpBAWloUsV+K6QhUL/hycpIlhgRyP2ZFm5rTtFwsX4B+KSkJKU1V
uath4lr2OjlLyuuP6WnWlWFhxhWb+41MjAMzfznAJBhXaHxkvlMaGXgprFsF0i5gpbOod8gs
EBacnuW2gYu7Ob3jdsRd0KoTkW13dU2J8M/zaHTNR61pvuUDGqnMvplvd5ya3onJSBp3zbiP
gNPE7nmoy8hoZGfHsl6NTmKyfSiTHhQXHdh/pXS/mc3HDdDlfkttBYezC3iZehFYCrfrmgv2
dEX2a+qY7ninZLOYTXVohirTbjZuNepnB67IVOrtbhkaLyYOHIHGm3Punq+7/aivB43pO96l
TWMRv3qRqCZdb5aLQOUiW2wX3rsc4uSiMkoTZQrryNUbwHEBZsJit9uNZpVczPdTL/xRXMvx
xDLvUu8Wy/msCc9KlLqIJFWCe/4RFLv7nQ0l70RANV7Pa2/cYR/6ScJIV8WZeNyQplVclqIZ
yd6SzYwZGPK8X/DDWTzK+Zz3kQ1LybKJA1Pt7uUbDYwA3Z72aXZSmmyCUeSa0lFGf8EyWhD9
jkiYn03kggNaUjLPB2zbP5D08Pn522/2zNc3SO0j56O0M8qep3796+eP4NGsyoqrizaGP03w
p087HjEIhEYcW469OOxCYqgsJxVgcNctxzTm+v3l25dn2O5fv/54+fb7M4nCaB/Kr7CluZGW
lI6xj+6E8rgaURaypv51PluspmWeft1udq7lh0If8iceE92y45uXh9ORvchRp+vDYYn22Uv8
dMi98ERPxLQ82CZoMsKFOs6QjgLrlPDQdgbWktPeB3ak2Mdkfih5OKle5HRc8DAXg0QZ8EwT
iSYQJjgIXfFi8zTnVJ1eyNybRbIte5ZWUXzHPL2SYVZpJNkeUOae8qkq76IsFY0z63mpOMUJ
n+84tAuvgMzLA9dkZB1Iuu3Awwvy+He5qwh+MJyP5zgD5YTh4EQglyL3nLqg2QyEAQvF9Ecz
QoFkol6o0EbMeh7HZQzsN6sr6pI3kHqJo1Ziw5uIdn4ZgDMWwtay86s82yVl6CyHiDGGBeZK
uLEiLl9EoOesNiHmdrfdTvD2Uzzqu3X58qmqdOGd8DICbxSw6koYvDKMDB8h50pi6CL0E1/V
WaSFPqtQS8HawEwQHZfKvQfUFTleP6hKX0PtHJnRjMzpmn0MvmiccCcKrsRdoHPyDlr4PFRI
an68UY5K6801aSo3iJDws7hWgX5ML9v5IjBG4yzFyz14rvm7xOjMCf5dZaE3u6e75Zy9YNER
Mtok2LS5VlWwo9NaN0kpIn5O+8XZkfGOeguRfaDI7L7EktP9fCFFAcBGzamu5YF3xPiiZrS9
SzJKJY6GOW/djVpYvmeQGcnIenanXshE1oukeW+Zp7yiQVu+wAdMZ37nt31zyhmphZqq7+MT
nlyrd9ZYYQL/ah1yKPryZia+p41CPxnaxORS1WK+DPD1aueaT5QnzboYWBCAvcDgrvAuYCXW
PNO4jUPdq6/mttJlMCarVW35+6TLVI23FkPk9xLDOrpxZB3Ff39DX0RtdK0v76bttZSFT1nO
RpTVqJnHJa8lWyYLedWy1p2xdO7sPPWv/AHNNhKxTl6KCZ/3JMzPRu1mq4VPhP/6gfaWkahD
oRfsa1iBUnBIM5bXnm3UhQZ1bVRnG+/GcICUemhC7SOlbLzmUH5xYIrLMeBDFK5h3b41Dl6u
Aegsb+mOVyHmkaZOIo3pFRsdpcn0er1j6IkdLK3Tm/vIfbwyZ7pbA/Lz87fnTwgNPMplIE7k
m9Mw+J/OE5NolGl7ibgLm1F1AgPtfHdofV+A5MDAa+EjDwhy6LVM1ftdU1RPfAZPAvuzfBrx
O665RBATttqbXG2g+cu31+cvY9eH1f5swox0QyVbxm6xnvljqiU3UVyUsRRVHJlrHeHNAoOs
e2C+Wa9norkJIGX08mBX7Ii2J28Ku2JtV75RZ1Y2mM6PV6cz3BJ0N5XGvQhbkbk6O2JP7Vwx
e7TX3LAsth+b6E5jLQiLp5fVYrereR5M0Tnx8rtMGETFWblmrctFizdzUbxcpsl/Yz5OfmQD
f20q0Z9f/wsfBooZaCZDg8lNaYsyKT3h/pRJobfz+fjVOgY3wVoRJvTKF0lFvZzPOIcxERhX
D1YERxsvAQ4vOLVwnCSezu6x3h7jvWQ/zueehMbrddSodkseHluMO9JKME0ISHZvOiV61jhs
lwv2wKT7yEStcohTX10d1W2ykTbBIVyrljKrC65ow3j7U4AxsVF6S895fF5AD2vFYC06xGUk
mKHU7vwfKnFqF5jRnKISbze4fYBdrxwezgbcgcdLqCt0ENcIr476dT5fg+obat37WobmqmDb
1XOCc65VoEB/CvQTFXhHY0CpaSar7CXG3VhK7kuV8h1fB4Rgdtqe9yc15vgmReAFB+Z7Jq+R
Vtkxiesg7k0/B8E2Mwnr6qQk6Bdcunk34ivYELmXt4x3TKcqXS7Y54H+nhdLb/Hh2vjv5G1p
92T0zYA2sdDA7JysVCWHGJQvUH392JEug49qYv5QklWZeLE6LSuDNhlghNKF9WrOUUKCImQT
F6Iom/OtQcRHeaaQVEbApEdbBIAY5dgI4uakKS7hFQNLKy5KyyThj0CVLVVTBIqbZNLekHqN
DpObNp5AhXLaoVUIhZaxIFAtBh3zSVWRKjD8sihhgRMM+yJ1c0jdLB+r5iHdCBBmVphA0AC3
fdRci+HzwDYoMUCedHlPNPfNgSmVxvzR7CB4EKtA+togY3uEeeNBpJt9I4aJ1WUZ1YVvelw/
ZTlnGgwi2G1cmZf4SVc5DaMbuBLmSkDRG4RqPFFn00lgQKUUQBkoF6+Hu+96s5neXfEiO5lL
fe13cYa8hH8F+y6EbOSU9j1IljoW8w50HHIjy3XAhSlPYzWbcG/QpCZ0W21fR7VcfiwWK6ZR
LYeedcDumjyRkMqOYjEehosQR7Z479BpO6y8wl5xyPOqB26xx8MLyV5CuJDseuuKO9JLbs3z
+tlk9QbAjZBnUSSdhRppZkhZmxtUvfT5e3sT0Y9vf375An8yB9r4nNWP+AUQ2eV+ueIjtAy7
Om/3gVaKMsWo8OXW9Xbah1KaQ9UTMSMnCjkgjVStzP/j7KSywC4MbETK2y25rF2HS8ISWjqG
2vst6yLwz3qqZRje+RhQspHdR9iSp5isRo7P9YsrNTZbzQhCDDcDMeSPrTvCewQrBTaGi07x
DxV3QYf5MsWe6UOrGk71H0q89fVN3LA+yua2rMNjEo0m1CqnSgpG2CJTpfj/Y6i3qTEOhA+e
4QikpNjtVvOmdKFm+n4gvpiWSNayjhiNqDZjBf46Sr+L02qznuiVtNpuFoGLgAz7AooeH0hs
OhV2yuaortMC/hd2e8Tm+RM0FaTnEhZ1N5fJEFMBC3zt9XOlzAwbizbz2ezi90cOagsXtoG8
QklXy+hJjX4cLcRFLRYT/drlRgRqKpml/fHKB8ogTy/lZsU7KZB79svSZ1iXJgb6lH8C2UXJ
uhdblh9WZOiooYULNFbSxEKImLBarmjndydTlLQZ1/2UwRohAwHvZhzXKrDBWvfifO5VbaiL
GSwriXBhnQmvzV0jNVX/x9iVNTeOI+m/oqeNntidbYmyDu9GP0AkJaHMywR1uF4UaltVpRjb
8viY6dpfv0iAB45Mul6qrMwPIM5EAkhk7vfUyoecgUqq//5OURNq6MDpL3h0qMBzjJvsq2yJ
vmYGflocVrfI+GOp71tP6QzdMwb0CBWad7NHkxZN0Gatd5gH/WoocctCUDVfEk+D/dDr4YSR
wxV99bwWxsCRPw7KOI9ny9ZXsyQO7ls96K0J2qvIj2fw8dOVFjKQO1fr0YF1XyB/kqpZVhU1
XD+tKETzAd+QE/IJEw7vqG8cXd5gqTsVlFPv1NsPfQenc8f3y6v5Lc2tClmMy/0/kELIAo8m
87nMNDftEW36IapikncrxextU5D4+fjn42mgnwcOwG40i6tdXqrnZmrLIiqWqkBk7xfZcqfB
+4/T4PjwcAYXecdHXc63/6ZKeCjCtanK+1UzOopncKSB3QHKprPW4Jqg/HIVUqOtHY1PRkGD
yJfO0UiThJe3tksHfbjhg8HThem2VtFCa1a0pMN25FBrl4hNO6enp8vrz8HT8eXl9DBQuox3
wabSzeRS4rg8VHSt9JvjWpO9R2IY/yBI7UmjiD2BYpYyj0VclnegKtrH3ooPavRNnuHKaYvY
rwRpBKZBZZiKauFlT3sR0WxPkVbkaKeDbNl5xTyk1k/NT70kywr+GxLGP2ZXozdeFq6sB5md
HFRkOvN1suvpXp7jeoliJvmKh1vc8kYD9K1gL4C4f1HsdDGfitneq1FahDJbOpnSa/1U+56i
pnv8OE+bEqSy9bG+dWB77GxHj/GQlV6BqPNbLRxYyiZRIIVWvsBVbA2jlbman/e0vwA/M6Hz
CNCB9FZZSkf10pqqtxRxof22UpGVFkWl0UrZfOrMuNZIys6qUazoMmqXSoTFl0YoNayHn/TM
gq89CcG9wDJ0HHU3Tvloia0l+jLS1NNfL3Ld9CU5K/nXPPNF9k2cFklfnyXBPHQQVkMXYjq5
HgV+r92m+/mUSqYtRM21GKlBqx321kyuUSMzTLqeoXARfj1CpAHbz8ZD7PBBs8PxeD73B07B
RS76ho0chFdDPEwwUgP9OEaOMq9mbSqEq9jb8+v7h1R1nFXbGUqrlZyn4AuYrKhUh+qwYPUH
0YybNDtLQu5GcCvhKfKjv//7/HpSzng9NV4maWLXiODqeuhkV/McqYukHe2M0+iO4a5lHUes
ONorSGHNSojH479sH8syS7W5OMAzUWxZbQHCOZ5vGVD1IXaqaCPmdOI5OGCIIJ7RZ7mY5qN2
HlOCERAp5sMJWaAxronYGGy22Ygx/YGxXHKIQWGgyCabDHGJa2Jmc8ykxkaMiLaJh5Z5nz16
2l0IhNJT3pWNm3aDqNTNG0c8u3ypjqI1MXG14zlFyomnMhaeUsRdEPxZUbfsJhhOOiSy4oQ5
jYmtgwGrH59nXIXB9QQ/ODJxaTUdB+NPYVI8bhJCQNo4VW+827BrPpOvFZpPvqBBbZ/hXyrT
fMET8kOEWlFnXcZwGXVwA8JgZQkDxw4IXGqnv5QDhE5J7vwSajp56GGB1jsryloBToHsMJRa
cTiABLSjWtYMBceuBSFggJPXglVyhbiDoIDz66uJGw1P8WDyE65hTQgqQSzAyP/u4hZae08y
Duvo1mdKDWY0C2zVBo6cwNEVF8VoNsSMzRuETD2/Nu3mG4a7gnYJwGEfrvo0mKQaTyeYlG8A
yuGdSBcLvzqrPImW3Dw5bRKBgyN4MFFEPg8G6thoUmfgqJ/1WUp9vqKtPY/vUq/BrIm1620W
yVwt4/6OU0kWPhBajBjPPkHs+WHJMtCeqjLHDUmbvOCoBCsJRGootpS9k8aE8h/GZRMWJXFN
5QALQdzM1Dh49L1H70NrgD6esE12WofmILqvZqQJoUbBuB7Z4axM1jXucdmAjOW0oF4v1KBy
NglcLd3r6JC6rWmqk85wE1zNzqpQq4hcVLllxlzztakNwhBsbDqZaOjFLq1b1mGYZ2HNBPB7
jt7AtZB1NZr42at3qjO0Q+gHflBxZl3O16QmqA/atA1GaQ7wTBczu2lAcRpLGZDBS4J6zZQz
PWFSMgozTFQDVy3T+9UcV5Qa9q7k6kkwuBMsCDuuGtoEvFjlW3BlVhx2XBDP+pAUS5iJKnRM
T+3NBCrGj3oijjW4idSrLMTlCQmlp0llFwTLl6wcggObhYPtGsxkWxVA+E6xsdLE6Sah1c0G
5dojNOsEGAR0Y7amgvU7MpAleZ6mDQf93M24ly1lOiv7EZtszjFEzW896XmFhkNDgiony9hn
3fDyZpfnkc+J8maXa1Jrcxwfza6H08Cng0VAR6wdZLyfHuHO5vXJetOjw1yEcnngWTW+kls2
H9Nusfpx3Vsq7FM6htLr5fhwf3lCPtLoJnq75ddJObAU2OBQcQuIvm2CFFHfJQKSYG3QDGsO
3nF7v/Z5fvp47fj09vH8va/BKYhRHDnBc6w0Kpvbj+OjrHZPeyv1sILFxdxLk+m6D3/dB9fT
2Sdzrox6ATuI9R7lqK0cPBXPheCWOylhBgEECMQpBadUJrb7vgEgPlHHMbMv/eSAYsjHgeyM
O6Y8YsGAwPYgwK8/kHIzGrP+gGO1oIgZRmwKqeIEpBnBdTYRmufu/PSJNRgLfPt4voerW9Ll
brqMvGfBQGPV9UiuHoSjRgUAc0Aw4wpt0+SOuU7CCGsy9U3Ye8QQYXPrJk7BphO/i1F5Cx7i
GiZwQVhOAvKNtIIkGfboFVjaIvmQFMyJUwbFCkfjPflORyEaXwpe0n0wkdOP8rIAkDWfXgUj
dbdF5C4Rk8leIYx9WAVxvaBFjHVBgvWtg02Dg5vrmVm2+KvML2T4dYrqpV7ulhdx6blaMgBF
Ore230AT6cR0tdeSXDekQFeHJU6N2WI/GQ7RMSuqtMCVQcUFe6VDUaJxghXAux0DagXmOOOx
bPlKhIwcz8Y1DUJ17YcVj7q/UYO8vU3yiVhmobiaJcEVWfldOhkNqVEPzNHQzVJuQa7tPaHL
nNvFa6+cPJptPFl31TiQ86yxrHH7UTIVi4hUCDmHEWn4DHztdzodDeE1BX7l1ycgW/2uOcY0
C9kSyUO3DqGdoG/zpGIrO0hmDYA3Fxv9hkpsnNboUKDIKz2+xfV+lWXM8QzS8WrRi7Zch3JP
rj2Alkf4J+AScDYN8LMaF0Y8U7Bg8+shfjzhZjbHo1S4sGt8BXFgc3TKGCB1FI51KnBMZwU2
x/TaaXOuZxinWHAm8JYudpg46/hK8yuLdI3lW58aRgCg+YUdp8RhK3+T1POrDiuCtGBD3LzZ
RgnCEaWBmqTz2fSz8aBPMD8DKVGzyHO4yuxtSI3clvFysVni7aEhxQ4/yzVxu6u5lIrb1JVM
HlQtIAEh5hyYXGc+gWHWGb48Aqs8vIL+qRQ1KhK24AssVGUZeks3xGpnmI1tws0gWhCcGijq
ksT0IQNKZChppptlDkF0WoZFL8OJQe8OH4AzbThoHSXkyzbEIB1A5Nkdkb1g2V3+Seo1Kwsi
eSpl/80i6s9gn1LJuT6w762d1I3SXoxq6y1EacTuImI3wBlQsrziS8vUGqiF6dg3jSPOFNl+
FF0DD3FZqlhVXzBlpE0LN1yO1x1Vop7VDvj6wQbD1jpge7c28CXtSELKIVw3VpgK34BoHmWg
D1zPGqvlKsdqm0TEcwCSkJLxTA6kKN+5MKvNkPayGLV3d1zBqoGLqNwqjzIiTpyAOLUd7MP5
2KhW7z9fTL86dc+xFF7/d4WxuNrd6qHaUgB4b16BfwQSIfdjyjkRyhRRSbEa806Kr+47zTZs
Dcm8KhtNcX95RZwGb3kU5wfL1rhuHX2NlZjTJ9ouOhFqfdTKvLZlejhdrpLz88dfg0sd5tz5
6vYqsWzLOqrq31j2L7GX1kgWbUktWCO0BpzyDIJksWxluu1U3/lSxHInGyeFWU3FSeM0gOvx
5pSgtaTyq2U1cvumsqu0M3a7loUGpQVLByvj2w30OesCBxePp+PbCVKqzv5xfFf28idlZf/g
l6Y8/fPj9PY+qFs03ssacwjVxhLzPJCsRR2T9vv5/fg4qLZY7WB0pCmxaQcmHhNOJWN72Zus
qGAlHU3tZHUodN2NuLKnYDHEshBSFnAIWZ8LAXbJJHyTxP7gMeKFejU1pYp/aqv7THlG1xMT
U0CUPGjraeohWlLwqxlh0tQBRvj2Ab6cln2BASKxIFZWnbdc//ELPIOPLx3K3X0cE29u9bpQ
xlIJwO+rVdHZNaGhy8lYl4AL1hPFuZk0KSgbteuvZrLASTPss1W3EdJIqtaBo0N09FpSeXQp
IHLz3LXjRKmewXyF5peqey8qoTASiVTIfmdZfkijyjqw7DiEW2RounYtoVsOYK20c4OGaDkq
1TLm0uAmbRvlzJfgwCmIQE8aoToLQk2B/P0V3LbAbRgcWBphynwDagS6ciOeODerDUhFfYsD
3Gxagwwl7LAKsBNIHwcVdVvQ5KdLdzTA0e0hBoFaFn5Bm7T1sfFKEENAgyt+WERc9HUJYNZb
zBa/40dxUnnjoGUcUrSSLdsNOa75TXSxZVSM/Go23C92/+M5hEg7NcytKDAjphrU3LyWK696
svjbwhUKNVUvIC5P7UK3cbbxppFKFaXYN4TX/ZIY2s6KYNnqm8+dZJC6ZR9QL2Vp+DtcXg1A
CTk+HF+ct5kgXXSk+K2lGmn1sxMUrvrGU0zxb5lBiqWBfV/oFXF5fj3twOb2Nx7H8WA0vr76
24B1RbVaZsnLWEpI/LzVWraNlfz4fH9+fDy+/vRurD8ezhepS99fwDz/vwYvr5f709sbvKGE
t4tP57/cq+tfSqBSlJFogWYWFr1Tok2sQYVcj9ZHzbyclEa60zOFbjkG+vwkK/KvE9wyD+5/
nF+QZD6ka8HfNUQuwC+vsjXgtNvLpR+ob7KjcvD+8SwXby+1y9Kde367P8l+fT5dPt4GP06P
L1jSHpQeXMen0+tRjqRn2Y2Gd9bOXQwKUIhE0rALd4uuB/nj8e0HlrvNaB/MeLWxptJKjKbT
AJ0EXmJjHgAPm1jhPgrm86F27VH2TS4rB53Fx9v75en8fyfQolUXeVvwapPB3bXgjSv9pmGR
pGaecucDUmv5KjcqMkk7M9S9ytu7nBrH14fBb2/Hd9m/5/fT3wbfPoHeq9fJ/zmQxZfj7x3c
oSGJ5Ef/LvrzBUg1+I3Mx9xK68ZttFRIGdYlQTJmlVzjf8vkBvvHgMlxd74/Pv9+I/fdx+dB
1X3t91DVREpCJA8uov7SdSi7mv/xi0mbfZOBGlyeH3/Wnfh7kSQNVO7Umo1mM8gH3+Q0Um3c
gEKtufMmxNDgtzibDINg9Ddzk4rMM2qgaHucy+XxDZ6Zy++eHi8vg+fTv6lOijZpendYImce
/tqhMl+9Hl9+nO+Rd/2gF/Nisx1759AR4r2WSRoiFUyylh+vUgoN/vz49g0cORkJ6ryXRMhM
OK71VMJG9GB5agOr4/0/Hs/ff7zLIZGEERmMSvIOYcKE6OKbtp8GXnK1HA6Dq6AiTHYVJhXB
fLxa2s+qbEi1HU+Gt1sSwBN+HQSYOWvD1Xa5VqIqyoMr7HILmNvVKrgaB8x4lgjkRt+yqVJL
H0+vlyvzYVZdtclwdKO93FvfXu/n4wl29w3MHI5vg4mhQMJjiUQ5i6dau0PcVFEwGSNZd5Bi
l+JplVK7SwgPAB2OtB7uIJ4hUcvxsm+s6/oHXS0p5CIsBd/D+e3l8djMSeTAc8V8n6l6kveT
5f/JJs3EH/Mhzi/znfgjmBgy6JMiNThPYhiafL7JfIcsax75FZNEs1Xlz/YdhqjkNmiFRhOU
sJIZfr43OhsjE8e/hHg53YNUhzJ4Jl2AZ1fg4NPOg4XhxgmLocml6WetJR2WS7cqrChQx6wt
j5dORsLcfynKBgJce22kQj0SOS/iKi+Q0iz4agGhiJZEunANpvtuKrnFlL/w6NaKrx9sUHnm
m5XtOwCoKQtZkmDP7lUapWZ55ZDtUHF4zLoYTq7wE0OFu1NBaYm85bhZ5VnJhTlhWhrSaLHc
UZItFifmKwhNibV5n0XLHcLXm/jOHa/pgpfeXFgtS8JNKTAT8AhGWBIAYJ0njvt/M3Wer+T8
X7PUsaEB5pZvWRLh1xgqcTWdj/GDWWDL6nkReWzAHTUtNqHyy2G3zo4ljnWOLmS8E27wHLOQ
d6Wyw3fTcfCZQhaNo9GbgfOFLUpmF6za8cxxC6zrnwkuZRf61BIASei8/FPE2Ov/JM7yLf5O
IFIOTGqpZSeq6YcIuwC2EPKHGdi6pdvzAMjlJl0kccGigIp4B6jV9dUQny7A3a3jOBEH80mp
lgayw1WESV9OJBAeiahFyu4cu2CglrGez843ONxr58vKIedwqupORhV+G5H8WcVdQslXbqHz
kp50BcvA8ltOXKurDTLVuip1HSONyjyuWHKXOWtTAf7FwwgldloMzibT1QFa7dLVvJBcDApw
majCXfmJS56igdJ0l8pUUez0cx6GrHLzkUsRFfFEs72QFiY3t9w2gmWKO1bVI8jEdsQN5Cpm
qUeSg10qIbGzossCQMRppzapM7RWEMOKCXsdbIn0kqQir3/J7+xPmFSvTnJVdRYoKWyFfuxp
EtdSpKVug1drcC6sXVtQIh2UtUMhxm7aTbD8GpeUeFMBC511gPM0r5yBsOdyVtgkyLVugPaD
DY1uuq93kVTkXMmhXxge1puFN9Y0J5T1B7M/9YsceSxxX+o1B1yIatp6Y0F1Zrh6RPTmgmOX
OjXYMQjw8m6jQRlEM4t8HYLL39UhzqRuBoZR5tk/hrCdtLWIhFeVVDs0yOZ7hiN1QEbnHSlQ
pfyBx4/YRAb2JgEHxX6ccvlnRhnq6mjpsCYycVibgm9jPq/RwdczKYbD+JDFu8a+q9lp2Mez
0M6I0YG62a4fQxZxKbjAX08Dbim/wTNeKSnIUUMylZ1lb+BWPK+IAFmaB77Lo01YJX0FAVzE
hXp4CoGcygzesm4wW5C6i4TqI3gdD4/mva5VdlAbKVGzSL+X/SMw2brbu6lweXvHvX+bHTyd
7YfDuvus0u9h8Ek6WT3Eo4nBjevkdg0UtQRHFLIdDlWFcKsKRomQeyuvSIq/FNirSvOTxvts
PznwPb/AOEy99fwFGGGIZ4HgtdNnxYb4GPkSLbXAdwYt3w904GNS/PhMjYJMqJdHgPu0lN0J
mD3a95tgNFwXvWMGvFuMpvtPMeNp0ItZyrklv9aLAX8C8OLJwbjyFRn6+a+NgPxXRkAHGofB
FeF+wgK6QwVHgdNr2kaohUVsyzOyU3N76B0WMdkUNQI9nUGAdJMSjvlaUM9Qz39hqDdDOaeH
co4MZXMtHI0DX3KJZD4a9ZDlsM3dSpdzNp1Ormc9Q7AxXJB/rwU2FiFreINJaSq6Se1CAVFd
36fWJsD7nrla6OP/Qfh4fHvzT/zU6hN6c14FvkHVWODuIqdlq7Q9X8ykVvo/A9WCVS63n/Hg
4fQC1zKDy/NAhIIP/vx4HyySGxV8R0SDp+PP5rbo+Ph2Gfx5GjyfTg+nh/8dgBdhM6f16fFF
3TE9gbnq+fnbpUkJFeVPx+/n5+/WpYspNaJwjsbnk0xeeFc6mrpF1koLAM97kWQb4r2mZiN2
i+ZAjzLRY4Wo6lJtxm6XAe1AvGRu+SsWrWK3wJoVwUuyEg+f1YFsgxlFVwMzsu3vO0beo0cp
hC4S9VGl0DUl+6M1nj2+y2HwNFg9fpwGyfHn6dXrbW0yWVBKouJv4D1oq66qySLn49Pl4WRc
dKvpANFrM9uDlvrAjnhPXDOxN2Cqi9cc3KYzN7+Gftigr0UtSD3yMFYqUoJjxbewON01Acb1
wnc267njgKudjCpWJyptdOgtN68uGhwZgs2A1YUlmqgN35gWiSMlmzh4vAyZ4wzAZJc3Y6nN
9GevLx6oeqzHV5RaWEN2a17F65hVaAnhdQJcu8RJ7G8Xmo8UgRVQ1GTpo/9DOkfZcaot/bCi
L6sIQkvQtr41bssF6qzGgPCC3aLf5yXx8VjKgh6556AOFacqMR8FY2r2dZjJGG++FStTsm95
gUXaNgGbDZoruCQsWAau84isa0R/9jeJGRbBZIAfwoMIPfnexQE8bD5tlhSOGKkccjGbEW9z
HdicuJgyYfvN532dsW3qHY9oVpEEY9NdnsHKKz6dT+ZENW5DtsHt9E2QXHXgyOUTIVOExXw/
QQsh2BIXP8A4FCyKYlfpbCRXXJZsx0s5+4XAIXfpIk9QVoWPjvBuEZdfmBkLwpRGO6KRtSk+
0ZB5mvGMcBDq5BGilxcGaA/HhlLLwIvHxXqhvXkibSE2I9uhuNmN1SfjfVNEs/lyOBtTOew/
kXKNTtSuffbBF7oIximfBnZlJCmY2iQWbaqNd9oh4q0grO6BncSrvCI8bSq+u9Np1orwbhZO
x/9f2ZNsN24ru39f4ZNV7jlJriXPiywgEJJ4zckgKcm94XG7FbdOum0fWb5J3tc/VAGkMBTo
fptuC1UYiaHm8mEYnid4+RNUUkV6wBfEVQjjbEDNDyZLIN+yGsTyLp+nmKRDR5GMrXhaq/9W
tpU3TilgrhrJCi5W6UxGQqrhLMo1kzK1AwFiXRGQ9J1YQghWZL3m6aZpZZxESWvQIs3XUYR7
VZvS72A/n3ABN97eADVLp5ZNyH50DpHGylqr0Y82OZJr//oqLWIuXfhNmtBwDbZw9fWft93j
wzdNXNN7uFo6XRZlhcUbLtJVZHoYiXJFiKORvoQWoyMFQTYJ/M+n86ur07CuJd+PzMYZGckY
6dIP+DUbCTxfRVyG4aLGeBODBevUoXXPlIAanrgr2rybtfM5GPMf8Tx62r6dqu1+9/p1u1fL
cZQhu1+2F8K1ScDULeQIb9KLRUYkE1SbFkKcm4JUbVexY5OvTLte2Zn/vhaV5yPWl6rqKDUK
mFiYUOwFmSU87Fe9h9Pp1dRvyBT7yRnDDxumEsNxoMzz1F989zDrFD4rTxPhMqVo8hZIV+3D
Qu4P9zaaKcKoKuu08VZybmRJ9rk9MnxOqYCHxa8tRO4X1e3MCc2uS2WRpLVfOA9K2hX3i4xk
y1etwZ9zSkuG5WYOMZa8xyIEaQOsnIk4yTlgFZw2cnKQBBmHykchV25AIBbwWFnEp1EtyzGC
b8Cbd5k6WLEbzkIbWfQ5qGs/biH4yBbs+LWH+2/x8OVpezh53W/BWeXlbfsFTNH/2D297x9I
9aSvmHcJgyYu1V6Mfk593Ofxx2LeFugLPYKyIDamh0BIcj1pI4TeMKd5pB3vU3jQZLaIExmL
bi1mnMWXAowiQjGgm27lw6/W74DmvhLWhsCfXcMrZ0/rUjSK9uPmDRul+ed1+yu3Myf+O9na
eRTrv3aHx69OOkVrxP/f6n6/7Nthu39+OGxP8pcvRPhFPYWkgoRvRh3gTa9YpRgJQ8OjSzve
n/OSg5l0vU4b2xwstzPOV2tZiztwew0LfXkceie2zIsjknMkcYMvot0dtcdjXAHutBMn2wBa
J54iyYHm5SaWUgPAmJl2GQkxB12H2jkH3kfWj48uFoUSYGSecVy5HBLd+fENDSBSR61D6nxN
LIGQhkCrcAKEFwqYPBi409NIoChcmLXbYLJWZFczz4PSWdaKeSpc1s7ARjSFBmOZnl3dXPPV
lNT4GKTbM29yS/gvnbulq3Z25koXcJr1MvYRWlikS3VWgkp1W2zICKAKxu/UdvQrLOu76CyJ
POjuFl1T9Eoucojh7mS87cti0WAxv1l92D3+SUfOMLXbAuVaUkCMwdFWPjRgAWsiY1hpStCG
Bl1k7JEfSzu0fyUXw0JCc1ZeZhHrNMScSeDfC5CILNfAXBcLEbpwgKsLsRjYApNq3450ADnn
p9cfIFyMIHB5ejo5n0zooJ2IIrIJpFM4Jfc/YgwRCN2KaM0QybKgOy9n6kXp7toZTS7YSJLd
xbp3Y7ZiUR/xs2FN63/6hPHJ9Lw+vb7wAJ7HE5aRCYRclKw5u7ihfKkQWtRTrxtF9G5mroUz
lpcNfcXotdRRaGdZM6jHj/sGFdmfv+2e//x58i98iOVidmJcqN4hqxxlEHny89EA9V+Wux52
10ehddYnvz61w0nqb59tpAgnA5FC40sGPsSz+wiRqG3c0i7LW2OoGEdLq7NQaai9pcEpvnnZ
K7LIPWDD2jX73dOTc1fY1nX+rumN7rwszA5M8TP1smyCxejhS6EIgZlglJ7CQbQtyOmmOBkF
w0FhiuRfpc19tI1oWjAHqzepJDIB7l4P4GH8dnLQS3ncbsX28McOqEBDWp/8DCt+eNgryvtf
wS03rK1kRQ15qz8elY7Y9tESVKxIeXT+6iAmIuIv6rYCvnMju3BY8Tb5kRVtGlo2CTpaCASf
ZmkEI1X/FumMFRQvK9TF1qmrCgxWay5by+AHQYElMJTai4NYmVgwfq/zUMc66dUUbk1UC8aq
8IrfTC+COpiHlagjG97p5NsDPhTh00uuTALx2ld+TEjtiJ6zWTsPYz3V9wVHIavFR6yx1BEj
mOqRThVIEfgroSNM0l/NoNUimwM/Ep0AIKkrImLS7k3D2jbtxqhCyIZBC5LRZkeOLTmkP4VA
iuqLpPLOBSQQLYkCzOtM0QcziFDpCax8ID57F5MLUgAKfcu2dqLkyIYKQSUbe9D6t6Ibi9bu
3BTPILIWqSs0CGlRtU3YWu46JVvFHc/BT0VQ8UeP+ElFxk7C9A3BULE0JgfT0FVdctr7RsPB
CavuPQT0+Q1p5t3j/uXt5Y/DyVLx6PtfVydPGASQkDh8hHrsfiHFfSzosiK9FmkRSSJNsKzD
bpVlLgarS+vbmxCq9uL16RtkldeU10IPdwK/94WVLJsyLIbj4sTA7AH4Hs9ct9setppRF98x
u4S6Ll3h5DAy9G+JSdkHrMhl3MN7OZVbsYWceuAiuCBZaAtH310uH5dlrCg3ZH75AavMKnWF
l5MrmnU0Efh4RjrurdVXKbLS5R+PpSgXIZu1cEDq9hFOncqI85+FE0tobuNE4+Uua3U7ttcX
pyEpyr+9KCa1fnnfU2lPkJbUhtBOidqaMzuAcXZbQ8TpPMi6Aly7rkOsMOQqgmyzXZDewIiU
wppHjHShmdto68m6Y9UsbHveNLk8nZyONJ5uKsUWRlvGwHuXYcvlOhtpVCYs2mLdFudp2KDW
FMebXDXwTaOtGg+SsF1W5zfTy3hF8z0TnUMEcoG09seu6qvJhGgWErvEB1uojSpFtE8QtC2k
zspQ+UyMGVCVqkubL71Q0xrWp8qgCVeZr65yuKZAekOjYC6eKqVYHw2zbRH6Tk1kw8rOBg5U
xbzJ/TmUm4Ipdr2qfQAmKPPXUqeLii6m6f8/IP+MDLpemsPKbTujoTRvWkdv2yum1XtNadyG
eo29F4SZJTiPhF9r40ZzuD6DvZpLWtgzgCd0agoDj8TW1KOAoEUgy+XN6KopikS9C5FdwNVq
TqhDddzm4FSOIRgV6uW59zL28VSoe3X44izNZqWj94ah56qMWPohOmK+dCgzkwjvDI64XKsN
F6k/RIzMdZ99dQhbzrzCZXp2qS4Gv/ByOvULzRw8Gx3UMrGKg+CDe2+Bot55MEaLHIPzq2qR
omZ1RBRle9eP4VgLsxUp4iraLJyjaKc43EifqSIOWosn1QGzts8QzewEgSfVw9MWBQwntUWl
OvWBcVjotJ1ZxWh5UoCJ1xXNZH00AHf0BGGH2hxdm3yl+s0SR1FrfnGajiCkFfS9yms6Pj+D
aPHRxs9uTjvO12P9A8roJGC7xKH6o/tgHe1y+/3lsIVwmCEtBFGhG6EoH+5em31px2OyGsVl
KM6UQ2Bgdf/LMpLeTA265nSMM2Jceryv39+eiKECu3E8lPgT+QZn5FhaUGS7BuE6LdyoBz7E
pMTxGtUMKT0TZ8TWR4XgUWAFHHwTyCf4c/3P22H7/aR8PuFfd6//OnkDafEf6hwE6hQgwqq8
S9Q+T4s6iJfvgvtjzb5/e3lSrdUvnFb7QKRlzooVi2jiNEJ2q/5idcxi0gRs3kCKxLSYk0rK
HsUZo9eCEBZ4pKec7OkYnY+YtF4NtK2KLYaxvALOClLgUOTSEaMuSjeCj4FVUxbU9nFGxx4O
8Uis3UwwK6kbK2Eorucy2GNDStTInHtOpvJtja39y7UuK5a0G+Chr7n7PuY0LUGOTjsgbqp/
z/fb7dvjg3oD7l726V1sCndtynknikVKyjOTirGpZUI5dP5RF1rO/lu+iXUMlM2i4qvpR5sW
vxnkNiYXIehCh/9UnNrff0e71nzcXb4Y5fMKPx1in7s3bBxbF5i44iTbHbZ6SLP33TdQKgy3
EqUtTRuB59FKlkH2+uOtH2PiNts/vTXwCCfnEmnQH5VVMUpLnTrJ+HzhsihgO9StJav8ttSj
pYjusTcNaPKPbiyFmedBO3YQU3+S/+Mk9SWnjw8VSHkYBJtwpPX6DVPvckfa9mtwPUuDOllG
kovaviqR5sWpPZr4Lk8tiNsi5J2LUyoKWtGyH5OXTlD8Gp2zTkfG5EWNPFIW0O3SPvnk0rrH
1TCNY0zHQrpp4I70pd4OY3WdR9Dq1rDdjrJG5xbQTpzkahmMD/ahwbLSQJZtFRxVaywotVDc
kUld+WP4Z6P4Nrbr9IfyGP22BW/YZvdt9xy9CrWldbfiLXnAqMpDqKIfIsCOXVWYiGguBWUP
ITYNP0Z4EX8fHl+ee7f9gJbTyJ75hCkEI/GzC1dhpyFDOkbFqUdSTRjM3k0jOk7A4JRgH5Kp
yIgKlGzPkRCpH1pkbjcJhXErPoCiGGoc2jWcpi8AY8yKCuFCZimtRUZwNFQOQHuxoDtLYumg
WFQ3HqFkAY38zK+zTGcrWgkFUEU40PFGDHBK58FEKKbAzRa0oB4x7urL6SnNzQJcUbqTa8h5
zeMDVDhn0whxqOHqUqaUGRYOvtxpXblr3GeU8Rcs39BXHMBQCpDkcSEXIFWb+JQlZ9SdhSAj
SWyq1h9Sf7NHmyUi9bnwbHrNq4y+4REhGuxGQyNqFARGAuBoWE76Eg8w9f38ycYzFCI0FbGk
4Qa8lF7WWgdBy/6j4E/OTtO0srzDZApEsHd5B1/FYZfUGUwpOkeLnFnqSUH0J1dHiUNrVeQa
GfBUh6MI8hObxLH6XYD90fLg+vxaPZUw5TGJTMPbKE4/lOV1He9HVR6sgNWiJBE1OUbTl3cQ
HDLCiQBC0eQRV21DlUBv6nGbKRYuYrtWlsUCWP+KLyEyJ01q10046Z7l8ffIsEUqxm/94HpD
kICSN6THkBTgSnpkeNw9AzDWLK9uojXZptZRH7xayGmf0y+ZwYi/ZQYh+po5cPjFbY8uDV3W
ya1fpr7hVThU/bosqDAKGgGio6Z3YUXzqETroYzHH4NJ09pi8j45C1sFnWC0SVK/pkGaQShJ
LycLo0p4WLfmOWUJboC9p4RfCW7VvJpcxBJYI1LJ59WCvmQNRsQMXUObNDAk1YD+TIfjGk77
ImtJwzDE+nRfOJ/UWBqYzYNKFqKuhwVal55SBpff+v3zG5Lhx5vbBIfx/ZPVz4EoASI3FggS
8AILtyO7Af6Pizzqqgy1tea6jcRDMxg3H2KAQiHqEgs4uLGvZ4BEvsM9SrfYZIjkL4eBTqYs
aGME70zdpCm9Okdktln8KFqu2FPENTl7f7RKMvYNjNwRnY4ja8PvF0VbY8/+woDksZbRDzQY
acCqjW4FwCzq8dU94sQ/dVFPg+X0wOjdKy2HZ2wb4gDUrGHBDE2AgEiDZgGotYGQ8RDxtSml
jFn92nijn6lH0hFPPkZj2Yq21QUsYJJQWHo3erTydKNeH3ILWVhGwdvWM38BjD54rItlCs8k
kCVjHdTgSlWU5NHsqbGxXvQr2a3kZgomKfHtYRClouxMXz1Fi+rys6sLZOqzFkJXU/emphxw
I8W3scaJ76l8pTj5TvWmBts2eRrcRgZ+vUGH1OjCKRasm14Xivut7XhlDohaUgCO7ou8OvsY
ATqNY4DZyth+B4Q24tDbwzd1fO6KRUUP7C5PcrUJT/05llxkZQNEaBIxdAUsJDBHp2qMAO7O
TycBoo925+6poRwupGXtj3AA1UVVd3ORN2W3il+OVksj625h4ff/GDFikW7P/fr0cjMyd8lQ
2UtcECAHACrkbPxOH0S6Cf7aRBhXGxOvi6ROR+6to6CYuLsHIBqfRvszrFVS6aSEH+HhVRpg
hnjUiHprsbFDMeCMvaIDDfrDWPEvM2CNUjBHHjfmSIyDb7T8ZXI2OYWVGqMbB9Tzj1HT5fnp
1TgJiTIYMBZe3se/NUpkJjfnXTWlTUMAKWGGao5j5NeT6HFByZrheP3nRbEbVVoJyhUPh6da
nEwnwUWnWchbIfIZu0d/8+jQXNSxSQxST3y64/v+iDfasdEvAN+T0zYsLgdj1QadekwUlrvi
bM0KbfcQEPXh+XF78v3leXd42TteAsf3vuM5LQIAWJLzS0X0VL6VUD/ckV4GXo8dLUiev+xf
dl+OnBkrElna+clMQTdLiwRsFV37OBdKGtN7DfQZCH76vAOPtl++/mX++O/zF/3XT/GuB18f
W+HXz2GwCWCWNL9Y5XbAGvwZKjF0MUqzUkrOcISXvGwciSPEtro+7cScDrama/ZMrQCTq2A4
PVS37IDANjnoEiiQWH/6uZ+73QxvCtYi9ZqqC3LL6WEAr4HDGMHRdxl4mZChb/qbOBiCrr2a
X6rLN+ijn3FvGNTXdnsuVrVaxEXlmiJrz95goY4IYGMZgHX2v/XJYf/wCKGqA6lz7ep41E/t
8tLNWIz+OeKASQFp9awwMO6TpTFWRXXZSi7CrIkWbPB9dcxy8fbz4970WVPCyR1rRuVS85qS
RzViCFym/qSyxNrFw/BT2yQXfoGI1lOY1lmaz5y0QKrAmEY4RgAY60L9XQgeLEJfDmc3IlK3
kLDxslYnkiY8HOQxnQ+HxFcxO+wg3HbviOiqk7XL9e7b9kS/PW4makXZJqwRHcR7YrImNfEA
K+t00zFuLZfYgGWwHYirL+lm2kGosmDgx9lBceoaLoBpChga3DsYkZ3TiYLLe4xSSg9zJaR2
qPaL/GjmR8CsTbMGGN50UTCI9mgPuh48r/o3IXTFSnVR4FHft8H8Nu7asmHeT/AwRB4Dt8ac
uXlhMbCTQVwzWaRkMi8N9yaqCxsprFN/N8+bbjXxC6ZeLd5YXxvS1szrcyfwmi7zwnrBPdhF
KPxSrXnG7j2w3o8Pj1+9ZMg1Z3xJm6YZbE0PvW3fv7yc/KF2+HGDDwtXcm98WHQLWjyKDAXg
KvfD6ljFhu6ASzaivQRckKo3EVsFgFdg+pKXRUpHLNX21Ms0S6SwZPO3Qhb2+vfkx3BZwH/H
D9JTcuH6DM9hWmsPa/AMErYzZykhFkrwcQUePzqcJZcs95YaAleSxIxo1qW8pbvmolo628wU
OHfQ8YZM6cGUCXP3aj8X63fgJj8UdryVdMjzIrMaUT/68Au//7R7e7m+vrj5dfKTRZNkEB8l
Efi9z89oXY6DdPVDSK5DJ4VyfXHqjtOCTKOQiyjEUe25MFKX46FMYg1fTkcapjhFD+U82vDF
SMNUvH8P5SbS8M3ZZQwSXfKbs9iS35zfxId5dR4ZZlqXsNW660irk+nFabRZBaTSFQAOq3ma
um32XU3o4uDr9QCa8LExPprcBd3jJV18RRcHqzvM5+MBRmIuOSixc3hbpteddMeEZa0/oJxx
YHbITAA9nAuIZUXV5ELRC20kaOWAJEvWpOM93Ms0y+g+FkxkEYZkQFH0BeVE3sPVi5kpQs9d
DwQUbdqExbggqZtiuIcpGu02Fk4PcNpmfk0MJckcdkv9HIv1XKTci6PYU3tlt76zn1eHstYe
O9vH9/3u8E8Y0QRyPtiDgN+dFHctBBsPqJ3+FdWpEtWHBnxFCS6sF6iBPKQi6Vvun2lNJgfl
6leXLBVhLnSOaJuWEOrJQ0JZ8cioxm9kypsQwX5El2wFubRlIgrVFxDAvKzuOwjrwYGotzE9
JHsZwhbmqgmIsUR+nBAd7jU/mcaRjlQ8CdDnms+N8NVqOTi2B+EztaE6tYdMqKXjYtlBE7M6
//2nz/v3w/YX8H798vLX8y//PHx/UL8evrzunn95e/hjq1rbffll93zYPsEe+eXz6x8/6W1z
u90/b7+dfH3Yf9k+A1N93D5WVL2T3fPusHv4tvtfjIV63FucYw5PoMkVVyd19kwTGcmipSgs
iHrrcjQpGKCAxVNRku4yFob6UlY3VBuAEQ2si3ig6oc9E4llFSDP1XUTxR18Jsjl6sHx1R7s
vv1jfCR01dkqe3EF3//zeng5eYQ0ZS/7k6/bb692jHWNrKa3YG6QE6t4GpYLlpCFIWp9y9PK
ia/tAcIqSyd9uFUYospiQZWRiAMpHAw8OhIWG/xtVYXYt3bW9r4F0B+HqOr5UHdC2K4pDyvA
2Y9hDwlgMTpUgLWYT6bXeZsFgKLN6EKHajLlFf5P8lUIx/+ITdE2S1FwokE/tK4L1Z5w/Sau
3j9/2z3++uf2n5NH3M9P+4fXr/8E21jWLBhBEu4lwTlRhoj+KBVHmUQcpft9nNM6vn5dWrkS
04uLiWNGqZUS74ev2+fD7vHhsP1yIp5xauoon/y1O3w9YW9vL487BCUPh4dgrtwOb99/aqKM
L9XDzaanVZndT85OL4hzu0hrtUXCEyru0hWxUEumLrpV/21mGEoBMtW9hWOcUV+ezynNXA9s
JFWloVl6M6IZUSWTdN4TAy7HBlHRA99EYq/151/cgwPeGAqDGFtNS1sF9NOpazdriRbVQ0zK
yCo7sZH7+5Iq3Oh5uYUrjalj3e2etm+HsAfJz6ZhTSym1mmzjEXANRizjN2KaSxqlYUy8tlV
783kNLGDJPfHgHxBrAPg95UnFLc3AMMzo8ogCW1YnqrTgSZd1P6ReTKZUsS/Bb88pStOL+jA
K0eMsylptGrO8pJNiIahGCYyWlF1Hd4NS3YxIV77JTujuslpdrYHg/x3FjG37J+LhZzcjN60
60qNKBTcYgaR8NAwEb6Uqsxz6Rv2YrmOBZwzm5FByLM0fH44A94JLYdJGLUdoZwSAfUvGjH0
Of5PLT3Laja2M/r3gaorZBWzqxy+7MjJadYlrFowWFN+XBb9pV6+v+63b28u29BPeZ4xO8VL
f8l/KoOy6/NwX2afzqmyJXVKP9VN6L4pH56/vHw/Kd6/f97udZgXn8Exe6io045XFGGayNmi
D+BIQMgbW0P0deYPFGFeMKUQI2jyPylwQwJMYFw+1yI1O0X2dx9d4gNiT8r/ELKM6RI9PGAn
xi8NNkYUwODBVd5nhL7tPu8fFOO1f3k/7J6J1zRLZ+TlgOWSn1OkhgJ9+FwBkj5rVoJbqiWN
NDZ1xCLpyhCPuiygvH8NFc2cfhK/T8ZQxsfbo304Yo8QHR935N1ZrqmDIFbAoK/TIuZ5ZSH2
LuSkjtLCqy9Cbs6qT5IYAC82kWI0JZbCTRtgzwA9hFnEWDZAbDyz2hieWshIh3eckp04CBDg
gLrJFDDNF43g0btJYWhrsx+ZUe8jOz4cP3qv/bHYXGy4yCIj4VwRGOONow187YdBPa5lnpWL
lIP/ykeTUc9t+yFSbwNY8hrJDvodZfV9DklwVccgGwVT2eP0LWDVzjKDU7czg3ZUGx4Rmyq3
sYguNxenNx0XIJNMOVheaLMLu73qltfXoPRfARyai5pmAOoVmDXVoNqhm7rSySxVO7TwM12A
MLUS2gIDzCJwZCkRUJ5v9wcIe6C45jdMavC2e3p+OLzvtyePX7ePf+6en+z43aDZtUXUMrX3
egivf//JUp4auNg0ktkrRpk9CfVHwuT9h72pZwRC99fND2DgEwd/6WH1tgc/sAY6h0H0JYQQ
1Ux2qGN3NeYsMH8xkFmqaHgItm1t0N77TZH3BQepuUSLd1uQZaNkoohAC3Dsa9LMMSaQifsi
qf2YYw7KmRoFMUKtUrB9RetG3U7aXsI6VZIvYRiKq642fLlAkx8pHCaTqwtFEVFO0eTSxQhZ
U96lTdu5tc6m3k/X8tOFqCMuZvc0/2ghnBNVmVyzSLoMjTFLY2Q+v6QpfO5Q1NxScEJSxkBg
wC35ktpYSZm7kzUgRbzb76RVmoiw/BNQCorIc3mDT5ru8UoVq0C0DKVUy4o5ILEVy0CXu60M
67f5BABiAfu9TSijGnWl1AI2IlXW3eYVWT7LyeJ5bZWj+dYKMnM7Fleshmhu6oCsILqlZJY1
GKhj0tIxLtZFmPU+Z5VbnuQWC6x+uFZ2pqCb3VfMXr8CA8ppuLoGFs3SgwEALPeB6PcPK8BY
ksiu6S7PZ7a6FiBq9TMmwbZ0iUyPCwVGw7NIc4q72jHA6YcxEwVX7JqkCJZ6kemPaq06Rvv0
Yx1yiDfpLGByZ91Ohdq+jRNk+VPXMCspB4QbULS0VSWvUp30om8vzZ3f6sc8sVYAjM4lSH8b
6XxxtQv67blKaovi6ksXooHYJOU8sbdKDbbGmf0B8PvAtqjAftnRMA0gBZFCe2XkFWvU2qkH
n8BrdXqTbp5BwjNQRhNIqG51Ev6BX6Gj+Stn/2EL6gkDjXKxIE3vg6fS1Yj2hAWWvu53z4c/
MX3Ql+/bt6dQzY7mkjqotPeAQTFnfuy54clD62iIyJ+ppzYb9FlXUYy7NhXN7+fD/jB0WNDC
gJHcFwwCyflnwi720hYr4nJWAvUppFRYTnTC6FoMAp/dt+2vh913Q5u8IeqjLt+HKzeXqgM0
Mf19enp+bWvIZVpB4HQYDs1uSMESHb63jsT8VwiKdFB3pLplMipehrkSBOZCBevEnDn5J30I
jrQri8wRs5iU2yVYtfeJVfWu784iInG7ylqwWzC68FM4HQnAH11WJ2Sy2czJ9vP70xMonNPn
t8P+/fv2+WAHLGTABClK1E7kYhUOWm9RwFr/fvr3hMLy8zCHMFA+teBoDbStuwr2e2JK8MJd
w7/EQteoH0WEHOzVx1a4byliV4BXo36EF268QvhNMXDD7TWrGXgtF2mTfhL+SBEa60+xSKoq
3I5pH6PFizY9+u3ctQIbXZH5KwiGtr2czBgmDI1Z9xbcHYqwEEWd2tJs3QZA+3fPW9YBZLZF
v0toA2TopVwXND+JbGSZ1mXh8Ea6H3W1qxMY7A9TTJLWLsbcExNE0DAuVyQNk4MIVsQ/gAbe
8EtP3EkiqmMPVINxu4jN013k3yd+t3XGqL2Km83sEvUoZ+qeCVeqh8RvR7SpaeGdsWvX6r1O
DFAUSad+RsyndDMryrlqOE0GJ5VNy4gjbwDRMerwgGiuY1c2xegPgS5cUpZgggSrOjJUcxcD
YUjxnday4vTByWCu7phw2A6YIgC0cdQtg/vgKJN1obDlgIwpyuNlo4jjni1xrY+OhzwYy9KL
QaXVw4B/Ur68vv1ykr08/vn+qp+W5cPzk03gQNo8MIQqHerfKQbXntaSOwOb3QI73qjVtrmh
upw3UeCsLBtF4rHcRqtM1r4PcfwxgOWe1xV8XYuLJzCojiy06GB8HH8wuv1uCe7mDatv7dOu
39gBhBdS2aqjPj09fkirqwERe6LENzFcMyqr2fWdImsUcZP4+trBvWtsj2gLVEWVfHnHdLvh
K6NvCo8A1YVGnWOXoRbI3tlU2+7ph8W6FaLyPL3MYVYvQF6FOb9hJtYD+/Pb6+4ZDF/UJL+/
H7Z/b9Uf28Pjb7/9ZqdCLftMxgvkLIZkFRbND7n/CK8yuwWYo3/XA+/dKi5fBK+dlRbLvfRo
9PVaQ9SrUK4V/7UM10Sua5FTV5sG4xg9jhfKElH5nUWK+6STmRBV2L1ZHa1ppHIg2mulDiQ4
yXl5T46TJEiAms+darQcrE50B2uWNpRlds8p/j/2ibsI6r6dZ8w2nsb3oJGesx3yFGCz2ha1
EIk6FlqcNvJC3WrKIHKd/6mpxy8Ph4cTIBsfQVZs3ebmK6QU4VRB8UjPZFo9DeqfWWvCSMQU
XcIaBkymbNGV0j7doyN22+dSLU7RKF5iiAKg6CzqxvH2zJFjVGQZRBcMt4WFMFZZivnHDQDp
gAzncItPJ04HZgNYReLOdg7rU3c4k/MO+Z1hHiWSKtY5ZYqa5/dN6YjxVhZjit3LGHQhWbWk
cXqZwdybgG4AC7scKVm1TiDO91DARxFXBTAVyV80vmU/NxV1K5bwE9vm7iUIhZFLWA+GVj4x
CH9Ihns40qI6aIJhHUViH2DwUTAYtjgwgGjJ0ctf2/3rI8l6VXyw8l0jXWqRVeh9q0lrdbmq
G/zy3K4ncoiVrqlvxzy4TEAlp57yQOx1XJhunm4UhdJDyUXK6xT0ByifJfCsoYDIEogwRSvX
t6F/4yaWqxunwWR2H968FkbVgNerI38KVtQW3DXbtwNc0kCd8Jf/bvcPT1vbw/e2LcjUbSSD
4HDEVU4j2VLtBq0CIljHT4CU3tDF2Ea85aVtravZAcUEqGJzJNyYJoBP3UnqLIEmDT4jbAw/
42x2m5Ap6FCJi3rJ2jtfCMnTApMTk98XMaAaRZr2jyBuLu9hlzNQZISXr05Qk5UQrzOyHx1V
iNesJkguzwkFFQ51KTbDVnOmoEXIJpPEyFQbWfOK1ndrZbjCaCJZ0RABD/089hn0aQyG17aR
5AsI3aDmJ9akxbbaxRKU0JgWzV8ixz4Gi9KEBUPS8nmi03laQESc5qhrCerOU5kraogS1Onp
JiJj9+FOFDlnquexz4N67ohKtG9kHAF9gNDxi74zRR7ep67vD3k9eXRgntY17Lik5K06qBH7
dE0yzlJ9y9A5XDxlxv8BWjNNa1i8AQA=

--ZGiS0Q5IWpPtfppv--
