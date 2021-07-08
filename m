Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8479E3C1837
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 19:33:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230120AbhGHRgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 13:36:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbhGHRgg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 13:36:36 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 422BEC06175F
        for <netdev@vger.kernel.org>; Thu,  8 Jul 2021 10:33:53 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id 14so6494729qkh.0
        for <netdev@vger.kernel.org>; Thu, 08 Jul 2021 10:33:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vt-edu.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:organization:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KLrdSvYEEX3YZrkKPq6HFsJS1XSZeD9kvdsdsDbRcDo=;
        b=IQIB//A0IcNgkHerG/VTCY4MIR8s4PgemOFT8bygqdiH7RqY0kWYAwTyTYT5RlZrwK
         N0zyXPl7b8j8grNIbAqg0AcAFvvLMt007N9UZxAwjK9MyOUulKVzzXiTj+/seZIwtEr1
         r/R+EJNTveeVTfwq6c6ZPD6zuMCJ+EFPe9GpvvcEmkPY1HODVBas/YfvGgtdJJlSlxcH
         X6Oi+15EKTAKbKO+6ic7WQ2OkD3aXmzjqr7YyUZ9zRfP4+MvK7zQB8Is8O7y+j9SPeDL
         hvYBnV0KIksMzxhE6Y05kSt0GTG+1c+ixLdCmIidsIO0HOu7ej0bjN2ju9FzOyAvx80o
         SAtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:organization
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=KLrdSvYEEX3YZrkKPq6HFsJS1XSZeD9kvdsdsDbRcDo=;
        b=oJ5HuhN0o5cRIUHMVWxBy6yNbGM3z6GBgJhjYUbSeqjFY76dKgtHwL50DCmKkGVKDD
         4fZrFpSbBekQkGee6ZYqILiegbbaeBv1dQWbjxpPo1/rs3D3Zxxt+kWvi30LVYiQSWY9
         PDmWnn0aKrrWbu8km4fMGlcP9mjr4XXxLWKdPbaX7HjPpzzsLQO4wJ1wnvPVwAL9Ipnc
         by881R1JZ/ROSgDR1QzW85Ot+HzU/SJAP1zJM4976G9kVPB9+/v/j3Khx8JPTj9HRe+x
         8nNfMCxWwfhBX07CXYX6hhtpRt/ac84eupjpqVcER/LpeR6qP480AMay7+Utg09TRpTU
         Rngw==
X-Gm-Message-State: AOAM531gaDDnIKaHJ/iYV/yfHbcOfkxAxw7d9s0ZXDdVn7air2xk29WS
        HCmW0tG5j8QhnZiRoZJ6UkrVC4VVMAjmgoNgGg8=
X-Google-Smtp-Source: ABdhPJxtjv25FqobuleyoF3luF8stat3Twut/AYTXe+NfSrjR8ZGSnw3PH8PeoJ4zcPuz6Stp1kpXg==
X-Received: by 2002:a05:620a:17a5:: with SMTP id ay37mr33224910qkb.465.1625765632330;
        Thu, 08 Jul 2021 10:33:52 -0700 (PDT)
Received: from iron-maiden.localnet (50-200-151-121-static.hfc.comcastbusiness.net. [50.200.151.121])
        by smtp.gmail.com with ESMTPSA id 137sm1273860qkf.29.2021.07.08.10.33.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jul 2021 10:33:52 -0700 (PDT)
From:   Carlos Bilbao <bilbao@vt.edu>
To:     davem@davemloft.net, Joe Perches <joe@perches.com>
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, andrew@lunn.ch,
        gregkh@linuxfoundation.org
Subject: [PATCH net-next v2] drivers: net: Follow the indentation coding standard on printks
Date:   Thu, 08 Jul 2021 13:33:51 -0400
Message-ID: <5183009.Sb9uPGUboI@iron-maiden>
Organization: Virginia Tech
In-Reply-To: <03ad1f2319a608bbfe3fc09e901742455bf733a0.camel@perches.com>
References: <1884900.usQuhbGJ8B@iron-maiden> <03ad1f2319a608bbfe3fc09e901742455bf733a0.camel@perches.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix indentation of printks that start at the beginning of the line. Change this 
for the right number of space characters, or tabs if the file uses them. 

Signed-off-by: Carlos Bilbao <bilbao@vt.edu>
---
Changelog: 
v2 - Remove the printks inside XXXDEBUG
---
diff --git a/drivers/net/ethernet/dec/tulip/de4x5.c b/drivers/net/ethernet/dec/tulip/de4x5.c
index b125d7faefdf..0d8ddfdd5c09 100644
--- a/drivers/net/ethernet/dec/tulip/de4x5.c
+++ b/drivers/net/ethernet/dec/tulip/de4x5.c
@@ -3169,7 +3169,7 @@ dc2114x_autoconf(struct net_device *dev)
 
     default:
 	lp->tcount++;
-printk("Huh?: media:%02x\n", lp->media);
+	printk(KERN_NOTICE "Huh?: media:%02x\n", lp->media);
 	lp->media = INIT;
 	break;
     }
diff --git a/drivers/net/ethernet/dec/tulip/de4x5.c.rej b/drivers/net/ethernet/dec/tulip/de4x5.c.rej
new file mode 100644
index 000000000000..949b9902b0bc
--- /dev/null
+++ b/drivers/net/ethernet/dec/tulip/de4x5.c.rej
@@ -0,0 +1,11 @@
+--- drivers/net/ethernet/dec/tulip/de4x5.c
++++ drivers/net/ethernet/dec/tulip/de4x5.c
+@@ -3169,7 +3169,7 @@ dc2114x_autoconf(struct net_device *dev)
+ 
+     default:
+        lp->tcount++;
+-printk("Huh?: media:%02x\n", lp->media);
++       printk("Huh?: media:%02x\n", lp->media);
+        lp->media = INIT;
+        break;
+     }
diff --git a/drivers/net/sb1000.c b/drivers/net/sb1000.c
index e88af978f63c..a7a6bd7ef015 100644
--- a/drivers/net/sb1000.c
+++ b/drivers/net/sb1000.c
@@ -759,9 +759,6 @@ sb1000_rx(struct net_device *dev)
 	ioaddr = dev->base_addr;
 
 	insw(ioaddr, (unsigned short*) st, 1);
-#ifdef XXXDEBUG
-printk("cm0: received: %02x %02x\n", st[0], st[1]);
-#endif /* XXXDEBUG */
 	lp->rx_frames++;
 
 	/* decide if it is a good or bad frame */
@@ -804,9 +801,6 @@ printk("cm0: received: %02x %02x\n", st[0], st[1]);
 	if (st[0] & 0x40) {
 		/* get data length */
 		insw(ioaddr, buffer, NewDatagramHeaderSize / 2);
-#ifdef XXXDEBUG
-printk("cm0: IP identification: %02x%02x  fragment offset: %02x%02x\n", buffer[30], buffer[31], buffer[32], buffer[33]);
-#endif /* XXXDEBUG */
 		if (buffer[0] != NewDatagramHeaderSkip) {
 			if (sb1000_debug > 1)
 				printk(KERN_WARNING "%s: new datagram header skip error: "
-- 
2.25.1



