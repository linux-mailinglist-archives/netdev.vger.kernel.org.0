Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16D04444D74
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 04:03:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbhKDDFe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 23:05:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbhKDDFd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 23:05:33 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47EF1C061714;
        Wed,  3 Nov 2021 20:02:56 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id u17so4896804plg.9;
        Wed, 03 Nov 2021 20:02:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8TcziieSeJt2XzZbAoNFqSo9KPYA6B681Bs/Zj9nsrk=;
        b=GqWwdjaPX9g1LbZMFrN9/ZUb+6tXZyrRrc5BMW2Lz+on6zAAqJomTgqsNC0wVyM8O2
         Y4J2MZs5v9uCc6IUqIxDYk327HQ2pN3whrwn19UQ1Gs6rB1eTzW5y4X5ZnHOUtQoYDf/
         eD3hUfLjHZp+0nGKG25leI6XzZEvdIYZ4oPOReFybMKInGL9AwNw8CKsjGNG9BWRZE83
         Rsj87W5FnI0R1k6aFQLU8BaoZcfjU/1fpaohWQpkaaY+td+7qguy/3xFlBoOmlBr7t4e
         G9WPPOvusAismJZ6jghViwwsXGif9n+BgJunQsoLRGwKkrm3lA210sL/9iDEr99eJ1sI
         tkMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8TcziieSeJt2XzZbAoNFqSo9KPYA6B681Bs/Zj9nsrk=;
        b=VQgNh7dYtLrnRQlsGK8a7TqlNOYbOZZUotEZxOfChxAx/i3cR0jSYKRMPEoeYsBsd0
         rOgFR6tIGOfl9H+jwqYU+DZ5l3qmhWZPOq8FXgoWKk1Piwt8+5981Sv3O2g1hEtfNcLK
         1ToiyCerp/XWBlwXcoXBYrGQUaTzFdIk4CZKlhKpRowOZ5KrVsO0qLg+yHV0Po1gT3EW
         Tar5HOyov/Jw1Z/WrxooUGbJzbPygUAJDuvb1NUPScHVu0SIOjjrL6Rvuu+Pf+yB3FBR
         y5nl5C3i5UYtgvoq9GxuMN6ZCgTLdvN0DCshU+cIU40gejpSsVXpgYMmHOhM0Y8y2f4F
         aQUg==
X-Gm-Message-State: AOAM532Coja7v9RpQvdkYcxklLwfYVCQN/K3Stz/510+qrQVG1B7BrwM
        UCIIcfa1C+gd/GANi2Xj3LYWdYLsvd0=
X-Google-Smtp-Source: ABdhPJy6Z/KboUdfCUyfnYDryfgHTkZx3YMOYC6uN8AvX7aAJ4jSxhO+Sltxv6NZwElAyrn66kbv5w==
X-Received: by 2002:a17:902:bf07:b0:138:e32d:9f2e with SMTP id bi7-20020a170902bf0700b00138e32d9f2emr41283567plb.59.1635994975742;
        Wed, 03 Nov 2021 20:02:55 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id h3sm6259078pjz.43.2021.11.03.20.02.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 20:02:54 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: luo.penghao@zte.com.cn
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, luo penghao <luo.penghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH v2] ipv4: Remove useless assignments
Date:   Thu,  4 Nov 2021 03:02:22 +0000
Message-Id: <20211104030222.30580-1-luo.penghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: luo penghao <luo.penghao@zte.com.cn>

From: luo penghao <luo.penghao@zte.com.cn>

The assigned local variables will not be used next, so this statement
should be deleted.

The clang_analyzer complains as follows:

net/ipv4/ipconfig.c:1037:2 warning:

Value stored to 'h' is never read

Changes in v2:

Repair sending email box

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: luo penghao <luo.penghao@zte.com.cn>
---
 net/ipv4/ipconfig.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/ipv4/ipconfig.c b/net/ipv4/ipconfig.c
index 816d8aa..fe2c8e9 100644
--- a/net/ipv4/ipconfig.c
+++ b/net/ipv4/ipconfig.c
@@ -1034,7 +1034,6 @@ static int __init ic_bootp_recv(struct sk_buff *skb, struct net_device *dev, str
 		goto drop;
 
 	b = (struct bootp_pkt *)skb_network_header(skb);
-	h = &b->iph;
 
 	/* One reply at a time, please. */
 	spin_lock(&ic_recv_lock);
-- 
2.15.2


