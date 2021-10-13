Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1256A42B80A
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 08:53:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238134AbhJMGzo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 02:55:44 -0400
Received: from mga11.intel.com ([192.55.52.93]:41469 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238039AbhJMGzj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 02:55:39 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10135"; a="224801985"
X-IronPort-AV: E=Sophos;i="5.85,369,1624345200"; 
   d="scan'208";a="224801985"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2021 23:53:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,369,1624345200"; 
   d="scan'208";a="626229930"
Received: from glass.png.intel.com ([10.158.65.69])
  by fmsmga001.fm.intel.com with ESMTP; 12 Oct 2021 23:53:28 -0700
From:   Ong Boon Leong <boon.leong.ong@intel.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lay Kuan Loon <kuan.loon.lay@intel.com>,
        Wong Vee Khee <vee.khee.wong@linux.intel.com>
Subject: [PATCH net-next v2 0/1] net: phy: dp83867 non-OF and loopback support
Date:   Wed, 13 Oct 2021 14:59:40 +0800
Message-Id: <20211013065941.2124858-1-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes in v2:

 * drop "net: phy: dp83867: add generic PHY loopback" patch as not relevant.
   Thanks Vee Khee for pointing out.
 * Fix dictionary spell check error detected and length issue detected.

Thanks
Boon Leong

Lay, Kuan Loon (1):
  net: phy: dp83867: introduce critical chip default init for non-of
    platform

 drivers/net/phy/dp83867.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

-- 
2.25.1

