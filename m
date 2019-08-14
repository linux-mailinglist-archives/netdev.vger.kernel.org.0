Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC0A98C769
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 04:24:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729906AbfHNCXn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 22:23:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:52688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729904AbfHNCXm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 22:23:42 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B7392084F;
        Wed, 14 Aug 2019 02:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565749421;
        bh=SQ9l5mnNRcN636V0IPLjwe8BB4ri/ZSdtxwPHxqey10=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fIEsckv/lWzuQ8btvikQJSi3+JVEx0AdfyR6iUa+I1O1qPEuThhZLvWY5YofDetKx
         BzZl+KdD0XeRvwkH9bsWY20vRb9KXqh6/LUq4t7CTE9QZDRgzIR4HNec+6eAAiHsLu
         yofro9zB8kSYn9AwYEGSjOAYt2RKuqtSVdfItnFQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bob Ham <bob.ham@puri.sm>, Angus Ainslie <angus@akkea.ca>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 11/33] net: usb: qmi_wwan: Add the BroadMobi BM818 card
Date:   Tue, 13 Aug 2019 22:23:01 -0400
Message-Id: <20190814022323.17111-11-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814022323.17111-1-sashal@kernel.org>
References: <20190814022323.17111-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bob Ham <bob.ham@puri.sm>

[ Upstream commit 9a07406b00cdc6ec689dc142540739575c717f3c ]

The BroadMobi BM818 M.2 card uses the QMI protocol

Signed-off-by: Bob Ham <bob.ham@puri.sm>
Signed-off-by: Angus Ainslie (Purism) <angus@akkea.ca>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/qmi_wwan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index d51ad140f46d2..05953e14a064e 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -892,6 +892,7 @@ static const struct usb_device_id products[] = {
 	{QMI_FIXED_INTF(0x2001, 0x7e35, 4)},	/* D-Link DWM-222 */
 	{QMI_FIXED_INTF(0x2020, 0x2031, 4)},	/* Olicard 600 */
 	{QMI_FIXED_INTF(0x2020, 0x2033, 4)},	/* BroadMobi BM806U */
+	{QMI_FIXED_INTF(0x2020, 0x2060, 4)},	/* BroadMobi BM818 */
 	{QMI_FIXED_INTF(0x0f3d, 0x68a2, 8)},    /* Sierra Wireless MC7700 */
 	{QMI_FIXED_INTF(0x114f, 0x68a2, 8)},    /* Sierra Wireless MC7750 */
 	{QMI_FIXED_INTF(0x1199, 0x68a2, 8)},	/* Sierra Wireless MC7710 in QMI mode */
-- 
2.20.1

