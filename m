Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66CD344D8E6
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 16:09:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233715AbhKKPMX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 10:12:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233899AbhKKPMT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 10:12:19 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAC79C0613F5;
        Thu, 11 Nov 2021 07:09:30 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id u17so5962961plg.9;
        Thu, 11 Nov 2021 07:09:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wARBVdjy78Ki5zgSlrRbIXBHuiHmJIv2mEbO4npOMh0=;
        b=ESW0416vE10IDi125y9XoRl8Q1AILrQVd33mETZV5Rp7APUmtHFWalFB9XmMIPZN+3
         H7sxBwNnU3vSS53JCMNAsPa8MeF0mEmgnmaiFZDLAplh/xluaLxZnnpngGaP6/zg+zK2
         qszaWo5p7/0ga2YmPsY3ogeYDMfuPYPBDC8IQ0dqWJJLMJu9WWAkmUl9BdFEJxsj5Jn/
         5UUUNNwiROjpCDBwuOJgeKEW8iQr1kSGcDmtyY5LphrV5EfYwIjkejfI3f6qVkLsevKa
         6yItBNiqPhoxY8K8DRATsfs0NJZ55lvQ+eFcH1HOdvK2CddkZEurrrEYnwPxeFZ20SY6
         vf5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wARBVdjy78Ki5zgSlrRbIXBHuiHmJIv2mEbO4npOMh0=;
        b=2x+iYEp9lQYl3N+fw+sTFz7d8kVbPtfdKNuDTVVf6fjiQIxNN2165rM9PO5Ys603gB
         T3CUz8+HznbrmF6WZJPHb7Ue5UHTjJJOWRnX7er7kKAzUYk/0rb63ogpt8OmfbJ8VuS4
         7T2qrRrT4BvrfOBlr5NlAQx9UPnx5RY0j6VR9QzTwQGLTKVuizllkbiHc8W+FOx61Kbj
         cU7yADuwgi5E5C/rr3dFcdlOdb8rdxmd/mDIPnhK4GnPiW3ji2xfmk2UNWF3tP4KS/Y/
         AxOQypG1GvMuAb+6VpAsEIwHh5E9DQSNAl1Fo9N7cobNBg5PTji6somqZhARHe66TXRV
         7SPg==
X-Gm-Message-State: AOAM532TbmHSqSlt6mDPfMjR70mQIPXzaXX8Xf1lJJ9SEUjiNqCKcc9b
        V9NZQlWI/vHnvl9xDyP+gJQ=
X-Google-Smtp-Source: ABdhPJwKoSnTWzEbQzrzy0Yv/LSkNWw5AzN47+w3Ent+iNKJznVHyGcAXEYEZ0RPRn0Qz6HXXpxqIg==
X-Received: by 2002:a17:90b:4a0f:: with SMTP id kk15mr8761363pjb.223.1636643370300;
        Thu, 11 Nov 2021 07:09:30 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id h12sm3675599pfv.117.2021.11.11.07.09.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 07:09:29 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: luo.penghao@zte.com.cn
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, luo penghao <luo.penghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH linux-next] ipv6: Remove duplicate statements
Date:   Thu, 11 Nov 2021 15:09:24 +0000
Message-Id: <20211111150924.2576-1-luo.penghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: luo penghao <luo.penghao@zte.com.cn>

This statement is repeated with the initialization statement

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: luo penghao <luo.penghao@zte.com.cn>
---
 net/ipv6/exthdrs.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
index 3a871a0..e7e955d 100644
--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -686,7 +686,6 @@ static int ipv6_rthdr_rcv(struct sk_buff *skb)
 	struct net *net = dev_net(skb->dev);
 	int accept_source_route = net->ipv6.devconf_all->accept_source_route;
 
-	idev = __in6_dev_get(skb->dev);
 	if (idev && accept_source_route > idev->cnf.accept_source_route)
 		accept_source_route = idev->cnf.accept_source_route;
 
-- 
2.15.2


