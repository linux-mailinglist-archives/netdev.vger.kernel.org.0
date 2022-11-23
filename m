Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B083635E12
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 13:56:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238593AbiKWMz3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 07:55:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238759AbiKWMx1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 07:53:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B874F6EB7F;
        Wed, 23 Nov 2022 04:45:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4FCC861CC0;
        Wed, 23 Nov 2022 12:45:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADD2CC433C1;
        Wed, 23 Nov 2022 12:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669207516;
        bh=s7DGeJvcd98IAo46F3nQMLH1dTWYu/cCMv/7KZdfigA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B3AKWx0egNYVA9qhgxUf8+gtx984yKFr5t+ETnv6ozLkBmWT4Re5hF6Y9kMKylGLg
         1vZXb8lAeq7Ka3qoJL3rnbECRs4JZSrY/sgmqjwFapbNcOif3p4D9qa2taoulfW8IW
         Bz7rzaYKe+2mrpkILbl+mEIDpYI0/XMTdnCZ112VpAn4plKpbCX+7KInatkO63tCjO
         sFfir0Rws4uugzSwNlIQHkNWZGz7KIWXpiG5rpVMnwdjATPC3rCq1mNmjfzDU8+leM
         3LIyDU6iTjKaIJ6ZazX2usVYEYhdU+rKR37dcsmmNUeIp4zpHYeAgAfyTZQ6t5b7sf
         7LgWptm0DfFaA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Enrico Sau <enrico.sau@gmail.com>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 10/11] net: usb: qmi_wwan: add Telit 0x103a composition
Date:   Wed, 23 Nov 2022 07:44:55 -0500
Message-Id: <20221123124458.266492-10-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221123124458.266492-1-sashal@kernel.org>
References: <20221123124458.266492-1-sashal@kernel.org>
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
index 56115792bea1..24fb9708fb11 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1317,6 +1317,7 @@ static const struct usb_device_id products[] = {
 	{QMI_FIXED_INTF(0x2357, 0x0201, 4)},	/* TP-LINK HSUPA Modem MA180 */
 	{QMI_FIXED_INTF(0x2357, 0x9000, 4)},	/* TP-LINK MA260 */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1031, 3)}, /* Telit LE910C1-EUX */
+	{QMI_QUIRK_SET_DTR(0x1bc7, 0x103a, 0)}, /* Telit LE910C4-WWX */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1040, 2)},	/* Telit LE922A */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1050, 2)},	/* Telit FN980 */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1060, 2)},	/* Telit LN920 */
-- 
2.35.1

