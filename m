Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C59A42CB37
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 22:44:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbhJMUqd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 16:46:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:55888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229462AbhJMUqd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 16:46:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B19296054F;
        Wed, 13 Oct 2021 20:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634157869;
        bh=FobP0/OixENx5K/bYUpWQ5xRS2moBX9d1tNWW9Pvkkc=;
        h=From:To:Cc:Subject:Date:From;
        b=ncqph26D6vMQPdX9bHfVwKq012hJ21APNVeYX63jDVRLwuokA4Fpb5oTE1bae1va0
         WlLRvoJglTjQgyIoXsrReeMrKCqVP+lmuHaVs7a7PKCy3iYAd/tTAN+7VZewHZY5u8
         nBZlnvRmBLcfk2KNug/bbpbEocw7de+/1hQ4Lxdc1rAy45EzjKByizWGv1BaeR8uta
         NgRpd1Pw+vUrISm9rh/f67ELezrhqNLQjkF2Kddu55Guyz0lGZ7fjccq3Efuljzkl2
         ZMYjyivp22wUlPE+hH7KTtqL349o2o/croQ3mMwu1FN6S7FR3VARYuqv31FVsVeCGd
         b7wiahky7X3gQ==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     devicetree@vger.kernel.org, linux-leds@vger.kernel.org,
        pavel@ucw.cz, Andrew Lunn <andrew@lunn.ch>
Cc:     robh+dt@kernel.org, Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 1/3] dt-bindings: leds: Deprecate `linux,default-trigger` property
Date:   Wed, 13 Oct 2021 22:44:22 +0200
Message-Id: <20211013204424.10961-1-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This property is deprecated in favor of the `function` property.

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 Documentation/devicetree/bindings/leds/common.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/leds/common.yaml b/Documentation/devicetree/bindings/leds/common.yaml
index 697102707703..a19acc781e89 100644
--- a/Documentation/devicetree/bindings/leds/common.yaml
+++ b/Documentation/devicetree/bindings/leds/common.yaml
@@ -78,6 +78,7 @@ properties:
       This parameter, if present, is a string defining the trigger assigned to
       the LED.
     $ref: /schemas/types.yaml#/definitions/string
+    deprecated: true
 
     enum:
         # LED will act as a back-light, controlled by the framebuffer system
-- 
2.32.0

