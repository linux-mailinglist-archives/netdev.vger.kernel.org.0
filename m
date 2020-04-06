Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE3B1A007C
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 23:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbgDFVwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 17:52:42 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42510 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbgDFVwl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 17:52:41 -0400
Received: by mail-wr1-f66.google.com with SMTP id h15so1351592wrx.9
        for <netdev@vger.kernel.org>; Mon, 06 Apr 2020 14:52:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zB1NSRQYvEfwBZPNE/8IfnahdRjVFm34I8yx81t7+H8=;
        b=ImKKTKp3YwPINq3FWiVrj7gXE18eMdO3lDCQzZWZFiNZMZ6bwopVOhIrAjmmatLP/s
         Ev64ylES48nohybKC1p0u1MlWl1Jgj4hUoxPmwNdWHxPazUDRppTpw3n5LHJDTRKrDit
         lUoMzpE//RTXXxrWjQSB6zfcbciDBSJR81j7RNzTFpKsrUycVVg9LiVVSywKY9+IzjCi
         e8D/x/n7uYrlMfFQm5YdrGmhpBYjjP4YLHzX4aHBIl3DpxfXyutU6InWj0rTLBwMP+eL
         d3ZqZXEyeQECh950NGNPV/YuSEN+BsEgxPMBXAii/HZegiMTfY15ptc+JBN50aPHYrAH
         EXUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zB1NSRQYvEfwBZPNE/8IfnahdRjVFm34I8yx81t7+H8=;
        b=hMdEP91PwWRdYe0krUdtPTEZiYsnpMmcAE3T5yhH8H9p4J0WbO6oEC9PP//w+2O0ds
         wsqAIRWXJEEdOAdza0rqrhq3MK3g0BBDX8am9OWt/t4ZIOZkVCQeTlw16Y+FKoGTm+Gv
         eRYzB8ZCBCxUTf8/H9+H1GQlqJmpKaGRwapb0PQSmPuSFtxBTKAASIRsySiySppvwoQE
         6+MSaKRCyIoRwlu/jJJDqiOb+Z/qeF9ws76GHLqe1xUwO1R8YnuADifgL3OuqRzqzRNC
         w0VpeYfehyrVx2LlAkjPT3PL9c/anxfwRRvQRI2fGEV1X1Zk3+BcfwIOoiOKKZwFwhXZ
         zrqg==
X-Gm-Message-State: AGi0PuaE7r5PZK0ON3kdzo90vv1cjJ/fQ7gbHkGBPXVLEC+C5s5r00UO
        gl/wWAh5x+6J42U/TQBJz5ZwLH4fbnQ=
X-Google-Smtp-Source: APiQypL1AeP3tuBfY/xOocjqcaJGXmWJIalc80mmVl8eT41om5sNsio0i4NVj8jOMHGjP3+LeuEaJA==
X-Received: by 2002:a5d:6310:: with SMTP id i16mr1347547wru.244.1586209959686;
        Mon, 06 Apr 2020 14:52:39 -0700 (PDT)
Received: from de0709bef958.v.cablecom.net ([185.104.184.118])
        by smtp.gmail.com with ESMTPSA id w15sm18218199wra.25.2020.04.06.14.52.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Apr 2020 14:52:39 -0700 (PDT)
From:   Lothar Rubusch <l.rubusch@gmail.com>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, Lothar Rubusch <l.rubusch@gmail.com>
Subject: [PATCH] Documentation: sock.h - fix warnings
Date:   Mon,  6 Apr 2020 21:52:30 +0000
Message-Id: <20200406215230.21758-1-l.rubusch@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix some sphinx warnings at 'make htmldocs'.

Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
---
 include/net/sock.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 6d84784d33fa..2924bcbbd402 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2554,8 +2554,8 @@ sk_is_refcounted(struct sock *sk)
 
 /**
  * skb_steal_sock
- * @skb to steal the socket from
- * @refcounted is set to true if the socket is reference-counted
+ * @skb: to steal the socket from
+ * @refcounted: is set to true if the socket is reference-counted
  */
 static inline struct sock *
 skb_steal_sock(struct sk_buff *skb, bool *refcounted)
-- 
2.20.1

