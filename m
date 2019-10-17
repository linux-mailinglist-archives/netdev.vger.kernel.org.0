Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12BE8DB5DF
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 20:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441337AbfJQSWE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 14:22:04 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:44021 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438745AbfJQSWD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 14:22:03 -0400
Received: by mail-pf1-f196.google.com with SMTP id a2so2158978pfo.10
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 11:22:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dy9XXJKnOeEoSFkVc1Fnb1YmIoGDsdnyRt591SUzhjg=;
        b=ZbzafM1EoCBj51alxdGLXo6mzOq3ot9WShev8Dz6OpSE+VvonpVsAcSdk2/f0dXk7b
         LBV3LeXlKjmvYuBzsJtuQbZ92jCqOgrSOARuGfyio5KkgzSAsqUEgFeJTQSAfzPiCC0t
         TCTCcdB0+Ma9p2FHqrWLxguP6T0TZTESApdZW1cctYK8hkEfqC4zBf8qicwJmOv2su/N
         eum3LhRGls6vfd6Kh/bO6YC6iEq9F6N4Ig+DbLa0Nsb+pFX6Iu2LDTZcpvaTPiSl00Xc
         bBerFo06ZGjr/WzQeaSzmGFE8XrDxJYR9+dQqiyypE7uPcuaQfTctfHKl/lkw1FVX8D1
         v4oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dy9XXJKnOeEoSFkVc1Fnb1YmIoGDsdnyRt591SUzhjg=;
        b=oZJVQOR4ZkakMi5/GKctKO4iciYU1N5i2pT0Q6v66dV7nGtGPCP99qyffgH4vGrZxO
         Rja+ShyvPgRUiqUnLNNhEajUw0B66BJOGp4Lzc4/lpApKuOjSRw/RxLCDCgXymFpqARR
         UvxQHNhMBE4r8Utst8UOhyc7q3ceGAU8UZBA69Fiuq08On6NDFJt6/LHm0H0Q5sFxFrl
         +Av0u+CFUj6JW1RYhK3kuHC0uNs93ToieWFSozJYS7KeS3LUjAsz6b9T2mJgdiQpNMFX
         WwP8ueZ9hMpxbrBk6tU+f5rN+MoG9/kkoA7tTYFguA9bXSem+yOg45V1IrlpdEolhTvC
         8iug==
X-Gm-Message-State: APjAAAXSHJZWHOyXn9UQ2rfeWr8/GWlToD5GII00Uf5FogzzW4dotMQN
        F8XtDSmtSsHNCFXEcwJNvPs=
X-Google-Smtp-Source: APXvYqyqf4cs4sdUWZYhyzlrTrejioOnyZbFQaz3xIxSECSmG+mYnvaSn6hF5gbsy7hqUn8pQRg4wQ==
X-Received: by 2002:a63:31d0:: with SMTP id x199mr5632083pgx.228.1571336520575;
        Thu, 17 Oct 2019 11:22:00 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:c786:d9fd:ab91:6283])
        by smtp.gmail.com with ESMTPSA id p24sm6174603pgc.72.2019.10.17.11.21.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 11:21:59 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        "John W . Linville" <linville@tuxdriver.com>
Cc:     netdev@vger.kernel.org
Subject: [PATCH 18/33] fix unused parameter warning in fec_8xx_dump_regs()
Date:   Thu, 17 Oct 2019 11:21:06 -0700
Message-Id: <20191017182121.103569-18-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.23.0.866.gb869b98d4c-goog
In-Reply-To: <20191017182121.103569-1-zenczykowski@gmail.com>
References: <CAHo-Ooze4yTO_yeimV-XSD=AXvvd0BmbKdvUK4bKWN=+LXirYQ@mail.gmail.com>
 <20191017182121.103569-1-zenczykowski@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

This fixes:
  external/ethtool/fec_8xx.c:50:47: error: unused parameter 'info' [-Werror,-Wunused-parameter]
  int fec_8xx_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs)

Signed-off-by: Maciej Żenczykowski <maze@google.com>
Change-Id: Iefd61cf2b89804fab8ca6c845196706684ddd45e
---
 fec_8xx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fec_8xx.c b/fec_8xx.c
index 69db8c8..02ecaef 100644
--- a/fec_8xx.c
+++ b/fec_8xx.c
@@ -47,7 +47,8 @@ struct fec {
 				(unsigned long)(offsetof(struct fec, x)), \
 				#x, f->x)
 
-int fec_8xx_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs)
+int fec_8xx_dump_regs(struct ethtool_drvinfo *info maybe_unused,
+		      struct ethtool_regs *regs)
 {
 	struct fec *f = (struct fec *)regs->data;
 
-- 
2.23.0.866.gb869b98d4c-goog

