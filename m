Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD2B55918D5
	for <lists+netdev@lfdr.de>; Sat, 13 Aug 2022 06:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235672AbiHMEfY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Aug 2022 00:35:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231424AbiHMEfW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Aug 2022 00:35:22 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 620FA6472;
        Fri, 12 Aug 2022 21:35:19 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id y1so2318848plb.2;
        Fri, 12 Aug 2022 21:35:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=VUHCQwlaRdPYc5+96fH2AK8O9hMSpZvPcuLwqBAO7GQ=;
        b=DbqPITAh6lgQPvO8iRa3uqHjy37oFWqdIFpqX5YpaTeFSa9gvbfPa8ouyMvutd/LuW
         ka2BMZndXfiNWXfow9ffrQt2nFRaSV/9YFfeii7/IHng9yehzW/yZ297A2N1C6RfU+ES
         gP6LngMgBEL1JkSigxeKsJQysiofWZ8/etpZ9MY4uEFuTFSHqdlVL+jJ6bfj0Z3tqynK
         yb4oIbwmRKsf8Ki1eaBFEGKXcYM6hrSfRqOJjNJqY9pg9yocPUKxr85qAzee0zUi6lyO
         WgOZZ7KBVGUbxOEwDEEof2WCWLeokyTkWD2mvkkQgqYl8iPWfdGnjzWzlElMvOMFwMZ4
         xpXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=VUHCQwlaRdPYc5+96fH2AK8O9hMSpZvPcuLwqBAO7GQ=;
        b=bqtwLqfmwjMDf+Zlo3ln2I+yO0HFywftoIkqjIxLOkAAPQqeK8AiKlmdKo+XQ+HHEz
         4rnbG4T/WXr/DhQVZAPWKbqrnZEYSrOqDd7SmTHOCHuSQHPk4s/wBznBr2MSafvGAA5+
         gnYVh4wNmOjWbUXf9L0zpRfFBX3qWWYdI6eQguU3c/HI8OM+N3N0yoCvS3VcyFC3s3v6
         QsHG+6mkxLGn4flk+rQVMixxb1NpPTQyKhFbWuN+Y0z4x19iqR7s0S90PSrCW/acrjTb
         33voNkMygwDlmkq9W21MBGcUMXwl9i4qxZJw6/enrzoVgLwojyqkIOnIA3Iqhk25BHbO
         bHaw==
X-Gm-Message-State: ACgBeo0lON3ZtiNDNAmfNoo+llJ/lO9aAtyJu/wLttQf42XjOmwYYuQb
        UiabOQOdTYbTAqB7ZuRuzqQ=
X-Google-Smtp-Source: AA6agR5E1/zUPIeHYwRmzswCgIOXoJuOjoKcs89aA7ZQycOVw8pfa7Exlb/hyVvFnRNXjExarmZJ8A==
X-Received: by 2002:a17:90b:1c8e:b0:1f7:5250:7b44 with SMTP id oo14-20020a17090b1c8e00b001f752507b44mr17176314pjb.212.1660365318895;
        Fri, 12 Aug 2022 21:35:18 -0700 (PDT)
Received: from localhost.localdomain ([223.212.58.71])
        by smtp.gmail.com with ESMTPSA id y6-20020aa793c6000000b0052e2a1edab8sm2479425pff.24.2022.08.12.21.35.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Aug 2022 21:35:18 -0700 (PDT)
From:   Yuntao Wang <ytcoode@gmail.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, wireguard@lists.zx2c4.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yuntao Wang <ytcoode@gmail.com>
Subject: [PATCH] wireguard: send/receive: update function names in comments
Date:   Sat, 13 Aug 2022 12:35:08 +0800
Message-Id: <20220813043508.128996-1-ytcoode@gmail.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The functions packet_send_queued_handshakes() and
packet_process_queued_handshake_packets() were renamed to
wg_packet_handshake_send_worker() and wg_packet_handshake_receive_worker()
respectively, but the comments referring to them were not updated
accordingly, let's fix it.

Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
---
 drivers/net/wireguard/receive.c | 2 +-
 drivers/net/wireguard/send.c    | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireguard/receive.c b/drivers/net/wireguard/receive.c
index 7135d51d2d87..5b9cd1841390 100644
--- a/drivers/net/wireguard/receive.c
+++ b/drivers/net/wireguard/receive.c
@@ -566,7 +566,7 @@ void wg_packet_receive(struct wg_device *wg, struct sk_buff *skb)
 		}
 		atomic_inc(&wg->handshake_queue_len);
 		cpu = wg_cpumask_next_online(&wg->handshake_queue.last_cpu);
-		/* Queues up a call to packet_process_queued_handshake_packets(skb): */
+		/* Queues up a call to wg_packet_handshake_receive_worker(skb): */
 		queue_work_on(cpu, wg->handshake_receive_wq,
 			      &per_cpu_ptr(wg->handshake_queue.worker, cpu)->work);
 		break;
diff --git a/drivers/net/wireguard/send.c b/drivers/net/wireguard/send.c
index 5368f7c35b4b..15202c2e91a8 100644
--- a/drivers/net/wireguard/send.c
+++ b/drivers/net/wireguard/send.c
@@ -69,8 +69,8 @@ void wg_packet_send_queued_handshake_initiation(struct wg_peer *peer,
 		goto out;
 
 	wg_peer_get(peer);
-	/* Queues up calling packet_send_queued_handshakes(peer), where we do a
-	 * peer_put(peer) after:
+	/* Queues up calling wg_packet_handshake_send_worker(peer), where we do
+	 * a wg_peer_put(peer) after:
 	 */
 	if (!queue_work(peer->device->handshake_send_wq,
 			&peer->transmit_handshake_work))
-- 
2.37.1

