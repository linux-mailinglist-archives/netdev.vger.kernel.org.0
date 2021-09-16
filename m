Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC1940D6AD
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 11:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236436AbhIPJ46 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 05:56:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:57814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235625AbhIPJ4q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 05:56:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B3306120C;
        Thu, 16 Sep 2021 09:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631786126;
        bh=W6jGf7EkX3lQniCXTbNfJeDPlrO+LIjN+LLgn+bQ1JA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L6TVulWiQXqYEVgkpN7p+Ldrv39fHjs8yRvhHKwP38Ijmmd/msoactlozwsM7COxk
         /IzdeQQ7ru/0CTntG4y7amQJaH4nuOLg3laRdGWEdWiVjF7RiqwNc9H2bb/zeXqBu1
         Luf8iX5cb5BavSm0yCHY3n1HouKzUNH3KDxl1Tni+1GW3jV6ehp4QuMVauQqaXbA0Y
         scFFmv0RyT5I2ZLe1kl1t2cNwiAkJtW8luTAZMKF/YNmaZpUlCJRRWqNn4ef9psY3A
         nRP3ZJyV98q6sjLlKENWlDUD+sdan9VO+v+0TfAEhV7cbgVyE0Kov4ECmwOcxWSVji
         4482HsEINQqXA==
Received: by mail.kernel.org with local (Exim 4.94.2)
        (envelope-from <mchehab@kernel.org>)
        id 1mQo72-001vTO-6E; Thu, 16 Sep 2021 11:55:24 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v2 02/23] dt-bindings: net: dsa: sja1105: update nxp,sja1105.yaml reference
Date:   Thu, 16 Sep 2021 11:55:01 +0200
Message-Id: <994ce6c6358746ff600459822b9f6e336db933c9.1631785820.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1631785820.git.mchehab+huawei@kernel.org>
References: <cover.1631785820.git.mchehab+huawei@kernel.org>
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
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/networking/dsa/sja1105.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/networking/dsa/sja1105.rst b/Documentation/networking/dsa/sja1105.rst
index 564caeebe2b2..29b1bae0cf00 100644
--- a/Documentation/networking/dsa/sja1105.rst
+++ b/Documentation/networking/dsa/sja1105.rst
@@ -296,7 +296,7 @@ not available.
 Device Tree bindings and board design
 =====================================
 
-This section references ``Documentation/devicetree/bindings/net/dsa/sja1105.txt``
+This section references ``Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml``
 and aims to showcase some potential switch caveats.
 
 RMII PHY role and out-of-band signaling
-- 
2.31.1

