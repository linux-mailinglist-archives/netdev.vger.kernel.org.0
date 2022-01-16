Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D504B48FF04
	for <lists+netdev@lfdr.de>; Sun, 16 Jan 2022 22:16:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236185AbiAPVQF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jan 2022 16:16:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236162AbiAPVQB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jan 2022 16:16:01 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3448C06161C
        for <netdev@vger.kernel.org>; Sun, 16 Jan 2022 13:16:00 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id n19-20020a7bc5d3000000b003466ef16375so19843392wmk.1
        for <netdev@vger.kernel.org>; Sun, 16 Jan 2022 13:16:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=OYx9JCI6DcrgKeqxQcsds9tuZxZXQZpFHva5BE3zQL4=;
        b=tEQ3Z8ArVhbEOydXcPfD6z02encandhWSTEPXG0PyWYE8yDtw+UL8FwKA44xl4SWMU
         X6Qm+gpBc1Khn7VtlAdiva7ORd8VE7v3PuSx2CseK0ifZb81ijLf3VW2pIo3sELVqspw
         GTkn8RI1Ghd+0zQb2HIEky2x3wcbVCNPlD1Nr2eiWC2I3OfF4xGUqFjLPkofjAiQTi83
         xJwxegF5xZqmhXcgLtyDqteBTAOacAsuRO0xxWXLYFNvZRev6esjHTO+o9rjJGDXU+We
         FxdF/6w8DrWc9R+QuHPSItS6JmFi8isnosrIMTT3iXb3cyG4FI1RicV5/cB2mOWFKZ8g
         1+Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=OYx9JCI6DcrgKeqxQcsds9tuZxZXQZpFHva5BE3zQL4=;
        b=F8edTLjxPxFpaPjmCVjQw55iESli4FjhWaPnQaGZ0TUhsHXicA7A9fnv/HLKN1BNIb
         +O+3ETABnmYGAgzY3WuToqEodU0Rz5ZOs60RxfdqT8CkDjFNLAkFPs8cZNWdWpx+sNIT
         URlOQ8LLkLrUrIoyp27hi/F+wyIKKJJ/Lc/9SV79kp20V+wJD22rf7XsnalP/aZWgqBa
         sIXAO6kPlRtb1zCJ1XPd5z9l7gXKM7jzajmV5udwSqcCyZgavsjW34Vsa0vcBqsEj6ZG
         6zuyX4vrmL3yenU5yF5MtKn0JoyRPHiANd1Iklexlpsc9QIp5Krh80bTl3W04MKu0Oku
         Blmg==
X-Gm-Message-State: AOAM533JbE1D7O4dclevECXXzeM3QFzaxkWox+gVzRnfo54TNzRAl2LN
        myENRYIu9Qp1CbrjLZ+TfPhD2A==
X-Google-Smtp-Source: ABdhPJwNI6YNksXjvEy8DE/JH4Lfpaq7XmCMwtYuyn8XmgW/tNTS2qAAmHFICjzlNLuvLqxGCA+Ecw==
X-Received: by 2002:a05:600c:48a1:: with SMTP id j33mr17126323wmp.143.1642367759452;
        Sun, 16 Jan 2022 13:15:59 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id l12sm8820445wrz.15.2022.01.16.13.15.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Jan 2022 13:15:59 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     madalin.bucur@nxp.com, robh+dt@kernel.org, mpe@ellerman.id.au,
        benh@kernel.crashing.org, paulus@samba.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH net 2/4] dt-bindings: net: Document fsl,erratum-a009885
Date:   Sun, 16 Jan 2022 22:15:27 +0100
Message-Id: <20220116211529.25604-3-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220116211529.25604-1-tobias@waldekranz.com>
References: <20220116211529.25604-1-tobias@waldekranz.com>
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update FMan binding documentation with the newly added workaround for
erratum A-009885.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 Documentation/devicetree/bindings/net/fsl-fman.txt | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/fsl-fman.txt b/Documentation/devicetree/bindings/net/fsl-fman.txt
index c00fb0d22c7b..020337f3c05f 100644
--- a/Documentation/devicetree/bindings/net/fsl-fman.txt
+++ b/Documentation/devicetree/bindings/net/fsl-fman.txt
@@ -410,6 +410,15 @@ PROPERTIES
 		The settings and programming routines for internal/external
 		MDIO are different. Must be included for internal MDIO.
 
+- fsl,erratum-a009885
+		Usage: optional
+		Value type: <boolean>
+		Definition: Indicates the presence of the A009885
+		erratum describing that the contents of MDIO_DATA may
+		become corrupt unless it is read within 16 MDC cycles
+		of MDIO_CFG[BSY] being cleared, when performing an
+		MDIO read operation.
+
 - fsl,erratum-a011043
 		Usage: optional
 		Value type: <boolean>
-- 
2.25.1

