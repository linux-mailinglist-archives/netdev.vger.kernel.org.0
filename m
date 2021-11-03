Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AEE7443D64
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 07:46:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231940AbhKCGtD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 02:49:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbhKCGs7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 02:48:59 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F8CAC061714;
        Tue,  2 Nov 2021 23:46:23 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id 75so1572470pga.3;
        Tue, 02 Nov 2021 23:46:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pI36R+MtK4DFuDKTdniIaZGYlSfnURuzUDb6Loihijg=;
        b=lTas3Zult9s5ThjdA295A+MwfeiN21Jq/UkfEIFriI9B5VbYqamL3YwDLjLBhSREap
         IHOHQlrFUYQC7TsQDXzikUn6p/CRraNNeM40AIQolYhOVY4BrfffH/IH57ZH6AWy+I1Z
         sYCiBHOX02iho1t4FzKDGYZ4uDJ4PY63qwIS1scZ4Pqw0q8V6m9pN6A8ogib+CE0GF3F
         QNThWUw+g5lgx1qYK23z10CRxXe0A62zSjpsHUTZxT/tXrt5z+wcs9dQ8v1f9NvtbZqn
         rMi66y/3knd4+FWQpsCDibNG+LfYEOQ0TBCkUMrE++X/rUFizQx0zmaQ09o5pqv2XDU8
         YNpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pI36R+MtK4DFuDKTdniIaZGYlSfnURuzUDb6Loihijg=;
        b=5xkhm3U/zGOldlsttbVPgQRRzZOxzPbAB5agqYUk2JzB0ls6vuly5PcFf4yL79uYGM
         PU26Hqeb/yHoQZ1mgcx2Ld3LrjOFYUGGL0jn0kTOdJkF8ln7tqULF2L9YX4Ac3BK/Eg9
         SGV9QZg/s4yufxq50jVuYQZQm1YBogywCogvApY7nOGP9z92SWpp2ZCsCMcifEOPHVBM
         8yjdoeAHcBEasiMlCvlq/EGg9LXsxRkJsUchn6QLu7lCZQjk8M5TRSGkI+htoVXsyI6N
         4owb5BRmx0pHXNYB9keuq6E3x8LbcHXWNzB95KEM6CUYDl49iSTPq1mjZMF8IoyTBgAT
         dxRw==
X-Gm-Message-State: AOAM533wrfOAkA0L0HNZgtX5tp8tpQW6I+Ii01PSQDFhLWjfpkX7t/qq
        Y+R+IBuG79RpK/t62/PL+0A=
X-Google-Smtp-Source: ABdhPJzm67tjFDmosp6HWn3lMGapj+xYhNxcXqcHZbyh5bCcbHrtnz4FGAZIl7MbRUXwmPcZLowl2Q==
X-Received: by 2002:a62:e719:0:b0:480:a0ab:c6bc with SMTP id s25-20020a62e719000000b00480a0abc6bcmr26876752pfh.79.1635921982739;
        Tue, 02 Nov 2021 23:46:22 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id e12sm943377pgv.82.2021.11.02.23.46.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Nov 2021 23:46:22 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: zhang.mingyu@zte.com.cn
To:     davem@davemloft.net
Cc:     yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhang Mingyu <zhang.mingyu@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] net:ipv6:Remove unneeded semicolon
Date:   Wed,  3 Nov 2021 06:46:17 +0000
Message-Id: <20211103064617.27021-1-zhang.mingyu@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhang Mingyu <zhang.mingyu@zte.com.cn>

Eliminate the following coccinelle check warning:
net/ipv6/seg6.c:381:2-3

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Zhang Mingyu <zhang.mingyu@zte.com.cn>
---
 net/ipv6/seg6.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/seg6.c b/net/ipv6/seg6.c
index 5daa1c3ed83b..a8b5784afb1a 100644
--- a/net/ipv6/seg6.c
+++ b/net/ipv6/seg6.c
@@ -378,7 +378,7 @@ static int __net_init seg6_net_init(struct net *net)
 		kfree(rcu_dereference_raw(sdata->tun_src));
 		kfree(sdata);
 		return -ENOMEM;
-	};
+	}
 #endif
 
 	return 0;
-- 
2.25.1

