Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F928132DD9
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 19:00:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728628AbgAGSAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 13:00:16 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:32919 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728391AbgAGSAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 13:00:16 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1iot9J-0000p9-CV; Tue, 07 Jan 2020 18:00:13 +0000
From:   Colin King <colin.king@canonical.com>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Bluetooth: remove redundant assignment to variable icid
Date:   Tue,  7 Jan 2020 18:00:13 +0000
Message-Id: <20200107180013.124501-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Variable icid is being rc is assigned with a value that is never
read. The assignment is redundant and can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 net/bluetooth/l2cap_core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 1bca608e0170..195459a1e53e 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -5081,7 +5081,6 @@ static inline int l2cap_move_channel_req(struct l2cap_conn *conn,
 	chan->move_role = L2CAP_MOVE_ROLE_RESPONDER;
 	l2cap_move_setup(chan);
 	chan->move_id = req->dest_amp_id;
-	icid = chan->dcid;
 
 	if (req->dest_amp_id == AMP_ID_BREDR) {
 		/* Moving to BR/EDR */
-- 
2.24.0

