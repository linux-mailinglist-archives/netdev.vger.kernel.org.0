Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2A2346FB25
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 08:14:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237246AbhLJHSF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 02:18:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232025AbhLJHSE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 02:18:04 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 676F7C061746;
        Thu,  9 Dec 2021 23:14:30 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id g16so7330052pgi.1;
        Thu, 09 Dec 2021 23:14:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oqc3Zy153WbezVayk4lPdpOs1jpGB2UlH4cKZFhAgdg=;
        b=ESFH4dsCDOXt93W4UFBDg+bQezoPqeuYXP6ri6zG2KDfyRj7cijQrO1IDIn+mxNzl6
         WDUro+fNSfo1XdWhLx9Y4WqOweqONw7ccUZvs9lZEjvL7DKDJiSxGsXjhw5un1D/ACK7
         d6GvSk16+vkJ6kWsr72Qnx96gf4B7KCuxEkSS2u8HBH/gHgK9AwWGPYLmFNxEcotCPcO
         6DSNDTAarFM4TxVjHajJ0M3QNCS8D05rkjxih+OlXKFT+FsN+l+HFcETTVEkMoP4t0Nj
         KH35FiVmHh2WkOsrzrldfgDCSSUwWqW6GPyINafg+pvHW1MMa7ORht1SS2qSnOQCnYeB
         iomg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oqc3Zy153WbezVayk4lPdpOs1jpGB2UlH4cKZFhAgdg=;
        b=kM9rwLMWiVysualrMXKLIvuS23C9eBLr8lSCt4np28GehcLxhood8UgCDEj+uykJ7e
         mE+uQx2KivW6QghXBO0F8zBKQlET6OWYG6I14r6eTrhoNs74DQOJh/deo04XST/5wIzW
         H+ibH4XYdxZKaqtRHQVNuEbRhIvb5wpQfmcY+jW4/jeyXI36oiCK+HbZONOVg33GxkIR
         k/wsR+dKCIKOpXTjRLm9IIepLQzOJMVeZ7m4DgrNIWK3sUmdDQpG3B5b2I7jiChNoeNh
         rVKHaN+PC/EPaZG1C8L1766b6TvEnLsLMlQwX/VI13T+piLyldz8CKDB/ncZGXCPaL0z
         o72Q==
X-Gm-Message-State: AOAM533CRJs6Yi95dKCL50Ss4kpt4Z/BxoS/H08HcuO0R5skAY+BxDoe
        yrsfSMJ9Hrq1ftY2MbGYRKY=
X-Google-Smtp-Source: ABdhPJyhrSiPeGFtLudwxHIgPIzsCoNdLVarHRG7OEqB2MpYRMnkmZ395ydC03P8t6+svdx+G6RBCQ==
X-Received: by 2002:a62:6414:0:b0:4ac:9a0f:124e with SMTP id y20-20020a626414000000b004ac9a0f124emr16761728pfb.56.1639120469970;
        Thu, 09 Dec 2021 23:14:29 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id i67sm1918987pfg.189.2021.12.09.23.14.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 23:14:29 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: ye.guojin@zte.com.cn
To:     mathew.j.martineau@linux.intel.com
Cc:     matthieu.baerts@tessares.net, davem@davemloft.net, kuba@kernel.org,
        shuah@kernel.org, netdev@vger.kernel.org, mptcp@lists.linux.dev,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ye Guojin <ye.guojin@zte.com.cn>, ZealRobot <zealci@zte.com.cn>
Subject: [PATCH] selftests: mptcp: remove duplicate include in mptcp_inq.c
Date:   Fri, 10 Dec 2021 07:14:24 +0000
Message-Id: <20211210071424.425773-1-ye.guojin@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ye Guojin <ye.guojin@zte.com.cn>

'sys/ioctl.h' included in 'mptcp_inq.c' is duplicated.

Reported-by: ZealRobot <zealci@zte.com.cn>
Signed-off-by: Ye Guojin <ye.guojin@zte.com.cn>
---
 tools/testing/selftests/net/mptcp/mptcp_inq.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_inq.c b/tools/testing/selftests/net/mptcp/mptcp_inq.c
index b8debd4fb5ed..29f75e2a1116 100644
--- a/tools/testing/selftests/net/mptcp/mptcp_inq.c
+++ b/tools/testing/selftests/net/mptcp/mptcp_inq.c
@@ -17,7 +17,6 @@
 #include <unistd.h>
 #include <time.h>
 
-#include <sys/ioctl.h>
 #include <sys/ioctl.h>
 #include <sys/socket.h>
 #include <sys/types.h>
-- 
2.25.1

