Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91B714EEF4F
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 16:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346841AbiDAO1d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 10:27:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346832AbiDAO1c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 10:27:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59AD5147510;
        Fri,  1 Apr 2022 07:25:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB4BA61BCE;
        Fri,  1 Apr 2022 14:25:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEEA2C340F2;
        Fri,  1 Apr 2022 14:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823142;
        bh=gouVROA5DvaNV23cEyJOTX1H2nEAK67vhW8Pg5mWjpY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hkVL15N5LSb8Y9Lxv1RJcj+yEGV+0+uGC1cLJkSZnyNcFIcFcwJkJBzlvRUEX8cQ3
         NFW25q29R0xv5Bplff3qo0SF8xbh66gMVEqC9Erla0+vteC2eW2XYzjKFWenk3tBjX
         959f5GKrey9FBeU+nhhZ7ChugnVH65BL5lQXU6nCakpb+NZE3nRlfubImZOAvOR356
         XJ1pC+clMeNuw06MV41ykUHvxzINCHFGOgC9TgpjGAFCQ4f4xrHRANdmiPJbPS93Lr
         HwW9QrdzuNAODaCUzIjasCJ00ORWWkxoziSwZeMtPHTFfCyrR2jWYYSobURQd/88pG
         v2yNAvIkrT4bg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>, johan.hedberg@gmail.com,
        luiz.dentz@gmail.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 002/149] Bluetooth: hci_sync: Fix compilation warning
Date:   Fri,  1 Apr 2022 10:23:09 -0400
Message-Id: <20220401142536.1948161-2-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401142536.1948161-1-sashal@kernel.org>
References: <20220401142536.1948161-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 89a0b8b98f49ae34886e67624208c2898e1e4d7f ]

This fixes the following warning:

net/bluetooth/hci_sync.c:5143:5: warning: no previous prototype for
‘hci_le_ext_create_conn_sync’ [-Wmissing-prototypes]

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index ab9aa700b6b3..4426cc2aaf4a 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -5140,8 +5140,8 @@ static void set_ext_conn_params(struct hci_conn *conn,
 	p->max_ce_len = cpu_to_le16(0x0000);
 }
 
-int hci_le_ext_create_conn_sync(struct hci_dev *hdev, struct hci_conn *conn,
-				u8 own_addr_type)
+static int hci_le_ext_create_conn_sync(struct hci_dev *hdev,
+				       struct hci_conn *conn, u8 own_addr_type)
 {
 	struct hci_cp_le_ext_create_conn *cp;
 	struct hci_cp_le_ext_conn_param *p;
-- 
2.34.1

