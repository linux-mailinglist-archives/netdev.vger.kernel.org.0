Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 551BD36D450
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 10:57:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237897AbhD1I5N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 04:57:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237757AbhD1I5G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Apr 2021 04:57:06 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFF12C06138A;
        Wed, 28 Apr 2021 01:56:21 -0700 (PDT)
Received: from mwalle01.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:fa59:71ff:fe9b:b851])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 5E9192224E;
        Wed, 28 Apr 2021 10:56:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1619600179;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=NebQUfQumqeNvv7P4dYqK95tgZxeYQFm09mrUWYwK08=;
        b=I3mIBOvyuxMDL7r3ahv4yIxZgkdDeXxjVx19JcFaA9ybBDy9CdHe5ON5cIVNT8BwemBuW1
        DlCa/bc+bSUArI5bzrfa4TdPt2fhDwfvB8u193t/30+BVZcWa41LYKZQ4PEax3XRwhsmHi
        I81DL0sPzFQysHcuOihrNGDhX/0hCxQ=
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Michael Walle <michael@walle.cc>
Subject: [PATCH 1/2] MAINTAINERS: remove Wingman Kwok
Date:   Wed, 28 Apr 2021 10:56:06 +0200
Message-Id: <20210428085607.32075-1-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

His email bounces with permanent error "550 Invalid recipient". His last
email on the LKML was from 2015-10-22 on the LKML.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 80ae7dbf8723..981413f41bf3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -18324,7 +18324,6 @@ F:	sound/soc/codecs/isabelle*
 F:	sound/soc/codecs/lm49453*
 
 TI NETCP ETHERNET DRIVER
-M:	Wingman Kwok <w-kwok2@ti.com>
 M:	Murali Karicheri <m-karicheri2@ti.com>
 L:	netdev@vger.kernel.org
 S:	Maintained
-- 
2.20.1

