Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D75C92A2CB4
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 15:25:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726053AbgKBOYt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 09:24:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726366AbgKBOYj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 09:24:39 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E155BC0617A6;
        Mon,  2 Nov 2020 06:24:38 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id a200so11226933pfa.10;
        Mon, 02 Nov 2020 06:24:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WSOubX35enZzF+yjGfPIE2Q+g0AGYASa3BDpwq7MYJ4=;
        b=bWyWwnQm2EfjR6LukMJ3EILB+QqJuGH3FSpE85BSg12ipGL7dFFaYFcTfKH+4NqgQC
         Ejedvs4xBDI2TzlpcOBN2CKfMm++FXCMKCQvl9drYS12OUMQyNkCv8QnUIMz4oJ0VvXi
         7NWzNlhDIvF53dbukupWL20af5vdrt8imqjBt4dcnbgtty584R8r3Um6B2h2Lp4QjPzi
         vGM1CfOgRs3RJ1B3clWAP2jrEbXIHBk4ejR4gBd48lDUsQe6p3maxonNys579Q+F04ly
         LHGnB//3XFPxPTBS06dMlz0La0scQgtt9lZ0OVf2XjLebzF2/GIq6aUOUC5+bbHs9JIo
         mAew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WSOubX35enZzF+yjGfPIE2Q+g0AGYASa3BDpwq7MYJ4=;
        b=a668wdxpnjGjJ1zcXAiJAFCfmSsax11hGSVOIj+mi8XfNa9jlsYTx7RqtDyE8yZg6y
         M3QbhjfbMjmC6Psb9eG6XzfFneIyraevfO30uT/JPXQdVo8BZIvborVVE1ZQbBliJAXQ
         vfBgVVV0BRgusqd4KK2JdUzZ+RNWTVLhxZIO/zA9DnpFjruO/ROIwDliAA2Bq7Zwxglm
         NuERJxrakqRXVs9EJ9AeuY/IaDw0Lji723I3DRjLhSGkKwyibSQ2Gjau64JY9vFbJUCK
         wnUMLcZKfe31LEx1uL73palgpkEu0NTxJ4lBZuW1hqY51GzRIrjnIustz0BkFHcq3oVg
         uJAQ==
X-Gm-Message-State: AOAM53108BV7PLrepmHQXIbOp4IfTXrxYeK9dKrBysKrn2rkZi0GJuO0
        tDVvNSnE99KyN4bJhgqmtrs=
X-Google-Smtp-Source: ABdhPJwGdyAw93JFhDfWZG58oOkjju5Ya20TSkAWdMHObkecatzOZ8bOxhSM3h0zCOi3c55ZeCGP3Q==
X-Received: by 2002:a62:1b58:0:b029:18a:df98:24fa with SMTP id b85-20020a621b580000b029018adf9824famr6915372pfb.25.1604327078217;
        Mon, 02 Nov 2020 06:24:38 -0800 (PST)
Received: from localhost.localdomain ([154.93.3.113])
        by smtp.gmail.com with ESMTPSA id z5sm12366012pjr.22.2020.11.02.06.24.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 06:24:37 -0800 (PST)
From:   Menglong Dong <menglong8.dong@gmail.com>
To:     davem@davemloft.net
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Menglong Dong <dong.menglong@zte.com.cn>
Subject: [PATCH] net: ipv6: remove redundant blank in ip6_frags_ns_sysctl_register
Date:   Mon,  2 Nov 2020 22:24:03 +0800
Message-Id: <20201102142403.4063-1-menglong8.dong@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <dong.menglong@zte.com.cn>

This blank seems redundant.

Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>
---
 net/ipv6/reassembly.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/ipv6/reassembly.c b/net/ipv6/reassembly.c
index 1f5d4d196dcc..b1b8d104063b 100644
--- a/net/ipv6/reassembly.c
+++ b/net/ipv6/reassembly.c
@@ -437,7 +437,6 @@ static int __net_init ip6_frags_ns_sysctl_register(struct net *net)
 		table = kmemdup(table, sizeof(ip6_frags_ns_ctl_table), GFP_KERNEL);
 		if (!table)
 			goto err_alloc;
-
 	}
 	table[0].data	= &net->ipv6.fqdir->high_thresh;
 	table[0].extra1	= &net->ipv6.fqdir->low_thresh;
-- 
2.28.0

