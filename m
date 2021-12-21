Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15D9C47B71C
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 02:58:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232340AbhLUB6M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 20:58:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232272AbhLUB6I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 20:58:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1CFFC06173E;
        Mon, 20 Dec 2021 17:58:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 388B161224;
        Tue, 21 Dec 2021 01:58:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B41F0C36AEA;
        Tue, 21 Dec 2021 01:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640051887;
        bh=ZQVyKEge9r0FTOEqdE6XH5HRkMOreaMlc6KNk2Oi238=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xx7ZNwvNkXqWr6oz4Lj8dF/OfrUZp92vw370tQqZaaZCDF1MeDcHy0ckFG47wx8Qt
         jqltq4XrVyaCkQLQhSoTuJpKbMpNNzsT1HzphLMXXxLBnjo+wDNtjLKxxM31u7hjZj
         lEQI9ScibD7eCfKBycsCJat4Qkp15hvKoy5e3pF5Xiyx2ANBdZTb7p84zD58/HTYz1
         R/+37jpj+zib+qfwNdq15c3JzbsBhCZXGXN2DyWrnoW0WfoiVIfni9weHeWoIdkgix
         /RDRMVNmPzcOhzzm1n6KvFFserX8eBC/+DpgUWWVW5cm4LecfIBNWtpkkksowlj9lt
         N/m61acg+peOQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniele Palmas <dnlplm@gmail.com>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 10/29] net: usb: qmi_wwan: add Telit 0x1070 composition
Date:   Mon, 20 Dec 2021 20:57:31 -0500
Message-Id: <20211221015751.116328-10-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211221015751.116328-1-sashal@kernel.org>
References: <20211221015751.116328-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Daniele Palmas <dnlplm@gmail.com>

[ Upstream commit 94f2a444f28a649926c410eb9a38afb13a83ebe0 ]

Add the following Telit FN990 composition:

0x1070: tty, adb, rmnet, tty, tty, tty, tty

Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
Acked-by: Bjørn Mork <bjorn@mork.no>
Link: https://lore.kernel.org/r/20211210095722.22269-1-dnlplm@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/qmi_wwan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 33ada2c59952e..b62489f567e48 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1355,6 +1355,7 @@ static const struct usb_device_id products[] = {
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1040, 2)},	/* Telit LE922A */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1050, 2)},	/* Telit FN980 */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1060, 2)},	/* Telit LN920 */
+	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1070, 2)},	/* Telit FN990 */
 	{QMI_FIXED_INTF(0x1bc7, 0x1100, 3)},	/* Telit ME910 */
 	{QMI_FIXED_INTF(0x1bc7, 0x1101, 3)},	/* Telit ME910 dual modem */
 	{QMI_FIXED_INTF(0x1bc7, 0x1200, 5)},	/* Telit LE920 */
-- 
2.34.1

