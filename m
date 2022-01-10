Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A825A48901E
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 07:22:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238975AbiAJGWG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 01:22:06 -0500
Received: from mga09.intel.com ([134.134.136.24]:56164 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230013AbiAJGWF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jan 2022 01:22:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641795725; x=1673331725;
  h=from:to:cc:subject:date:message-id;
  bh=4bqr2Q0RgFYTSxEbUoGaq3OkKLcOKBI+WeWFJnHJyCs=;
  b=lbLYVMLycKrCx47LeJkISPgGSJYT6FFnr94PaGPxMXbQF1ysr2bbb8nW
   qPGCvA99iKBEFsiMehadx5X67c4yKPljJI0Rbm0Ip/VTJ1KXjSsOGD7L5
   zXbUVLO7+mAAsWkA4uw/QdSMCOp5pXHOb5+iX7LenoR38sXbBC+hgch68
   Ot9w2fjoJmqBzKz8hTqIv/OiDNa8LeVCO+qeNtYrkEbJJQDYSUcVL0PZn
   NiSzgVGV+MVTnMYkwYNxV9w2QpGW69S08fRL38JSQuHQiTAwlUhV6Yvqm
   r6NyqEOI+twqbU2ihdPJSilMdAX2FPLlH8w5pbQVZ4qhbcgNUdOgbqsGa
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10222"; a="242958088"
X-IronPort-AV: E=Sophos;i="5.88,276,1635231600"; 
   d="scan'208";a="242958088"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2022 22:22:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,276,1635231600"; 
   d="scan'208";a="764424446"
Received: from mismail5-ilbpg0.png.intel.com ([10.88.229.13])
  by fmsmga005.fm.intel.com with ESMTP; 09 Jan 2022 22:22:02 -0800
From:   Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        mohammad.athari.ismail@intel.com, stable@vger.kernel.org
Subject: [PATCH net 0/1] net: phy: marvell: add Marvell specific PHY loopback
Date:   Mon, 10 Jan 2022 14:21:16 +0800
Message-Id: <20220110062117.17540-1-mohammad.athari.ismail@intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch to implement Marvell PHY specific loopback callback function.
Verified working on Marvell 88E1510 at 1Gbps speed only. For 100Mbps and
10Mbps, found that the PHY loopback not able to function properly.
Possible due to limitation in Marvell 88E1510 PHY.

Tested on Intel Elkhart Lake platform (Synopsys Designware QoS MAC and
Marvell 88E1510 PHY).

Mohammad Athari Bin Ismail (1):
  net: phy: marvell: add Marvell specific PHY loopback

 drivers/net/phy/marvell.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

-- 
2.17.1

