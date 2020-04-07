Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 437251A1868
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 00:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726407AbgDGWzf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 18:55:35 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36100 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726406AbgDGWzf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 18:55:35 -0400
Received: by mail-wr1-f67.google.com with SMTP id k1so5741049wrm.3
        for <netdev@vger.kernel.org>; Tue, 07 Apr 2020 15:55:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qmD+rXue8qGClRxB16W8Ilg+md3Pb1jWqKxoVPMWbr8=;
        b=b+YTRX1XbTKSXyX5aU0i33xtmt9T5z/4eCqw6XQF5ywYAciKvx/UmGL0huaulk4N54
         TYtuEmxWD6DuacdFFUvsHjUTRr55SNe3H+CvBBaPqIIc7PgehuRvE32PEoZKPKpkbvoh
         D6AAxZ3a2ZnAyTd5FxV2imU226SBzh/pddh25LycW1WDDm5Oi3DqSx/yzLTsqq0wVr8X
         13/jL9OUH1P5Mn1xb+IvYQzPj/cNTU9i3NK3hjS17QkINoQlQWZjxgzWaN+tqi1GQnrv
         Wor/b2JO1N7m1hY9ww5yI+/xb/KoH4IZz7sl+hVPBJ//zL+XxwbvPm2GEj+wdFYoZG40
         tPEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qmD+rXue8qGClRxB16W8Ilg+md3Pb1jWqKxoVPMWbr8=;
        b=p1osjkP6zZ16vHIv42l61389wtNCwpRV2Glmv9lHbxmMnE2/fc32sw/OqohmDAC9TI
         xO11Q/jPZs4BghVJysAdNndMagGoougHg8lvZm6/8DGgCtgk1UtRkX7TshsbrB4ur5s1
         DbLx6p+3V5yWF2SPh78vvUtw0ijxuMIpdORk/xk/VVDU3KWuO/8hZTwtZM/lVS0dHOma
         PMrRReSy+4cy+kscj954nT/71I1A/ZWc/xx85qLff92/I3flZ77rnsVXqivc4p6xZ9Bo
         kCRPQnQ1ffIQ/husMsAFOEiPXPGrNsCziUony5eEKT9Keb+QV2IDZ70bBgqgukJS71jS
         5YXg==
X-Gm-Message-State: AGi0PuaKVhsXDzLOa0irNjO4Z57tEM2g0iDZBXMU3XU4ABCtwIke8iJA
        4dQiY716pJ+Fhk6VswNILFOhWzIxTBOkaw==
X-Google-Smtp-Source: APiQypLqnuHAluttXQUvz5l9+6WC30yM5N9s2cvVU3NTd/PDY9OHRutqd1r/pH+4PS0Yw8VEZ4/XKg==
X-Received: by 2002:adf:c506:: with SMTP id q6mr5221298wrf.142.1586300131043;
        Tue, 07 Apr 2020 15:55:31 -0700 (PDT)
Received: from de0709bef958.v.cablecom.net ([185.104.184.118])
        by smtp.gmail.com with ESMTPSA id r20sm3783455wmh.46.2020.04.07.15.55.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2020 15:55:30 -0700 (PDT)
From:   Lothar Rubusch <l.rubusch@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, rdunlap@infradead.org
Cc:     netdev@vger.kernel.org, Lothar Rubusch <l.rubusch@gmail.com>
Subject: [PATCH v2] net: sock.h: fix skb_steal_sock() kernel-doc
Date:   Tue,  7 Apr 2020 22:55:25 +0000
Message-Id: <20200407225526.16085-1-l.rubusch@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix warnings related to kernel-doc notation, and wording in
function description.

Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
---
 include/net/sock.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 6d84784d33fa..3e8c6d4b4b59 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2553,9 +2553,9 @@ sk_is_refcounted(struct sock *sk)
 }
 
 /**
- * skb_steal_sock
- * @skb to steal the socket from
- * @refcounted is set to true if the socket is reference-counted
+ * skb_steal_sock - steal a socket from an sk_buff
+ * @skb: sk_buff to steal the socket from
+ * @refcounted: is set to true if the socket is reference-counted
  */
 static inline struct sock *
 skb_steal_sock(struct sk_buff *skb, bool *refcounted)
-- 
2.20.1

