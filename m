Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF2B9410589
	for <lists+netdev@lfdr.de>; Sat, 18 Sep 2021 11:39:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238663AbhIRJkx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Sep 2021 05:40:53 -0400
Received: from smtpbg704.qq.com ([203.205.195.105]:45520 "EHLO
        smtpproxy21.qq.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S238616AbhIRJkr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Sep 2021 05:40:47 -0400
X-QQ-mid: bizesmtp49t1631957955t7u3lz1p
Received: from localhost.localdomain (unknown [111.207.172.18])
        by esmtp6.qq.com (ESMTP) with 
        id ; Sat, 18 Sep 2021 17:39:12 +0800 (CST)
X-QQ-SSF: 0140000000200040C000B00B0000000
X-QQ-FEAT: znfcQSa1hKZ2yEIvNJ2OcqiA7EHuYmeam+NTYSEInx79cqjT3Gtz/bYg6Y+Ie
        PFEXynJjqzamtkIZjsd+kjJq1VIuIlKjp0IGCVYMeHQBV7qbUFld0ci3f1H9+2aLuhhO6wd
        M09mRVfD9Aqb8HTUbBjKQrMnn9zGBKklYvjO+aYbG6hzI5JFw2Rbf5o6asWAbgRw0sf0SpO
        zHjy8Wql28wjDuViPUmmRG64AzNGfhDIaEui6hoQUO2Gg2KoyIKxxEyB1ntSbQ2jfoyXlL9
        kWdEW/GYA5XTTeVG9Llt9NwtJ/6gIJPXEt22XbxRA2ogj2SoT0iJ5116gDzv87Mvpn9rBxj
        lCC8PhA+Mao0J/7Ly4=
X-QQ-GoodBg: 2
From:   wangzhitong <wangzhitong@uniontech.com>
To:     paul@paul-moore.com, davem@davemloft.net, ckuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        wangzhitong <wangzhitong@uniontech.com>
Subject: [PATCH]     NET: IPV4: fix error "do not initialise globals to 0"
Date:   Sat, 18 Sep 2021 17:39:10 +0800
Message-Id: <20210918093910.31127-1-wangzhitong@uniontech.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:uniontech.com:qybgforeign:qybgforeign6
X-QQ-Bgrelay: 1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

    this patch fixes below Errors reported by checkpatch
    ERROR: do not initialise globals to 0
    +int cipso_v4_rbm_optfmt = 0;

Signed-off-by: wangzhitong <wangzhitong@uniontech.com>
---
 net/ipv4/cipso_ipv4.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
index a23094b050f8..6adeb3942c96 100644
--- a/net/ipv4/cipso_ipv4.c
+++ b/net/ipv4/cipso_ipv4.c
@@ -73,7 +73,7 @@ struct cipso_v4_map_cache_entry {
 static struct cipso_v4_map_cache_bkt *cipso_v4_cache;
 
 /* Restricted bitmap (tag #1) flags */
-int cipso_v4_rbm_optfmt = 0;
+int cipso_v4_rbm_optfmt;
 int cipso_v4_rbm_strictvalid = 1;
 
 /*
-- 
2.20.1



