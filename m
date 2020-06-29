Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8CF420DE73
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389022AbgF2UZr convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 29 Jun 2020 16:25:47 -0400
Received: from mga04.intel.com ([192.55.52.120]:36333 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732536AbgF2TZ1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 15:25:27 -0400
IronPort-SDR: BPilyrZLEUod/rd+lo7jG6DPHzSfrpWGg6/ouOqILsj/8HCJlvaJdVSH0PyMHwmn0XZQ/S+cDu
 N5XEPMpOuIvQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9666"; a="143489070"
X-IronPort-AV: E=Sophos;i="5.75,295,1589266800"; 
   d="scan'208";a="143489070"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2020 10:17:12 -0700
IronPort-SDR: drsb/8/BwkA3Y2h1fsUPStPFXNQJ5FQkja8l/n53h3urLpIrJ7NopQ1VBDXnKKbcTMU7N0TbNS
 9Qh3pagMirFw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,295,1589266800"; 
   d="scan'208";a="280936341"
Received: from orsmsx109.amr.corp.intel.com ([10.22.240.7])
  by orsmga006.jf.intel.com with ESMTP; 29 Jun 2020 10:17:12 -0700
Received: from orsmsx111.amr.corp.intel.com (10.22.240.12) by
 ORSMSX109.amr.corp.intel.com (10.22.240.7) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 29 Jun 2020 10:17:12 -0700
Received: from orsmsx112.amr.corp.intel.com ([169.254.3.199]) by
 ORSMSX111.amr.corp.intel.com ([169.254.12.75]) with mapi id 14.03.0439.000;
 Mon, 29 Jun 2020 10:17:11 -0700
From:   "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
To:     Bartosz Golaszewski <brgl@bgdev.pl>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: RE: [PATCH v2 01/10] net: ethernet: ixgbe: check the return value
 of ixgbe_mii_bus_init()
Thread-Topic: [PATCH v2 01/10] net: ethernet: ixgbe: check the return value
 of ixgbe_mii_bus_init()
Thread-Index: AQHWTg2BLgDIjVCQa0C9CEFbwRBNpqjv0qMg
Date:   Mon, 29 Jun 2020 17:17:11 +0000
Message-ID: <61CC2BC414934749BD9F5BF3D5D94044987405F1@ORSMSX112.amr.corp.intel.com>
References: <20200629120346.4382-1-brgl@bgdev.pl>
 <20200629120346.4382-2-brgl@bgdev.pl>
In-Reply-To: <20200629120346.4382-2-brgl@bgdev.pl>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Bartosz Golaszewski <brgl@bgdev.pl>
> Sent: Monday, June 29, 2020 05:04
> To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>; David S . Miller
> <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>; John Crispin
> <john@phrozen.org>; Sean Wang <sean.wang@mediatek.com>; Mark Lee
> <Mark-MC.Lee@mediatek.com>; Matthias Brugger
> <matthias.bgg@gmail.com>; Heiner Kallweit <hkallweit1@gmail.com>; Andrew
> Lunn <andrew@lunn.ch>; Florian Fainelli <f.fainelli@gmail.com>; Russell King
> <linux@armlinux.org.uk>; Rob Herring <robh+dt@kernel.org>; Frank Rowand
> <frowand.list@gmail.com>
> Cc: linux-kernel@vger.kernel.org; netdev@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; linux-mediatek@lists.infradead.org;
> devicetree@vger.kernel.org; Bartosz Golaszewski
> <bgolaszewski@baylibre.com>
> Subject: [PATCH v2 01/10] net: ethernet: ixgbe: check the return value of
> ixgbe_mii_bus_init()
> 
> From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> 
> This function may fail. Check its return value and propagate the error code.
> 
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
 
Acked-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

> ---
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
