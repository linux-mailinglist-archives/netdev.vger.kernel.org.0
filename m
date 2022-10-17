Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2386060143B
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 19:04:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbiJQRDz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 13:03:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbiJQRDp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 13:03:45 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43D2D70E5F
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 10:03:42 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id f11so19405086wrm.6
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 10:03:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gEoJHvS66JIGsjoazI2M6OaOrNoEypplADfc8cnFGk4=;
        b=80u7DIzeK9daSMhraqqPUAUc3eDN1CAvX0uPF9/kBslaMm9BQ0Sy7m+zrClTNyLALV
         3zeNQObxRSxhHJeoUvM1ez2WIzplGDQLjpFffzwZa3vcWGi0RqPbuck8yqAG8ftcFUXL
         NyMgT1hTPJhS9d2AcdSgHApQaXU/vkxoiWR+UBnq6NGgaqmEQEIS8u0l6q5wGqYdFP7K
         Sg8wduO5B2E0ZkkaYpam0seJoMgmE/mvLUWhhLih8epqL6/olN6lOrK4xcrSQHD3oaXZ
         khWbF3qxKD8NSlLPlFIOhZFzqIMAgfdg0xCK2NBMbyQpnaXiAT/tJqsYLa1yZgwhLAd0
         0V2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gEoJHvS66JIGsjoazI2M6OaOrNoEypplADfc8cnFGk4=;
        b=Nn5cwnQ1qbt1BuS+E43fdK81kDy62/zhZG5OE+9nQt/QIMT4IDyJaQlsAoyc5EDF9J
         Ed0hJ9tQX9J1OYR9k4vO5uzdmxusIsN8gDaGdAW2cVl6ZUKG0ho16sLlPgqi2sMDZetU
         NhbZSh+D3QrgJKYa/bGEXz0fIdXust/fWp7nqgoN0Y+zAst37oqlsMqwFVmv5TMyO5EX
         DDifDTYZ/wBwQvSmlofexL1RpyiQZyZ7LxzuQyCT4vhyMYXejsc4wXCLT7Z4ue69EFqA
         O8I0DCpO/H4ZdvR9d9AJ+0zmB0HAEaYg8neFs6qrU8SnOE7VntHc5zKueJXPlWvP77dN
         SbCQ==
X-Gm-Message-State: ACrzQf2Ww0B26KUEJuTLjlRDxIoza2qrylOA9ViC9pmUWP57Ti6huazF
        w8HiiBYF77bhQcNn89+aGCSkmw==
X-Google-Smtp-Source: AMsMyM4qtvWrrG9HH1iyFhUPDwSvukheeXofFF5uiUmDrdzaPPoAAD9sUsfR+M5aag2SwYKzHHFqVg==
X-Received: by 2002:adf:e711:0:b0:230:6e89:363e with SMTP id c17-20020adfe711000000b002306e89363emr7042415wrm.536.1666026220663;
        Mon, 17 Oct 2022 10:03:40 -0700 (PDT)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id w16-20020adf8bd0000000b0022f40a2d06esm9079196wra.35.2022.10.17.10.03.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Oct 2022 10:03:39 -0700 (PDT)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: [PATCH iproute2 2/4] ss: man: add missing entries for TIPC
Date:   Mon, 17 Oct 2022 19:03:06 +0200
Message-Id: <20221017170308.1280537-3-matthieu.baerts@tessares.net>
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

'ss -h' was mentioning TIPC but not the man page.

Fixes: 5caf79a0 ("ss: Add support for TIPC socket diag in ss tool")
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 man/man8/ss.8 | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/man/man8/ss.8 b/man/man8/ss.8
index 6489aa79..996c80c9 100644
--- a/man/man8/ss.8
+++ b/man/man8/ss.8
@@ -299,6 +299,11 @@ Show cgroup information. Below fields may appear:
 Cgroup v2 pathname. This pathname is relative to the mount point of the hierarchy.
 .RE
 .TP
+.B \-\-tipcinfo
+Show internal tipc socket information.
+.RS
+.P
+.TP
 .B \-K, \-\-kill
 Attempts to forcibly close sockets. This option displays sockets that are
 successfully closed and silently skips sockets that the kernel does not support
@@ -379,6 +384,10 @@ Display Unix domain sockets (alias for -f unix).
 .B \-S, \-\-sctp
 Display SCTP sockets.
 .TP
+.B \-\-tipc
+Display tipc sockets (alias for -f tipc).
+.TP
+.TP
 .B \-\-vsock
 Display vsock sockets (alias for -f vsock).
 .TP
@@ -393,12 +402,12 @@ Display inet socket options.
 .TP
 .B \-f FAMILY, \-\-family=FAMILY
 Display sockets of type FAMILY.  Currently the following families are
-supported: unix, inet, inet6, link, netlink, vsock, xdp.
+supported: unix, inet, inet6, link, netlink, vsock, tipc, xdp.
 .TP
 .B \-A QUERY, \-\-query=QUERY, \-\-socket=QUERY
 List of socket tables to dump, separated by commas. The following identifiers
 are understood: all, inet, tcp, udp, raw, unix, packet, netlink, unix_dgram,
-unix_stream, unix_seqpacket, packet_raw, packet_dgram, dccp, sctp,
+unix_stream, unix_seqpacket, packet_raw, packet_dgram, dccp, sctp, tipc,
 vsock_stream, vsock_dgram, xdp, mptcp. Any item in the list may optionally be
 prefixed by an exclamation mark
 .RB ( ! )
-- 
2.37.2

