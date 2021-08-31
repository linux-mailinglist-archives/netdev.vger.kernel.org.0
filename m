Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79DD23FC683
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 13:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241308AbhHaLYt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 07:24:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbhHaLYt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 07:24:49 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4010AC061575;
        Tue, 31 Aug 2021 04:23:54 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id 17so16344494pgp.4;
        Tue, 31 Aug 2021 04:23:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Zbn1lreGZxJVDlwL+VgDbBJ+pZDFvJhr5f++SxvLVh0=;
        b=XR8yD9T9wHcxAyvbRPv0YDNjWtFk/JFZhXImSr+m5ZpXow5yRIh3jtKcNgbO+QnhGi
         335HwNRcF9Bg1erfFkWFeOvYZvJ3OYH591Sg3paye4gMpADssM5FyIWYQ884ZNVQO+Ag
         YdIF2Lvo8rcx6PoX0FglLX4WLExYEwPayJlUm9/8SPCrSUdcQe+tY2l32nMoipra0VNI
         OWil24kKEOv4NB4hk4OGc/v4O/PWUW0/9fGDFSvllGP1m93NovmIFw7qx9sIZNfOcIKq
         Se2aIAejhjhS036ctmzmJVWAYxqgPHt4KugQfchORISKFnpQ0RXvwJDzqYCEa5mXxc68
         kXIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Zbn1lreGZxJVDlwL+VgDbBJ+pZDFvJhr5f++SxvLVh0=;
        b=NkGPA0qk2RBxzf+1shS2k2jJ/IgbIYtnfc52l64cq2d72DwV93Zv1Xxnv0pNwPpPLs
         Y348RyWSys3+97DjGPAJcXRGeu4cUmvE9T99T5TzD5rQkt07a8Jl9CeHyp35uTTvBUfv
         Cu0eptZj7VltkxCSRFGne26WIY+GYCCA0Y3cPa32cVlHEhY0DkJMfdGn5cRPoCJ9P2o3
         OCbVccDnxl/gn0Socj++LqFmr1x+IfS+FQ8jvAi3BP9FXXdefrDs6Hrz8jsydUcmpgs7
         omMZFw05UMLylC1EiURvf3L7evKTdLaJPnQvzXCcyULJeAYIdbeG0ZFTCZtAjXXhzhd8
         niEg==
X-Gm-Message-State: AOAM533mIaUXPUty7B2xsc6WzUEOxUn9Kq0/mLllQmVXpBn4r7h0Code
        qtmpk1kIf4ZYR36aDwLHXEFckO56xIA=
X-Google-Smtp-Source: ABdhPJzYtwb6FOR7oypYnFTA5ItxbQ6IK8/J/j03oyquJT/7xiBkRApmYI+Y8fEJxJpp3oKO7Xf+hg==
X-Received: by 2002:a63:f050:: with SMTP id s16mr26526742pgj.258.1630409033668;
        Tue, 31 Aug 2021 04:23:53 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id c133sm17837509pfb.39.2021.08.31.04.23.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Aug 2021 04:23:53 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: lv.ruyi@zte.com.cn
To:     davem@davemloft.net
Cc:     yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lv Ruyi <lv.ruyi@zte.com.cn>, Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] ipv6: seg6: remove duplicated include
Date:   Tue, 31 Aug 2021 04:22:50 -0700
Message-Id: <20210831112250.17429-1-lv.ruyi@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lv Ruyi <lv.ruyi@zte.com.cn>

Remove all but the first include of net/lwtunnel.h from 'seg6_local.c.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Lv Ruyi <lv.ruyi@zte.com.cn>
---
 net/ipv6/seg6_local.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
index ddc8dfcd4e2b..2dc40b3f373e 100644
--- a/net/ipv6/seg6_local.c
+++ b/net/ipv6/seg6_local.c
@@ -30,7 +30,6 @@
 #include <net/seg6_local.h>
 #include <linux/etherdevice.h>
 #include <linux/bpf.h>
-#include <net/lwtunnel.h>
 #include <linux/netfilter.h>
 
 #define SEG6_F_ATTR(i)		BIT(i)
-- 
2.25.1

