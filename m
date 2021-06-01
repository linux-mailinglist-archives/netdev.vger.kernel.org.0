Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F161397834
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 18:39:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233904AbhFAQkm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 12:40:42 -0400
Received: from smtprelay0008.hostedemail.com ([216.40.44.8]:55436 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230288AbhFAQkm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 12:40:42 -0400
Received: from omf11.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id 33C86C5AA;
        Tue,  1 Jun 2021 16:39:00 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf11.hostedemail.com (Postfix) with ESMTPA id 4220220A295;
        Tue,  1 Jun 2021 16:38:59 +0000 (UTC)
Message-ID: <c923aee4b8d21261af2c9f0fdbdd8e3c796da65c.camel@perches.com>
Subject: [PATCH] MAINTAINERS: nfc mailing lists are subscribers-only
From:   Joe Perches <joe@perches.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Date:   Tue, 01 Jun 2021 09:38:58 -0700
In-Reply-To: <5780056e09dbbd285d470a313939e5d3cc1a0c3e.camel@perches.com>
References: <20210601160713.312622-1-krzysztof.kozlowski@canonical.com>
         <5780056e09dbbd285d470a313939e5d3cc1a0c3e.camel@perches.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.61
X-Stat-Signature: ymz7p67yybfn3z6y4k8mj78xng9hgz6n
X-Rspamd-Server: rspamout04
X-Rspamd-Queue-Id: 4220220A295
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1/loMw07p1ULQ062+NP5oDT0Up4uhY5QPk=
X-HE-Tag: 1622565539-3943
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It looks as if the MAINTAINERS entries for the nfc mailing list
should be updated as I just got a "rejected" bounce from the nfc list.

-------
Your message to the Linux-nfc mailing-list was rejected for the following
reasons:

The message is not from a list member
-------

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 0e5f02b1c284c..f989cc806943b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12975,7 +12975,7 @@ F:	net/ipv4/nexthop.c
 
 NFC SUBSYSTEM
 M:	Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
-L:	linux-nfc@lists.01.org (moderated for non-subscribers)
+L:	linux-nfc@lists.01.org (subscribers-only)
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	Documentation/devicetree/bindings/net/nfc/
@@ -12988,7 +12988,7 @@ F:	net/nfc/
 NFC VIRTUAL NCI DEVICE DRIVER
 M:	Bongsu Jeon <bongsu.jeon@samsung.com>
 L:	netdev@vger.kernel.org
-L:	linux-nfc@lists.01.org (moderated for non-subscribers)
+L:	linux-nfc@lists.01.org (subscribers-only)
 S:	Supported
 F:	drivers/nfc/virtual_ncidev.c
 F:	tools/testing/selftests/nci/
@@ -13293,7 +13293,7 @@ F:	sound/soc/codecs/tfa989x.c
 
 NXP-NCI NFC DRIVER
 R:	Charles Gorand <charles.gorand@effinnov.com>
-L:	linux-nfc@lists.01.org (moderated for non-subscribers)
+L:	linux-nfc@lists.01.org (subscribers-only)
 S:	Supported
 F:	drivers/nfc/nxp-nci
 
@@ -16249,7 +16249,7 @@ F:	include/media/drv-intf/s3c_camif.h
 SAMSUNG S3FWRN5 NFC DRIVER
 M:	Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
 M:	Krzysztof Opasiak <k.opasiak@samsung.com>
-L:	linux-nfc@lists.01.org (moderated for non-subscribers)
+L:	linux-nfc@lists.01.org (subscribers-only)
 S:	Maintained
 F:	Documentation/devicetree/bindings/net/nfc/samsung,s3fwrn5.yaml
 F:	drivers/nfc/s3fwrn5
@@ -18448,7 +18448,7 @@ F:	sound/soc/codecs/tas571x*
 TI TRF7970A NFC DRIVER
 M:	Mark Greer <mgreer@animalcreek.com>
 L:	linux-wireless@vger.kernel.org
-L:	linux-nfc@lists.01.org (moderated for non-subscribers)
+L:	linux-nfc@lists.01.org (subscribers-only)
 S:	Supported
 F:	Documentation/devicetree/bindings/net/nfc/trf7970a.txt
 F:	drivers/nfc/trf7970a.c

