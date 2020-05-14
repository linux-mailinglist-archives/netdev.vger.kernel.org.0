Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 029FD1D3ABF
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 20:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729673AbgENS4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 14:56:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:57160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729650AbgENS4R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 May 2020 14:56:17 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A13632074A;
        Thu, 14 May 2020 18:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589482576;
        bh=GQkvxY6a60MfmC9Z3Ps15B2m5edknHHKmRYox64jmQw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O23BWtX+kbHwy42eKO8Z925R45e/8pn06X7GE3WEAGgGJfS2VWWbh+f8CAtR0s1G5
         IYZ8SwV37Iz53Gn9B/ZTRIIDJhrCLbcNIx3xfsGHwrtH6dYTXiE72mwAKiWbqLk2By
         1b/EIZDhpBaRyWfFc0ohiF3u15iBwXgdsDIPvUSI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Matt Jolly <Kangie@footclan.ninja>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 21/27] net: usb: qmi_wwan: add support for DW5816e
Date:   Thu, 14 May 2020 14:55:44 -0400
Message-Id: <20200514185550.21462-21-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200514185550.21462-1-sashal@kernel.org>
References: <20200514185550.21462-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matt Jolly <Kangie@footclan.ninja>

[ Upstream commit 57c7f2bd758eed867295c81d3527fff4fab1ed74 ]

Add support for Dell Wireless 5816e to drivers/net/usb/qmi_wwan.c

Signed-off-by: Matt Jolly <Kangie@footclan.ninja>
Acked-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/qmi_wwan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 97f6b8130db33..5755eec00d7f8 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -950,6 +950,7 @@ static const struct usb_device_id products[] = {
 	{QMI_FIXED_INTF(0x413c, 0x81b3, 8)},	/* Dell Wireless 5809e Gobi(TM) 4G LTE Mobile Broadband Card (rev3) */
 	{QMI_FIXED_INTF(0x413c, 0x81b6, 8)},	/* Dell Wireless 5811e */
 	{QMI_FIXED_INTF(0x413c, 0x81b6, 10)},	/* Dell Wireless 5811e */
+	{QMI_FIXED_INTF(0x413c, 0x81cc, 8)},	/* Dell Wireless 5816e */
 	{QMI_FIXED_INTF(0x413c, 0x81d7, 0)},	/* Dell Wireless 5821e */
 	{QMI_FIXED_INTF(0x413c, 0x81d7, 1)},	/* Dell Wireless 5821e preproduction config */
 	{QMI_FIXED_INTF(0x413c, 0x81e0, 0)},	/* Dell Wireless 5821e with eSIM support*/
-- 
2.20.1

