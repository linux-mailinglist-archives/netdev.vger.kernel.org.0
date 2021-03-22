Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94823343694
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 03:21:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbhCVCRo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 22:17:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbhCVCRX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Mar 2021 22:17:23 -0400
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3D50C061574;
        Sun, 21 Mar 2021 19:17:22 -0700 (PDT)
Received: by mail-qv1-xf31.google.com with SMTP id t5so7989602qvs.5;
        Sun, 21 Mar 2021 19:17:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QO6Y8KGOnYu06lVAiS4fDOAD9bsZot07l6boarZdoRY=;
        b=o1iGO2JBwLKliQVrWKMhzDX2ychX6hmeU/Wxx2MFhi3cr9swCXaomu3M3rESmwNOwZ
         njG12FktHdplLdFvRpL2GUfPWnyWgjJWbwMIuyvvJC2sFmePHE1Co6fZ64Pk9MJamWuv
         nJwoD/R0bmJnxkIoTLnlrwQsj+4XMwcPwSVAl69ExpxQXTb/vK/qxCecxQkGyzPSghFB
         ZYySTmHZdXcAqPLaTcygkpKyHsCEZuL6I1cis3976lMSE8ulLsX9p4WbPuH2kuUww2N6
         nh8tgy7OGVQW3mdxLlWYF+bJwCij0oTU1UjHRIlEA0VTG2c8+ENd67ucZeWIa70QY1Cd
         oR0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QO6Y8KGOnYu06lVAiS4fDOAD9bsZot07l6boarZdoRY=;
        b=RmzOm/iyS4tLr8u5MYktHsMTx25yWGX1LGrZrJReRFeNyY0LtYjHtwqgdEZ3WiATBT
         jvxiXjXdpur2kNHtijZEvXgjOjnXp+TDOan3EKxis2CzSsaSZjcypC8BIERnPsvks++S
         qVETmOlc+ha6tYowmtZl9R9ZmNxl7bXrAtal2RLFQMMgiauL9318XK5KXUdGVyMu4ysa
         R22AJbqXQJEO9RtJNWZk9u2ZGbEXR0Ieccpo5Q5A3/MS8ITQMZZqoXK7fxwkzaViIApB
         PXUdaaUOJ2MjZf4sbQGXlHRTJGNocRU9S+dnse6CsqRN4anwzhi8cy2vop4a+fxHE5d/
         Ka/w==
X-Gm-Message-State: AOAM5331ghCKY1ICNSmHAgcgofqASBll3xWGQlxmE8z4nuBnk0Oz2Vpo
        l5h/JsqSFK68AkobV+CNUvE=
X-Google-Smtp-Source: ABdhPJwOh0dCChOUKXjPO9DNcVbUNLoaxkQ9ie5eM2R+5PQBqpM3J0iufyRftUPTtqYr4HproMZCQA==
X-Received: by 2002:a0c:f950:: with SMTP id i16mr19141087qvo.54.1616379441919;
        Sun, 21 Mar 2021 19:17:21 -0700 (PDT)
Received: from localhost.localdomain ([156.146.54.190])
        by smtp.gmail.com with ESMTPSA id 77sm10116563qko.48.2021.03.21.19.17.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Mar 2021 19:17:21 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     pshelar@ovn.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, dev@openvswitch.org,
        linux-kernel@vger.kernel.org
Cc:     rdunlap@infradead.org, Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: [PATCH] openvswitch: Fix a typo
Date:   Mon, 22 Mar 2021 07:47:08 +0530
Message-Id: <20210322021708.3687398-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


s/subsytem/subsystem/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 net/openvswitch/vport.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/openvswitch/vport.h b/net/openvswitch/vport.h
index 1eb7495ac5b4..8a930ca6d6b1 100644
--- a/net/openvswitch/vport.h
+++ b/net/openvswitch/vport.h
@@ -20,7 +20,7 @@
 struct vport;
 struct vport_parms;

-/* The following definitions are for users of the vport subsytem: */
+/* The following definitions are for users of the vport subsystem: */

 int ovs_vport_init(void);
 void ovs_vport_exit(void);
--
2.31.0

