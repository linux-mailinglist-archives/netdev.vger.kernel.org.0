Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF8411CFEF
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 15:35:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729780AbfLLOfB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 09:35:01 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:36179 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729603AbfLLOfB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 09:35:01 -0500
Received: by mail-pj1-f67.google.com with SMTP id n96so1116644pjc.3
        for <netdev@vger.kernel.org>; Thu, 12 Dec 2019 06:35:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=b3hiJ3A3rMjBROFjEn7dlrVf4haGfG2YX4vYzJvUu0g=;
        b=ZU1mzT1a6j1q1Thw9Us8eq7wVAZfGe8Ee1pajQtvhwQz6RBYAf7qaYRvDYVYgKRgdb
         UnR2lzVLud3j17ipek0FwRbr0zX3DKC0V0QHzGAZg12znXWomPRWsGgH5f9rtW3Fh/I3
         7KUSkO324M5jyTeOnqojmlncRFLGUj9LuUFsWKtyjMbCDwm3xegELFZJLLrDGorwUbrT
         e9UW3s5Rp4+DvWe+oDFcjJ2JLXdH02GdQ0VHWnF7g78fAygak60ANLlp7pfCKgj4byZU
         sJiF2TwXUAIK/5dqpq9AiWXap4iO26wUS8czLd1FK1MctBS8WGq5g2eHMvute9DhuCj8
         /o2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=b3hiJ3A3rMjBROFjEn7dlrVf4haGfG2YX4vYzJvUu0g=;
        b=fGQE7YpQJSdLXFF8ZTBK+UIE072S0CuyUkg1zXNSqL4oUCzooIm/YFKGBW38IyI9cB
         NEKBbTuLmzV2kPiG0UDPy4ZEV3yAuPgiZC2p1Kg4dX6l8glZ/6jN6gDtxykNWoeTxZgS
         UtEqixU4d+swedEQ0+N8l2JA4YqicO2Jl8ZrSsm6WO5Kq/2K0UKcdgoSe3FAF4byqYqi
         e90lr56fS0cayCEuOJIBS9G+VOTABJFMbr3ID8d9uNvbDil387nKrhiXkUTWstNi1v4M
         Cz+qtGmHQBSKVCmxbwZ8aOYH2vY62dTGx9+mGHD0Q6NM8XIvHwbWDHD/AZz+CqHaDBeX
         8Nmw==
X-Gm-Message-State: APjAAAURlEKn4/5OhTFhuu+I2A4nQF/KHCdidDr8D3R6YCFkLMbAJv4z
        Eyz3r/A6ryHDk3TU5fWmAACYwcI3
X-Google-Smtp-Source: APXvYqygbe2VJcdjxVn2U1OOmHggeaQ7So/egx/FPbk/vwvba6aW6ohtVTc7RAE8ReXPmWBl6m6XVw==
X-Received: by 2002:aa7:8f3d:: with SMTP id y29mr10317055pfr.183.1576161299421;
        Thu, 12 Dec 2019 06:34:59 -0800 (PST)
Received: from martin-VirtualBox.dlink.router ([122.182.209.142])
        by smtp.gmail.com with ESMTPSA id z29sm7475473pge.21.2019.12.12.06.34.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 12 Dec 2019 06:34:58 -0800 (PST)
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, pshelar@ovn.org,
        scott.drennan@nokia.com, jbenc@redhat.com,
        martin.varghese@nokia.com
Subject: [PATCH net-next v2 2/3] net: Rephrased comments section of skb_mpls_pop()
Date:   Thu, 12 Dec 2019 20:04:52 +0530
Message-Id: <a934a03a66b3672acb09222055fe283991f93787.1576157907.git.martin.varghese@nokia.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1576157907.git.martin.varghese@nokia.com>
References: <cover.1576157907.git.martin.varghese@nokia.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Varghese <martin.varghese@nokia.com>

Rephrased comments section of skb_mpls_pop() to align it with
comments section of skb_mpls_push().

Signed-off-by: Martin Varghese <martin.varghese@nokia.com>
---
 net/core/skbuff.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index d90c827..44b0894 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -5533,7 +5533,7 @@ int skb_mpls_push(struct sk_buff *skb, __be32 mpls_lse, __be16 mpls_proto,
  * @skb: buffer
  * @next_proto: ethertype of header after popped MPLS header
  * @mac_len: length of the MAC header
- * @ethernet: flag to indicate if ethernet header is present in packet
+ * @ethernet: flag to indicate if the packet is ethernet
  *
  * Expects skb->data at mac header.
  *
-- 
1.8.3.1

