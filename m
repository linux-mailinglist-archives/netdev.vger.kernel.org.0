Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77058601439
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 19:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229909AbiJQRD5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 13:03:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbiJQRDq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 13:03:46 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 654436FA1B
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 10:03:45 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id j16so19424543wrh.5
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 10:03:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ItWaB1pUuIxheAsm0NyjIiuci7ngtIPPBIPfJeZ0vZg=;
        b=c+IyaSMQ5wpRgSj5Yj6NmMchM2uGEutJdgWEQ6/rjcpA4p5JH5TbSRvYKg0fNzV0nz
         5bYyLu5UZGEXTgPc7o+bAmvorKUEEK7Fu+8CUDWENJTE6ZXmfZVJhADNW66EID91D+TP
         GOyUYVaTdqvyuk4J1hIQO4DD8xx62oSlDn/I5ODNOO17q6zz3wwe7TbuJjUG98ke1WwA
         kYVqReCWQamQHklpWuYiqCGymbgSCAQgmW9t2RoycCd3OO2qfkPdfZU5i47ahZ99E7Pt
         khjo3gMW3jLh5eq79rvui/WvPdB6djBWvZd4Z09en6BrafKW4OVXLXP6SxNvh6dJx6z1
         nVhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ItWaB1pUuIxheAsm0NyjIiuci7ngtIPPBIPfJeZ0vZg=;
        b=2UEdMSnLKNLv3gFIcfRnuI9PIT/4zXIesr065h7ZQUEcrr9LTHPx5VN8b86dxAK6Sj
         vpudUrllCRnexzo/vGUTwuLDaf6539e58wz3e2fwyW7VfAMWlj1iSzQo/GyOpRCjxCxc
         dUT81WcfL3X1Zz3aLUInz4LZIl/J1Xf8LR2SaSCaJ+8cRE+QaCGnrjuiab4pW0snUOPU
         pCsaQYpZ5BeTBLN/5CYS+MuSKqWKXp42Y8Vl8rbJF7J8xqt27zNv2ae++bdwhPvPgbuj
         eSUF9ALcJ3+aUt30NRlqgZDHU3q+yhFh9wjsXdxQrQmeV+9O5piAR2TPaguo3MPa1CVF
         RPVA==
X-Gm-Message-State: ACrzQf29Kpt1bfEGrv/+DB7B18HDl+2b6ttFhcpgsxBSxWLiGgffYtFg
        zDYEijkM2qIZA7DkRC7uSDngcw==
X-Google-Smtp-Source: AMsMyM7w09pEDQMVhaALfvXqydMqk4dsKcEvNSmYBLBzbBNqtGI5UxxlIpfwhGrNuJgogK/4bsAYjA==
X-Received: by 2002:adf:f40e:0:b0:22e:2ce4:e6a2 with SMTP id g14-20020adff40e000000b0022e2ce4e6a2mr7307838wro.30.1666026223537;
        Mon, 17 Oct 2022 10:03:43 -0700 (PDT)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id w16-20020adf8bd0000000b0022f40a2d06esm9079196wra.35.2022.10.17.10.03.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Oct 2022 10:03:41 -0700 (PDT)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: [PATCH iproute2 3/4] ss: usage: add missing parameters
Date:   Mon, 17 Oct 2022 19:03:07 +0200
Message-Id: <20221017170308.1280537-4-matthieu.baerts@tessares.net>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221017170308.1280537-1-matthieu.baerts@tessares.net>
References: <20221017170308.1280537-1-matthieu.baerts@tessares.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These query entries were in the man page but not in 'ss -h':

- packet_raw
- packet_dgram
- dccp
- sctp
- xdp (+ the --xdp option)

I only created one commit with all: this fixes multiple commits but all
on the same line.

The only exception is with '--xdp' parameter which is linked to
commit 2abc3d76 ("ss: add AF_XDP support").

Fixes: aba5acdf ("(Logical change 1.3)") # packet raw/dgram
Fixes: 351efcde ("Update header files to 2.6.14") # dccp
Fixes: f89d46ad ("ss: Add support for SCTP protocol") # sctp
Fixes: 2abc3d76 ("ss: add AF_XDP support") # xdp
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
I can also split this in 4 small patches if you prefer.

 misc/ss.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/misc/ss.c b/misc/ss.c
index 1c82352d..bf891a58 100644
--- a/misc/ss.c
+++ b/misc/ss.c
@@ -5373,6 +5373,7 @@ static void _usage(FILE *dest)
 "   -x, --unix          display only Unix domain sockets\n"
 "       --tipc          display only TIPC sockets\n"
 "       --vsock         display only vsock sockets\n"
+"       --xdp           display only XDP sockets\n"
 "   -f, --family=FAMILY display sockets of type FAMILY\n"
 "       FAMILY := {inet|inet6|link|unix|netlink|vsock|tipc|xdp|help}\n"
 "\n"
@@ -5382,7 +5383,7 @@ static void _usage(FILE *dest)
 "       --inet-sockopt  show various inet socket options\n"
 "\n"
 "   -A, --query=QUERY, --socket=QUERY\n"
-"       QUERY := {all|inet|tcp|mptcp|udp|raw|unix|unix_dgram|unix_stream|unix_seqpacket|packet|netlink|vsock_stream|vsock_dgram|tipc}[,QUERY]\n"
+"       QUERY := {all|inet|tcp|mptcp|udp|raw|unix|unix_dgram|unix_stream|unix_seqpacket|packet|packet_raw|packet_dgram|netlink|dccp|sctp|vsock_stream|vsock_dgram|tipc|xdp}[,QUERY]\n"
 "\n"
 "   -D, --diag=FILE     Dump raw information about TCP sockets to FILE\n"
 "   -F, --filter=FILE   read filter information from FILE\n"
-- 
2.37.2

