Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 917E2635DF7
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 13:56:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237949AbiKWMtZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 07:49:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237932AbiKWMsF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 07:48:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D55B729B3;
        Wed, 23 Nov 2022 04:43:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A1D75B81F5D;
        Wed, 23 Nov 2022 12:43:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 553FFC43144;
        Wed, 23 Nov 2022 12:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669207409;
        bh=IbwlYfRKx2oPLPSg64B39bC2Nx553yI3ldTK0aVs/ZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SJRd22Ixz1Z+cNqos51h66uH3SkG6MADjRl1QMwsdJDEmbfzAP5TrTAGVOu//TlZ6
         zdSIniAY81kO1oSlOfe+ylnMWpd4wW1wGwbhcmeUrR9zmdFBgU9kqf99uFwA5tLo23
         dQj8HIZNqizFbKJRl0gcrwOhkTGZxcRtb6pVSGL9ec6KxIiYtU1aczYTYkoNynfhpQ
         jRy396+6bhXzdoY7vZupQpiDCv1vfLLWRB1xXMytI62aEZMLdEfabZEKfb1WuSBjq8
         uSyQS/VBr+Kw1iLg2YADus3jrXrqrnLgVU+oeqmn+j4qHzY8s8cgCiz/6YTHMg/plF
         Sy6LoSy97rU6g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Enrico Sau <enrico.sau@gmail.com>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 26/31] net: usb: qmi_wwan: add Telit 0x103a composition
Date:   Wed, 23 Nov 2022 07:42:27 -0500
Message-Id: <20221123124234.265396-26-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221123124234.265396-1-sashal@kernel.org>
References: <20221123124234.265396-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Enrico Sau <enrico.sau@gmail.com>

[ Upstream commit e103ba33998d0f25653cc8ebe745b68d1ee10cda ]

Add the following Telit LE910C4-WWX composition:

0x103a: rmnet

Signed-off-by: Enrico Sau <enrico.sau@gmail.com>
Acked-by: Bjørn Mork <bjorn@mork.no>
Link: https://lore.kernel.org/r/20221115105859.14324-1-enrico.sau@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/qmi_wwan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 6bf5c75f519d..d886f903e428 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1353,6 +1353,7 @@ static const struct usb_device_id products[] = {
 	{QMI_FIXED_INTF(0x2357, 0x0201, 4)},	/* TP-LINK HSUPA Modem MA180 */
 	{QMI_FIXED_INTF(0x2357, 0x9000, 4)},	/* TP-LINK MA260 */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1031, 3)}, /* Telit LE910C1-EUX */
+	{QMI_QUIRK_SET_DTR(0x1bc7, 0x103a, 0)}, /* Telit LE910C4-WWX */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1040, 2)},	/* Telit LE922A */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1050, 2)},	/* Telit FN980 */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1060, 2)},	/* Telit LN920 */
-- 
2.35.1

