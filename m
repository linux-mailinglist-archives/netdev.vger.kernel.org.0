Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF982218992
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 15:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729479AbgGHN5t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 09:57:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728148AbgGHN5t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 09:57:49 -0400
Received: from smtp.al2klimov.de (smtp.al2klimov.de [IPv6:2a01:4f8:c0c:1465::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F531C061A0B;
        Wed,  8 Jul 2020 06:57:49 -0700 (PDT)
Received: from authenticated-user (PRIMARY_HOSTNAME [PUBLIC_IP])
        by smtp.al2klimov.de (Postfix) with ESMTPA id 0F4B4BC118;
        Wed,  8 Jul 2020 13:57:43 +0000 (UTC)
From:   "Alexander A. Klimov" <grandmaster@al2klimov.de>
To:     corbet@lwn.net, ast@kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
        john.fastabend@gmail.com, mchehab+samsung@kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     "Alexander A. Klimov" <grandmaster@al2klimov.de>
Subject: [PATCH] Replace HTTP links with HTTPS ones: XDP (eXpress Data Path)
Date:   Wed,  8 Jul 2020 15:57:37 +0200
Message-Id: <20200708135737.14660-1-grandmaster@al2klimov.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: ++++++
X-Spam-Level: ******
Authentication-Results: smtp.al2klimov.de;
        auth=pass smtp.auth=aklimov@al2klimov.de smtp.mailfrom=grandmaster@al2klimov.de
X-Spam: Yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rationale:
Reduces attack surface on kernel devs opening the links for MITM
as HTTPS traffic is much harder to manipulate.

Deterministic algorithm:
For each file:
  If not .svg:
    For each line:
      If doesn't contain `\bxmlns\b`:
        For each link, `\bhttp://[^# \t\r\n]*(?:\w|/)`:
	  If neither `\bgnu\.org/license`, nor `\bmozilla\.org/MPL\b`:
            If both the HTTP and HTTPS versions
            return 200 OK and serve the same content:
              Replace HTTP with HTTPS.

Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>
---
 Continuing my work started at 93431e0607e5.
 See also: git log --oneline '--author=Alexander A. Klimov <grandmaster@al2klimov.de>' v5.7..master
 (Actually letting a shell for loop submit all this stuff for me.)

 If there are any URLs to be removed completely or at least not HTTPSified:
 Just clearly say so and I'll *undo my change*.
 See also: https://lkml.org/lkml/2020/6/27/64

 If there are any valid, but yet not changed URLs:
 See: https://lkml.org/lkml/2020/6/26/837

 If you apply the patch, please let me know.


 Documentation/arm/ixp4xx.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/arm/ixp4xx.rst b/Documentation/arm/ixp4xx.rst
index a57235616294..d94188b8624f 100644
--- a/Documentation/arm/ixp4xx.rst
+++ b/Documentation/arm/ixp4xx.rst
@@ -119,14 +119,14 @@ http://www.gateworks.com/support/overview.php
    the expansion bus.
 
 Intel IXDP425 Development Platform
-http://www.intel.com/design/network/products/npfamily/ixdpg425.htm
+https://www.intel.com/design/network/products/npfamily/ixdpg425.htm
 
    This is Intel's standard reference platform for the IXDP425 and is
    also known as the Richfield board. It contains 4 PCI slots, 16MB
    of flash, two 10/100 ports and one ADSL port.
 
 Intel IXDP465 Development Platform
-http://www.intel.com/design/network/products/npfamily/ixdp465.htm
+https://www.intel.com/design/network/products/npfamily/ixdp465.htm
 
    This is basically an IXDP425 with an IXP465 and 32M of flash instead
    of just 16.
-- 
2.27.0

