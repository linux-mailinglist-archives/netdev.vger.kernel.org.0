Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D261D123FD4
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 07:55:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbfLRGzs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 01:55:48 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:46956 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbfLRGzs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 01:55:48 -0500
Received: by mail-pl1-f193.google.com with SMTP id y8so527455pll.13
        for <netdev@vger.kernel.org>; Tue, 17 Dec 2019 22:55:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=b3hiJ3A3rMjBROFjEn7dlrVf4haGfG2YX4vYzJvUu0g=;
        b=tWNGVOmDpdCV/cL+mR1c3efXP7iMoERShzb18ZXMnuG9ssqfS1rNeUONB6dLWD7214
         O48Zv+3ICcXno/HTXDSB3RbdY6QxoKwpysYobPFGMMXZka9jjMWTcn9kw/JnMBTU5CGN
         ybdzPnxv2quCH6x8w6bxn0fgXtVYNccel57cpY+ez0S7RyJcy5kJibf4wVrJi2EoHZii
         gm74kYjoHfjJ0I0H21hrlY3EmE/xsQBc+QjwoDmtanNUf5wUYLkmwMvdmg6NSoPHJBl2
         qPjk34EDqaJ/5cjw63iPGnReFQ4ibFWDxh03Fbyp8ycbkRY03d6BcVIQN0i91Eq0dxI8
         sYhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=b3hiJ3A3rMjBROFjEn7dlrVf4haGfG2YX4vYzJvUu0g=;
        b=M37mj5mCZfd8XIHQ0XOr0G2MHvUQdL8YtNsMdGF9gOQJjypAN3kbhsncfPh1bqMS7q
         4EbQvZ9+Q7+fDU0SZZ65GyTDgnaJ1/IAspdPxeotrAtugFF2gmRpy9es1hXYPY7WeBHL
         ycZNm8oEIj8hLwTM0WPlFKxnuJnadiKMtoSnBr8VYOqvW1K2xXL8rFWUA+lwY1nG9lnt
         Xy/JHJtyXy6oB9a8T6IpsrIrziHf68AGEjAJzPLyC8gQN3SkH79nMBTQVrKuQIpkGVLf
         TAQqEycNtD88HmUhilvU/0by6TlwAt/UoFJUoxaOgQun0MiGwN6If/7Ek5UQYBjue+Tn
         0vUw==
X-Gm-Message-State: APjAAAXSfNNXdY8qeSD4xro+9Zi/GXV+F1o3rGwgll5UHqAXDwlwvCh5
        J7RlEU2MhpdQGzH8hDjmyr4WHoxf
X-Google-Smtp-Source: APXvYqxZd3YkPfjPub8/Yw5LfDBNjKtVMtAwD2H9cYlfn/G9ggla/olwcUx0iZPX4MI9Vkkvqb20Gg==
X-Received: by 2002:a17:902:12c:: with SMTP id 41mr1034836plb.160.1576652147732;
        Tue, 17 Dec 2019 22:55:47 -0800 (PST)
Received: from localhost.localdomain ([122.182.209.142])
        by smtp.gmail.com with ESMTPSA id y144sm1473739pfb.188.2019.12.17.22.55.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 17 Dec 2019 22:55:47 -0800 (PST)
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, pshelar@ovn.org,
        scott.drennan@nokia.com, jbenc@redhat.com,
        martin.varghese@nokia.com
Subject: [PATCH net-next v4 2/3] net: Rephrased comments section of skb_mpls_pop()
Date:   Wed, 18 Dec 2019 12:18:11 +0530
Message-Id: <a934a03a66b3672acb09222055fe283991f93787.1576648350.git.martin.varghese@nokia.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1576648350.git.martin.varghese@nokia.com>
References: <cover.1576648350.git.martin.varghese@nokia.com>
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

