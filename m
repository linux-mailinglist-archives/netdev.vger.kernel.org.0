Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49F763978CB
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 19:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234539AbhFARLU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 13:11:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42157 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233853AbhFARLT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 13:11:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622567376;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=oJi3oxvhb0RidGeXBLXpbsWf65M1X1ad5JiF2Uexv60=;
        b=ELuRIRDRBuYAUaN+99X+MDBrRZxNdWotGPPnSPv14JD9FHB0ZxvuzIs05clxFvue5t8Mjl
        a1KHs8NP0Xy+jyTC5Jjk6R4fV0xQnEyWstEXd4h3tgA5Jmzwz4LRZ/YzB7tWM49RgvqgI6
        tYHjgPRxyzpAu48MCdi93Kum4sonlRo=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-414-Joo1k5FfPE-e1WEcnFRpdg-1; Tue, 01 Jun 2021 13:09:35 -0400
X-MC-Unique: Joo1k5FfPE-e1WEcnFRpdg-1
Received: by mail-wm1-f71.google.com with SMTP id n20-20020a05600c4f94b029017f371265feso1310752wmq.5
        for <netdev@vger.kernel.org>; Tue, 01 Jun 2021 10:09:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=oJi3oxvhb0RidGeXBLXpbsWf65M1X1ad5JiF2Uexv60=;
        b=dE4cvzEDa9n/5NvkVU4Jes/iGxfq/FuuByOU8+QwkpXnztbtfdOPnqw3M0kkL9i6RX
         GdXxz+iUakfztbeO0mYzqqYgfPVmGS0pLZHdJPDX23w/sl8d1eGWWXBbNxUDs/W1G7DN
         IZ/wevA248UjVCVAvC6+/oIxMb7otRpX0+iz8o1D2kFPboNQwR30N8nuUHQrdDrDs1T7
         B7oC2J0AKx8i4wpj6sLCWSx5KzCcp76DUfszLvoGD0a/VT/tP1jNCBNLQJdQHk+AgMM9
         Y2m21XTPFwktbyrh3Sf3l40GRIXdkQJE40nlZw22dsgWTZqP1ZtrfTrfhGg3+pHHxk6N
         4R4w==
X-Gm-Message-State: AOAM532BAGTkrpd7qvjUZCFri8Qbj03aiooRVJ+GV1flerbiBTwrVCjf
        80CVsDDWFO6Cws67O5khC2HgOtKfXt3uKyvBQRZNa/ymHKEA/miPuR4Drc2T5mNjZ4RT7/4DN0V
        JZqzz7sxnxo+czVOG
X-Received: by 2002:adf:efc9:: with SMTP id i9mr12528565wrp.152.1622567374003;
        Tue, 01 Jun 2021 10:09:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzmlRj/G67Ck43luILto+/sn1d2zYe7/B/OqUBZkXEQS/l5Sj1twspaP1PbYOXO/fZiSescCw==
X-Received: by 2002:adf:efc9:: with SMTP id i9mr12528551wrp.152.1622567373770;
        Tue, 01 Jun 2021 10:09:33 -0700 (PDT)
Received: from linux.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id t14sm3763976wra.60.2021.06.01.10.09.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jun 2021 10:09:33 -0700 (PDT)
Date:   Tue, 1 Jun 2021 19:09:31 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
Subject: [PATCH iproute2] utils: bump max args number to 256 for batch files
Message-ID: <4a0fcf72130d3ef5c4ca91b518f66ac6449cf57f.1622565590.git.gnault@redhat.com>
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

Let's bump the limit to the next power of 2. That should leave a lot of
room for big batch commands.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---

Note: I have no production use case for MPLS stacks with 7 LSEs at the
      moment, but 7 is the maximum depth the flow dissector can handle,
      and having the possibility to express such rules with tc -batch
      would help testing the kernel API (writing scripts that generate
      filters, without worrying about the 100 parameters limit).

 lib/utils.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/utils.c b/lib/utils.c
index 93ae0c55..d5496e45 100644
--- a/lib/utils.c
+++ b/lib/utils.c
@@ -1714,10 +1714,10 @@ int do_batch(const char *name, bool force,
 
 	cmdlineno = 0;
 	while (getcmdline(&line, &len, stdin) != -1) {
-		char *largv[100];
+		char *largv[256];
 		int largc;
 
-		largc = makeargs(line, largv, 100);
+		largc = makeargs(line, largv, 256);
 		if (!largc)
 			continue;	/* blank line */
 
-- 
2.21.3

