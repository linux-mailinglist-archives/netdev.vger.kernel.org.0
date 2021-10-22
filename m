Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0A34437510
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 11:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232502AbhJVJxO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 05:53:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232465AbhJVJxL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 05:53:11 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6448BC061764;
        Fri, 22 Oct 2021 02:50:53 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id 187so3127228pfc.10;
        Fri, 22 Oct 2021 02:50:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DV/7C61f6fqM78yHZsRiqCOwwU+HfAoXATfWQmENNkU=;
        b=aXMXjEoEs6VoofcakCamdi3WkcuGEzRWpbCPUGhw9OKm/0CkiK7WcyAkWkwq9qDhAQ
         /idixeSZ0dXF9DGAHfdhqVaqKtqgSxFku2yRzA6xY/6JJQ8GfbV/PK5kRQGPI9TlyoIu
         47tEuX3KPB9NJMrgQTqc1Ylchol42SdMfng++vaXrpU50myGYearSaU/ztciTji3dr2I
         +KjzJEFHdpAAw19gPb3r+Yng4W3jzRywop9FThYNEfugT4jnkBi8u10TAq3UVDGYddaO
         1V6lH8HFdLWmw0xl/ARZR9TbyRNtIqj33CkBC8f+yUCjLf19FCK4MrXakb5kAN90YK3W
         QUBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DV/7C61f6fqM78yHZsRiqCOwwU+HfAoXATfWQmENNkU=;
        b=R8Zva8mZeY1XmlrgsZ2o2/IQaDOSlZ11hzreMQGhidSwx9MdiAp5uaIjzXKkPWByel
         Dqq3CkOYc3oJC2wzRWfeXVXslM8VQe3zcBJeMVds7DobbP11QMA4IIW5MyfZ/wOzWqrL
         oUQxlWXBIV9/gBmzDWfeQNACNnRBSqSnxhyLsDRn56Kq99aFXPz85ziae2RGURtSxgy0
         3LTH8J6OpEHppHhoPfQcJ74BBvmJ/uHX9pZojipbUO+XWVYyG1G1ywgJyfA+J9I8zXiL
         T877i75m3iDKGaae7YhQa2pIOmJrngJ+5MSEfmwun+KQk+dqFmAToqPrwFY5qwjYIbyG
         qSRQ==
X-Gm-Message-State: AOAM533B6gbwkKz8TzqpryqXHb3mE/KZD3JJG636chmNhx9TL4jTIzpX
        8MrJbsimAGd4BJeolKIveso=
X-Google-Smtp-Source: ABdhPJzuuduBX5UKa2o5JHEP2vtgwg5rWAjRQ5+e825Leufi8NL9GRMOfqsQcp/qLvvjH38ZhzAEnQ==
X-Received: by 2002:a05:6a00:2405:b0:3e1:9f65:9703 with SMTP id z5-20020a056a00240500b003e19f659703mr11365941pfh.6.1634896252935;
        Fri, 22 Oct 2021 02:50:52 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id f15sm10174837pfe.132.2021.10.22.02.50.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Oct 2021 02:50:52 -0700 (PDT)
From:   luo penghao <cgel.zte@gmail.com>
X-Google-Original-From: luo penghao <luo.penghao@zte.com.cn>
To:     SimonHorman <horms@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        luo penghao <luo.penghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH linux-next] net/core: Remove unused assignment and extra parentheses
Date:   Fri, 22 Oct 2021 09:50:43 +0000
Message-Id: <20211022095043.1065856-1-luo.penghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Although if_info_size is assigned, it has not been used. it should
be deleted.This will cause the double parentheses to be redundant, 
and the inner parentheses should be deleted.

The clang_analyzer complains as follows:

net/core/rtnetlink.c:3806: warning:

Although the value stored to 'if_info_size' is used in the enclosing
expression, the value is never actually read from 'if_info_size'.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: luo penghao <luo.penghao@zte.com.cn>
---
 net/core/rtnetlink.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 10e2a0e..c218ad0 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -3807,9 +3807,8 @@ struct sk_buff *rtmsg_ifinfo_build_skb(int type, struct net_device *dev,
 	struct net *net = dev_net(dev);
 	struct sk_buff *skb;
 	int err = -ENOBUFS;
-	size_t if_info_size;
 
-	skb = nlmsg_new((if_info_size = if_nlmsg_size(dev, 0)), flags);
+	skb = nlmsg_new(if_nlmsg_size(dev, 0), flags);
 	if (skb == NULL)
 		goto errout;
 
-- 
2.15.2


