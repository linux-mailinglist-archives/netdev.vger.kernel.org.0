Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95CA12E6896
	for <lists+netdev@lfdr.de>; Mon, 28 Dec 2020 17:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633714AbgL1QiT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 11:38:19 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:42709 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729780AbgL1NB0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Dec 2020 08:01:26 -0500
Received: from mwalle01.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:fa59:71ff:fe9b:b851])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 17BEA22EEB;
        Mon, 28 Dec 2020 14:00:42 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1609160442;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=HYM/FGC1y56/lX0Aezq6NeaOgnYUFJ9zMlvrdTGdE+8=;
        b=VXQhj/yuaAHAiNZROZAW18tV7n9cfGAsh1X1HMd8f5poWXCIv8aqqqNvsyxfAiqsvFf0Ao
        3kHQJfas87fDtmRQcwEmDnvUTi7xGSxnef8RYWqB85rlthibFKPCF1uULhCVsCSgxBXtp8
        YLHma/tj1hUCq38Fj4v5fq8FSNpGTY8=
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH RESEND net-next 0/4] enetc: code cleanups
Date:   Mon, 28 Dec 2020 14:00:30 +0100
Message-Id: <20201228130034.21577-1-michael@walle.cc>
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

