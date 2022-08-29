Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A88935A5431
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 20:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbiH2Sr4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 14:47:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbiH2Srz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 14:47:55 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E52FA7F248
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 11:47:53 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-33dce8cae71so141406737b3.8
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 11:47:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date;
        bh=DbVqcIyW57dhZ/hIdLVFQvuYF0J4JrhZ5ni9wGMW9Ag=;
        b=Bpxc99Cx8g1WNPGF3BCmC/VoPNs61HsTmERxtKm422RXkqlVULM/hKLNF0xNFuVNkN
         1KToXtUUr11Elo915BICHTSM1qqOdvl9rvKkoR9SX9HF6XQf8bCRum9MXue3tHp73vLu
         OrmpfFrPN9MRx8h4pqb1XbKVKoBPrLTM7eza7PaLJETy9bNwkXT+m6kSBSDIV/uaRTZW
         s5s0kAyLwnJUoQJZvwAwbLrAuJ8jBPWku15FOyeod5W6QHlo9Lf2hGXeA1yfSkz+ando
         oZzQ7i4T2D9zzNV8qtY9BglsiIxGQotK8D/K0lG7IynDaX8t/HiQhD6P2DXJmzEm3c8A
         4lYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=DbVqcIyW57dhZ/hIdLVFQvuYF0J4JrhZ5ni9wGMW9Ag=;
        b=Bl8hLfxJRABPbe+jnRtO5xv+zATdTKJrMHkHm+SxoGRWJySVXkIYzyj2siE7m4+jwN
         zm3JwPTy38v8mN1tTQvQYdEQ5pWa6DfJzyA4ILrrwSkJBxdz4mIRAWls/m2KSiNGPnb2
         I6s5yAmUjVclIhpc6UmFFyr7tS3IOd4XX1XyJZdlq/RDhed7oxPH/USN9br2LdAeii2b
         bXoO+nNUMDgUbZPGfw3oRWfLJoFtfGBSN2gUEypb7YBBwAjLDgtYA+RAqhORTaUmIceu
         4uMtY8ujBV3f+JGnFooqeOUs0EGURWp1x2H2ioIC0kY8/5U9+7qBrZG+fd/O3Jwrg2i9
         9rNQ==
X-Gm-Message-State: ACgBeo3Yj8AtexIoJg2ys2y0QMJGt4uarkggn8cWjWT58W6Lyc/qqLyx
        6uSzv/vm2qCbV8MNB/uEEWyaHVpsEtntW+its5Fw
X-Google-Smtp-Source: AA6agR5kg/MwB86XKDmGJd6n/E1ekru+JbHqpyFoaEkO8JpFf0a5wh4HuiaimXQUqlMdzguadjYDNNcritMemD1bSrhw
X-Received: from ajr0.svl.corp.google.com ([2620:15c:2d4:203:3f93:1c9a:457e:d2d1])
 (user=axelrasmussen job=sendgmr) by 2002:a25:b8c6:0:b0:692:af14:6f99 with
 SMTP id g6-20020a25b8c6000000b00692af146f99mr9874055ybm.197.1661798873239;
 Mon, 29 Aug 2022 11:47:53 -0700 (PDT)
Date:   Mon, 29 Aug 2022 11:47:48 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220829184748.1535580-1-axelrasmussen@google.com>
Subject: [PATCH] selftests: net: sort .gitignore file
From:   Axel Rasmussen <axelrasmussen@google.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Axel Rasmussen <axelrasmussen@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the result of `sort tools/testing/selftests/net/.gitignore`, but
preserving the comment at the top.

Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
---
 tools/testing/selftests/net/.gitignore | 52 +++++++++++++-------------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff --git a/tools/testing/selftests/net/.gitignore b/tools/testing/selftests/net/.gitignore
index 02abf8fdfd3a..e64419c3fed8 100644
--- a/tools/testing/selftests/net/.gitignore
+++ b/tools/testing/selftests/net/.gitignore
@@ -1,43 +1,43 @@
 # SPDX-License-Identifier: GPL-2.0-only
+cmsg_sender
+fin_ack_lat
+gro
+hwtstamp_config
+ioam6_parser
+io_uring_zerocopy_tx
+ip_defrag
 ipsec
+ipv6_flowlabel
+ipv6_flowlabel_mgr
 msg_zerocopy
-socket
+nettest
 psock_fanout
 psock_snd
 psock_tpacket
-stress_reuseport_listen
+reuseaddr_conflict
+reuseaddr_ports_exhausted
 reuseport_addr_any
 reuseport_bpf
 reuseport_bpf_cpu
 reuseport_bpf_numa
 reuseport_dualstack
-reuseaddr_conflict
-tcp_mmap
-udpgso
-udpgso_bench_rx
-udpgso_bench_tx
-tcp_inq
-tls
-txring_overwrite
-ip_defrag
-ipv6_flowlabel
-ipv6_flowlabel_mgr
-so_txtime
-tcp_fastopen_backup_key
-nettest
-fin_ack_lat
-reuseaddr_ports_exhausted
-hwtstamp_config
 rxtimestamp
-timestamping
-txtimestamp
+socket
 so_netns_cookie
+so_txtime
+stress_reuseport_listen
+tap
+tcp_fastopen_backup_key
+tcp_inq
+tcp_mmap
 test_unix_oob
-gro
-ioam6_parser
+timestamping
+tls
 toeplitz
 tun
-cmsg_sender
+txring_overwrite
+txtimestamp
+udpgso
+udpgso_bench_rx
+udpgso_bench_tx
 unix_connect
-tap
-io_uring_zerocopy_tx
-- 
2.37.2.672.g94769d06f0-goog

