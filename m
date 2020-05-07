Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 097BC1C840A
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 09:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726308AbgEGH6P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 03:58:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725858AbgEGH6P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 03:58:15 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 242A7C061A10
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 00:58:14 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id 207so2487601pgc.6
        for <netdev@vger.kernel.org>; Thu, 07 May 2020 00:58:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=d9gjnubS63tvlYTBfTQRcvuipQYZtycVKe2DmQLBUFQ=;
        b=ljN8fdLOCYgjepN3wjPsNHnZ9ZTXanyLQ9NFx4/GKfliXyUYWEG2ed/1ycQQ5nd2eW
         qibuUwT+0yrcZUVgL9A+hBjZqfsr+N7Hov34nuCXboqzLQj6aXxmO+0gFDQU/lXbK1Kw
         86sVOrjTH79MV8gfLfNxo8g0gO3us1V8Vy/pSbjzPUXBSnv7d78OebUI+Pl3ZovN7hsr
         Ab2UlUm+SFxW5GLciQDbIXYT9waNBO+1YUEF+Kn6d/EiyTklqMFY2/W9AXIDdo3OdwXs
         aWn1FBVvQLEw7wIBqTLwQpFFk3avvc5bf2F6SBvj8nc4yXRH6mByyDF9B11i+MFmRloJ
         CrrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=d9gjnubS63tvlYTBfTQRcvuipQYZtycVKe2DmQLBUFQ=;
        b=B8YhEUGuA2Ydjn9TEQE5PrH/iSQffVlqLQkV4Zn8nQujh+1El/UicMcvkrz4jPRuC6
         rQ0zhkBHLodDQzBUU4VN3kTnZinmqRlp5yNzUOswUTMevYEhkV5AZVvhKt88YN5QQUNV
         x6LbA9ZEcl1T8cL9gIwYdclxmhHmMHviFTBu4CKddxqEsXDfU3FqI6BdvsrllStIuWm9
         EHoNm7pa9SLHmrDdO7Y22luNtuzvOMABS+KMZp32udK1331qpQAylHyzkNRIUlT+j0on
         hDlFug4A+EHkg2k93yJ/Uf1gS8utTOFufOTn+FfETv/UhjUhhFHAnArn8A9R7gnQtaad
         0IBg==
X-Gm-Message-State: AGi0PuaQUxiiQdIP47P4QUiqeTBMycQruSvosD8GbcEsPlPB1l6tcxSe
        7RKPTZ77ER2ywkXonlhBNTdwvPAp
X-Google-Smtp-Source: APiQypIbUgD4db0QpGJMVVDi0iT6lE812i+YmlEZLGR7yis+k9UOtRUHNkFEIeYomU8Qs3IWm0ktIA==
X-Received: by 2002:a63:ed02:: with SMTP id d2mr5011058pgi.119.1588838293569;
        Thu, 07 May 2020 00:58:13 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:c786:d9fd:ab91:6283])
        by smtp.gmail.com with ESMTPSA id p10sm4094749pff.210.2020.05.07.00.58.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2020 00:58:12 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>
Subject: [PATCH] net: remove spurious declaration of tcp_default_init_rwnd()
Date:   Thu,  7 May 2020 00:58:05 -0700
Message-Id: <20200507075805.4831-1-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.26.2.526.g744177e7f7-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

it doesn't actually exist...

Test: builds and 'git grep tcp_default_init_rwnd' comes up empty
Signed-off-by: Maciej Żenczykowski <maze@google.com>
---
 include/net/tcp.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index dcf9a72eeaa6..64f84683feae 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1376,7 +1376,6 @@ static inline void tcp_sack_reset(struct tcp_options_received *rx_opt)
 	rx_opt->num_sacks = 0;
 }
 
-u32 tcp_default_init_rwnd(u32 mss);
 void tcp_cwnd_restart(struct sock *sk, s32 delta);
 
 static inline void tcp_slow_start_after_idle_check(struct sock *sk)
-- 
2.26.2.526.g744177e7f7-goog

