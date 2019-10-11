Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A6A3D47DF
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 20:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728900AbfJKSse (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 14:48:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:47414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728878AbfJKSsc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Oct 2019 14:48:32 -0400
Received: from ziggy.de (unknown [37.223.145.112])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D218C21E6F;
        Fri, 11 Oct 2019 18:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570819712;
        bh=OSSt+reHfL3uEfpz09ftnbbXI7VLIRW3qEzvMgs8aKI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tY1MpDe+AdZS/V/qg85LK4kVcQbnvFT3fr2YtPdfdvVZUm8KTEeQOETC/KxFqWUpc
         r7aZTSVfJBHALLP7e8A8rOlpc8pMKv80UZXNRDJjsPVQpXvdVtKHjat6jPV9MnrLZR
         I50BTqRH+Z4BowwrAuBWqdHfff7fwSxGuXZ7dQqg=
From:   matthias.bgg@kernel.org
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Matthias Brugger <matthias.bgg@kernel.org>,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        Stefan Wahren <wahrenst@gmx.net>,
        Matthias Brugger <mbrugger@suse.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v1 1/3] dt-bindings: net: bcmgenet add property for max DMA burst size
Date:   Fri, 11 Oct 2019 20:48:19 +0200
Message-Id: <20191011184822.866-2-matthias.bgg@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191011184822.866-1-matthias.bgg@kernel.org>
References: <20191011184822.866-1-matthias.bgg@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matthias Brugger <mbrugger@suse.com>

The maximal usable DMA burst size can vary in different SoCs.
Add a optional property to configure the DMA channels properly.

Signed-off-by: Matthias Brugger <mbrugger@suse.com>
---

 Documentation/devicetree/bindings/net/brcm,bcmgenet.txt | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/brcm,bcmgenet.txt b/Documentation/devicetree/bindings/net/brcm,bcmgenet.txt
index 3956af1d30f3..10a7169ec902 100644
--- a/Documentation/devicetree/bindings/net/brcm,bcmgenet.txt
+++ b/Documentation/devicetree/bindings/net/brcm,bcmgenet.txt
@@ -30,6 +30,8 @@ Optional properties:
   See Documentation/devicetree/bindings/net/fixed-link.txt for information on
   the property specifics
 
+- dma-burst-sz: Maximal length of a burst.
+
 Required child nodes:
 
 - mdio bus node: this node should always be present regardless of the PHY
-- 
2.23.0

