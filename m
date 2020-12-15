Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8B402DB615
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 22:52:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730551AbgLOVve (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 16:51:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729523AbgLOVW4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 16:22:56 -0500
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F889C0617A6;
        Tue, 15 Dec 2020 13:22:13 -0800 (PST)
Received: from mwalle01.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:fa59:71ff:fe9b:b851])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 2E3C222FB3;
        Tue, 15 Dec 2020 22:22:09 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1608067330;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=HYM/FGC1y56/lX0Aezq6NeaOgnYUFJ9zMlvrdTGdE+8=;
        b=iCEix/EQjlRyzOOqSm3JSqhh9zchpOlDb2UQpKu6WGM56VPPOac4b4vYfjQm5YuX+URI9m
        OrPPsDzaQ8JDVqxamT/IpnU1V/bWkz+5/bsLaxNn8C1MnthUECBs4xfuVGbmEPqT/JCe5o
        t14DRsWSsNSrJKCEz9e7LOSXWnzZlTU=
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next 0/4] enetc: code cleanups
Date:   Tue, 15 Dec 2020 22:21:56 +0100
Message-Id: <20201215212200.30915-1-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This are some code cleanups in the MDIO part of the enetc. They are
intended to make the code more readable.

Michael Walle (4):
  enetc: drop unneeded indirection
  enetc: don't use macro magic for the readx_poll_timeout() callback
  enetc: drop MDIO_DATA() macro
  enetc: reorder macros and functions

 .../net/ethernet/freescale/enetc/enetc_mdio.c | 61 +++++++++----------
 1 file changed, 29 insertions(+), 32 deletions(-)

-- 
2.20.1

