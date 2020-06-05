Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80C5C1EF802
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 14:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728157AbgFEMbH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 08:31:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:56752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726709AbgFEMZ0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jun 2020 08:25:26 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 912A3207D8;
        Fri,  5 Jun 2020 12:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591359926;
        bh=+tWFxojbwbjTLS/ezsp1cuaZ8C8To3S6VWEHd9iuCno=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gSPRC3nFoG34T1q8DdRNcXNaOXCoXYNoTgx+7lw/+H+IJdQp+YKuMieP/u/xuGrDR
         4MvRHVW3XYSJtxF/Lc+/yu61JeFOtZqjOv2+8Zk6I16nFJolPDJMyEls73TO7l7wEv
         gZ1APvdzrUi7PjRM3JFhTlyM4foLreO3mfjQq3fQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniele Palmas <dnlplm@gmail.com>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 07/17] net: usb: qmi_wwan: add Telit LE910C1-EUX composition
Date:   Fri,  5 Jun 2020 08:25:06 -0400
Message-Id: <20200605122517.2882338-7-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200605122517.2882338-1-sashal@kernel.org>
References: <20200605122517.2882338-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Daniele Palmas <dnlplm@gmail.com>

[ Upstream commit 591612aa578cd7148b7b9d74869ef40118978389 ]

Add support for Telit LE910C1-EUX composition

0x1031: tty, tty, tty, rmnet
Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
Acked-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/qmi_wwan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 4bb8552a00d3..4a2c7355be63 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1324,6 +1324,7 @@ static const struct usb_device_id products[] = {
 	{QMI_FIXED_INTF(0x1bbb, 0x0203, 2)},	/* Alcatel L800MA */
 	{QMI_FIXED_INTF(0x2357, 0x0201, 4)},	/* TP-LINK HSUPA Modem MA180 */
 	{QMI_FIXED_INTF(0x2357, 0x9000, 4)},	/* TP-LINK MA260 */
+	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1031, 3)}, /* Telit LE910C1-EUX */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1040, 2)},	/* Telit LE922A */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1050, 2)},	/* Telit FN980 */
 	{QMI_FIXED_INTF(0x1bc7, 0x1100, 3)},	/* Telit ME910 */
-- 
2.25.1

