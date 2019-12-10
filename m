Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34AF3118201
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 09:17:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727045AbfLJIRA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 03:17:00 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:43889 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726062AbfLJIRA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 03:17:00 -0500
Received: by mail-pf1-f194.google.com with SMTP id h14so8659765pfe.10
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 00:16:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=YcNMeJbRiejGZtuoCLd9iYQVolncIEe6nhULhLaXtxg=;
        b=dpz/FrxQDC27MtYrwAxRTCG698GBqESWUW3bBmxKYHDT+9oVXCfL6jk2v+oKK8w3PT
         7inDKJqjkRf+fx8p1mBpgpEuUN8cPBdrE9vsowiSXStclIAjlquAb/3JlZA/8qqvqQHe
         NRfhIvx3rM7K5j9T1JWXFWanTbWDJ0wAc7EXayRNeipm6ZbVRcyQT9okyvRkspH1zpC4
         LDA1Ohit6cgEnyFvwiro9sIVRSWj3pMli3iEqyax8jLMB/2yBwbHLwCWpCRG5QtLGetz
         Nutojs9ZO41amsnRh5WSoOCGCJtUTuV6Vt0wQTrVUQ5h5qE105Bv8MwrlWW+dp0CgMJ4
         +N5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=YcNMeJbRiejGZtuoCLd9iYQVolncIEe6nhULhLaXtxg=;
        b=OIOtI1Pqj9FvkT456ZD55nJ8vMI4+uTxOoJGwAMs2kCSmkJoZ2Hfgxj/nYmSAshql7
         XbfmWF57sBdXEC/MmPxv5L5hjp0MmAv2FZpqD4/CdDvnr2FlGSI2XWAYjFyTvTEkNXR0
         kiUsfKNPWskrT9NQmCBWQoUA788YH+od/nu+YSiQgEBEuDiB2E/6Dw54ZoXPC0KyMNs0
         lUvuRMzj8aLWFVN8sL9ygRgZQS1dsKGvdxMrNTjFS/vgIJLt5jxx64kImmkTtyKUD30J
         O+44z17A7KzFVbfMERIV2okcswT986qvKTv+WyvjRGijwr/3zycn0JW/fougzs75XHxZ
         0CTQ==
X-Gm-Message-State: APjAAAWmXfnTDZxTQsrR37PkQZ02evEBlQZYoK2xw1BM0WLBWGhA30j9
        BcKCJHylGDmVu3Krcbhw/uXjr1b/
X-Google-Smtp-Source: APXvYqynOy8kIBZsT8ky6WPeAdvK6eP8/iMjbgiE+U9zu2pAvLRrmY7PcOIkIpK63FjAnT95zGbZaQ==
X-Received: by 2002:a63:1f21:: with SMTP id f33mr7039047pgf.91.1575965819361;
        Tue, 10 Dec 2019 00:16:59 -0800 (PST)
Received: from martin-VirtualBox.in.alcatel-lucent.com ([1.39.147.184])
        by smtp.gmail.com with ESMTPSA id k5sm1834560pju.5.2019.12.10.00.16.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 10 Dec 2019 00:16:58 -0800 (PST)
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     netdev@vger.kernel.org, pshelar@ovn.org, davem@davemloft.net,
        scott.drennan@nokia.com, jbenc@redhat.com,
        martin.varghese@nokia.com
Subject: [PATCH net-next 2/3] net: Rephrased comments section of skb_mpls_pop()
Date:   Tue, 10 Dec 2019 13:46:19 +0530
Message-Id: <23ecf5b2bf5a1d0b4b1587f11a8b8134682e75a0.1575964218.git.martin.varghese@nokia.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1575964218.git.martin.varghese@nokia.com>
References: <cover.1575964218.git.martin.varghese@nokia.com>
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
index 7773176..024679e 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -5532,7 +5532,7 @@ int skb_mpls_push(struct sk_buff *skb, __be32 mpls_lse, __be16 mpls_proto,
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

