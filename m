Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6877434B2B4
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 00:18:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231583AbhCZXRq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 19:17:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231475AbhCZXR0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 19:17:26 -0400
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5BAFC0613AA;
        Fri, 26 Mar 2021 16:17:25 -0700 (PDT)
Received: by mail-qv1-xf2a.google.com with SMTP id t5so3792617qvs.5;
        Fri, 26 Mar 2021 16:17:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qMvLELFpcxybNRSuEuhTD/NwF9d/VF4bQMmwUX0d/R4=;
        b=AoVd/gcvIL668L9IXj63GDllnhIxmA2VEbx1IKtrXPs1opR9TITG4V9IKqZI5ccTEv
         At5Ig65R5LLzw0VrH0OYo+thPp9g8aY+Bx4h0sfpGAUKc8TnEQ2c2h5srt50oCqAAS5Z
         YqIyWVG6fSyCwct9QZB7rpIeyBDA+1xl1OXVH04es5YnBpnUuen0UCSA5lfP1w+5nI5u
         XYT+48Sx6L1vS2zV0L3D1hR9TRkt0JQ9GsXQRB5pQ55DsniHaAoqaBbO6fcO1rH4WRCu
         qIBNciS0bVZdBZa3SfRJIl/K9ibOXr2qD51gjhScrrGzyDeLZHKYw/0xvR9N1Vy6p3jJ
         0P+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qMvLELFpcxybNRSuEuhTD/NwF9d/VF4bQMmwUX0d/R4=;
        b=uA0Q0XdNq+gUHVmXrAJD+5zjC0a8P87w/gEpFezKR5qf2juj2bVSE6BaG7q4t66V1F
         j15wqRhF5sW+nrtQmKm1J23+jN1MN+HnebMe/GTXH7T171flefOO4MSMYHX4erlZvVEA
         e2f6MyKS3hjyD/WME+Y3wfeTr0eWtzOdvBFk+NA7N8PLm2g6ntaBiPi2dUwb6oMODcNa
         U3p6Lz0s/itzBiXjcM87tPyFOB32kNBgugGMhPGVMEaBkhrYh/3A+ZPohbw8WeetsrHg
         KuNcwIRSZbBROa92HhqPIhlfDsBEBAtGEPcirEIR67s8mt2lQ62PIby4kPt2RgAZW5HN
         MHCg==
X-Gm-Message-State: AOAM530c7ZemTvV3mCXMqtO9XRKKkEOteglPRlVRtCBL1tRDS7PuI6k0
        AX4sPOxhRBaAPKuEd6uvKNo=
X-Google-Smtp-Source: ABdhPJz/ZZcu/NpebTOjwbcc52+qqOATzPc1xHaapC7OD64nELWzdTymFYvfRVVj7QDSSPOjR1x+Yw==
X-Received: by 2002:a05:6214:80a:: with SMTP id df10mr15728199qvb.46.1616800645082;
        Fri, 26 Mar 2021 16:17:25 -0700 (PDT)
Received: from localhost.localdomain ([156.146.58.30])
        by smtp.gmail.com with ESMTPSA id w78sm7960414qkb.11.2021.03.26.16.17.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 16:17:24 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, rdunlap@infradead.org
Subject: [PATCH 02/19] xfrm_user.c: Added a punctuation
Date:   Sat, 27 Mar 2021 04:42:55 +0530
Message-Id: <89e59a9d546fe758fa4d166fe2e65d8a0a2525e8.1616797633.git.unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1616797633.git.unixbhaskar@gmail.com>
References: <cover.1616797633.git.unixbhaskar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

s/wouldnt/wouldn\'t/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 net/xfrm/xfrm_user.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 5a0ef4361e43..df8bc8fc724c 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -1761,7 +1761,7 @@ static int xfrm_add_policy(struct sk_buff *skb, struct nlmsghdr *nlh,

 	/* shouldn't excl be based on nlh flags??
 	 * Aha! this is anti-netlink really i.e  more pfkey derived
-	 * in netlink excl is a flag and you wouldnt need
+	 * in netlink excl is a flag and you wouldn't need
 	 * a type XFRM_MSG_UPDPOLICY - JHS */
 	excl = nlh->nlmsg_type == XFRM_MSG_NEWPOLICY;
 	err = xfrm_policy_insert(p->dir, xp, excl);
--
2.26.2

