Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB83530AE4B
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 18:46:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231134AbhBARqA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 12:46:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38834 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231280AbhBARpl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 12:45:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612201454;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=5CQouvwXL1+OlI6kilnJbl1lJaKIxU/jbazBDfnUguU=;
        b=Z8/CW5uONrZs6YZCYgTMCM3b1regm+GyN416Q/nQ8H2sV0vZmroKJFn/h0OFfBQIBzlwCF
        8TMX12h/9+a7EOHfwzHzrjaq1yBQsEzS7J4gZaXu8878ocwjD4F/gxhzsh7IsaOXli+cSW
        sX+Pjo+2T5pq/+LlRNbzQzEHzavAmpM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-473-Zv5nYTy_NMmlp6e6VYbBOw-1; Mon, 01 Feb 2021 12:44:12 -0500
X-MC-Unique: Zv5nYTy_NMmlp6e6VYbBOw-1
Received: by mail-wr1-f71.google.com with SMTP id l10so10827078wry.16
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 09:44:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=5CQouvwXL1+OlI6kilnJbl1lJaKIxU/jbazBDfnUguU=;
        b=MHWrfdflHW663yqiMhlzvTmAuwlNZnowFcxuYOhj3Bm4nsI2rkVZQfpvj677fPgtFT
         Rqo323Bdape+ZqpspzVMSCMU3ZvRkZYFuWy1fp4BItxzCJ87Qf3k+LMofkd60+LkLGYx
         HrHx1sFgNv5AQcKyztGFeCfFAfR7MRTrDqOpNy2WZMOxtNlLDQEozpxcgRwhg4jdykoz
         D35vLWVf9bnKwOROi6/ifbDctLYefVr1m9X2XyWaOceR1/gfv+IB/CvOzyUiRuFMP6h1
         meQwpI9MPbykTQaW/Hk/tJjJbjQHM6811jlblQRZ4nGol2YSXxO4bPYLqRrpxOlM4pBf
         Lj1A==
X-Gm-Message-State: AOAM530WtPGTmcqsqFUb0MeKumg+BQcAlrZVdGUKrLFe9Q4dB26gvn4Q
        UO56Kb+osHxzmtnVki5E+ls0os+ZsiNIfflRRxNpjZUqutAxwjOLXom/EyJiEX1hqRmEMPQXgrD
        pxkEgZSxzZ67dv3JH
X-Received: by 2002:a1c:f417:: with SMTP id z23mr2220wma.29.1612201451384;
        Mon, 01 Feb 2021 09:44:11 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx9m8F9p+sGqZ6Fxzga331GqDdam9wnXqb5JnV6x7MMM1Ychyl2FYb/5LRsVHLfM5eYf30V7A==
X-Received: by 2002:a1c:f417:: with SMTP id z23mr2201wma.29.1612201451180;
        Mon, 01 Feb 2021 09:44:11 -0800 (PST)
Received: from linux.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id l14sm27353603wrq.87.2021.02.01.09.44.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 09:44:10 -0800 (PST)
Date:   Mon, 1 Feb 2021 18:44:07 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
Subject: [PATCH v2 iproute2] iplink_bareudp: cleanup help message and man page
Message-ID: <f03210e3683cf99c58ed847a6abbe48eb021479d.1612201006.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 * Fix PROTO description in help message (mpls isn't a valid argument).

 * Remove SRCPORTMIN description from help message since it doesn't
   appear in the syntax string.

 * Use same keywords in help message and in man page.

 * Use the "ethertype" option name (.B ethertype) rather than the
   option value (.I ETHERTYPE) in the man page description of
   [no]multiproto.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
No changes since v1.
Reposting since v1 appears neither in lore.kernel.org nor in patchwork.

 ip/iplink_bareudp.c   |  8 +++++---
 man/man8/ip-link.8.in | 15 +++++++++------
 2 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/ip/iplink_bareudp.c b/ip/iplink_bareudp.c
index 860ec699..aa311106 100644
--- a/ip/iplink_bareudp.c
+++ b/ip/iplink_bareudp.c
@@ -22,9 +22,11 @@ static void print_explain(FILE *f)
 		"		[ srcportmin PORT ]\n"
 		"		[ [no]multiproto ]\n"
 		"\n"
-		"Where:	PORT       := 0-65535\n"
-		"	PROTO      := NUMBER | ip | mpls\n"
-		"	SRCPORTMIN := 0-65535\n"
+		"Where:	PORT  := UDP_PORT\n"
+		"	PROTO := ETHERTYPE\n"
+		"\n"
+		"Note: ETHERTYPE can be given as number or as protocol name (\"ipv4\", \"ipv6\",\n"
+		"      \"mpls_uc\", etc.).\n"
 	);
 }
 
diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
index 3516765a..fd67e611 100644
--- a/man/man8/ip-link.8.in
+++ b/man/man8/ip-link.8.in
@@ -1307,9 +1307,9 @@ For a link of type
 the following additional arguments are supported:
 
 .BI "ip link add " DEVICE
-.BI type " bareudp " dstport " PORT " ethertype " ETHERTYPE"
+.BI type " bareudp " dstport " PORT " ethertype " PROTO"
 [
-.BI srcportmin " SRCPORTMIN "
+.BI srcportmin " PORT "
 ] [
 .RB [ no ] multiproto
 ]
@@ -1320,11 +1320,14 @@ the following additional arguments are supported:
 - specifies the destination port for the UDP tunnel.
 
 .sp
-.BI ethertype " ETHERTYPE"
+.BI ethertype " PROTO"
 - specifies the ethertype of the L3 protocol being tunnelled.
+.B ethertype
+can be given as plain Ethernet protocol number or using the protocol name
+("ipv4", "ipv6", "mpls_uc", etc.).
 
 .sp
-.BI srcportmin " SRCPORTMIN"
+.BI srcportmin " PORT"
 - selects the lowest value of the UDP tunnel source port range.
 
 .sp
@@ -1332,11 +1335,11 @@ the following additional arguments are supported:
 - activates support for protocols similar to the one
 .RB "specified by " ethertype .
 When
-.I ETHERTYPE
+.B ethertype
 is "mpls_uc" (that is, unicast MPLS), this allows the tunnel to also handle
 multicast MPLS.
 When
-.I ETHERTYPE
+.B ethertype
 is "ipv4", this allows the tunnel to also handle IPv6. This option is disabled
 by default.
 
-- 
2.21.3

