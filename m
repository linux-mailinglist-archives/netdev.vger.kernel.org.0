Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC1AF26FF3A
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 15:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbgIRN4W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 09:56:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgIRN4W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 09:56:22 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54CE4C0613CE;
        Fri, 18 Sep 2020 06:56:22 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id mm21so3211110pjb.4;
        Fri, 18 Sep 2020 06:56:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=e50txI21qxCOlSZEE/s+KXBs121bkQlo+YOTZFWgT4Q=;
        b=ol79raY7QT6yuZbVEC8ss5TbRNg/D6VHGtP71k7PLl/RvjMhwvOBnBc77dZdmiAQae
         uGDOIgAgii96oZxF49vtTJv86Zodq6Jdz+pZfGF0QdUKVfzwBTnVuVqGz1RO2I/s4dEO
         n+xaonQ2FMcEgL93C8luOrgIjN3F1FgNDk+eiexRQDDHPbdtanOKFV1+SAkuVDx5gYVn
         5b7nJd35Ea9rYOEha5Xa3cgpeWPawVkaSqJ55YjMmL4l/49zdAnOPDFCfXj9nHGD1Wzl
         pDEv16PMkEffvUuzbSxDUnimW362oVAo9tXneta1xyKz7pqxpXNAJbnv2wBGHHwIlTQH
         DVcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=e50txI21qxCOlSZEE/s+KXBs121bkQlo+YOTZFWgT4Q=;
        b=AuuQrSeIpRf4m+7jgiZQyw8y73F6+0a47NsfgKMeZFnoNP7IXTjVukBTWls9RyUb83
         Un8TcspnsU/IXBtHkE9PN5HXIqEtlifWoAs42aNZGpmNkCQ13rGGS20J+rmO6wOhiXmL
         lflNZ23CP8KD7TF4nucbqw0RB4BPwFO+PyYvUeV0euAq6lYgh7SA3sC3hm7BDGcVP+aQ
         QmSYY33EbGeyFpR6J2Vm8i3kBw9ctPRs6LrahMfd8m5j9Bx+vFdivoQnTpSs1iRktNBO
         uGRb0ySAj3vScjWnvSskrAcIic5Wu/sENxTQqZ4puCFn3vSTnbLz5dCmOqz6aGo/bR0x
         99Fg==
X-Gm-Message-State: AOAM532RvET26I6X9ftEJwiuUyxGOVwHsn31Z4q87MNBKZUv+BPtQqNI
        ZbbbTAHBzY2exgMUU0vyp+0=
X-Google-Smtp-Source: ABdhPJwLkAxgojWnrZX3yOs2JsVG9eiToCOYAcxB+sHd8LxKfK/VXr+TWs7qMk+xzG0S048RUECdJA==
X-Received: by 2002:a17:902:aa49:b029:d0:cbe1:e7b3 with SMTP id c9-20020a170902aa49b02900d0cbe1e7b3mr33675444plr.36.1600437381635;
        Fri, 18 Sep 2020 06:56:21 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:8c72:c180:8ad1:6676])
        by smtp.gmail.com with ESMTPSA id u15sm3480867pfm.61.2020.09.18.06.56.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2020 06:56:21 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH net-next] net/packet: Fix a comment about network_header
Date:   Fri, 18 Sep 2020 06:56:16 -0700
Message-Id: <20200918135616.8677-1-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

skb->nh.raw has been renamed as skb->network_header in 2007, in
commit b0e380b1d8a8 ("[SK_BUFF]: unions of just one member don't get
                      anything done, kill them")

So here we change it to the new name.

Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
---
 net/packet/af_packet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index f59fa26d4826..cefbd50c1090 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -142,7 +142,7 @@ dev->header_ops == NULL (ll header is invisible to us)
    mac_header -> data
    data       -> data
 
-   We should set nh.raw on output to correct posistion,
+   We should set network_header on output to the correct position,
    packet classifier depends on it.
  */
 
-- 
2.25.1

