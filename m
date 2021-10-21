Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 709FB435B05
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 08:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231154AbhJUGmr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 02:42:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbhJUGmr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 02:42:47 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8421DC06161C;
        Wed, 20 Oct 2021 23:40:31 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id g184so24677087pgc.6;
        Wed, 20 Oct 2021 23:40:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=P/sIz/qZqIMO/S2er8IR+h8S/x+xx/aGZWMasE4tA+c=;
        b=JcFylAM8P1zQ07C3deiI9z9ksJtGm33KFY3qB6L17ycNc17WoWYmuCDbOiaeO+ExVy
         k1OGxPKIwJOgnDFOcJUFrPWvv9VeQUGvsEfSESF3d8BNCLoA5Dcwqy0sblKrfPnZYdeM
         1c97Dy1RZ/d0RdHu8ioL7oKH7WYb0rXmPylLgxPcAFnb61tTcxnqN9G8Wavord2cjhdv
         iyN095By5Owa7wnzUiMF0t7KyXbZyB6ozrb0VLWjQleQlU43a2had0StJonOhTQEYu61
         XMms5o+HvFcTqjXc3E7sXhr3d10sZkcbvACNIcy4onrnN+ldG6TGX4T96IdHEqc4rLtM
         DiBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=P/sIz/qZqIMO/S2er8IR+h8S/x+xx/aGZWMasE4tA+c=;
        b=eGLQuDPDWPkC6NDW4ncrwjBvlOHWVsJV3fwDnrwCYVrYyxlqjvhze17DJhNFfHfuye
         O3cw6ImJ99MwH9twcS5ge59ndGL18eUFYGsPyEGUCmtmG2RjtGsm02z3ZPUnZMtGXfSY
         V9RRnI3r1nzxEXRI1kRuWB43XrDxrTOWTmQRyKB63RbwHdOmT4uG64zfu8Vzx8AnfhGb
         GzohyRvwmuJBCfcXVgg3fOIXM6B8CTaQD2iIyx3CXaUtcoV6f8mv7p+Sd0QJnicU+ujf
         wiyiBG/WAuRmFnerfR2XaydJu2i6XuNdl6WdrwTCwfNoOUvT0bYYeJxqoo5Ddy3FU0m3
         sFsA==
X-Gm-Message-State: AOAM530INnTDfwlgGyXa++rD/KWXs9BbLguWmqNOG33AngjhEATLkV0k
        uZfJ/6wosAZsFHAGKfSfCO8=
X-Google-Smtp-Source: ABdhPJyUIHhXk2TBODI4l+G8EpfZgo3uaS6HDXMeQUwt9oLpDD5H2gyrSqviubUHtHzFVbZvSbs7Gg==
X-Received: by 2002:a05:6a00:1147:b029:3e0:8c37:938e with SMTP id b7-20020a056a001147b02903e08c37938emr3680802pfm.65.1634798431011;
        Wed, 20 Oct 2021 23:40:31 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id d14sm4952292pfu.124.2021.10.20.23.40.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 23:40:30 -0700 (PDT)
From:   luo penghao <cgel.zte@gmail.com>
X-Google-Original-From: luo penghao <luo.penghao@zte.com.cn>
To:     SimonHorman <horms@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        luo penghao <luo.penghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH linux-next] net/core: Remove unused assignment operations and variable
Date:   Thu, 21 Oct 2021 06:40:20 +0000
Message-Id: <20211021064020.1047324-1-luo.penghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Although if_info_size is assigned, it has not been used. And the variable
should also be deleted.

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


