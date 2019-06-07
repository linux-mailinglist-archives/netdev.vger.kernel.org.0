Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 268D3394C5
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 20:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732129AbfFGSyl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 14:54:41 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:42294 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732068AbfFGSyk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 14:54:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=WyA/RRUzEMCNSDUX0J/2kOmsPoE/y5/FaiFLeEY8Z7g=; b=iWSQ0qusvOUDaZsZnfA5nWGq0M
        h8gnnaAG8NiL0zNkjhdC9PMv4V7jMXzPKAXCaR1sP2kClosffVEFnRCmsAsRrsO1WR7luVoEzh6tY
        GXzCqnP2Zf3kGR/7SfE7vqvjIHPMc5iEVKJzqRobCZZ1rkJUZn2XflQWFnh4fqRInJj5KJOOEZ5At
        2SjPg2/Esd+7jiK5Pv+rbWe/IQodTPyFkfYmwYDFN5+5iRlidSKjc6Sh/1NSZnaupiRUnSdI2JEYc
        CIKqi5s3S5lrVQDu07XROMXpl86lxtWClns2Ubx2FndE1Ai1DorsjqbCeZKfTWYIG6YsG+a3KVfnk
        a79sm00Q==;
Received: from [179.181.119.115] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hZK0d-0005sh-Kv; Fri, 07 Jun 2019 18:54:39 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1hZK0b-0007FI-HT; Fri, 07 Jun 2019 15:54:37 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH v3 13/20] docs: net: dpio-driver.rst: fix two codeblock warnings
Date:   Fri,  7 Jun 2019 15:54:29 -0300
Message-Id: <111b55be881577bcf6516a572a6e44d64f84a05d.1559933665.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <ff457774d46d96e8fe56b45409aba39d87a8672a.1559933665.git.mchehab+samsung@kernel.org>
References: <ff457774d46d96e8fe56b45409aba39d87a8672a.1559933665.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

    Documentation/networking/device_drivers/freescale/dpaa2/dpio-driver.rst:43: WARNING: Definition list ends without a blank line; unexpected unindent.
    Documentation/networking/device_drivers/freescale/dpaa2/dpio-driver.rst:63: WARNING: Unexpected indentation. looking for now-outdated files... none found

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 .../networking/device_drivers/freescale/dpaa2/dpio-driver.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/device_drivers/freescale/dpaa2/dpio-driver.rst b/Documentation/networking/device_drivers/freescale/dpaa2/dpio-driver.rst
index 5045df990a4c..17dbee1ac53e 100644
--- a/Documentation/networking/device_drivers/freescale/dpaa2/dpio-driver.rst
+++ b/Documentation/networking/device_drivers/freescale/dpaa2/dpio-driver.rst
@@ -39,8 +39,7 @@ The Linux DPIO driver consists of 3 primary components--
 
    DPIO service-- provides APIs to other Linux drivers for services
 
-   QBman portal interface-- sends portal commands, gets responses
-::
+   QBman portal interface-- sends portal commands, gets responses::
 
           fsl-mc          other
            bus           drivers
@@ -60,6 +59,7 @@ The Linux DPIO driver consists of 3 primary components--
 
 The diagram below shows how the DPIO driver components fit with the other
 DPAA2 Linux driver components::
+
                                                    +------------+
                                                    | OS Network |
                                                    |   Stack    |
-- 
2.21.0

