Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E2301207E2
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 15:03:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728072AbfLPODm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 09:03:42 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:44532 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728017AbfLPODl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 09:03:41 -0500
Received: by mail-pf1-f194.google.com with SMTP id d199so5626712pfd.11
        for <netdev@vger.kernel.org>; Mon, 16 Dec 2019 06:03:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=b3hiJ3A3rMjBROFjEn7dlrVf4haGfG2YX4vYzJvUu0g=;
        b=QTORjUxSkLpv8447E8IVH2iLE1iPtHes6kNxq/YYpU6wdEkFJ/Ulr1WsC9450jdjig
         rgGHQJ8sqQxe9U+a/hIoWSofUai8f3NVdBTejp2W06pDH8sqTLjvEhsdFny+hLlo90k8
         paBaMER1NxuJh/dZOJEBVnmO1ZZyPL9sAtFStsw0zcCgEAPEofRaVaNKP34ZC5Gy0GZa
         gx+9zt6QYV/uMciy4Xn6Fe+frwBSKMtu+OzmJTuwmBGzYEN/hL0J1I+Gjt/AllEQHi9d
         EZ7b50V/f+cP7e+3MCXm8ZAbUVeTucKGc2zryBkGYHBrmSJPj2Rpr9spjsqXYdA7Iw5X
         A32w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=b3hiJ3A3rMjBROFjEn7dlrVf4haGfG2YX4vYzJvUu0g=;
        b=FwXCe0xUwFru9A9nUrJn98NpSrxT3jwZhTMEcxDpFS8QfvpAK3IbaXHxxy4947u5eF
         4C4FJEXS9755tzPRAD1IvYsM9SCrCL83QcloDIjtLUcefa2p8bguAax2RGIWJ8SYV4ad
         pbhjP52CA+ldkRXrd0aRlHg2wluhHIsCmHK6qPg+e5vAWpagGUxQLui0SdMlLZZ6oEV/
         LoRRwZoyaeiyvq4bHAYvLUTU9HAnSA/ZfAhvy0ctwUHtZy5LQeVKO3H6tb6Q61pGVBwR
         ubYT9T/fr6bdeC3jyn1U5sPjUBgEsV9elMlvObdw4m7+k/PVOvZLLUHRTwBnzMWDonrg
         ygeA==
X-Gm-Message-State: APjAAAXoytpMuu5FxP6B/1QJD27W7BCeDa0CmPTLcsqtpGbh7wd2pPQ/
        AxyKBedM/aG/p70T0coaT1Gnr1jS
X-Google-Smtp-Source: APXvYqzCANBob2ooKw7HaGNQf+2DdDZ1r2oleN2TiHwfYpiR+kCX/v4xe8Kbk1M0uaNpAXZAK3zeiA==
X-Received: by 2002:a62:aa09:: with SMTP id e9mr15914903pff.154.1576505021023;
        Mon, 16 Dec 2019 06:03:41 -0800 (PST)
Received: from martin-VirtualBox.dlink.router ([122.182.209.142])
        by smtp.gmail.com with ESMTPSA id f9sm22384764pfd.141.2019.12.16.06.03.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 16 Dec 2019 06:03:40 -0800 (PST)
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, pshelar@ovn.org,
        scott.drennan@nokia.com, jbenc@redhat.com,
        martin.varghese@nokia.com
Subject: [PATCH net-next v3 2/3] net: Rephrased comments section of skb_mpls_pop()
Date:   Mon, 16 Dec 2019 19:33:23 +0530
Message-Id: <a934a03a66b3672acb09222055fe283991f93787.1576488935.git.martin.varghese@nokia.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1576488935.git.martin.varghese@nokia.com>
References: <cover.1576488935.git.martin.varghese@nokia.com>
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

