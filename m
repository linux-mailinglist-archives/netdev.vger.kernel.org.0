Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2D65462D49
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 08:03:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238945AbhK3HHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 02:07:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238943AbhK3HHL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 02:07:11 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7B02C061574
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 23:03:52 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id t5so82871578edd.0
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 23:03:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=76fBQ3m8zaXnv0k+vzxFiLe3EqjE3QNEI4UdiuCTMic=;
        b=JSow12YOxzIjsF1cOP/gMuJtvr27QWodBUvhioXsOaIWiDRvUJhG2mJ69n6dsi04A7
         EX934LYu4lN9Y7Q6Yj9/hujs9LgNz1xrX/5uoaS3XWDFd2LBiNfW8WVYcUhPiL6xwDhu
         1u4nJFmUcneDfSuD2uJjI07GjvQvfPZUdl0ER+6/1Nd5PTNoSd8VmVdoyY1yKra2oVdg
         kop8WIcV4v+ErFcE3HI0fz2NXFywFidSUkWkG6Fvs7prSCZl6ObeZ74XNpJ8utGUZz0T
         5+PeEHFWb8mENbu11WF4KPriCuO2K5XbujuKi4prH902Wgilvhfu8FQE5sXqoSq+rxEX
         Ul/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=76fBQ3m8zaXnv0k+vzxFiLe3EqjE3QNEI4UdiuCTMic=;
        b=xIUqfl08LlNF31jwsf9xq9JJg3wEm3wzxl4Xd99C66+6dYRjUAcmlj7wbilElHYa+P
         HbOqGYD0lJbik++REN1Zramqtr+Ep9umGCN46gtKFNKnPeR5QMMuDJGfRK0Li5owbInR
         uzPflC4WxzGqEYpQ7ua6QoafJOY3Jsik0NtNoOeJ5vvwDamJ+Dfg6R/25MRSLbujQkfh
         YWUga4yyfvXhMLawy5Da3lenRR577CIwvN4LAfDtY/RUOBKxw4s3Z5bQAqidTvjCPUtT
         WryvFbOwStv5aBbazN8aFOtzEvp9Cy/EqGk0kH1o3nKV/K1dXuAyn5O6jdHILiFEmYO9
         jpxA==
X-Gm-Message-State: AOAM53279DByud2HTP4f1SeUD39RZipoZCI9YOphGMAH729d5cw8tBiT
        0yFUh71L+rnOaUfEmiH04TI=
X-Google-Smtp-Source: ABdhPJySoqdjUjlR7AVA3s6xsYS6X0c/iqT12SIgdsF59XgTlElHJ2J4Gw7LWSFGtJROqzSsUlX87g==
X-Received: by 2002:a17:907:a0d4:: with SMTP id hw20mr65885048ejc.16.1638255831527;
        Mon, 29 Nov 2021 23:03:51 -0800 (PST)
Received: from localhost ([45.153.160.134])
        by smtp.gmail.com with ESMTPSA id nc29sm8891703ejc.3.2021.11.29.23.03.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 23:03:51 -0800 (PST)
From:   =?UTF-8?q?J=CE=B5an=20Sacren?= <sakiwit@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, hkallweit1@gmail.com,
        andrew@lunn.ch, netdev@vger.kernel.org
Subject: [PATCH net-next] net: cxgb: fix a typo in kernel doc
Date:   Tue, 30 Nov 2021 00:03:11 -0700
Message-Id: <20211130070312.5494-2-sakiwit@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jean Sacren <sakiwit@gmail.com>

Fix a trivial typo of 'pakcet' in cxgb kernel doc.

Signed-off-by: Jean Sacren <sakiwit@gmail.com>
---
 drivers/net/ethernet/chelsio/cxgb/sge.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb/sge.c b/drivers/net/ethernet/chelsio/cxgb/sge.c
index cda01f22c71c..12e76fd0ae91 100644
--- a/drivers/net/ethernet/chelsio/cxgb/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb/sge.c
@@ -1359,7 +1359,7 @@ static void restart_sched(struct tasklet_struct *t)
  *	@fl: the free list that contains the packet buffer
  *	@len: the packet length
  *
- *	Process an ingress ethernet pakcet and deliver it to the stack.
+ *	Process an ingress ethernet packet and deliver it to the stack.
  */
 static void sge_rx(struct sge *sge, struct freelQ *fl, unsigned int len)
 {
