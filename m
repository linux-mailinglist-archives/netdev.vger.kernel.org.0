Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 099A031163C
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 00:00:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231357AbhBEW7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 17:59:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232277AbhBEMsh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 07:48:37 -0500
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67619C06178B;
        Fri,  5 Feb 2021 04:47:56 -0800 (PST)
Received: by mail-qt1-x82b.google.com with SMTP id t17so4833669qtq.2;
        Fri, 05 Feb 2021 04:47:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=paJuzDYDLsC0xxweYb9BHOSqnECoSO++KQ1DWn0hxFM=;
        b=dg7Be6vJfg1XCEnHU5587INk0mfVh3VEKMThkTPZy0vCMXLeTKooBU2VdgR5W72Vq/
         FRm8SzWWdxWBWJACVuH4Uecs0bkfAiXAb53QhXZ/ykjG9tuTfl2BOchLCUqgRrjb2EKG
         BD4vbqPZ5I8zCtYE6Pzztvs6WtwEDpA6VAL/tIZ0O6qjTLPFEFSwWZvg+LjduTwmy+ER
         0Oog85nBEIQpYIOa/Y0zq0mRwIxbpC+NDBdcfYw2905Rh6eBhPFAmsvyXFJUkQdARJ9r
         jP57s15jc9ktI6wUISJRCNvsDWZx6R3Fr7+xrxDK/sbwAKoYrw5sDb3xL1Eyo4M42+Rn
         njvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=paJuzDYDLsC0xxweYb9BHOSqnECoSO++KQ1DWn0hxFM=;
        b=YcVWLhEhld38q2RbKQgdpCl7uPDo2fzqt7zKfGeE63GMcwHpdz/MoAo/M2MeGnMJu+
         YZCQXOHeoN4jr8ldD8KcpG+tBkOJDMbNjVjEf5f5pKxuCWJLZdMJo17c3P/19CnPoGsG
         Afxzli11+1L3XZmG40djwNX5W+tv5JkE0koXFUCelaofBAhVJYwaVRfl8RytNKJtJ7ps
         tjCbfLWAgwLhXIcCa8wHJT6KlFt45EHpeSSNVO58MyrzPaVo5kN56bCnsFbkGfvZz2hU
         ZUqb2M1uxTuA4hlk54VK677E1EAz1CYJxuL0LtGAmB1cZWs33o3GDDwjDI0oi8D1zAQB
         XqZA==
X-Gm-Message-State: AOAM53264465YPNeLscyRHvO3L1uIilOOETyMfkHS0pZsqhCgeR5+nsh
        8Ci08XAQNOMCg1D4sNMqBLk=
X-Google-Smtp-Source: ABdhPJyTLNdaPqQSQYvNm+BBIeqysRdOTD8tf+NrNTWWPrmbpykOdQ2aHGwjMjRS20ADf7HpSLzusA==
X-Received: by 2002:ac8:7768:: with SMTP id h8mr3953433qtu.331.1612529275723;
        Fri, 05 Feb 2021 04:47:55 -0800 (PST)
Received: from localhost.localdomain ([138.199.10.106])
        by smtp.gmail.com with ESMTPSA id y186sm721035qka.121.2021.02.05.04.47.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 04:47:54 -0800 (PST)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, rppt@kernel.org,
        akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rdunlap@infradead.org, Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: [PATCH] drivers: net: ethernet: sun:  Fix couple of spells in the file sunhme.c
Date:   Fri,  5 Feb 2021 18:17:41 +0530
Message-Id: <20210205124741.1397457-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



s/fuck/mess/
s/fucking/soooo/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 drivers/net/ethernet/sun/sunhme.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index 54b53dbdb33c..98ff9300b5ee 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -982,7 +982,7 @@ static void happy_meal_poll_stop(struct happy_meal *hp, void __iomem *tregs)
 	ASD(("done\n"));
 }

-/* Only Sun can take such nice parts and fuck up the programming interface
+/* Only Sun can take such nice parts and mess up the programming interface
  * like this.  Good job guys...
  */
 #define TCVR_RESET_TRIES       16 /* It should reset quickly        */
@@ -2074,7 +2074,7 @@ static void happy_meal_rx(struct happy_meal *hp, struct net_device *dev)
 			skb = copy_skb;
 		}

-		/* This card is _fucking_ hot... */
+		/* This card is _sooooo_ hot... */
 		skb->csum = csum_unfold(~(__force __sum16)htons(csum));
 		skb->ip_summed = CHECKSUM_COMPLETE;

--
2.30.0

