Return-Path: <netdev+bounces-10713-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 92FF672FEC1
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 14:33:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BF7181C20D0A
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 12:33:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C34403D78;
	Wed, 14 Jun 2023 12:33:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B514664F
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 12:33:23 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2FB82109
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 05:33:08 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <lgo@pengutronix.de>)
	id 1q9Pg9-00017X-S0; Wed, 14 Jun 2023 14:32:49 +0200
Received: from [2a0a:edc0:0:1101:1d::39] (helo=dude03.red.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
	(envelope-from <lgo@pengutronix.de>)
	id 1q9Pg7-007LpW-60; Wed, 14 Jun 2023 14:32:47 +0200
Received: from lgo by dude03.red.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <lgo@pengutronix.de>)
	id 1q9Pg6-00HUKF-CO; Wed, 14 Jun 2023 14:32:46 +0200
From: =?UTF-8?q?Leonard=20G=C3=B6hrs?= <l.goehrs@pengutronix.de>
To: Conor Dooley <conor@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Alexandre TORGUE <alexandre.torgue@foss.st.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
	Wolfgang Grandegger <wg@grandegger.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: kernel@pengutronix.de,
	=?UTF-8?q?Leonard=20G=C3=B6hrs?= <l.goehrs@pengutronix.de>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>,
	linux-can@vger.kernel.org,
	netdev@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/8] dt-bindings: can: m_can: change from additional- to unevaluatedProperties
Date: Wed, 14 Jun 2023 14:32:18 +0200
Message-Id: <20230614123222.4167460-5-l.goehrs@pengutronix.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230614123222.4167460-1-l.goehrs@pengutronix.de>
References: <20230614123222.4167460-1-l.goehrs@pengutronix.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: lgo@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This allows the usage of properties like termination-gpios and
termination-ohms, which are specified in can-controller.yaml
but were previously not usable due to additionalProperties: false.

Signed-off-by: Leonard Göhrs <l.goehrs@pengutronix.de>
Suggested-by: Rob Herring <robh@kernel.org>
---
 Documentation/devicetree/bindings/net/can/bosch,m_can.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml b/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
index 67879aab623b5..76c5024b6423e 100644
--- a/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
+++ b/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
@@ -128,7 +128,7 @@ required:
   - clock-names
   - bosch,mram-cfg
 
-additionalProperties: false
+unevaluatedProperties: false
 
 examples:
   - |
-- 
2.39.2


