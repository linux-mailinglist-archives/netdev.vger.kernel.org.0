Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF51492088
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 08:50:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245526AbiARHuo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 02:50:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234433AbiARHuo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 02:50:44 -0500
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08B54C061574;
        Mon, 17 Jan 2022 23:50:44 -0800 (PST)
Received: by mail-qv1-xf2b.google.com with SMTP id kl12so20595704qvb.5;
        Mon, 17 Jan 2022 23:50:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JM5oEuGQvwPu2uDjo5nnYULdKnPojfIxdAFkXu5OFrk=;
        b=UQ8b/7ijatd4UqEhQ8HEe1uvKddfQg0IRy85KaedCIeRKLMV7vhUrHdho+p7KpILRc
         4Q/rUoWjShNCCZ7cOEoJIQfsJAS9B4Pjs6ntPPjMnieuNxbQqCPDq17c9lCEq1thc8Kc
         ug1dxe1Nvjirl64tM+GtjTOZzDpJEbA4jCz7Bom5xuzomnGWqZwG/Trmmab00zUgluOo
         d0czBPs202XEcoBx/mJni5Clzr0Bok+1EuJRJZnqtJuxtX2hZJC9xqI2ifqUrUBGCp+X
         u/mCAwj5b1+6w8jBDG9zwbNU2lvJCW26CBaQ/8G160EDcwl8fkNjjdMwBJTpg7Pu96u5
         Ag5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JM5oEuGQvwPu2uDjo5nnYULdKnPojfIxdAFkXu5OFrk=;
        b=FdamjifahFr+eBN1z2Fsqmhu0NhujcJUmKR+4PWh8dIoY9xuhXJyI25sfQJN30QX1b
         36FU6sZ7jdBmhOkFBa7qCq+r88ylLKY37qonDjjKqUykF/VIqt7l/gbhjd2NFticics/
         LRzYi9zunWCtoByZJ2W9wZcdDClswOwSJJZtql4wQVNKewyT2mDuG+QWbccpoI/Z+SDn
         uHkbqybDHKREQ8iz6JQ84rPjoq5oz4UY1Q2DIkftU3s+/zfjGwTeMPTO2Pxn7xh0BgoP
         48DqqRCfXk187C9hN6ypMj7FIftx/NFxfDPaBClYwjh0XeeRoTTR0fq0kctR6E1FuyeD
         t+XQ==
X-Gm-Message-State: AOAM532VpqeeuQ7pZhzMQbUleLBqIVNmv8//HyXLULtLVomX5cxqeWQm
        X1PKQkw2L2MvExv8vi3/QHA=
X-Google-Smtp-Source: ABdhPJwgzad8/tEfZa6sW8Zd1MtdAjv/pUTrNXCreSNZBS/qBG+COo/UYU+0nfl/YMTfCPZ31tDsKg==
X-Received: by 2002:a05:6214:ca3:: with SMTP id s3mr18846174qvs.9.1642492243037;
        Mon, 17 Jan 2022 23:50:43 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id l9sm9850610qkj.37.2022.01.17.23.50.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jan 2022 23:50:42 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     marcel@holtmann.org
Cc:     johan.hedberg@gmail.com, luiz.dentz@gmail.com, davem@davemloft.net,
        kuba@kernel.org, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>, CGEL ZTE <cgel.zte@gmail.com>
Subject: [PATCH] net/bluetooth: remove unneeded err variable
Date:   Tue, 18 Jan 2022 07:50:33 +0000
Message-Id: <20220118075033.925388-1-chi.minghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Minghao Chi <chi.minghao@zte.com.cn>

Return value from mgmt_cmd_complete() directly instead
of taking this in another redundant variable.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
Signed-off-by: CGEL ZTE <cgel.zte@gmail.com>
---
 net/bluetooth/mgmt.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 37087cf7dc5a..d0804648da32 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -8601,7 +8601,6 @@ static int get_adv_size_info(struct sock *sk, struct hci_dev *hdev,
 	struct mgmt_cp_get_adv_size_info *cp = data;
 	struct mgmt_rp_get_adv_size_info rp;
 	u32 flags, supported_flags;
-	int err;
 
 	bt_dev_dbg(hdev, "sock %p", sk);
 
@@ -8628,10 +8627,8 @@ static int get_adv_size_info(struct sock *sk, struct hci_dev *hdev,
 	rp.max_adv_data_len = tlv_data_max_len(hdev, flags, true);
 	rp.max_scan_rsp_len = tlv_data_max_len(hdev, flags, false);
 
-	err = mgmt_cmd_complete(sk, hdev->id, MGMT_OP_GET_ADV_SIZE_INFO,
+	return mgmt_cmd_complete(sk, hdev->id, MGMT_OP_GET_ADV_SIZE_INFO,
 				MGMT_STATUS_SUCCESS, &rp, sizeof(rp));
-
-	return err;
 }
 
 static const struct hci_mgmt_handler mgmt_handlers[] = {
-- 
2.25.1

