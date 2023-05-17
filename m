Return-Path: <netdev+bounces-3454-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 31833707322
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 22:36:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D196B1C21024
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 20:36:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC65FC8CE;
	Wed, 17 May 2023 20:35:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2311101F2
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 20:35:57 +0000 (UTC)
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::222])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65A7AF2;
	Wed, 17 May 2023 13:35:55 -0700 (PDT)
Received: (Authenticated sender: alexis.lothore@bootlin.com)
	by mail.gandi.net (Postfix) with ESMTPSA id 0397340005;
	Wed, 17 May 2023 20:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1684355754;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+MBWhOUAOvvTZgiK7s5H33hdqjZ2816+sJdntqiIXT4=;
	b=GqJ5Vyx/tb7Luv00L1AdVOmLyjhQvAVEZ8zxu7ha/yr3q/qJXlTt3b4tzEu64twJRFp9ti
	kFlAxv4Uj6E4RJ+wVlP/L8UqWIbdnrQgITngKT9UA5fD+tUnB90NNgllgEQnZ8svVQQORe
	WEa6dVUN75bRDfO0UohN965/qL20qLdf/k6tMPNOcIGoLZomL0HHv72aXKXTGHEDciAsO7
	Q2Mk0+ctyh9ucKP6cuuQPRqvPHeavuE+hClKTlCufJr7g4LnQUaPyCl2aYVF6WboJ1gXf3
	SNvQdc1SjKaZ7muKqc1i+XV57FW/r+sF/GxWk9GgPloUEOFMe6EsQXuvvO/A+Q==
From: alexis.lothore@bootlin.com
To: Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Richard Cochran <richardcochran@gmail.com>
Cc: netdev@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	thomas.petazzoni@bootlin.com,
	paul.arola@telus.com,
	scott.roberts@telus.com,
	=?UTF-8?q?Alexis=20Lothor=C3=A9?= <alexis.lothore@bootlin.com>
Subject: [PATCH net-next 1/2] dt-bindings: net: dsa: marvell: add MV88E6361 switch to compatibility list
Date: Wed, 17 May 2023 22:34:29 +0200
Message-Id: <20230517203430.448705-2-alexis.lothore@bootlin.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230517203430.448705-1-alexis.lothore@bootlin.com>
References: <20230517203430.448705-1-alexis.lothore@bootlin.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Alexis Lothoré <alexis.lothore@bootlin.com>

Marvell MV88E6361 is an 8-port switch derived from the
88E6393X/88E9193X/88E6191X switches family. Since its functional behavior
is very close to switches from this family, it can benefit from existing
drivers for this family, so add it to the list of compatible switches

Signed-off-by: Alexis Lothoré <alexis.lothore@bootlin.com>
---
 Documentation/devicetree/bindings/net/dsa/marvell.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/marvell.txt b/Documentation/devicetree/bindings/net/dsa/marvell.txt
index 2363b412410c..33726134f5c9 100644
--- a/Documentation/devicetree/bindings/net/dsa/marvell.txt
+++ b/Documentation/devicetree/bindings/net/dsa/marvell.txt
@@ -20,7 +20,7 @@ which is at a different MDIO base address in different switch families.
 			  6171, 6172, 6175, 6176, 6185, 6240, 6320, 6321,
 			  6341, 6350, 6351, 6352
 - "marvell,mv88e6190"	: Switch has base address 0x00. Use with models:
-			  6190, 6190X, 6191, 6290, 6390, 6390X
+			  6163, 6190, 6190X, 6191, 6290, 6390, 6390X
 - "marvell,mv88e6250"	: Switch has base address 0x08 or 0x18. Use with model:
 			  6220, 6250
 
-- 
2.40.1


