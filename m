Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3CC62DAEE8
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 15:28:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729486AbgLOO0E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 09:26:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:23425 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729406AbgLOOZr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 09:25:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608042260;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Lh128b+GziqgEpkmwjasFVDKfPVvlVtz7J92RBggGoE=;
        b=WzOutTaqCKQFN9jeuhGu9S9p+Xd4kybUneez8I38F1YPIBid7m+mxJadre04CvEhd//HPE
        VnG4RxplGF+A23c46uboGt+pzrSGsZ/erIbvS7DsaubAdTpj3wgzuSDOIO4n0qU9uMRue9
        loAT84aNefOLBgKgg5DmmD/TtF6a5OM=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-148-bDTA6mgGNLylbQg15bAfBQ-1; Tue, 15 Dec 2020 09:24:19 -0500
X-MC-Unique: bDTA6mgGNLylbQg15bAfBQ-1
Received: by mail-qt1-f199.google.com with SMTP id e14so14439156qtr.8
        for <netdev@vger.kernel.org>; Tue, 15 Dec 2020 06:24:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Lh128b+GziqgEpkmwjasFVDKfPVvlVtz7J92RBggGoE=;
        b=iSjKfk/fymG4QAQVfxmJET4KipwEN2yyLAkPv5RuhLboFGSlVk5qMJ4fIUr1fQ4mTv
         PmCgLnFXQz31/xfef+MdpNdRXaDoMqJ+SkiLDuVAph38wAQpk8jnbFtoWppi6In4f0Bb
         mE39g2yTUO56w2JXSQD0gvMt2plbNqMcYze97sIpNr7OLJYWOu4iXG2+4SD8Y90hm52e
         arFMDfCQ3/m4PGyA2rp1esGJoczdNvFnfpDwrSR+R5l0Kd4KiyZARygMphLoramyzcby
         jBVY9W9mbxonsNCmGNKM4DFVe4gx5DzVJhBFn90uuFKMA3dg5T8+hm+SrEE/FHoBr+RB
         +msw==
X-Gm-Message-State: AOAM533zQif2ZMzfFSMiIWbjWMUsryR//qyzC2/g7ZadI/t2/kc/Keak
        s49ZsDHWL9db/v6/nRhYNmYQ6IFxDAPBbvhupPm7gddcSYSVjF5R369UxLYzc8MS5vafIkH7Cyu
        OQeUxcpNuCnk96FlL
X-Received: by 2002:a05:620a:6a1:: with SMTP id i1mr39446586qkh.136.1608042258787;
        Tue, 15 Dec 2020 06:24:18 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzWmKJHnnQzZgr/qkxUxr+klrMzu+hmua4q2p786ygMY1gwah6mebFalpf0oQfexXhmxd5Zdw==
X-Received: by 2002:a05:620a:6a1:: with SMTP id i1mr39446569qkh.136.1608042258627;
        Tue, 15 Dec 2020 06:24:18 -0800 (PST)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id i4sm15342556qti.78.2020.12.15.06.24.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Dec 2020 06:24:18 -0800 (PST)
From:   trix@redhat.com
To:     3chas3@gmail.com
Cc:     linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tom Rix <trix@redhat.com>
Subject: [PATCH] atm: horizon: remove h from printk format specifier
Date:   Tue, 15 Dec 2020 06:24:13 -0800
Message-Id: <20201215142413.1850207-1-trix@redhat.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

See Documentation/core-api/printk-formats.rst.
h should no longer be used in the format specifier for printk.

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/atm/horizon.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/atm/horizon.c b/drivers/atm/horizon.c
index 4f2951cbe69c..e110c305fc9c 100644
--- a/drivers/atm/horizon.c
+++ b/drivers/atm/horizon.c
@@ -1609,7 +1609,7 @@ static int hrz_send (struct atm_vcc * atm_vcc, struct sk_buff * skb) {
     if (*s++ == 'D') {
 	for (i = 0; i < 4; ++i)
 		d = (d << 4) | hex_to_bin(*s++);
-      PRINTK (KERN_INFO, "debug bitmap is now %hx", debug = d);
+      PRINTK (KERN_INFO, "debug bitmap is now %x", debug = d);
     }
   }
 #endif
@@ -2675,7 +2675,7 @@ static int hrz_probe(struct pci_dev *pci_dev,
 		       "changing", lat, pci_lat);
 		pci_write_config_byte(pci_dev, PCI_LATENCY_TIMER, pci_lat);
 	} else if (lat < MIN_PCI_LATENCY) {
-		PRINTK(KERN_INFO, "%s PCI latency timer from %hu to %hu",
+		PRINTK(KERN_INFO, "%s PCI latency timer from %u to %u",
 		       "increasing", lat, MIN_PCI_LATENCY);
 		pci_write_config_byte(pci_dev, PCI_LATENCY_TIMER, MIN_PCI_LATENCY);
 	}
@@ -2777,7 +2777,7 @@ static void hrz_remove_one(struct pci_dev *pci_dev)
 
 static void __init hrz_check_args (void) {
 #ifdef DEBUG_HORIZON
-  PRINTK (KERN_NOTICE, "debug bitmap is %hx", debug &= DBG_MASK);
+  PRINTK (KERN_NOTICE, "debug bitmap is %x", debug &= DBG_MASK);
 #else
   if (debug)
     PRINTK (KERN_NOTICE, "no debug support in this image");
-- 
2.27.0

