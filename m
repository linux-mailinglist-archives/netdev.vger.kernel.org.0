Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E6353C63B0
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 21:25:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236249AbhGLT1r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 15:27:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233614AbhGLT1p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 15:27:45 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60463C0613DD;
        Mon, 12 Jul 2021 12:24:55 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id go30so9638501ejc.8;
        Mon, 12 Jul 2021 12:24:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=EXSa7ZRP07wE7xUqpdX6khnXof1r5yjvLJ0tFjO93j0=;
        b=o7wRt8S0gGAXaqNkaY+7A6QfY02q1S+poDsAK1tbKJ6ceLEo7ZUjbAwz2TaiXZzC/v
         YO8tEqzL5DLmFuH4i/5qgTOZtZn5R3XDMVMIke2TSqfFniUix+e/CGC/GCKNBYjMrA3W
         ZYVOBqtIDkVX3Adj6NcjbFgn0X57reLVrDs8G3jrQ9eyVLRZqsDRP1rsRddV5w5pW89j
         IQANDt3+4nYKSe/YdlVBdrap6GdU+zyiGq0IkObSbq/wTFIAY42Xa0hdElJGkPt/+UsY
         YRlIBFZatJh/KjPnJmiEzXgfW6vdzFkeUOeFoxPipR5Z1+0IWm+TSvmVNv1Pg1Yr805q
         ouoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=EXSa7ZRP07wE7xUqpdX6khnXof1r5yjvLJ0tFjO93j0=;
        b=XLGY6xfkeBR8q0tdmUZrIakPJZ+zuDuaUeThTQwZ7RQDfDSF7T6lCKU0ZOq4OESCU1
         Vi/UR7yvnzUFAEcVM/uGcZn/9x2cdqfpR5fjbW0V6kDo7Gbos3iAUCseiZtWEFuzV6zc
         nNP4Yu09ku1Qnjy71wpH0RbwbgCqkJ47KaAZT/PVOda2xzRoQtuqUv4dH67hdTTZHyXq
         YE4vegKFD+GNH97ySt5gukKKe2fgIwsRTSJYvbSUWC2qgpnFfD0BVlYkBRHKiYXurcB4
         X9ivWLjuU8y4nYZSFw+NTunbrGy18p321o+VIbk1XNki0UZP5lbhQgPy1EQHR7+RfwdM
         AZ/g==
X-Gm-Message-State: AOAM533Usak/zyXiSqwjd6RvGwKezmDtnNgoCUxZjv4gYRGlh8doGdgM
        rqijs/JJa62ULYCduQRY4g0=
X-Google-Smtp-Source: ABdhPJzL/8kLERclU83xBs8Grvq115gIv9Hy+fqUWOzMH1Dz3a9CzcsbLTstwFRXoBTjMM92ryWn7w==
X-Received: by 2002:a17:906:2844:: with SMTP id s4mr690292ejc.263.1626117894021;
        Mon, 12 Jul 2021 12:24:54 -0700 (PDT)
Received: from pc ([196.235.212.194])
        by smtp.gmail.com with ESMTPSA id ec38sm3710222edb.15.2021.07.12.12.24.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 12:24:53 -0700 (PDT)
Date:   Mon, 12 Jul 2021 20:24:50 +0100
From:   Salah Triki <salah.triki@gmail.com>
To:     kevin.curtis@farsite.co.uk, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] replace for loop with array initializer
Message-ID: <20210712192450.GA1153790@pc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace for loop with array initializer in order to make code more clean.

Signed-off-by: Salah Triki <salah.triki@gmail.com>
---
 drivers/net/wan/farsync.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/wan/farsync.c b/drivers/net/wan/farsync.c
index b3466e084e84..a90d3b9a8170 100644
--- a/drivers/net/wan/farsync.c
+++ b/drivers/net/wan/farsync.c
@@ -567,7 +567,7 @@ static void fst_process_int_work_q(struct tasklet_struct *unused);
 static DECLARE_TASKLET(fst_tx_task, fst_process_tx_work_q);
 static DECLARE_TASKLET(fst_int_task, fst_process_int_work_q);
 
-static struct fst_card_info *fst_card_array[FST_MAX_CARDS];
+static struct fst_card_info *fst_card_array[FST_MAX_CARDS] = { [0 ... FST_MAX_CARDS-1] = NULL };
 static DEFINE_SPINLOCK(fst_work_q_lock);
 static u64 fst_work_txq;
 static u64 fst_work_intq;
@@ -2565,10 +2565,6 @@ static struct pci_driver fst_driver = {
 static int __init
 fst_init(void)
 {
-	int i;
-
-	for (i = 0; i < FST_MAX_CARDS; i++)
-		fst_card_array[i] = NULL;
 	return pci_register_driver(&fst_driver);
 }
 
-- 
2.25.1

