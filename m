Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCE29357860
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 01:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbhDGXUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 19:20:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbhDGXUX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 19:20:23 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C44FC061761
        for <netdev@vger.kernel.org>; Wed,  7 Apr 2021 16:20:13 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id j6-20020a17090adc86b02900cbfe6f2c96so323030pjv.1
        for <netdev@vger.kernel.org>; Wed, 07 Apr 2021 16:20:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=WWFs2CvSTSC0cIwVlaRuaYTlAezQpAqLGtwVnAuh2fo=;
        b=TytgDHUN6OhblGqS86bK6ZBgpQg/WzwkyUFDPp6bp6BVY8hmqbC0L0+bgqaqK1ojeh
         I2VJ+oHjDVY8FYCDa4ZSdSufm3CzH5TepMGgQLT2ZiXwHtHVLZuDeWhQtb6v+2PGj2Og
         Ksq999qZNj9P0KujSkRf9G/2shqEjAhxAQo+3Ew47J5OpjMnuZE6GkN8pQXclU2FyAmP
         CfLJGa1Z07M7rklI1yO6LE24xk9w18ZkT1u2UFKJZaw2ugXG/poe9+NOzKXQG3Q6uwk9
         HXmwphSYGG75hvagRhYNDbGMek5dtBQ87wEcxvHD4KSxmwegYwEF8VKDKMGEMkcjub8O
         9DlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=WWFs2CvSTSC0cIwVlaRuaYTlAezQpAqLGtwVnAuh2fo=;
        b=DAEhQ1Sen4Ezfqf+lA7GvbHngiq1ODrprkBDxTgroruYjFlylLcg5LEa+9oT37cBZz
         ipso/Nl750zvZljBjOhhYkGSZLggu0WPh6LY62oAxJBByAWV1Zk4A01Uz8NlQlEOsU4R
         e4ui9Vq3vM0nhmzwUzKwLaCghpU4MrDhofCHBF2w7XDI+rCAKsrI6iolU6HrMRFxLbql
         JAe1xdUim/Vmw9I5BQrKPY8hyBbH3qGycv0qgfVnwWhUnpbnUTDVmSHpCqwbm62GWgo0
         GfBEn/OSmpZjIFcbUzOSUIAnwosJQnTj1e78E6HQGrzWChJvUluaRDiP8dhuRR0qcUVI
         hXOA==
X-Gm-Message-State: AOAM5322Wkd0tUnwrWJD7xu75hXiUO9KjC8NTlO0o4a0SVickEteHFnn
        24DzefWFJnMlvwhOoiU/ZU1QeWSnhc4h7Q==
X-Google-Smtp-Source: ABdhPJzIq+aykrc87FHWku9EAgtKzjNCgv8ZrcCbTO0NU36llmaiRlSkKerPT3B2mYytXL7Z9aQy+Q==
X-Received: by 2002:a17:902:ce88:b029:e6:3a3c:2f65 with SMTP id f8-20020a170902ce88b02900e63a3c2f65mr5133142plg.66.1617837612962;
        Wed, 07 Apr 2021 16:20:12 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id g3sm21422171pfk.186.2021.04.07.16.20.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Apr 2021 16:20:12 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        richardcochran@gmail.com
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 1/8] ionic: fix up a couple of code style nits
Date:   Wed,  7 Apr 2021 16:19:54 -0700
Message-Id: <20210407232001.16670-2-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210407232001.16670-1-snelson@pensando.io>
References: <20210407232001.16670-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clean up variable declarations.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index ee56fed12e07..4e22e50922cd 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -2015,9 +2015,8 @@ static void ionic_txrx_free(struct ionic_lif *lif)
 
 static int ionic_txrx_alloc(struct ionic_lif *lif)
 {
-	unsigned int num_desc, desc_sz, comp_sz, sg_desc_sz;
-	unsigned int flags;
-	unsigned int i;
+	unsigned int comp_sz, desc_sz, num_desc, sg_desc_sz;
+	unsigned int flags, i;
 	int err = 0;
 
 	num_desc = lif->ntxq_descs;
@@ -2584,12 +2583,11 @@ static void ionic_swap_queues(struct ionic_qcq *a, struct ionic_qcq *b)
 int ionic_reconfigure_queues(struct ionic_lif *lif,
 			     struct ionic_queue_params *qparam)
 {
-	unsigned int num_desc, desc_sz, comp_sz, sg_desc_sz;
+	unsigned int comp_sz, desc_sz, num_desc, sg_desc_sz;
 	struct ionic_qcq **tx_qcqs = NULL;
 	struct ionic_qcq **rx_qcqs = NULL;
-	unsigned int flags;
+	unsigned int flags, i;
 	int err = -ENOMEM;
-	unsigned int i;
 
 	/* allocate temporary qcq arrays to hold new queue structs */
 	if (qparam->nxqs != lif->nxqs || qparam->ntxq_descs != lif->ntxq_descs) {
-- 
2.17.1

