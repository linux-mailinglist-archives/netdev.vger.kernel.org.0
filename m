Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23B4149EB76
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 21:00:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343519AbiA0UAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 15:00:15 -0500
Received: from mga14.intel.com ([192.55.52.115]:36298 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239957AbiA0UAP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jan 2022 15:00:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643313615; x=1674849615;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=WgsDuE1l0b1YzJT/FUo98mgo2thGXanBPv776yV5/pY=;
  b=ENoz+BTgCFhdBDY+PNuGi5QGnIkHbt5uGfL0hwFe5FF0QaXWpBVoTjuc
   AXuvZ0YHSnW+XYpBRE8zLNOp4uhoz6vsfn321VDw09lzemoTszYf9IW6J
   LEKV5vQvuF5IkFwUAxKYhgpRa9M1u7coSMFMhWmDSPVkzYaDY6nZX/I7P
   bWMn0MD59Apo8cv8kmOFGZNbS2w4fElCbqn1+ozp1CWjeEnVANxSiP5kO
   iBzLULPRwGb9xQTF0oRMdG/xIGfJrj5KQzi1gPnNZJi+ASJn7dSzhHoFv
   QgfSKcErHDPF6+DABEXhDgoJg+wVqE8NHjfKVge4PGwWy4n6283dGeqjd
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10239"; a="247172814"
X-IronPort-AV: E=Sophos;i="5.88,321,1635231600"; 
   d="scan'208";a="247172814"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2022 12:00:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,321,1635231600"; 
   d="scan'208";a="495851430"
Received: from lkp-server01.sh.intel.com (HELO 276f1b88eecb) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 27 Jan 2022 12:00:11 -0800
Received: from kbuild by 276f1b88eecb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nDAwE-000MzL-Ti; Thu, 27 Jan 2022 20:00:10 +0000
Date:   Fri, 28 Jan 2022 03:59:28 +0800
From:   kernel test robot <lkp@intel.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net-next v1 1/1] usbnet: add devlink support
Message-ID: <202201280314.xHmPCOVw-lkp@intel.com>
References: <20220127110742.922752-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220127110742.922752-1-o.rempel@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Oleksij,

I love your patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/0day-ci/linux/commits/Oleksij-Rempel/usbnet-add-devlink-support/20220127-190839
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git fbb8295248e1d6f576d444309fcf79356008eac1
config: i386-randconfig-a005 (https://download.01.org/0day-ci/archive/20220128/202201280314.xHmPCOVw-lkp@intel.com/config)
compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
reproduce (this is a W=1 build):
        # https://github.com/0day-ci/linux/commit/edbd83152011a64e9d01a65864999e915e1b5561
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Oleksij-Rempel/usbnet-add-devlink-support/20220127-190839
        git checkout edbd83152011a64e9d01a65864999e915e1b5561
        # save the config file to linux build tree
        mkdir build_dir
        make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>, old ones prefixed by <<):

ERROR: modpost: missing MODULE_LICENSE() in drivers/net/usb/usbnet-devlink.o
>> ERROR: modpost: "usbnet_usb_rx_health_report" [drivers/net/usb/usbnet.ko] undefined!
>> ERROR: modpost: "usbnet_usb_tx_health_report" [drivers/net/usb/usbnet.ko] undefined!
>> ERROR: modpost: "usbnet_usb_ctrl_health_report" [drivers/net/usb/usbnet.ko] undefined!
>> ERROR: modpost: "usbnet_devlink_register" [drivers/net/usb/usbnet.ko] undefined!
>> ERROR: modpost: "usbnet_devlink_alloc" [drivers/net/usb/usbnet.ko] undefined!
>> ERROR: modpost: "usbnet_devlink_free" [drivers/net/usb/usbnet.ko] undefined!
>> ERROR: modpost: "usbnet_devlink_unregister" [drivers/net/usb/usbnet.ko] undefined!
>> ERROR: modpost: "usbnet_usb_intr_health_report" [drivers/net/usb/usbnet.ko] undefined!

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
