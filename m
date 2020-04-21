Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7544D1B2132
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 10:15:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728123AbgDUIPZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 04:15:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726013AbgDUIPY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 04:15:24 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34FCEC061A0F;
        Tue, 21 Apr 2020 01:15:23 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id t9so1060338pjw.0;
        Tue, 21 Apr 2020 01:15:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zVQPuvs+ga9V2QoaefAziadkD0funnQyJCSSfTN7M/w=;
        b=UzJPXsdk7kQ/O0ZqsPEMG8XAzUTdYzy24rrQFvvOROb2WcE2WcfmqyGy8mB4iIsOsc
         mpG16aYxWahFsQQLGBeSJ1Zk4I1ppqH14e8F+P5yE5KGPNpivo2mhyPORYC/Wdmg4NhD
         b93hg6KsphNylEPRtxkLywO8Dgt8Zsq21YFgaYESBzUOPjZjA/iGTD4bUYuZ5/pTcXTp
         cfLciu9h2MQrmM0OYBHCbfDTAWA8jUXkEuGLIVHN05EeqpWnSCxaiJfwE62TQke13UH1
         Rt9fWBR70YA7CmHuvX4z0ggXEbF2Rm5UUWZkYf43QDrace5qCk8eX7Ly/N9gG54q449b
         S+rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zVQPuvs+ga9V2QoaefAziadkD0funnQyJCSSfTN7M/w=;
        b=sVzw9WE9c219EuWqPu14Njv1hZ5ZWBRonh79aDt5Z5CZjz0nakMhdwOohFzMynjfrd
         eD5DgF2LIVfRX+fnViqJb0oyZ91pKx3onMF86upkf7wypkMYM0osBWTdybWWUn5yG5mN
         17e4kPKMpqt29L3FlK5Lc3NJR3hR+MlUrMnile39SzHJK5jnWtA+FFxnHXKtyWbJXnWt
         EXb/wPMnjpE+FcqssTuZ5Wqf5zOgHgjgIBn25L8lbVJsgRHwpS6bIg6KWLw8BBpNiyYw
         eDNrTH0qGsj7BBiV1iqPC3kcibkmSF704e6phaNpVLZJHBcN83o24LL/A5wt/guwR9um
         0ieg==
X-Gm-Message-State: AGi0PuY0qiHsDtCHuAJT2tlPvWwOztkJ8XtLf8hqrMDLVEMeZ8eAGVxH
        wniLD3Ji7y3uPTwIz3ZtbYA=
X-Google-Smtp-Source: APiQypKLrA+0AdFwZE5EJ//bVWYg18MOFdtsc+xTbqWSV5eP4qpA7Hec59TVcz/suj2HbSOaxU1NiQ==
X-Received: by 2002:a17:90b:3018:: with SMTP id hg24mr4345861pjb.130.1587456922557;
        Tue, 21 Apr 2020 01:15:22 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:c786:d9fd:ab91:6283])
        by smtp.gmail.com with ESMTPSA id f99sm1731133pjg.22.2020.04.21.01.15.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 01:15:21 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>
Subject: [PATCH] libipt_ULOG.c - include strings.h for the definition of ffs()
Date:   Tue, 21 Apr 2020 01:15:07 -0700
Message-Id: <20200421081507.108023-1-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.26.1.301.g55bc3eb7cb9-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

This resolves compiler warnings:

extensions/libext4_srcs/gen/gensrcs/external/iptables/extensions/libipt_ULOG.c:89:32: error: implicit declaration of function 'ffs' is invalid in C99 [-Werror,-Wimplicit-function-declaration]
  printf(" --ulog-nlgroup %d", ffs(loginfo->nl_group));
                               ^
extensions/libext4_srcs/gen/gensrcs/external/iptables/extensions/libipt_ULOG.c:105:9: error: implicit declaration of function 'ffs' is invalid in C99 [-Werror,-Wimplicit-function-declaration]
  ffs(loginfo->nl_group));
  ^

Test: builds with less warnings
Signed-off-by: Maciej Żenczykowski <maze@google.com>
---
 extensions/libipt_ULOG.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/extensions/libipt_ULOG.c b/extensions/libipt_ULOG.c
index fafb220b..5163eea3 100644
--- a/extensions/libipt_ULOG.c
+++ b/extensions/libipt_ULOG.c
@@ -11,6 +11,7 @@
  */
 #include <stdio.h>
 #include <string.h>
+#include <strings.h>
 #include <xtables.h>
 /* For 64bit kernel / 32bit userspace */
 #include <linux/netfilter_ipv4/ipt_ULOG.h>
-- 
2.26.1.301.g55bc3eb7cb9-goog

