Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4545534B2CA
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 00:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231317AbhCZXTn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 19:19:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231617AbhCZXR4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 19:17:56 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04EB8C0613BA;
        Fri, 26 Mar 2021 16:17:56 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id 7so6970400qka.7;
        Fri, 26 Mar 2021 16:17:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+QzTIMQkrFw6m3Cji1kHVk1ThDqLlItcXspdG6j7uyw=;
        b=psYphKTsQ+/ZRe9S3ENJWuq/qy4DjdT5LqmQ4ZYr9emk+LIcwuzo+eNs1QqWT+UNab
         n0PGTvRFKApWhF/XqUbpA+VZ7OA2oJ9EmZM56ExrBBTNBKivnfy+cCY0BkeZfI1UNg59
         VPzgbwZP8/+fksIgBnABlPYzaUTffYlo6/IAx+ROXIU09kIsCtc6Jin4VTAsaRuGUio2
         O8SJBtBukVdLCvqG/94dbp8Cd7aSBJrZRsY5fWfDr8VPMEdnPwkNHDmJ/8zEMqDinbvP
         tNj0LMw2vypQiN+C0dPf3u4hs9CeZUYbk/wtxlKEa2DrmJXrusMQpY/d449AtNkJBRsW
         /h6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+QzTIMQkrFw6m3Cji1kHVk1ThDqLlItcXspdG6j7uyw=;
        b=DlHsoqoCLMDS2QxGNuRJXqs41+QWOBAX6S/2VtjqtzgKSD1UgtXZpiia7ZzbYzUWXi
         +4nAYjsN+oJLVjK7KXATgvREzyHNxZMttzPwSh4SnQELzFfQPFQLzW62WSeXlQoE6qJX
         h2AS8IBsZ4O48vwcEfM2Z3zw4MOsg+jvOxCivnrUNXA8BF99HlWrIhuVbllZ7rAKYeM7
         6NXCBDTKDxoQYdF909EvCng7DTxkiz/HIke1SFbDqoJMaGpx5dxRL8BaXkAsEaCpaOqN
         9HInrOMHR9LAARjdlRv//Lll752XC927CoAVrpHVxaiec9j3hfBQPcI+Kp3QJ42PLBc2
         BJDA==
X-Gm-Message-State: AOAM533z6GRKUydzkwk96O57tEJuGGT9jrsckzocOMmXuhacO0Q/+VRV
        dlIwtyWP9mHHh/JeD2aH1H8=
X-Google-Smtp-Source: ABdhPJzhNODR49ZW6S15QuTEnCAJC6ISj+poAlLNfKpbilNbQlKaYFAUB3knVSONBjVZVY0BQIyvLg==
X-Received: by 2002:a37:9fd2:: with SMTP id i201mr14928050qke.435.1616800675355;
        Fri, 26 Mar 2021 16:17:55 -0700 (PDT)
Received: from localhost.localdomain ([156.146.58.30])
        by smtp.gmail.com with ESMTPSA id w78sm7960414qkb.11.2021.03.26.16.17.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 16:17:54 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, rdunlap@infradead.org
Subject: [PATCH 10/19] mptcp: subflow.c: Fix a typo
Date:   Sat, 27 Mar 2021 04:43:03 +0530
Message-Id: <cb5287a8c1dd4a877db81686ffba95a1d8976d70.1616797633.git.unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1616797633.git.unixbhaskar@gmail.com>
References: <cover.1616797633.git.unixbhaskar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

s/concerened/concerned/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 net/mptcp/subflow.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 3d47d670e665..f1b6e4d0b95f 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1076,7 +1076,7 @@ bool mptcp_subflow_data_available(struct sock *sk)
  * In mptcp, rwin is about the mptcp-level connection data.
  *
  * Data that is still on the ssk rx queue can thus be ignored,
- * as far as mptcp peer is concerened that data is still inflight.
+ * as far as mptcp peer is concerned that data is still inflight.
  * DSS ACK is updated when skb is moved to the mptcp rx queue.
  */
 void mptcp_space(const struct sock *ssk, int *space, int *full_space)
--
2.26.2

