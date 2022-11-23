Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C4ED635E6B
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 13:57:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238172AbiKWMxh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 07:53:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238631AbiKWMxJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 07:53:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ADDC8DA58;
        Wed, 23 Nov 2022 04:45:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 92C3B61CAE;
        Wed, 23 Nov 2022 12:44:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02450C433D6;
        Wed, 23 Nov 2022 12:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669207495;
        bh=ferL4fhdoP/toBE1TG+pzfCG4drM9L6b8kRwlhb+SHM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V/9yHMsHYP7ndn0PmWR0FZ/12veMWVGkNAZHTxrzyGNEZ1zu35wP511FpYU2nRfNc
         OpPW+gJde63ZR+72n5RZ480f4mtAdABRDgVF/Fj75+RS7gQTsPMycNripU43K3y2Fr
         3kjvn3J4+RGYjvkzaI6Xy3HuNqr+ueCCH06No7AI0d8m/fShXBobPSwayJB66xQ/eT
         mjclAtzDtj7+M/mP9kgp9wRibwpkqNFN0o4DLOXLWFSww5O9TJzU47NpSg7hMJVZpr
         ldpKJObqq0DWSSHWbi++MZ2jArsf7DtbauiJCXsU6D+CKZkOVK7uNXjG0fY2w36XVb
         ejv2Svif43Few==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Enrico Sau <enrico.sau@gmail.com>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 14/15] net: usb: qmi_wwan: add Telit 0x103a composition
Date:   Wed, 23 Nov 2022 07:44:24 -0500
Message-Id: <20221123124427.266286-14-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221123124427.266286-1-sashal@kernel.org>
References: <20221123124427.266286-1-sashal@kernel.org>
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
index 6f82436ff72f..7f0e3b09f776 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1314,6 +1314,7 @@ static const struct usb_device_id products[] = {
 	{QMI_FIXED_INTF(0x2357, 0x0201, 4)},	/* TP-LINK HSUPA Modem MA180 */
 	{QMI_FIXED_INTF(0x2357, 0x9000, 4)},	/* TP-LINK MA260 */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1031, 3)}, /* Telit LE910C1-EUX */
+	{QMI_QUIRK_SET_DTR(0x1bc7, 0x103a, 0)}, /* Telit LE910C4-WWX */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1040, 2)},	/* Telit LE922A */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1050, 2)},	/* Telit FN980 */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1060, 2)},	/* Telit LN920 */
-- 
2.35.1

