Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44E44E5C50
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 15:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727210AbfJZNUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 09:20:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:42118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726748AbfJZNUT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 09:20:19 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0C15214DA;
        Sat, 26 Oct 2019 13:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572096018;
        bh=ziBam62KRfV8A59qe6wtH0q1c3/kaQ2nomonpICXsVA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mfMbHQU6daIIxlVX365dH48kzxHctoz495PXtbGIQ73aWUOhaf2L+4JPYkH0x9dbJ
         G1D8WvJHEmO0vL8EBqJhOb237qEVli6PFWbIaT7at3y0LoMs6HzyzNieYEh4XtkCEN
         ouetGFrI1+OEZuoAjDAPE1sfTIbGcQo4jtpjVYmo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniele Palmas <dnlplm@gmail.com>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 33/59] net: usb: qmi_wwan: add Telit 0x1050 composition
Date:   Sat, 26 Oct 2019 09:18:44 -0400
Message-Id: <20191026131910.3435-33-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191026131910.3435-1-sashal@kernel.org>
References: <20191026131910.3435-1-sashal@kernel.org>
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

[ Upstream commit e0ae2c578d3909e60e9448207f5d83f785f1129f ]

This patch adds support for Telit FN980 0x1050 composition

0x1050: tty, adb, rmnet, tty, tty, tty, tty

Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
Acked-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/qmi_wwan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 6f517e6730208..3e22fc650a14f 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1263,6 +1263,7 @@ static const struct usb_device_id products[] = {
 	{QMI_FIXED_INTF(0x2357, 0x0201, 4)},	/* TP-LINK HSUPA Modem MA180 */
 	{QMI_FIXED_INTF(0x2357, 0x9000, 4)},	/* TP-LINK MA260 */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1040, 2)},	/* Telit LE922A */
+	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1050, 2)},	/* Telit FN980 */
 	{QMI_FIXED_INTF(0x1bc7, 0x1100, 3)},	/* Telit ME910 */
 	{QMI_FIXED_INTF(0x1bc7, 0x1101, 3)},	/* Telit ME910 dual modem */
 	{QMI_FIXED_INTF(0x1bc7, 0x1200, 5)},	/* Telit LE920 */
-- 
2.20.1

