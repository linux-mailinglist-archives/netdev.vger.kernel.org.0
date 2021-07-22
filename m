Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24E553D217B
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 12:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231579AbhGVJTq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 05:19:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:49300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231470AbhGVJTp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 05:19:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9501561241;
        Thu, 22 Jul 2021 10:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626948020;
        bh=mPBxCZz6/+NbyEmN9tmtfQYN6qT8N1p7uWgERM3SRkg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rXgarqj1hkjFnq3lJiMI4u1RV74hJkjsbKXxOGy/0w+8SGgPoouyG5TqfIgZ083jp
         tSCN/53p+hxxXMiO/LH9LKWzxSapW4ez6UUFaixCK5WEZ17Xx0Yp1ejnyK5gcJ2qOK
         mkYy5U+x/5wTIsAyMoVR35Sbocby77RSkgvKqBnQUKgc4Dp/Ud2VJzC2G4kkvR1j4D
         bILiU+c+Vy+Ls/3uGHKoLaNh3EMdEL5Gq+3alVER1ygaKh4HK/ApFwM646te1lEwkc
         gYYVJRgYTD7JAC0M1Ew6wybTj9LT/GCI+Fy3hFQI1i9zE3tpkk727N0xdjsiA/gnyR
         G3d5bkY19MEAg==
Received: by mail.kernel.org with local (Exim 4.94.2)
        (envelope-from <mchehab@kernel.org>)
        id 1m6VUz-008mHX-J5; Thu, 22 Jul 2021 12:00:13 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Jonathan Corbet" <corbet@lwn.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 03/15] dt-bindings: net: dsa: sja1105: update nxp,sja1105.yaml reference
Date:   Thu, 22 Jul 2021 12:00:00 +0200
Message-Id: <3e5fc7ad4f47887666868d6727f88f58613ea508.1626947923.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1626947923.git.mchehab+huawei@kernel.org>
References: <cover.1626947923.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changeset 62568bdbe6f6 ("dt-bindings: net: dsa: sja1105: convert to YAML schema")
renamed: Documentation/devicetree/bindings/net/dsa/sja1105.txt
to: Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml.

Update its cross-reference accordingly.

Fixes: 62568bdbe6f6 ("dt-bindings: net: dsa: sja1105: convert to YAML schema")
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/networking/dsa/sja1105.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/networking/dsa/sja1105.rst b/Documentation/networking/dsa/sja1105.rst
index da4057ba37f1..4fd6441dab5d 100644
--- a/Documentation/networking/dsa/sja1105.rst
+++ b/Documentation/networking/dsa/sja1105.rst
@@ -512,7 +512,7 @@ not available.
 Device Tree bindings and board design
 =====================================
 
-This section references ``Documentation/devicetree/bindings/net/dsa/sja1105.txt``
+This section references ``Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml``
 and aims to showcase some potential switch caveats.
 
 RMII PHY role and out-of-band signaling
-- 
2.31.1

