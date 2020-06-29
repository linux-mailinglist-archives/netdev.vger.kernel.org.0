Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F40720E5EC
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 00:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391399AbgF2Vm5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 17:42:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727878AbgF2Shw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 14:37:52 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3628EC031C7C;
        Mon, 29 Jun 2020 11:18:19 -0700 (PDT)
Received: from apollo.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:6257:18ff:fec4:ca34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 5F52122F00;
        Mon, 29 Jun 2020 20:18:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1593454696;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=h26XaCxnKB+gFInq65J1JgApd4LYjp2ZPQTDLTxiGs0=;
        b=dl8YSkKbCZPUxrbqrqZxNntTlPqXypw8KWUK+GE9Eb3H5du69lrR46YlBIVapCLKlgqwo3
        PrcRwp2ZwkinxKviJxlRtYa0vBe/S4kHoPv7tRCpuEUmY3vLdqKwhIeiFpgW0pGARGByoV
        FNFPWsn/dlilaKtblaFQb1FL2xadijQ=
From:   Michael Walle <michael@walle.cc>
To:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH 0/2] can: flexcan: small fix and ISO CAN-FD support
Date:   Mon, 29 Jun 2020 20:18:07 +0200
Message-Id: <20200629181809.25338-1-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

this patch series is based on:
https://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git/log/?h=flexcan

I took the liberty and ported and made some style changes to the ISO CAN-FD
patch from Joakim.

With these two patches applied for the branch above:
Tested-by: Michael Walle <michael@walle.cc>

Michael Walle (2):
  can: flexcan: use ctrlmode to enable CAN-FD
  can: flexcan: add support for ISO CAN-FD

 drivers/net/can/flexcan.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

-- 
2.20.1

