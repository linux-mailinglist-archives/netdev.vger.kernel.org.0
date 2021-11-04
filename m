Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87C01444D38
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 03:17:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbhKDCUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 22:20:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbhKDCUY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 22:20:24 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37575C061714;
        Wed,  3 Nov 2021 19:17:47 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id y4so4353657pfa.5;
        Wed, 03 Nov 2021 19:17:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0OOaW1Yl+VXnwuoDEkRgvptB+fyu81ip5VLBZg4xJ5s=;
        b=gWwHlgPsiTYAd1hZY9Pr2tqwndIm407Saq5MdfmZPZ89Si2cE4AlzutI/xlBX3htSR
         EnDfSTWniaz0g7kI/mgPjvGGuMV3ahe6cdZgd5z9+bujbHTEx6ToBcKDrmvVJjI/DUWH
         Ko3vXBtQ0AX5JHPpZmHJsOHvMgkObjBqPkjsJ6htm9yJsGLiiWQ+LYzSuh3vUfJdt1hL
         8q6BimVtNfeMopst0YcBmfvWCymtfAt1xLOrUjvqVchTMNsSiewi25+cQnznraC4q6RV
         hkYKd7BZARo75CNzw8Q/ibwBtMjuQee5sqwdlgDfzs5ACkSC55EuiGMTFqLU/uuInjzB
         s3Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0OOaW1Yl+VXnwuoDEkRgvptB+fyu81ip5VLBZg4xJ5s=;
        b=ia3MXvPijAeeErZaCtwvPFZX2wkiePblspo9t7EvfUcIP3JlW84sEbd3sZ5q9ZIr/2
         /U0Q7SwdNvH+Iu19iiG2/QDX9Lka1YtP38X4Bp2svSO2SuaNBXOV2Bh+vZ/hFD1RtVTI
         w0HzDhZZnnREYfxIiRNoM6Z0H59p58gsRdGb1ifnF4/woevkFBFF8rOPtbqkCTQSlvu+
         OiWEv+txapCuOFJ4AioURdxiBeAY1huLaErI8gKA74jk7qRvVT+fti6/z9yQj8aRNQFG
         JlWz3vIqkPYmJh13VIkX8cszGDJzdH11eUAC86JGrfEHPy3PIIAS9jTvxhuFJLdrV67t
         20Jg==
X-Gm-Message-State: AOAM532haChfYBkPDjObefu3Z1R2c+XzFgN0qJkkh4U4uGOtb6e21D/l
        cKaNm+bTYIJfk1EcVp8osXqvnwsFBg0=
X-Google-Smtp-Source: ABdhPJyOYo7Se2PBxISLeqjjTaGLUXjD3rfs55Am75ShwOrwik8aKBuQcqVp0IR7iL19/Y1oUMA26A==
X-Received: by 2002:aa7:9010:0:b0:481:1883:a3d2 with SMTP id m16-20020aa79010000000b004811883a3d2mr22721041pfo.50.1635992266758;
        Wed, 03 Nov 2021 19:17:46 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id u6sm3567844pfg.30.2021.11.03.19.17.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 19:17:46 -0700 (PDT)
From:   luo penghao <cgel.zte@gmail.com>
X-Google-Original-From: luo penghao <luo.penghao@zte.com.cn>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, luo penghao <luo.penghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH linux-next] ipv4: Remove useless assignments
Date:   Thu,  4 Nov 2021 02:17:32 +0000
Message-Id: <20211104021732.29822-1-luo.penghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The assigned local variables will not be used next, so this statement
should be deleted.

The clang_analyzer complains as follows:

net/ipv4/ipconfig.c:1037:2 warning:

Value stored to 'h' is never read

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


