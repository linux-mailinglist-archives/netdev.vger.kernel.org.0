Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD252264AE
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 17:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730739AbgGTPrI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 11:47:08 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:50761 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730734AbgGTPrG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 11:47:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595260024;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=Kgdcn0E7Ouk2st1ZJu/uYjUMSJLu1cQ6giaK+jHaBOI=;
        b=H0NBxyOVil3oU4bI8bHkh59m6tD0oa9AblbyGg2fG3yOhiSD7XqExAFzccM0DEwCr58wYy
        SYlIhBAYjiQJcTfas0YSNEYCFOJrlXSq6qMv/5SKHZ7J4kiBiNm7byHZqRrVtl0hLVFQcm
        Do9zpx6Pp9MrNAH/Czq3KlqR/oc6Yg4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-438-C0wa5ABiOMuhua70-G10kA-1; Mon, 20 Jul 2020 11:47:02 -0400
X-MC-Unique: C0wa5ABiOMuhua70-G10kA-1
Received: by mail-wr1-f72.google.com with SMTP id b8so12282389wro.19
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 08:47:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=Kgdcn0E7Ouk2st1ZJu/uYjUMSJLu1cQ6giaK+jHaBOI=;
        b=I7bGMzbtL5rK5zcko4KTQ+vbnviL1bikZpc2iqrqFZB1zIlndfa4l8rjCmchaGIIsc
         zueFpa4n8BJ5WIfs3pBEgEsUIaZMwrwB2BdkinfnxxcxeVI6IDkeoye8EVfRgHVOG66x
         ggoE71r74cEcAW8QUvhPVQrT8TY7H8G/cISyqZhh67OjaAEBHXzeqaN1oeS4+Y9GWvzd
         Vgtk6HID4oLbyt938t10MzHISpB9+z8iTCHgE3l0FmvV8708cFsZ+9IkP7RrxEwxHJ3H
         hCLOaATYK31wekkv6dyc/FUvYNWljyoDBjPhmpE298uDYV5umDqCjlyXkJodKotg/E6U
         w2rQ==
X-Gm-Message-State: AOAM533J7+k5X+70mDdF960Xx0LQPFCdymQZcRYjaowZlNPs14iInU17
        PrnypzL5J8B8QLgzFkyD4PVdo/HmKN2iVFNkZTdfHXP30SZ6Yu2EqwNgdiJYZWfXiMgH2skLGGQ
        2ckmJfWKCaqbVGsLG
X-Received: by 2002:a5d:6692:: with SMTP id l18mr2993685wru.211.1595260021521;
        Mon, 20 Jul 2020 08:47:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxH/9THfSAwsOq2vXIRMnukH6yIdzxmBCr1Ep6/MSnK/FAw8uA0E+iDWPgSVX/5OVMFV/u4Cw==
X-Received: by 2002:a5d:6692:: with SMTP id l18mr2993656wru.211.1595260021133;
        Mon, 20 Jul 2020 08:47:01 -0700 (PDT)
Received: from pc-2.home (2a01cb058529bf0075b0798a7f5975cb.ipv6.abo.wanadoo.fr. [2a01:cb05:8529:bf00:75b0:798a:7f59:75cb])
        by smtp.gmail.com with ESMTPSA id 22sm36719902wmb.11.2020.07.20.08.47.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2020 08:47:00 -0700 (PDT)
Date:   Mon, 20 Jul 2020 17:46:58 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>,
        Martin Varghese <martin.varghese@nokia.com>
Subject: [PATCH net] Documentation: bareudp: update iproute2 sample commands
Message-ID: <57d0fff72970fdc7d49ab969f940438728f10754.1595259799.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bareudp.rst was written before iproute2 gained support for this new
type of tunnel. Therefore, the sample command lines didn't match the
final iproute2 implementation.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 Documentation/networking/bareudp.rst | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/Documentation/networking/bareudp.rst b/Documentation/networking/bareudp.rst
index 465a8b251bfe..ff406563ea88 100644
--- a/Documentation/networking/bareudp.rst
+++ b/Documentation/networking/bareudp.rst
@@ -26,7 +26,7 @@ Usage
 
 1) Device creation & deletion
 
-    a) ip link add dev bareudp0 type bareudp dstport 6635 ethertype 0x8847.
+    a) ip link add dev bareudp0 type bareudp dstport 6635 ethertype mpls_uc
 
        This creates a bareudp tunnel device which tunnels L3 traffic with ethertype
        0x8847 (MPLS traffic). The destination port of the UDP header will be set to
@@ -34,14 +34,21 @@ Usage
 
     b) ip link delete bareudp0
 
-2) Device creation with multiple proto mode enabled
+2) Device creation with multiproto mode enabled
 
-There are two ways to create a bareudp device for MPLS & IP with multiproto mode
-enabled.
+The multiproto mode allows bareudp tunnels to handle several protocols of the
+same family. It is currently only available for IP and MPLS. This mode has to
+be enabled explicitly with the "multiproto" flag.
 
-    a) ip link add dev  bareudp0 type bareudp dstport 6635 ethertype 0x8847 multiproto
+    a) ip link add dev bareudp0 type bareudp dstport 6635 ethertype ipv4 multiproto
 
-    b) ip link add dev  bareudp0 type bareudp dstport 6635 ethertype mpls
+       For an IPv4 tunnel the multiproto mode allows the tunnel to also handle
+       IPv6.
+
+    b) ip link add dev bareudp0 type bareudp dstport 6635 ethertype mpls_uc multiproto
+
+       For MPLS, the multiproto mode allows the tunnel to handle both unicast
+       and multicast MPLS packets.
 
 3) Device Usage
 
-- 
2.21.3

