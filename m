Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 534723A3F65
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 11:46:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231675AbhFKJsZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 05:48:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28457 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231667AbhFKJsT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 05:48:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623404781;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=8W1J+TU0cjv19I/iMIFpBtiP5oztg/e9Sr662EosMB8=;
        b=goNpmQZbNUGvfsW0aE40bIpdnO3xztTiLhV1i8L+Xt6CxPaKLBs1zyeCpgVmkfOUWeWJIp
        yPWuli7i3o5uBupzUjnkY8ses+k7cZqV/39ZFGulgNtIaoV4r2JznwFHifr88UVu6g0VEG
        4RdGQSTn/zEdXeFkqetK6uYn6nMlcPE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-198-yGCdOSgRNwmSr5-ddR2HMg-1; Fri, 11 Jun 2021 05:46:20 -0400
X-MC-Unique: yGCdOSgRNwmSr5-ddR2HMg-1
Received: by mail-wm1-f72.google.com with SMTP id j6-20020a05600c1906b029019e9c982271so5269367wmq.0
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 02:46:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=8W1J+TU0cjv19I/iMIFpBtiP5oztg/e9Sr662EosMB8=;
        b=GD6FiY0rBMxF4PVDoT4DP+4lkJ6yU01o3TJjQGPvzRXh+9XngjYNnTndgPgG1iHuxX
         lKKO8uyEp3rPrE2K44tVzUTNP+HMFLGD8oxNaW0JlHVaunqKnt6MuToGOE4SOZMs+l1Q
         r+rVtsgPU5jP6LAXi/9SlAbnpepjRSgb0nk7D0zbTwvcAk6zC5gshO68RTaaLixz+hDr
         M30RsvWkjDcp0/Z9nMfDbfyVLQJb2MItOfv7YPxRWMh59kpIyiYaz2X2wCIKfm2MkQDM
         5GiDOmCWHPkz3hTWzLewUgK0i2DVLmDQhEDTxKiKd//03CnHATLUoTOYhvr3SLaO/M14
         pH2w==
X-Gm-Message-State: AOAM531d/xX94Jz6znI8YlwZtM3yk/ubE8KNxpWAsPMzLXkOe+3+YMK/
        I52tB9o9efwAM5OmKUoHfvB0vnui4gptBIkRlWiLmvs7fh8cxOKpL21Y8/i2auwl53TD2SfARIr
        CVIK9m4ovNdNne3lX
X-Received: by 2002:adf:ee52:: with SMTP id w18mr3065705wro.37.1623404778849;
        Fri, 11 Jun 2021 02:46:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzq/B3F9TXOx1yo4Y572vS37KN8dEqEZXDt4TmrpIlUGcjtKrLP9pBdRgBNSVxLhI4nuEFw5g==
X-Received: by 2002:adf:ee52:: with SMTP id w18mr3065695wro.37.1623404778646;
        Fri, 11 Jun 2021 02:46:18 -0700 (PDT)
Received: from linux.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id u7sm7624588wrt.18.2021.06.11.02.46.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 02:46:18 -0700 (PDT)
Date:   Fri, 11 Jun 2021 11:46:16 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
Subject: [PATCH v2 iproute2] utils: bump max args number to 512 for batch
 files
Message-ID: <e2bf7f7890e2da1a3bda08ef69f2685aba560561.1623404496.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Large tc filters can have many arguments. For example the following
filter matches the first 7 MPLS LSEs, pops all of them, then updates
the Ethernet header and redirects the resulting packet to eth1.

filter add dev eth0 ingress handle 44 priority 100 \
  protocol mpls_uc flower mpls                     \
    lse depth 1 label 1040076 tc 4 bos 0 ttl 175   \
    lse depth 2 label 89648 tc 2 bos 0 ttl 9       \
    lse depth 3 label 63417 tc 5 bos 0 ttl 185     \
    lse depth 4 label 593135 tc 5 bos 0 ttl 67     \
    lse depth 5 label 857021 tc 0 bos 0 ttl 181    \
    lse depth 6 label 239239 tc 1 bos 0 ttl 254    \
    lse depth 7 label 30 tc 7 bos 1 ttl 237        \
  action mpls pop protocol mpls_uc pipe            \
  action mpls pop protocol mpls_uc pipe            \
  action mpls pop protocol mpls_uc pipe            \
  action mpls pop protocol mpls_uc pipe            \
  action mpls pop protocol mpls_uc pipe            \
  action mpls pop protocol mpls_uc pipe            \
  action mpls pop protocol ipv6 pipe               \
  action vlan pop_eth pipe                         \
  action vlan push_eth                             \
    dst_mac 00:00:5e:00:53:7e                      \
    src_mac 00:00:5e:00:53:03 pipe                 \
  action mirred egress redirect dev eth1

This filter has 149 arguments, so it can't be used with tc -batch
which is limited to a 100.

Let's bump the limit to 512. That should leave a lot of room for big
batch commands.

v2:
   -Define the limit in utils.h (Stephen Hemminger)
   -Bump the limit even higher (256 -> 512) (Stephen Hemminger)

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 include/utils.h | 3 +++
 lib/utils.c     | 4 ++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/utils.h b/include/utils.h
index 187444d5..5f5d8fa0 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -50,6 +50,9 @@ void incomplete_command(void) __attribute__((noreturn));
 #define NEXT_ARG_FWD() do { argv++; argc--; } while(0)
 #define PREV_ARG() do { argv--; argc++; } while(0)
 
+/* Upper limit for batch mode */
+#define MAX_ARGS 512
+
 #define TIME_UNITS_PER_SEC	1000000
 #define NSEC_PER_USEC 1000
 #define NSEC_PER_MSEC 1000000
diff --git a/lib/utils.c b/lib/utils.c
index 93ae0c55..0559923b 100644
--- a/lib/utils.c
+++ b/lib/utils.c
@@ -1714,10 +1714,10 @@ int do_batch(const char *name, bool force,
 
 	cmdlineno = 0;
 	while (getcmdline(&line, &len, stdin) != -1) {
-		char *largv[100];
+		char *largv[MAX_ARGS];
 		int largc;
 
-		largc = makeargs(line, largv, 100);
+		largc = makeargs(line, largv, MAX_ARGS);
 		if (!largc)
 			continue;	/* blank line */
 
-- 
2.21.3

