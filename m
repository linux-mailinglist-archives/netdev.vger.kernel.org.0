Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6626E6FE78
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 13:08:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729878AbfGVLIe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 07:08:34 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:35980 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727123AbfGVLId (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 07:08:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=fkbDO6SEZODxro/YexMPjOtDygrKCoiW6Vz/vfK/gRc=; b=XSeB4nIV5SujmhyYiB9z6cvZY2
        GwCy2JZBbFsbYvMzD9Ls4+snegPYv5NF7wBPyOrHxESxAoq0phoWXKnFHjVifW6Tib21ueCQYLtsK
        b8eWoUZ8YquaXzITEwal3sg4uhbb/p8EKNqTceIVrG1auGwYtoz21TiSE+Tyz7Fgg0QQlHoFwGzKY
        9MQqr2Sxxad/780QIVcv1Nn4USFxdd3/sp40YDVFj9Q5Wo3ojzZ9J2uuXrinur0XoZabBhUKPZBod
        4ipxDqoeq0ljVOD6OwzgETGIpuK2HB3F7+fUlsBChBuw+Xy2gl2Mh0DKUgeUk2QJvMIiGH0d/f1gQ
        8J5Kon/A==;
Received: from 177.157.124.3.dynamic.adsl.gvt.net.br ([177.157.124.3] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hpWAh-000254-B2; Mon, 22 Jul 2019 11:07:59 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1hpWAa-00041b-Ct; Mon, 22 Jul 2019 08:07:52 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Vinod Koul <vkoul@kernel.org>,
        Sanyog Kale <sanyog.r.kale@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, linux-doc@vger.kernel.org,
        dmaengine@vger.kernel.org, alsa-devel@alsa-project.org,
        netdev@vger.kernel.org
Subject: [PATCH 15/22] docs: index.rst: don't use genindex for pdf output
Date:   Mon, 22 Jul 2019 08:07:42 -0300
Message-Id: <45d57666e5738a0b85e948b0e94151fe1b1f9274.1563792334.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1563792333.git.mchehab+samsung@kernel.org>
References: <cover.1563792333.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The genindex logic is meant to be used only for html output, as
pdf build has its own way to generate indexes.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 Documentation/core-api/index.rst                  | 2 +-
 Documentation/driver-api/dmaengine/index.rst      | 2 +-
 Documentation/driver-api/soundwire/index.rst      | 2 +-
 Documentation/networking/device_drivers/index.rst | 2 +-
 Documentation/networking/index.rst                | 2 +-
 Documentation/sound/index.rst                     | 2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/Documentation/core-api/index.rst b/Documentation/core-api/index.rst
index dfd8fad1e1ec..fa16a0538dcb 100644
--- a/Documentation/core-api/index.rst
+++ b/Documentation/core-api/index.rst
@@ -49,7 +49,7 @@ Interfaces for kernel debugging
    debug-objects
    tracepoint
 
-.. only::  subproject
+.. only:: subproject and html
 
    Indices
    =======
diff --git a/Documentation/driver-api/dmaengine/index.rst b/Documentation/driver-api/dmaengine/index.rst
index 3026fa975937..b9df904d0a79 100644
--- a/Documentation/driver-api/dmaengine/index.rst
+++ b/Documentation/driver-api/dmaengine/index.rst
@@ -47,7 +47,7 @@ This book adds some notes about PXA DMA
 
    pxa_dma
 
-.. only::  subproject
+.. only::  subproject and html
 
    Indices
    =======
diff --git a/Documentation/driver-api/soundwire/index.rst b/Documentation/driver-api/soundwire/index.rst
index 6db026028f27..234911a0db99 100644
--- a/Documentation/driver-api/soundwire/index.rst
+++ b/Documentation/driver-api/soundwire/index.rst
@@ -10,7 +10,7 @@ SoundWire Documentation
    error_handling
    locking
 
-.. only::  subproject
+.. only::  subproject and html
 
    Indices
    =======
diff --git a/Documentation/networking/device_drivers/index.rst b/Documentation/networking/device_drivers/index.rst
index 2b7fefe72351..f724b7c69b9e 100644
--- a/Documentation/networking/device_drivers/index.rst
+++ b/Documentation/networking/device_drivers/index.rst
@@ -24,7 +24,7 @@ Contents:
    google/gve
    mellanox/mlx5
 
-.. only::  subproject
+.. only::  subproject and html
 
    Indices
    =======
diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index a46fca264bee..6739066acadb 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -31,7 +31,7 @@ Contents:
    tls
    tls-offload
 
-.. only::  subproject
+.. only::  subproject and html
 
    Indices
    =======
diff --git a/Documentation/sound/index.rst b/Documentation/sound/index.rst
index 47b89f014e69..4d7d42acf6df 100644
--- a/Documentation/sound/index.rst
+++ b/Documentation/sound/index.rst
@@ -12,7 +12,7 @@ Linux Sound Subsystem Documentation
    hd-audio/index
    cards/index
 
-.. only::  subproject
+.. only::  subproject and html
 
    Indices
    =======
-- 
2.21.0

