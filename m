Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 942DB2D3946
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 04:36:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726288AbgLIDei (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 22:34:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725915AbgLIDei (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 22:34:38 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC3B2C0617A6;
        Tue,  8 Dec 2020 19:33:49 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id lb18so135817pjb.5;
        Tue, 08 Dec 2020 19:33:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=a83b//FaNAazZrbKxCVDpq5sDqquOZMLq79muQFPdAk=;
        b=YjwpSU8/1igV9WXVOWfx2ksH7iKlybNu4gKje6vY5aJRFrtZWHKtAOxFssptlAjnPy
         tsj/5lH9nSndDdHtRVcf+Eznr2JSQCvmXpw9bhPJ8mxc287L956Y7PFhOknFEOgnIo1n
         wxXa9GDqsTDX2nhkvIc4NQhwSjYEogqB2uIIwvbN+x58FWjTSQ7xTiGs2b/p/hqnrJcR
         BIAjolYlo9CT88D9Np7bBjunXmut9HzRQPL7lj2fEyYs1HE+4JMHkJcll1eWVAYxQHiz
         YldXcGgsARI02+CwQdljjK+utq9k24pDEOQ6h565q6SzKaP2xtD0SX/fYjrWwSbGk3F4
         BJJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=a83b//FaNAazZrbKxCVDpq5sDqquOZMLq79muQFPdAk=;
        b=tOJP820/J4i3liCjamR97N02v+P7GUMEk3YEZX00Js7StRxC+fjGFTks922M9jWuBe
         W6MmcqRh5aDP97efXGPWcmstJ7q/IrcAsQtJyn9Te5jfeSe+uEBLXfipeEpxd4A5oA5z
         Cp7zOIx+YMpmoe469uxeSaxzeUWRD+NS1aQU6LKg9zAWhQC0VBZdGAVRrE1E0u2bJN8d
         1MLI4bqSwW16Ab5eTZsLt0kW0Jd2kpCV+N9OtCRNrpd5XZvFVATkH9ATpBJ9vHkymelR
         fc9nRvdXxTT+6ymLfX1bB19rQZiwK9lTELr8NLzYN5vzd1GlMaaxMlKZAzb1o5PlFRR+
         lXNQ==
X-Gm-Message-State: AOAM532JAiqcpFA9kJLlgehvt3uRPZGTn72xq/CF4IXoWeGFUgd2sjqz
        dvcobM8ACx0BKdEAcoNoFwLQ6ELS28Q=
X-Google-Smtp-Source: ABdhPJxIddU0mSWzil8yak7Mc5Hej7XVdSdgXzsWjlsVDgkVTeFLr9SFDiGxsExLV0uqP5hDulwaQQ==
X-Received: by 2002:a17:90b:4a81:: with SMTP id lp1mr367767pjb.55.1607484829218;
        Tue, 08 Dec 2020 19:33:49 -0800 (PST)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:ac46:48a7:8096:18f5])
        by smtp.gmail.com with ESMTPSA id y5sm314371pfp.45.2020.12.08.19.33.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Dec 2020 19:33:48 -0800 (PST)
From:   Xie He <xie.he.0141@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Schiller <ms@dev.tdt.de>
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH net-next] net: x25: Remove unimplemented X.25-over-LLC code stubs
Date:   Tue,  8 Dec 2020 19:33:46 -0800
Message-Id: <20201209033346.83742-1-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to the X.25 documentation, there was a plan to implement
X.25-over-802.2-LLC. It never finished but left various code stubs in the
X.25 code. At this time it is unlikely that it would ever finish so it
may be better to remove those code stubs.

Also change the documentation to make it clear that this is not a ongoing
plan anymore. Change words like "will" to "could", "would", etc.

Cc: Martin Schiller <ms@dev.tdt.de>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
---
 Documentation/networking/x25.rst | 12 +++++-------
 net/x25/af_x25.c                 |  6 +-----
 net/x25/x25_dev.c                | 13 -------------
 net/x25/x25_route.c              |  7 +------
 4 files changed, 7 insertions(+), 31 deletions(-)

diff --git a/Documentation/networking/x25.rst b/Documentation/networking/x25.rst
index 00e45d384ba0..e11d9ebdf9a3 100644
--- a/Documentation/networking/x25.rst
+++ b/Documentation/networking/x25.rst
@@ -19,13 +19,11 @@ implementation of LAPB. Therefore the LAPB modules would be called by
 unintelligent X.25 card drivers and not by intelligent ones, this would
 provide a uniform device driver interface, and simplify configuration.
 
-To confuse matters a little, an 802.2 LLC implementation for Linux is being
-written which will allow X.25 to be run over an Ethernet (or Token Ring) and
-conform with the JNT "Pink Book", this will have a different interface to
-the Packet Layer but there will be no confusion since the class of device
-being served by the LLC will be completely separate from LAPB. The LLC
-implementation is being done as part of another protocol project (SNA) and
-by a different author.
+To confuse matters a little, an 802.2 LLC implementation is also possible
+which could allow X.25 to be run over an Ethernet (or Token Ring) and
+conform with the JNT "Pink Book", this would have a different interface to
+the Packet Layer but there would be no confusion since the class of device
+being served by the LLC would be completely separate from LAPB.
 
 Just when you thought that it could not become more confusing, another
 option appeared, XOT. This allows X.25 Packet Layer frames to operate over
diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
index d41fffb2507b..ff687b97b2d9 100644
--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -211,11 +211,7 @@ static int x25_device_event(struct notifier_block *this, unsigned long event,
 	if (!net_eq(dev_net(dev), &init_net))
 		return NOTIFY_DONE;
 
-	if (dev->type == ARPHRD_X25
-#if IS_ENABLED(CONFIG_LLC)
-	 || dev->type == ARPHRD_ETHER
-#endif
-	 ) {
+	if (dev->type == ARPHRD_X25) {
 		switch (event) {
 		case NETDEV_REGISTER:
 		case NETDEV_POST_TYPE_CHANGE:
diff --git a/net/x25/x25_dev.c b/net/x25/x25_dev.c
index 25bf72ee6cad..5259ef8f5242 100644
--- a/net/x25/x25_dev.c
+++ b/net/x25/x25_dev.c
@@ -160,10 +160,6 @@ void x25_establish_link(struct x25_neigh *nb)
 		*ptr = X25_IFACE_CONNECT;
 		break;
 
-#if IS_ENABLED(CONFIG_LLC)
-	case ARPHRD_ETHER:
-		return;
-#endif
 	default:
 		return;
 	}
@@ -179,10 +175,6 @@ void x25_terminate_link(struct x25_neigh *nb)
 	struct sk_buff *skb;
 	unsigned char *ptr;
 
-#if IS_ENABLED(CONFIG_LLC)
-	if (nb->dev->type == ARPHRD_ETHER)
-		return;
-#endif
 	if (nb->dev->type != ARPHRD_X25)
 		return;
 
@@ -212,11 +204,6 @@ void x25_send_frame(struct sk_buff *skb, struct x25_neigh *nb)
 		*dptr = X25_IFACE_DATA;
 		break;
 
-#if IS_ENABLED(CONFIG_LLC)
-	case ARPHRD_ETHER:
-		kfree_skb(skb);
-		return;
-#endif
 	default:
 		kfree_skb(skb);
 		return;
diff --git a/net/x25/x25_route.c b/net/x25/x25_route.c
index ec2a39e9b3e6..9fbe4bb38d94 100644
--- a/net/x25/x25_route.c
+++ b/net/x25/x25_route.c
@@ -124,12 +124,7 @@ struct net_device *x25_dev_get(char *devname)
 {
 	struct net_device *dev = dev_get_by_name(&init_net, devname);
 
-	if (dev &&
-	    (!(dev->flags & IFF_UP) || (dev->type != ARPHRD_X25
-#if IS_ENABLED(CONFIG_LLC)
-					&& dev->type != ARPHRD_ETHER
-#endif
-					))){
+	if (dev && (!(dev->flags & IFF_UP) || dev->type != ARPHRD_X25)) {
 		dev_put(dev);
 		dev = NULL;
 	}
-- 
2.27.0

