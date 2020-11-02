Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 623142A296A
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 12:28:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729044AbgKBL2c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 06:28:32 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45435 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728658AbgKBLYc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 06:24:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604316271;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=VyaF4YL/qkULf4igPbA343vHojdhHjVv1lCzEFqKg0k=;
        b=h+fYrusloWsYfjWCP7Id+Ga/GrtABO24sla5+k1RIEXYO6IHvLbfAU8isvvB9Y/VtPhcrp
        gR54DTDRB1gmK8wwSyf6bj8Phil/Z96J7cjSTc3UA5zFxd8zwN80JjaEofh3i1+KXXB3hJ
        9hDp8wsrYON/VK52qRBWJh7kBuzfcmQ=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-387-OPAJHY3DPAehMxWfAUdGog-1; Mon, 02 Nov 2020 06:24:29 -0500
X-MC-Unique: OPAJHY3DPAehMxWfAUdGog-1
Received: by mail-wr1-f70.google.com with SMTP id f11so6288820wro.15
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 03:24:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=VyaF4YL/qkULf4igPbA343vHojdhHjVv1lCzEFqKg0k=;
        b=NN3WsqaMRrtx9nIVcZSZk4oj3Rdl3pl2tdZHZLGobJYY3+zU1YqunOJp/OFsSL42Xq
         4amLXjXvvHTfdrC5O7Ow7OkAeioEOBTv8BxINTfZ6xXX3YlGrnBtrkEBMHB3sMVUy7TG
         Q71XamlodHFT7Sp7Z+cxrWNlW8EF0/ehOvqpBlqzZiOPUIYDwkKAxj3NxXy+1AMqk2JT
         LBbhNTlx62OQ6PchhBuQw6RaR3E2OFW/ADliFVOBirha7B4ZbJyrH6IVdkGgJe6Ay/0k
         BPT/p6x3OISd3C4s0y0fnnauChPnCdbjlQwudiL1RcaAqDKc3mqLH3zRdD49qmZvDfo8
         eiGQ==
X-Gm-Message-State: AOAM530fRCk+jUFP8DoK9Nc8QoGwU0/bCQMxVwpV/4bKfTfe7o58oc4V
        IhN6Wta0D3Owlo13NhiXh7/P3F29551yqZfBF9nmASYNOusrISSDhti29O7SckNQbXetLj4jEHH
        SEHh//iuaNKd4LBqd
X-Received: by 2002:a5d:54c1:: with SMTP id x1mr20743706wrv.172.1604316267979;
        Mon, 02 Nov 2020 03:24:27 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxX7v2H5bXLWIhyMrz50dKJMuhV9Bo1RRTXFDuCQoVpHI2Vrd/NysiyZGMQJQStYB1+MWh2uQ==
X-Received: by 2002:a5d:54c1:: with SMTP id x1mr20743688wrv.172.1604316267857;
        Mon, 02 Nov 2020 03:24:27 -0800 (PST)
Received: from linux.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id h4sm21749090wrp.52.2020.11.02.03.24.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 03:24:27 -0800 (PST)
Date:   Mon, 2 Nov 2020 12:24:25 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
Subject: [PATCH iproute2] tc-mpls: fix manpage example and help message string
Message-ID: <ef7eb4cdf9075eaa9b45baca994ff0d2021e9719.1604316228.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Manpage:
 * Remove the extra "and to ip packets" part from command description
   to make it more understandable.

 * Redirect packets to eth1, instead of eth0, as told in the
   description.

Help string:
 * "mpls pop" can be followed by a CONTROL keyword.

 * "mpls modify" can also set the MPLS_BOS field.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 man/man8/tc-mpls.8 | 6 +++---
 tc/m_mpls.c        | 5 +++--
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/man/man8/tc-mpls.8 b/man/man8/tc-mpls.8
index 9e563e98..7f8be221 100644
--- a/man/man8/tc-mpls.8
+++ b/man/man8/tc-mpls.8
@@ -147,15 +147,15 @@ a label 123 and sends them out eth1:
 .EE
 .RE
 
-In this example, incoming MPLS unicast packets on eth0 are decapsulated and to
-ip packets and output to eth1:
+In this example, incoming MPLS unicast packets on eth0 are decapsulated
+and redirected to eth1:
 
 .RS
 .EX
 #tc qdisc add dev eth0 handle ffff: ingress
 #tc filter add dev eth0 protocol mpls_uc parent ffff: flower \\
 	action mpls pop protocol ipv4  \\
-	action mirred egress redirect dev eth0
+	action mirred egress redirect dev eth1
 .EE
 .RE
 
diff --git a/tc/m_mpls.c b/tc/m_mpls.c
index 2c3752ba..9fee22e3 100644
--- a/tc/m_mpls.c
+++ b/tc/m_mpls.c
@@ -23,12 +23,13 @@ static const char * const action_names[] = {
 static void explain(void)
 {
 	fprintf(stderr,
-		"Usage: mpls pop [ protocol MPLS_PROTO ]\n"
+		"Usage: mpls pop [ protocol MPLS_PROTO ] [CONTROL]\n"
 		"       mpls push [ protocol MPLS_PROTO ] [ label MPLS_LABEL ] [ tc MPLS_TC ]\n"
 		"                 [ ttl MPLS_TTL ] [ bos MPLS_BOS ] [CONTROL]\n"
 		"       mpls mac_push [ protocol MPLS_PROTO ] [ label MPLS_LABEL ] [ tc MPLS_TC ]\n"
 		"                     [ ttl MPLS_TTL ] [ bos MPLS_BOS ] [CONTROL]\n"
-		"       mpls modify [ label MPLS_LABEL ] [ tc MPLS_TC ] [ ttl MPLS_TTL ] [CONTROL]\n"
+		"       mpls modify [ label MPLS_LABEL ] [ tc MPLS_TC ] [ ttl MPLS_TTL ]\n"
+		"                   [ bos MPLS_BOS ] [CONTROL]\n"
 		"           for pop, MPLS_PROTO is next header of packet - e.g. ip or mpls_uc\n"
 		"           for push and mac_push, MPLS_PROTO is one of mpls_uc or mpls_mc\n"
 		"               with default: mpls_uc\n"
-- 
2.21.3

