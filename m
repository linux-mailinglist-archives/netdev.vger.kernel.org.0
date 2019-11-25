Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2B5B1095DC
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 23:53:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727200AbfKYWwz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 17:52:55 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46798 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbfKYWwz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 17:52:55 -0500
Received: by mail-wr1-f65.google.com with SMTP id z7so16733839wrl.13;
        Mon, 25 Nov 2019 14:52:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KptWbyZabaLucCpyXjZ1u4NhChnSG9+WDqnEB5rW2AQ=;
        b=FiYbSb+h4Jhogduw+nEQ65ArHx4LR3FAO71An25+A3J1R7ohdp468z4Zh4hEHYgc83
         dPiAOAoy5TwyltsdGVSUI4EnCEYw9eJjMFwO7JU8gavjLcLWpfaR+jxq+FxPNzY0xUA6
         89+mvzi7aS43B9KgYDqCm4JC5FGndPbJCah01WZNgt+vrPM+6Y7/zEmMVEUko8Mi4Q8I
         H9KF1/MTG72yd4CkMJohJjyBt3w6K2rnoOVNDyd/MSku+GwgjyCWys50tLGERhPXNzXi
         S0f36xTIVr+ugYFRhMe8V1iPcEVid+ooThZ8i08rvucMKYJ2r8kPBEuI9uOIAhl6gndY
         mgAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KptWbyZabaLucCpyXjZ1u4NhChnSG9+WDqnEB5rW2AQ=;
        b=KRzzI4pCGg4jxQX1FcLod+0GLHQAfiXLs/Pgqrqx0MVqLyUUItt9z+WnjF+qHCswX4
         i6/X6y8eqEVmUvPzVnAKRSnci0gdA5Acia5BlgwozX29OXTVXeSGQtL+N4opuANLVKTx
         TNsR31Sx1raCAZCBFQqe3lio0tSE2eHTmgTq+G2NtWM/UJPFcaVeDu++Skt7EGVmaSUc
         oFLXQxiXwF4650Z7ehO58THm1gY67Pw+eITOvG/MM2+6vE5MeJEJU1/L7jxU9aByeG2y
         Ew1ZEx1joi9Dz5jFIkDlq5Dqzy8jQ1ujaW8IocF1G+eCcyuEOGtKB3vDUDr5AvGonZzi
         7eJw==
X-Gm-Message-State: APjAAAXI0/3sQTtVOLAN6TDoRvYHf/ZCT1eqzRO3LPnXJGiaLAHvrezS
        BhXgtWSdOj9fCYV/EuR8NA==
X-Google-Smtp-Source: APXvYqw2YE62y4OIk3k+fYmO9Vr0gZIGMKu6p+eRmBOh2OmIg3FWQTGpDGn3MQga1mPriXhHXz5Rzg==
X-Received: by 2002:adf:f20b:: with SMTP id p11mr22843661wro.195.1574722372900;
        Mon, 25 Nov 2019 14:52:52 -0800 (PST)
Received: from ninjahub.lan (host-2-102-12-67.as13285.net. [2.102.12.67])
        by smtp.googlemail.com with ESMTPSA id v128sm948599wmb.14.2019.11.25.14.52.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Nov 2019 14:52:52 -0800 (PST)
From:   Jules Irenge <jbi.octave@gmail.com>
To:     trond.myklebust@hammerspace.com
Cc:     anna.schumaker@netapp.com, davem@davemloft.net,
        linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jules Irenge <jbi.octave@gmail.com>
Subject: [PATCH] net: sunrpc:  replace 0 with NULL
Date:   Mon, 25 Nov 2019 22:52:39 +0000
Message-Id: <20191125225239.384343-1-jbi.octave@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace 0 with NULL to fix warning detected by sparse tool.
warning: Using plain integer as NULL pointer

Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
---
 net/sunrpc/xprtsock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 70e52f567b2a..74d4ca06d572 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -614,7 +614,7 @@ xs_read_stream_reply(struct sock_xprt *transport, struct msghdr *msg, int flags)
 static ssize_t
 xs_read_stream(struct sock_xprt *transport, int flags)
 {
-	struct msghdr msg = { 0 };
+	struct msghdr msg = { NULL };
 	size_t want, read = 0;
 	ssize_t ret = 0;
 
-- 
2.23.0

