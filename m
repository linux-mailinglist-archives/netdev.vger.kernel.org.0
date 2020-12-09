Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA0772D4A86
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 20:39:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387662AbgLITho (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 14:37:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729747AbgLIThc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 14:37:32 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4185FC0613D6;
        Wed,  9 Dec 2020 11:36:52 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id 4so1494197plk.5;
        Wed, 09 Dec 2020 11:36:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=CyWgjPy4I+HbjxDbhT+g/PzO0BxXYU1ulWjOU7DYulU=;
        b=TPJg7bYIXiUHQ6rRirpCUnu5kGZXP8cRVZwlsH7HBXNcp88TOTj5vkuPs0iczU1dve
         Duw9uO+PmjYt7zP/gqTJMmAonixhykINDhVdskZQzxQ7KB8/8xCFEzW6Q1AGn08kLU5G
         4KkVKOxacMcwgPnn3MqjHUu4iE2u4FfEDKtNUQH9fqQqdN5fJejMpPm03ERAWQqTDgjF
         bPUcJsqN1sjlGDyy1XIRMjgKZHRPfCrholGqi+lVhL+tE3f9tAFZry1sWDL02uWlfEaz
         t7WL5eoMio0ZdlzpVcDG+G35xhGECJ4223Ke3C87s4FbARmG9uDq5ferawYdpjjW0sd/
         Rnlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=CyWgjPy4I+HbjxDbhT+g/PzO0BxXYU1ulWjOU7DYulU=;
        b=pu3m7nh/51JE0eeDibh3UHk1GIfqcOM6r1pwjarRDsWab2eZ0fpBdJBxtRr7m/ktKd
         S/SCAQ0GaJ+Smfrrq5I37O/ExbIVjx1sdUGC3F2Ph3Zb90zZLfLlm5/0gjUjiKk4Y4Yb
         gJfpm/tsXFLgSu6ATQheJGC1Y0umqwLGRDOzCkEvv+1/3Ng/UPg3BMQTkss4EVhSQNVp
         eDACPLW8ztsUChKNSzJ0PKyQRAAg2rWTiGWWVMS7TgEWQGRynvdUjA5qK9tzqUG1GhZ5
         tf6u6ahmeMPnShwuHGDPcD58ETvkUr4aGruXKp+1ue6q9KVz1/tU6Ex42uoQC7jpsUPW
         cdHw==
X-Gm-Message-State: AOAM532lhJopTimFIkQlg+AeFsj5hiaDklYeUj4vxSiy+GuD3W78VGYK
        PW6XyNfD8gsheEI+/EefOnM=
X-Google-Smtp-Source: ABdhPJxwT/EueNc5KNGRYj9S8wYQiuJE2KBwKMWVjhaF+uU06n8Ti11ncw8BL0PtBi4etdv40vsqpQ==
X-Received: by 2002:a17:902:9f8b:b029:da:726d:3f17 with SMTP id g11-20020a1709029f8bb02900da726d3f17mr3358980plq.35.1607542611741;
        Wed, 09 Dec 2020 11:36:51 -0800 (PST)
Received: from jordon-HP-15-Notebook-PC.domain.name ([122.179.87.107])
        by smtp.gmail.com with ESMTPSA id fv22sm3079552pjb.14.2020.12.09.11.36.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Dec 2020 11:36:51 -0800 (PST)
From:   Souptick Joarder <jrdr.linux@gmail.com>
To:     nbd@nbd.name, lorenzo.bianconi83@gmail.com, ryder.lee@mediatek.com,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        matthias.bgg@gmail.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Souptick Joarder <jrdr.linux@gmail.com>
Subject: [PATCH] mt76: Fixed kernel test robot warning
Date:   Thu, 10 Dec 2020 01:06:57 +0530
Message-Id: <1607542617-4005-1-git-send-email-jrdr.linux@gmail.com>
X-Mailer: git-send-email 1.9.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kernel test robot throws below warning ->

   drivers/net/wireless/mediatek/mt76/tx.c: In function
'mt76_txq_schedule':
>> drivers/net/wireless/mediatek/mt76/tx.c:499:21: warning: variable 'q'
>> set but not used [-Wunused-but-set-variable]
     499 |  struct mt76_queue *q;
         |                     ^

This patch will silence this warning.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
---
 drivers/net/wireless/mediatek/mt76/tx.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index 1e20afb..25627e7 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -504,14 +504,11 @@ void mt76_tx_complete_skb(struct mt76_dev *dev, u16 wcid_idx, struct sk_buff *sk
 
 void mt76_txq_schedule(struct mt76_phy *phy, enum mt76_txq_id qid)
 {
-	struct mt76_queue *q;
 	int len;
 
 	if (qid >= 4)
 		return;
 
-	q = phy->q_tx[qid];
-
 	rcu_read_lock();
 
 	do {
-- 
1.9.1

