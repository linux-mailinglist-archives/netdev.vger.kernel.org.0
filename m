Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41C8F73233
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 16:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387542AbfGXOwh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 10:52:37 -0400
Received: from node.akkea.ca ([192.155.83.177]:58500 "EHLO node.akkea.ca"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726422AbfGXOwg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jul 2019 10:52:36 -0400
Received: from localhost (localhost [127.0.0.1])
        by node.akkea.ca (Postfix) with ESMTP id 75C354E200E;
        Wed, 24 Jul 2019 14:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akkea.ca; s=mail;
        t=1563979956; bh=W426McEeRu00NL6SGbRAa/sPcq/i1n5Nzqqz+qZ1PyU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=SX2ut3mIwIFnpXFTyiwY0Y3apXdfbq/oGUfh/jRvRAOvUS0VGV9EbljAkx9p8gaRw
         uq4JUq71eUulQiQMS91or+H8C7IW7cpANqZ6DGWK0k5u4CwvbEQKavqN/p4oGt1Lpd
         W4iJsJYNka2y0faW3cvpIGrLl1MLRneQVgsj6xHY=
X-Virus-Scanned: Debian amavisd-new at mail.akkea.ca
Received: from node.akkea.ca ([127.0.0.1])
        by localhost (mail.akkea.ca [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id NUn_LOvSUZ8f; Wed, 24 Jul 2019 14:52:36 +0000 (UTC)
Received: from midas.localdomain (S0106788a2041785e.gv.shawcable.net [70.66.86.75])
        by node.akkea.ca (Postfix) with ESMTPSA id D15054E2003;
        Wed, 24 Jul 2019 14:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akkea.ca; s=mail;
        t=1563979956; bh=W426McEeRu00NL6SGbRAa/sPcq/i1n5Nzqqz+qZ1PyU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=SX2ut3mIwIFnpXFTyiwY0Y3apXdfbq/oGUfh/jRvRAOvUS0VGV9EbljAkx9p8gaRw
         uq4JUq71eUulQiQMS91or+H8C7IW7cpANqZ6DGWK0k5u4CwvbEQKavqN/p4oGt1Lpd
         W4iJsJYNka2y0faW3cvpIGrLl1MLRneQVgsj6xHY=
From:   "Angus Ainslie (Purism)" <angus@akkea.ca>
To:     kernel@puri.sm
Cc:     =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bob Ham <bob.ham@puri.sm>,
        Angus Ainslie <angus@akkea.ca>
Subject: [PATCH 2/2] net: usb: qmi_wwan: Add the BroadMobi BM818 card
Date:   Wed, 24 Jul 2019 07:52:27 -0700
Message-Id: <20190724145227.27169-3-angus@akkea.ca>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190724145227.27169-1-angus@akkea.ca>
References: <20190724145227.27169-1-angus@akkea.ca>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bob Ham <bob.ham@puri.sm>

The BroadMobi BM818 M.2 card uses the QMI protocol

Signed-off-by: Bob Ham <bob.ham@puri.sm>
Signed-off-by: Angus Ainslie (Purism) <angus@akkea.ca>
---
 drivers/net/usb/qmi_wwan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 69e0a2acfcb0..b6dc5d714b5e 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1295,6 +1295,7 @@ static const struct usb_device_id products[] = {
 	{QMI_FIXED_INTF(0x2001, 0x7e3d, 4)},	/* D-Link DWM-222 A2 */
 	{QMI_FIXED_INTF(0x2020, 0x2031, 4)},	/* Olicard 600 */
 	{QMI_FIXED_INTF(0x2020, 0x2033, 4)},	/* BroadMobi BM806U */
+	{QMI_FIXED_INTF(0x2020, 0x2060, 4)},	/* BroadMobi BM818 */
 	{QMI_FIXED_INTF(0x0f3d, 0x68a2, 8)},    /* Sierra Wireless MC7700 */
 	{QMI_FIXED_INTF(0x114f, 0x68a2, 8)},    /* Sierra Wireless MC7750 */
 	{QMI_FIXED_INTF(0x1199, 0x68a2, 8)},	/* Sierra Wireless MC7710 in QMI mode */
-- 
2.17.1

