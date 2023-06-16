Return-Path: <netdev+bounces-11397-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A5A0F732F03
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 12:46:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C95111C20D6B
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 10:46:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AED51D310;
	Fri, 16 Jun 2023 10:46:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 753CE2E0F6
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 10:46:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67B69C433C0;
	Fri, 16 Jun 2023 10:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686912366;
	bh=0x7t1g8daL8i3jr7qX7O4gRvhVWJIsgPU5r60pL859Q=;
	h=From:Date:Subject:To:Cc:From;
	b=N6An/e8roTDGqNHPUonI3qtPu9G8NCWBoFvj0M07M/XvHMY/pTctc0pp8hnfo8YMZ
	 Oh4qy7J9feVBRDbhyB15Fi8N+8AijyqK/kf0rgNouxkhXw+ZnTsC3jg4W6xPjDbZFh
	 lSNp3lqgHFRL1zTRPCX9QvE+hygdpJqmif1ol+CRKkersu2JOU2X/72t8E1y70PZBm
	 LaB5n6COqaj5KrEeFoz5IiLl9b7gMn5C2wGhYuRen+pYBfudEHp5jfYPznLZs7gPnR
	 l6M575TcT6I+L8ZYjoWboAe57VW8SvwuAsiaqecD98c6rsjD9AigCViWeNpwSr59s5
	 zojez8n7aEwYQ==
From: Michael Walle <mwalle@kernel.org>
Date: Fri, 16 Jun 2023 12:45:57 +0200
Subject: [PATCH net-next] dt-bindings: net: phy: gpy2xx: more precise
 description
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230616-feature-maxlinear-dt-better-irq-desc-v1-1-57a8936543bf@kernel.org>
X-B4-Tracking: v=1; b=H4sIAGQ9jGQC/x2NQQrCMBBFr1Jm7UDTShZeRVxMk187YKNOogRK7
 27q8vE+72+UYYpMl24jw1ezPlMDd+ooLJLuYI2NaeiHsffO8wwpHwOvUh+aIMax8IRSYKz25og
 ceI6jE8D7swvUUpNk8GSSwnLEVsltfoiXYdb6/79SQuGEWui27z/ehho7mQAAAA==
To: "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, Rob Herring <robh+dt@kernel.org>, 
 Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, 
 Conor Dooley <conor+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>, 
 Michael Walle <michael@walle.cc>
Cc: netdev@vger.kernel.org, devicetree@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Rob Herring <robh@kernel.org>, 
 Michael Walle <mwalle@kernel.org>
X-Mailer: b4 0.12.2

Mention that the interrupt line is just asserted for a random period of
time, not the entire time.

Suggested-by: Rob Herring <robh@kernel.org>
Signed-off-by: Michael Walle <mwalle@kernel.org>
---
 Documentation/devicetree/bindings/net/maxlinear,gpy2xx.yaml | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/maxlinear,gpy2xx.yaml b/Documentation/devicetree/bindings/net/maxlinear,gpy2xx.yaml
index d71fa9de2b64..8a3713abd1ca 100644
--- a/Documentation/devicetree/bindings/net/maxlinear,gpy2xx.yaml
+++ b/Documentation/devicetree/bindings/net/maxlinear,gpy2xx.yaml
@@ -17,11 +17,12 @@ properties:
   maxlinear,use-broken-interrupts:
     description: |
       Interrupts are broken on some GPY2xx PHYs in that they keep the
-      interrupt line asserted even after the interrupt status register is
-      cleared. Thus it is blocking the interrupt line which is usually bad
-      for shared lines. By default interrupts are disabled for this PHY and
-      polling mode is used. If one can live with the consequences, this
-      property can be used to enable interrupt handling.
+      interrupt line asserted for a random amount of time even after the
+      interrupt status register is cleared. Thus it is blocking the
+      interrupt line which is usually bad for shared lines. By default,
+      interrupts are disabled for this PHY and polling mode is used. If one
+      can live with the consequences, this property can be used to enable
+      interrupt handling.
 
       Affected PHYs (as far as known) are GPY215B and GPY215C.
     type: boolean

---
base-commit: f7efed9f38f886edb450041b82a6f15d663c98f8
change-id: 20230616-feature-maxlinear-dt-better-irq-desc-fd31aee6641c


