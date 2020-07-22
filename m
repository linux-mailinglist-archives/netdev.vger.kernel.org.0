Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC6A229E77
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 19:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732111AbgGVRYr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 13:24:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726980AbgGVRYp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 13:24:45 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE727C0619E0;
        Wed, 22 Jul 2020 10:24:44 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id f12so3056953eja.9;
        Wed, 22 Jul 2020 10:24:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fkjRjgqmL9cSG9e/Flla8rZThIqv1kD45KaUMdt112E=;
        b=AGQDHPvHM8zufKwGgOsKli2uXLvFTiN2RfHhyglp5Y+ezUK3B4LwfNCm298BkBTCb+
         AjzP2W77WbuPxgJ72AOeHLIJRhLdfPGA71EZtWztpbKHDtxGr8x2U8dtmXcL0XOmVC0p
         gpCzzhQXgCbUDiSnuKdCO4XXteBU0ruDrB6kzxPogReG1rYujCFBzQUAynw71CKuCFZu
         2GTsFelCVs4biVZ4YPnKl6AlvCOj88y0GImybPcdDDMRylJnbt+9vYDUdkKKcTAokkj5
         cwcbhnUolcLdoaULWwmnfF+Kk+k4rUT7nnZyQ5nltLeXiC+1fM6D0P7R2yt6wmf1tlud
         uAjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fkjRjgqmL9cSG9e/Flla8rZThIqv1kD45KaUMdt112E=;
        b=J6q7u/ZxoFVET37jMWeNAu25E5CAxV9TTWgU3tHu7nn+moCbkoMk3BnY3o7xqodc3r
         fBxz7Iadbc92Mv1Ht/ctvCYqTuW25hOMe5gtMnFFOxnUMsf9niHAkvLN7b6xVB1KhkfK
         kVUvJrJDNLOMOTFqgpYEl1HpIwGYpA3ZMYuC9N8yWGw1n3yzYP9i42YYfBNRtMzePzLN
         PfTJFeGn1ohjSUOW3kDnvv8Qs1jiSYcN1dlDzCFT8O9fQcXkAzphqP2+2zgji6MyT6PU
         DBL3zqFozjOSjsOdmGIPOl13hnyx/arq46aQkUD2pUSY6D8W+fmbj2ZaKON4hP0ldDXz
         euUw==
X-Gm-Message-State: AOAM530DNr0YHk6ExK2dGCj3D/bhsv4Qxc6MkM9mUSpNXM5lYWShSEKD
        WmTYK/+TNO/03tmIgs1FoOs=
X-Google-Smtp-Source: ABdhPJxnnRi1Q6Spyx54hWbixVxvTLOnzK7/JDNXb7ja9hltyn+X7XnRO6znLoGbFJqK6fc2Usydpg==
X-Received: by 2002:a17:906:430b:: with SMTP id j11mr611733ejm.270.1595438683625;
        Wed, 22 Jul 2020 10:24:43 -0700 (PDT)
Received: from localhost.localdomain ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id bt26sm311517edb.17.2020.07.22.10.24.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2020 10:24:43 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     robh+dt@kernel.org, shawnguo@kernel.org, mpe@ellerman.id.au,
        devicetree@vger.kernel.org
Cc:     benh@kernel.crashing.org, paulus@samba.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, madalin.bucur@oss.nxp.com,
        radu-andrei.bulie@nxp.com, fido_max@inbox.ru
Subject: [PATCH devicetree 3/4] powerpc: dts: t1040rdb: put SGMII PHY under &mdio0 label
Date:   Wed, 22 Jul 2020 20:24:21 +0300
Message-Id: <20200722172422.2590489-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200722172422.2590489-1-olteanv@gmail.com>
References: <20200722172422.2590489-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We're going to add 8 more PHYs in a future patch. It is easier to follow
the hardware description if we don't need to fish for the path of the
MDIO controllers inside the SoC and just use the labels.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 arch/powerpc/boot/dts/fsl/t1040rdb.dts | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/boot/dts/fsl/t1040rdb.dts b/arch/powerpc/boot/dts/fsl/t1040rdb.dts
index 65ff34c49025..40d7126dbe90 100644
--- a/arch/powerpc/boot/dts/fsl/t1040rdb.dts
+++ b/arch/powerpc/boot/dts/fsl/t1040rdb.dts
@@ -59,12 +59,6 @@ ethernet@e4000 {
 				phy-handle = <&phy_sgmii_2>;
 				phy-connection-type = "sgmii";
 			};
-
-			mdio@fc000 {
-				phy_sgmii_2: ethernet-phy@3 {
-					reg = <0x03>;
-				};
-			};
 		};
 	};
 
@@ -76,3 +70,9 @@ cpld@3,0 {
 };
 
 #include "t1040si-post.dtsi"
+
+&mdio0 {
+	phy_sgmii_2: ethernet-phy@3 {
+		reg = <0x3>;
+	};
+};
-- 
2.25.1

