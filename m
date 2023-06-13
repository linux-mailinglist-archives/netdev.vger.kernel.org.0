Return-Path: <netdev+bounces-10513-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 68CCC72EC80
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 22:10:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 979521C20932
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 20:10:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CB213D3A9;
	Tue, 13 Jun 2023 20:10:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B6DF136A
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 20:10:00 +0000 (UTC)
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0A3B1BE5;
	Tue, 13 Jun 2023 13:09:56 -0700 (PDT)
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-77ac59135ebso213273939f.3;
        Tue, 13 Jun 2023 13:09:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686686996; x=1689278996;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Gjpk6M00PyKdezSkYwKG0YakVAZSBP58+XeaS+tOstY=;
        b=b1JV/lgdGp9ozFaZHd9pUNfKkq4IAYQHqy+FDJK2i059wE33dNG+b+GfjILuEaIMbl
         svwsXyC79DH6148eslIQUfYnSR1WVdn8U9EEpnR3YyyaqCCCfJfh8bWhdsL56tL9zJbw
         m/LN81O8RFp5DOCKjRPBJux8DwbF7Hh/r07OqX/0hEWwknDZqWXMKzD2hydvFWYPMYLe
         c+PQhV4uz2RYrBB4G8WsFwgo4VFKUyOwLamJtWIjX56SaC5rnp4f2VSsnu23IJlLCl2Z
         c47naN6dS2xX2Uha8rQUYXA2OJOR5ADTvL1UXILjSa142K5S3XQ83F4oS+HTq7JpA4T2
         nbrA==
X-Gm-Message-State: AC+VfDymi8p4255fuAOP3q8fYHbMwSUvZ7eF0WGUu1nynjcgNWSteaTV
	EPoDjCL1jPUQvL1UP3v2wGSM+mhCCQ==
X-Google-Smtp-Source: ACHHUZ7pD/oHFNZgCq+eRIVMNAKGU5vIehooTsAFl+mLTv6j93ybrKAnQLA3JXDCNHHCw1kjvMbRtg==
X-Received: by 2002:a6b:4418:0:b0:76c:8877:861f with SMTP id r24-20020a6b4418000000b0076c8877861fmr9829960ioa.1.1686686996069;
        Tue, 13 Jun 2023 13:09:56 -0700 (PDT)
Received: from robh_at_kernel.org ([64.188.179.250])
        by smtp.gmail.com with ESMTPSA id f5-20020a056638118500b0041eb1fb695csm3652269jas.105.2023.06.13.13.09.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jun 2023 13:09:55 -0700 (PDT)
Received: (nullmailer pid 2822666 invoked by uid 1000);
	Tue, 13 Jun 2023 20:09:53 -0000
From: Rob Herring <robh@kernel.org>
To: Amitkumar Karwar <amitkumar.karwar@nxp.com>, Neeraj Kale <neeraj.sanjaykale@nxp.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, Conor Dooley <conor+dt@kernel.org>
Cc: netdev@vger.kernel.org, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] dt-bindings: net: bluetooth: nxp: Add missing type for "fw-init-baudrate"
Date: Tue, 13 Jun 2023 14:09:29 -0600
Message-Id: <20230613200929.2822137-1-robh@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
	FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

"fw-init-baudrate" is missing a type, add it. While we're here, define the
default value with a schema rather than freeform text.

Signed-off-by: Rob Herring <robh@kernel.org>
---
 .../devicetree/bindings/net/bluetooth/nxp,88w8987-bt.yaml    | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/bluetooth/nxp,88w8987-bt.yaml b/Documentation/devicetree/bindings/net/bluetooth/nxp,88w8987-bt.yaml
index 57e4c87cb00b..f01a3988538c 100644
--- a/Documentation/devicetree/bindings/net/bluetooth/nxp,88w8987-bt.yaml
+++ b/Documentation/devicetree/bindings/net/bluetooth/nxp,88w8987-bt.yaml
@@ -24,11 +24,12 @@ properties:
       - nxp,88w8997-bt
 
   fw-init-baudrate:
+    $ref: /schemas/types.yaml#/definitions/uint32
+    default: 115200
     description:
       Chip baudrate after FW is downloaded and initialized.
       This property depends on the module vendor's
-      configuration. If this property is not specified,
-      115200 is set as default.
+      configuration.
 
 required:
   - compatible
-- 
2.39.2


