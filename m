Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0432234B2B7
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 00:18:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231330AbhCZXSF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 19:18:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231208AbhCZXRa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 19:17:30 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63FE9C0613AA;
        Fri, 26 Mar 2021 16:17:29 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id u8so5399079qtq.12;
        Fri, 26 Mar 2021 16:17:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lWmpm99AjPMwsAA+HeeQATviVqadwwf7PdEQKJXK2kQ=;
        b=L5u/XgWGyPcxmKIxenNC4PShPj9FlfiYPsxnlMMDi2Mbpy/5mOfvxsPIU0kU1Vyl2D
         L6qCDXeKkW1ETL8qO+84Gkx5GeMaabLHWt8OdIIpywCVY7Vk96NyY7773bUiGa+QcxAj
         aq3UC/DhPEzZ/361H4j7ODysDGVqwNZhLwClP6Lyr9T6BlEz5dPgFfaK/0mPB3jymIFY
         kofOpUJ8Y1pCvqfwkbUicwJSIPy5iANo+kZywXq7zP7iJSVcHkK1100wQIhz3rwM2+C+
         sJX+8QTfugV5BVBVXihlBzr3+BQYt75j0DN3T1jDQvy1WjEkmP+grhPB/dJj4LMh/mHH
         +neA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lWmpm99AjPMwsAA+HeeQATviVqadwwf7PdEQKJXK2kQ=;
        b=dL0UMa6PF5CVK52ihGWpqXlovo0BvzeptLZ3uRdQQiYj8qFKqfFW8jWoDWyljy4NCA
         J7sL0z2MdW3pMIGxRcdhMbaQqGlYyhYDv77VOR0CUrkL7XQ0jGx9DQFHpritbG2YFcgn
         oSoT9kFrLw2p1bXvGf7au2WL0sVrykE058Zj6goYqsYIaARggf75Q+3Fghz++kzEih9I
         ivryFPdfTOL3YGoPpY1yBP6odAUlZvSA8HiwuMbStOyKYcTwZ/ydUMU71asCenS01CVf
         7wp+NIJYambm5WUCyzB0/MBtTgkatPIfuXW0g2Zq1/xbR87M7GMWbY9ffOdY9KOkRt6F
         jWoA==
X-Gm-Message-State: AOAM532sn1S+Va9l/RY3siNqIgViqtbsw6Bom7iq4uAZIT44xtBl5c4S
        DJAAhC6UWFZk6fDI8aMWVfI=
X-Google-Smtp-Source: ABdhPJypxsNlsxs76uH/TXDZ0x9wUWyvv00QQkQGWaiI4F8K/gt4S518h/fr94nxI8rREvpnDhhSOg==
X-Received: by 2002:ac8:7b4d:: with SMTP id m13mr9797045qtu.364.1616800648742;
        Fri, 26 Mar 2021 16:17:28 -0700 (PDT)
Received: from localhost.localdomain ([156.146.58.30])
        by smtp.gmail.com with ESMTPSA id w78sm7960414qkb.11.2021.03.26.16.17.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 16:17:28 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, rdunlap@infradead.org
Subject: [PATCH 03/19] af_x25.c: Fix a spello
Date:   Sat, 27 Mar 2021 04:42:56 +0530
Message-Id: <803ac5ee08c7060c6a34a5f4bcb0e13ba9566f39.1616797633.git.unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1616797633.git.unixbhaskar@gmail.com>
References: <cover.1616797633.git.unixbhaskar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

s/facilties/facilities/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 net/x25/af_x25.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
index ff687b97b2d9..44d6566dd23e 100644
--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -1018,7 +1018,7 @@ int x25_rx_call_request(struct sk_buff *skb, struct x25_neigh *nb,

 	/*
 	 * current neighbour/link might impose additional limits
-	 * on certain facilties
+	 * on certain facilities
 	 */

 	x25_limit_facilities(&facilities, nb);
--
2.26.2

