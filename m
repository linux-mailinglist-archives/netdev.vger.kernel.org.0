Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F23361884EE
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 14:11:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727052AbgCQNL1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 09:11:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:37814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726474AbgCQNK4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Mar 2020 09:10:56 -0400
Received: from mail.kernel.org (ip5f5ad4e9.dynamic.kabel-deutschland.de [95.90.212.233])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6AED2076E;
        Tue, 17 Mar 2020 13:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584450655;
        bh=qcurY8bOcWo5+GUNbRcDNmw4qaVy7k5l/0CO6+ZkKn8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jl7qcP50X5PEG7pLxCKMawz9B/YaStb/OFPHwDjzIcVY19FeS1R3yo0VxzuRD+ym9
         S+81PAI+1NAfeNkBWgzWrPQzSLvxUth+7zhHb362HH+aM9PGwy9W2eHJ4Rp6bkFw6w
         36hdLJzkW2dPPbezgaeHvBZdG/HPKoMhzIwPaoYU=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jEBzh-0006S1-JQ; Tue, 17 Mar 2020 14:10:53 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Dan Murphy <dmurphy@ti.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@st.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH 04/12] docs: dt: fix references to m_can.txt file
Date:   Tue, 17 Mar 2020 14:10:43 +0100
Message-Id: <db67f9bc93f062179942f1e095a46b572a442b76.1584450500.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <cover.1584450500.git.mchehab+huawei@kernel.org>
References: <cover.1584450500.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This file was converted to json and renamed. Update its
references accordingly.

Fixes: 824674b59f72 ("dt-bindings: net: can: Convert M_CAN to json-schema")
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/devicetree/bindings/net/can/tcan4x5x.txt | 2 +-
 MAINTAINERS                                            | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/can/tcan4x5x.txt b/Documentation/devicetree/bindings/net/can/tcan4x5x.txt
index 6bdcc3f84bd3..3613c2c8f75d 100644
--- a/Documentation/devicetree/bindings/net/can/tcan4x5x.txt
+++ b/Documentation/devicetree/bindings/net/can/tcan4x5x.txt
@@ -14,7 +14,7 @@ Required properties:
                     the interrupt.
 	- interrupts: interrupt specification for data-ready.
 
-See Documentation/devicetree/bindings/net/can/m_can.txt for additional
+See Documentation/devicetree/bindings/net/can/bosch,m_can.yaml for additional
 required property details.
 
 Optional properties:
diff --git a/MAINTAINERS b/MAINTAINERS
index 39da9ac4cc1f..84cb39b5a23b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10327,7 +10327,7 @@ M:	Dan Murphy <dmurphy@ti.com>
 M:	Sriram Dash <sriram.dash@samsung.com>
 L:	linux-can@vger.kernel.org
 S:	Maintained
-F:	Documentation/devicetree/bindings/net/can/m_can.txt
+F:	Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
 F:	drivers/net/can/m_can/m_can.c
 F:	drivers/net/can/m_can/m_can.h
 F:	drivers/net/can/m_can/m_can_platform.c
-- 
2.24.1

