Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FD5326C898
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 20:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728216AbgIPSxt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 14:53:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727605AbgIPR6I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 13:58:08 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B032C02526E;
        Wed, 16 Sep 2020 05:23:14 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id k8so518777pfk.2;
        Wed, 16 Sep 2020 05:23:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SO0Ex4Ya6mRvIxqSXq6/Ym0CZ/B5t5LeMXgsGfBB4Fc=;
        b=novr6WWX8fdVkdvdJeDqfgQgieWTgpBpGyXMKup4fVRcSP0NVo27LvsQgKul+MpioA
         C87TFhwVaOBEOlcAM6necJHJHfTXkVKqFJBqBM0l4dHus9+IpWRE+u2+OL6hj1TtFjDC
         EjIYsqQFKHaDneM1iTj2tpJ7HzQuulJU+a8OhbOmw5DGBTOymAB8XSN3aF7knZxk+gDD
         4gM+oWa8xQClRjRdObPiX1MTlcwxPuVu2RE3tzdUekRq58J4VVC4ZlbdkBWJ9nKJikf3
         pJiM1BMHLAUkCO1SHEfhcXBEaNzmPSvhhudbykDEe4kwK4NmseJgJw9aZlDvCUp1U7iq
         sfEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SO0Ex4Ya6mRvIxqSXq6/Ym0CZ/B5t5LeMXgsGfBB4Fc=;
        b=LintwFUS8ibPH8dQgdOPBdqKa8m9HD8qcPPOEI5CItTMU2q7eYu8AWc5IYfuvE9PZq
         jkiA551fyJhnG+QGeum+GlgLlr3KxqW+l7lRTPDMb+TrVeh1KD3WIQ7v7gqsf4A4L4CG
         vK4DWx0X2gTVN6gh4duAfwrrQ2O1up/VjXmfpcANV0eCUzLACAFGGL+hfq/CvIgpi+xl
         WZwZQIZWP3N+fM1muHIURnnge5HH4vTHe6kvysupdWAU7v+7MFoxXw4gYARLtCdmOui1
         BSPCwHfVWmwc466YWKwtYCD+zN6p89G6agy4bD/3QFwUjNVl5vnPubqQycknxLUoqcCW
         WuNQ==
X-Gm-Message-State: AOAM532BJoOJ5/SYoOjVhhvftFuT11jyz0/bDRWtsCdVVUcUmhP7wA8v
        Yhs5qZ4nLHoOOQkBxJQsUPU=
X-Google-Smtp-Source: ABdhPJxKuaW/PLmdWfNmMICKBuNfnQtk22cI3eWSLMn8CZO3nteLRn4T87oOg934C0TnONScFhiicA==
X-Received: by 2002:a63:5ec5:: with SMTP id s188mr18361332pgb.218.1600258992545;
        Wed, 16 Sep 2020 05:23:12 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:29a5:9632:a091:4adb])
        by smtp.gmail.com with ESMTPSA id n21sm14796147pgl.7.2020.09.16.05.23.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2020 05:23:11 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        John Ogness <john.ogness@linutronix.de>,
        Wang Hai <wanghai38@huawei.com>, Arnd Bergmann <arnd@arndb.de>
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH net-next] net/packet: Fix a comment about mac_header
Date:   Wed, 16 Sep 2020 05:23:08 -0700
Message-Id: <20200916122308.11678-1-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1. Change all "dev->hard_header" to "dev->header_ops"

2. On receiving incoming frames when header_ops == NULL:

The comment only says what is wrong, but doesn't say what is right.
This patch changes the comment to make it clear what is right.

3. On transmitting and receiving outgoing frames when header_ops == NULL:

The comment explains that the LL header will be later added by the driver.

However, I think it's better to simply say that the LL header is invisible
to us. This phrasing is better from a software engineering perspective,
because this makes it clear that what happens in the driver should be
hidden from us and we should not care about what happens internally in the
driver.

4. On resuming the LL header (for RAW frames) when header_ops == NULL:

The comment says we are "unlikely" to restore the LL header.

However, we should say that we are "unable" to restore it.
It's not possible (rather than not likely) to restore it, because:

1) There is no way for us to restore because the LL header internally
processed by the driver should be invisible to us.

2) In function packet_rcv and tpacket_rcv, the code only tries to restore
the LL header when header_ops != NULL.

Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
---
 net/packet/af_packet.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 2d5d5fbb435c..f59fa26d4826 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -105,42 +105,43 @@
    - packet socket receives packets with pulled ll header,
      so that SOCK_RAW should push it back.
 
 On receive:
 -----------
 
-Incoming, dev->hard_header!=NULL
+Incoming, dev->header_ops != NULL
    mac_header -> ll header
    data       -> data
 
-Outgoing, dev->hard_header!=NULL
+Outgoing, dev->header_ops != NULL
    mac_header -> ll header
    data       -> ll header
 
-Incoming, dev->hard_header==NULL
-   mac_header -> UNKNOWN position. It is very likely, that it points to ll
-		 header.  PPP makes it, that is wrong, because introduce
-		 assymetry between rx and tx paths.
+Incoming, dev->header_ops == NULL
+   mac_header -> data
+     However drivers often make it point to the ll header.
+     This is incorrect because the ll header should be invisible to us.
    data       -> data
 
-Outgoing, dev->hard_header==NULL
-   mac_header -> data. ll header is still not built!
+Outgoing, dev->header_ops == NULL
+   mac_header -> data. ll header is invisible to us.
    data       -> data
 
 Resume
-  If dev->hard_header==NULL we are unlikely to restore sensible ll header.
+  If dev->header_ops == NULL we are unable to restore the ll header,
+    because it is invisible to us.
 
 
 On transmit:
 ------------
 
-dev->hard_header != NULL
+dev->header_ops != NULL
    mac_header -> ll header
    data       -> ll header
 
-dev->hard_header == NULL (ll header is added by device, we cannot control it)
+dev->header_ops == NULL (ll header is invisible to us)
    mac_header -> data
    data       -> data
 
    We should set nh.raw on output to correct posistion,
    packet classifier depends on it.
  */
-- 
2.25.1

