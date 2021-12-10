Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 947AD46F90E
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 03:19:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235867AbhLJCW4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 21:22:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230463AbhLJCWz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 21:22:55 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9D7FC061746;
        Thu,  9 Dec 2021 18:19:21 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id y14-20020a17090a2b4e00b001a5824f4918so8374887pjc.4;
        Thu, 09 Dec 2021 18:19:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FEw6cDwNumFEoIzG4G7yZNSpjLJlrE6wbUTHVe7gV4Y=;
        b=RIYz7QcaHop7MkJ2jvAtyObrBy5vOjsdjPD3USKsTAUvzZ4HgL71XT1HRO87uUGyHA
         rmhPBADv1RV8ZeL/2FvmwvTYA+tgDaHcbvvDYOCh8nzdLjEWe1g1kkEVPzwMCSSA2vaf
         7Z7X5hfBA9qWNQQPfJsHVYsjpWRDiplcgj4ZTpEWnsFWvBrxk453ysMzZr3vgVMMIUhU
         pgyVBSj+uqpmNnL9YAcqPFeAfvHbffjojzffDXySgxVz0kbndSYSOu4z4mWGxAfk7+by
         NscW5XNT7rRzhjtsze7fFaUM1FasQwoSIn6JnWdAnCztT5EsJJVcYEagZLLeSJgirG/Y
         ilDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FEw6cDwNumFEoIzG4G7yZNSpjLJlrE6wbUTHVe7gV4Y=;
        b=tZ6lrosCBWKs8EPsnuJJvq7KiKNk5tLx08GSrg4BsUd/vnWYvqMaNFcVev/h47JRN3
         QfglIWqnu7bntmyFjD5kSB3GciHG3EGH97y5jtBG4YYnUfQe0ykj5p4BleJxADG/Q0Hs
         kQrR810YMthxqNc5fiSUEcFB1oXprmPGP8UDtvsfKVk7WCL2J0OPD0dbvGwzNRJHRVrw
         0D7L1+/VQiO50vjWi7J7Ke3ngUMaSx5SfBk4vKRXNdz10P42184h/6rC8YfG4gjQ2Zpr
         6horUafrILPen8QlAs6ZeMI8My1KDQ/GNshgnXlukWtGu2kmGtH3FTeHxhT1KlkZpqNS
         EE0Q==
X-Gm-Message-State: AOAM533qN0Ir834gaRFpHKGeQNFuCHtgWf0BqkVZRguSlAWQEgHELwhR
        shGIli4TJxEK6P64v83FLKA=
X-Google-Smtp-Source: ABdhPJxwXZGDC1CedqgjnXGo0dpQS+/GKeAED/ubdvP3xlNrZQAKrcL1xIwGqKQ4ilY+qk9w9/ligg==
X-Received: by 2002:a17:903:41cb:b0:142:62a:4d86 with SMTP id u11-20020a17090341cb00b00142062a4d86mr71711050ple.43.1639102761277;
        Thu, 09 Dec 2021 18:19:21 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id pi17sm11219742pjb.34.2021.12.09.18.19.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 18:19:21 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     mareklindner@neomailbox.ch
Cc:     sw@simonwunderlich.de, a@unstable.cc, sven@narfation.org,
        davem@davemloft.net, kuba@kernel.org,
        b.a.t.m.a.n@lists.open-mesh.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cm>
Subject: [PATCH] net/batman-adv:remove unneeded variable
Date:   Fri, 10 Dec 2021 02:19:17 +0000
Message-Id: <20211210021917.423912-1-chi.minghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Minghao Chi <chi.minghao@zte.com.cn>

Return status directly from function called.

Reported-by: Zeal Robot <zealci@zte.com.cm>
Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
---
 net/batman-adv/network-coding.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/net/batman-adv/network-coding.c b/net/batman-adv/network-coding.c
index 0a7f1d36a6a8..0c300476d335 100644
--- a/net/batman-adv/network-coding.c
+++ b/net/batman-adv/network-coding.c
@@ -58,13 +58,9 @@ static int batadv_nc_recv_coded_packet(struct sk_buff *skb,
  */
 int __init batadv_nc_init(void)
 {
-	int ret;
-
 	/* Register our packet type */
-	ret = batadv_recv_handler_register(BATADV_CODED,
+	return batadv_recv_handler_register(BATADV_CODED,
 					   batadv_nc_recv_coded_packet);
-
-	return ret;
 }
 
 /**
-- 
2.25.1

