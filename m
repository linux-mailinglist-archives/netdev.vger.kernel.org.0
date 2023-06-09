Return-Path: <netdev+bounces-9666-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6829C72A271
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 20:37:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 23EBF281A06
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 18:37:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BA71408CC;
	Fri,  9 Jun 2023 18:37:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FA2A1427F
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 18:37:53 +0000 (UTC)
Received: from mail-40140.protonmail.ch (mail-40140.protonmail.ch [185.70.40.140])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8713D3A85
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 11:37:28 -0700 (PDT)
Date: Fri, 09 Jun 2023 18:37:21 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1686335846; x=1686595046;
	bh=0ZCYTq1OJ9ne6rrLmF3n5ebjjUoiWyyt/yw2i6ZwXrY=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=YW64GUaSrg4gs+Di+BfHM9HeAXjL0xIj+exj36pAl1uKr3cqKobVSCLHYZ2+ONL0w
	 CXe3bOuWGjEUU2LjGZh7A4C80UyG6noiJO75lR5vG9a2XCazSDCBxfO5olUYv9s92m
	 ZZ/dtBUYpDx7GHmjlWCSuti0k2DNuWqHQ3FjuUN/IibAeocMZIlMbXAkz/2wmk4CEg
	 bbRL61OmWUMF9kVnMykJX4j1R2zgh7LJ+NAQAMuU0g7e89XtgdtzNxFnxDruuTuer5
	 ram2Lwd4BhGtYAUoZp3ydBoZ4CUIzxyZvViMFFKHfM5o6/7bQGy73JHUjX2UrCzqmn
	 Yal6uGfKf3a7A==
To: linux-kernel@vger.kernel.org
From: Raymond Hackley <raymondhackley@protonmail.com>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>, "David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Rob Herring <robh+dt@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>, Michael Walle <michael@walle.cc>, =?utf-8?Q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>, Jeremy Kerr <jk@codeconstruct.com.au>, Raymond Hackley <raymondhackley@protonmail.com>, netdev@vger.kernel.org, devicetree@vger.kernel.org
Subject: [RESEND PATCH v3 1/2] dt-bindings: nfc: nxp-nci: document pvdd-supply
Message-ID: <20230609183639.85221-2-raymondhackley@protonmail.com>
In-Reply-To: <20230609183639.85221-1-raymondhackley@protonmail.com>
References: <20230609183639.85221-1-raymondhackley@protonmail.com>
Feedback-ID: 49437091:user:proton
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,SPF_HELO_PASS,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

PN547/553, QN310/330 chips on some devices require a pad supply voltage
(PVDD). Otherwise, the NFC won't power up.

Document support for pad supply voltage pvdd-supply that is enabled by
the nxp-nci driver so that the regulator gets enabled when needed.

Signed-off-by: Raymond Hackley <raymondhackley@protonmail.com>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 Documentation/devicetree/bindings/net/nfc/nxp,nci.yaml | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/nfc/nxp,nci.yaml b/Docum=
entation/devicetree/bindings/net/nfc/nxp,nci.yaml
index 6924aff0b2c5..d5a4f935c2ce 100644
--- a/Documentation/devicetree/bindings/net/nfc/nxp,nci.yaml
+++ b/Documentation/devicetree/bindings/net/nfc/nxp,nci.yaml
@@ -25,6 +25,11 @@ properties:
   firmware-gpios:
     description: Output GPIO pin used to enter firmware download mode
=20
+  pvdd-supply:
+    description: |
+      Optional regulator that provides pad supply voltage for some
+      controllers
+
   interrupts:
     maxItems: 1
=20
--=20
2.30.2



