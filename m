Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA010650A9
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 05:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727989AbfGKDkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 23:40:19 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:34891 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725977AbfGKDkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 23:40:19 -0400
Received: by mail-pg1-f193.google.com with SMTP id s27so2226249pgl.2;
        Wed, 10 Jul 2019 20:40:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=M8wX1u1AyY8aIZh85CrgBQrNgkI4YoDiE4Y/ARBtWTI=;
        b=MQSWRWsAWJYvODOaMa5S5WYGn5WyApLDP13/bq1J3buPbjvqYJk04y5+eL1GBCPaEY
         VxMNOWWX/W8DqqO0Cycuruwb36aIFFnuV+tscB1DRqRuS9BkZh1rUkwn2yyJgDkC+pDu
         kx7fMeiWEn4hBGCAR+IMyee/am4cZRsk4uXbhxS7Yj6ONNrCqsd2KD+JtV7wkWRtueJj
         lwzKDnD6v1FnSawOO7c0h3P3kxy554wDZGoIiFrnWjoayKHK/WHfy5j+97z+IXEwhlO6
         HsYmw+95wRiHg6gkWWwdZL9X+7cHT6pmJwCjust5djfhvzIufdEyFICSR8cnVqESD0cd
         NgAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=M8wX1u1AyY8aIZh85CrgBQrNgkI4YoDiE4Y/ARBtWTI=;
        b=S3tfGs3UlbGzzDeXlaVJbweFYPahR6qjEcods5F+0kf9giTjCvCZazVsjKlGUtjaqc
         PIbPfoWT2Sw6h/6QOmeYUTWXS1IX/Ct2CvgkmW7g36VDoYBpryoU6yhVo3QNHBRM4v/G
         1N/0htJaWT8/ANLZfvc1x59x3V5pB0tcWop9w4EPIYwFlzYNkbDmZDbSi5FlvWt57O7K
         7ulFI3pUpl/n9o8kyAW7jtBCOpQZ+GTfe7bXZC5kHVhvJlTopSIB4DEatVOjFvciGJvE
         bQ55wkfmEAw3+RKMPtELe4zCvh9vr1ZdJCkD9B978z/tGcn5vbbN8C82fpj85CpSYMGq
         b/5g==
X-Gm-Message-State: APjAAAXaWvmCPRaklGe7HEUYm6cUDPBTK++kUb8IbJZT54BnPDcfOiWZ
        OVj4H0vjym0tOSA0XTsaEHA=
X-Google-Smtp-Source: APXvYqxYR5XW+F/7S+4Zmn+naLYm4I1R/JfSfk5RrKN/ZLUBN1s5HNPr3vy1j6yMf97NWWQce/VQvA==
X-Received: by 2002:a65:6152:: with SMTP id o18mr1869115pgv.279.1562816418283;
        Wed, 10 Jul 2019 20:40:18 -0700 (PDT)
Received: from localhost.localdomain ([116.66.213.65])
        by smtp.gmail.com with ESMTPSA id c130sm3543777pfc.184.2019.07.10.20.40.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 10 Jul 2019 20:40:17 -0700 (PDT)
From:   yangxingwu <xingwu.yang@gmail.com>
To:     wensong@linux-vs.org
Cc:     horms@verge.net.au, ja@ssi.bg, pablo@netfilter.org,
        kadlec@blackhole.kfki.hu, fw@strlen.de, davem@davemloft.net,
        netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org, yangxingwu <xingwu.yang@gmail.com>
Subject: [PATCH] ipvs: remove unnecessary space
Date:   Thu, 11 Jul 2019 11:39:59 +0800
Message-Id: <20190711033959.1593-1-xingwu.yang@gmail.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

this patch removes the extra space and use bitmap_zalloc instead

Signed-off-by: yangxingwu <xingwu.yang@gmail.com>
---
 net/netfilter/ipvs/ip_vs_mh.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_mh.c b/net/netfilter/ipvs/ip_vs_mh.c
index 94d9d34..3229867 100644
--- a/net/netfilter/ipvs/ip_vs_mh.c
+++ b/net/netfilter/ipvs/ip_vs_mh.c
@@ -174,8 +174,7 @@ static int ip_vs_mh_populate(struct ip_vs_mh_state *s,
 		return 0;
 	}
 
-	table =  kcalloc(BITS_TO_LONGS(IP_VS_MH_TAB_SIZE),
-			 sizeof(unsigned long), GFP_KERNEL);
+	table = bitmap_zalloc(IP_VS_MH_TAB_SIZE, GFP_KERNEL);
 	if (!table)
 		return -ENOMEM;
 
-- 
1.8.3.1

