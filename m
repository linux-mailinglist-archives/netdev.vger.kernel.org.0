Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 056E9349FC
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 16:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727826AbfFDOSF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 10:18:05 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:52526 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727602AbfFDOSD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 10:18:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=WyA/RRUzEMCNSDUX0J/2kOmsPoE/y5/FaiFLeEY8Z7g=; b=b+jGFR+FqWUUKyYHiwJnW2zNxG
        AQHjUBqohGyiKmiM8QJtfzgadwn5knHuqTTQyOI4jg71iS/obQc6K16soiuTxMaam488022zBsNI9
        MnZeXMnsxG7Vo1gPsRqFv2yTOck32RwAe2pknIhnS3T5PhujxscxysQ1vUF/grkkg7CnaHGlHo2wT
        AxbMWEV4mLaVmjGUnydXYeARNse9IeDmMNbMyw6Urfs7bz+3TEd2WOiC2gGEi+tjBStnpHX21AjoQ
        u1K/LJ9CSk/wkGLTjQ1yNYMOur/rpovICKiqjLKFlwZFUDF4zvN5jU+4Fzk2BCq1dCWRSWQpHhIwr
        MDP4MUmg==;
Received: from [179.182.172.34] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hYAGH-0001Rv-Um; Tue, 04 Jun 2019 14:18:01 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1hYAGE-0002lg-TI; Tue, 04 Jun 2019 11:17:58 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Roy Pledge <roy.pledge@nxp.com>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Randy Dunlap <rdunlap@infradead.org>, netdev@vger.kernel.org
Subject: [PATCH v2 16/22] docs: net: dpio-driver.rst: fix two codeblock warnings
Date:   Tue,  4 Jun 2019 11:17:50 -0300
Message-Id: <f5e4bcdb6cc89c270d4ec8ae6cfb932146a834ca.1559656538.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1559656538.git.mchehab+samsung@kernel.org>
References: <cover.1559656538.git.mchehab+samsung@kernel.org>
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

