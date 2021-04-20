Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C89D9365FD1
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 20:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233708AbhDTSyN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 14:54:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233691AbhDTSx7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 14:53:59 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04756C06138A
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 11:53:27 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id m9so26014039wrx.3
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 11:53:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=ebyPwcdrPNJZ8NlIZPrB4jWl+zySFB+YPdDAxVIYV/A=;
        b=aSyR7WC+sW0cdvczodryOKG9/LngPw+7ooQh+Z/ZitRwLNknbczJRZZh1pVhjlAtoD
         vAuLH5k2rV3aJ8L/0uS7MsvjwoEVoglM0eh5BRj7H4SjzDcapmtZT16UCpkqVjPXXOWS
         bAQi6holwQIzCxjj3TfigMdFpRr6gyBE5vXYF0Kgjo3mRBg05fTDP73hTOY5PEJAgkXS
         8uanRKR7WIGcPukqEQdufh3TqCU3jJSalfcKMIKJCT97ly7PN1qCvKpFmyGfitUbe+I2
         lezFzLm/0wfqZ4ypBaZFxu0jvVTBJoyiFz28rwx8jBITF0wC7H/POU71LSSMwEe2OWBb
         98mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=ebyPwcdrPNJZ8NlIZPrB4jWl+zySFB+YPdDAxVIYV/A=;
        b=QIWIYep/a1U8s2eKq4PeUo6U7RWBeyuH9hJNPlgmBFH0aBfBk3K03dOx9D0q5JWG5s
         7HXfoGiF8GyS5ejdf+VtG1zwlkOlosBGCAgSLwXt0qH7HNBeDrq9OAMfZsHG1RRoVLCF
         pDg3RQFm5gByfXv8NuEeRQv1jZ9VZXFRJF/xU02FwtaPYyaRWTSe5dS4RYxdcSyNI85w
         g8Yq4JCYiKKDYm0iNs0R0qb9HLI2UrEo6S4XRSNFjzjZsBWvpdGSGv4V+14gGH5psZIb
         LZ0gH1kUeLOikYVT0EyplpcmcKwFlfj5+2+85iEhKnpK7Z0J0E5LBzhH3HSf8Tp1aSaE
         rveA==
X-Gm-Message-State: AOAM531nu8xWwa1BC3Oa5RMbj3QdqprnUTbenp03egAR3XqZ1MS429OW
        v4mMU3OQJ1CROMpOGFowHrHExw==
X-Google-Smtp-Source: ABdhPJzZWLpyDMfLjVsPnnpXEwimN8gu3yG1xx9ftWalQYNb/W3R8Epva41nLZHvd2tJJIyGtiYs+g==
X-Received: by 2002:adf:e707:: with SMTP id c7mr22409856wrm.391.1618944805800;
        Tue, 20 Apr 2021 11:53:25 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id f7sm25897402wrp.48.2021.04.20.11.53.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Apr 2021 11:53:25 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, netdev@vger.kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH v3 net-next 5/5] dt-bindings: net: dsa: Document dsa-tag-protocol property
Date:   Tue, 20 Apr 2021 20:53:11 +0200
Message-Id: <20210420185311.899183-6-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210420185311.899183-1-tobias@waldekranz.com>
References: <20210420185311.899183-1-tobias@waldekranz.com>
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 'dsa-tag-protocol' is used to force a switch tree to use a
particular tag protocol, typically because the Ethernet controller
that it is connected to is not compatible with the default one.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 Documentation/devicetree/bindings/net/dsa/dsa.yaml | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/dsa.yaml b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
index 8a3494db4d8d..16aa192c118e 100644
--- a/Documentation/devicetree/bindings/net/dsa/dsa.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
@@ -70,6 +70,15 @@ patternProperties:
               device is what the switch port is connected to
             $ref: /schemas/types.yaml#/definitions/phandle
 
+          dsa-tag-protocol:
+            description:
+              Instead of the default, the switch will use this tag protocol if
+              possible. Useful when a device supports multiple protcols and
+              the default is incompatible with the Ethernet device.
+            enum:
+              - dsa
+              - edsa
+
           phy-handle: true
 
           phy-mode: true
-- 
2.25.1

