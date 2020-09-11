Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D939C265B7F
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 10:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725817AbgIKIZu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 04:25:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725784AbgIKIZj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 04:25:39 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AF75C061757
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 01:25:37 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1kGeNB-0002LG-Fw; Fri, 11 Sep 2020 10:25:33 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1kGeN7-00074R-NS; Fri, 11 Sep 2020 10:25:29 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1 0/2] ag71xx: add ethtool and flow control support 
Date:   Fri, 11 Sep 2020 10:25:26 +0200
Message-Id: <20200911082528.27121-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The main target of this patches is to provide flow control support
for ag71xx driver. To be able to validate this functionality, I also
added ethtool support with HW counters. So, this patches was validated
with iperf3 and counters showing Pause frames send or received by this
NIC.

Oleksij Rempel (2):
  net: ag71xx: add ethtool support
  net: ag71xx: add flow control support

 drivers/net/ethernet/atheros/ag71xx.c | 160 +++++++++++++++++++++++++-
 1 file changed, 159 insertions(+), 1 deletion(-)

-- 
2.28.0

