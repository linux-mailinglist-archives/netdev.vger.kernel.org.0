Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A61C9229E7E
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 19:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731843AbgGVRYo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 13:24:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726980AbgGVRYm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 13:24:42 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 843D5C0619DC;
        Wed, 22 Jul 2020 10:24:42 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id g20so2260138edm.4;
        Wed, 22 Jul 2020 10:24:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vHgiL55jxDrujS/wtQnL77G2JrcZ1DngkTtPEjQmevw=;
        b=DaGkdRNfS8eXOBKB5sp0VfYsh5wlQq7pP2Y+QI84Pxei90Prd/XesQk8y64weQCjFE
         L86OcBmZoUSZgIa2YE2s+OKBewK5rBIob8PYrvByLTE9XNqc8RLuImeOh84tsK91hpi3
         i8CV2XUi0ZabD2QljLDMLQVJ3A0pnt+qRjIzv53RRgFbfDOWO4fQpAJ1veUbAA/PttcU
         DcRUDiUaOESxMwRpXL8NgIwbGJudZJ328hRyy4/awcGF/wyHSPiJ9nSjf068Upy+b8oD
         YMOHGhrd1G6VRmJHAMmAMZc42+x3O6Kqku58mnjIqCAQvoiUqDX3+yhM4Dyiutqv/OjC
         8GVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vHgiL55jxDrujS/wtQnL77G2JrcZ1DngkTtPEjQmevw=;
        b=AbNbo+SaYzwnrPLIJjmzcXXK7cFmYbvjcACDulPFvCH1aCw/nLqc2XhjZSGID+oqVO
         rxBUYNeYvt8ChHwVNvp0pe9ysc7wfPQk6YQY0JewwzewVyP3eT4pX8Sz8VXXvfMIvJ2P
         nOtFhHGKVOlpbxnKE9wbs8sdzOt4Mz9RA6fZ0YW8OIuyQeZYyPLxTEV9t6o7qaZDDOVO
         GbxiXknpF7K36x8cPKga5OTkTx1qY73DcD1SJ31R/weMlV+vT0MfIVqJudc1QXGOJWrw
         UDhFwrkuv0JdcYa6JFPsycyA7X2h/+vVnI19FM8LZxeCW+wkd4iLWoNuGhlrjAvHwClV
         z3KQ==
X-Gm-Message-State: AOAM532MhVF30PLVB9l66ycu1ojSLAhv70Sf0YZ4D9ff5tvcPMDRA+Kz
        LIPKNus6LIl3mPtG+z2n3ag=
X-Google-Smtp-Source: ABdhPJyXxT+y27dnP3zqkhp3Z0x2wLeOmgRRK6nopGhYGs2ugqJ+s1/IyCgvhCQI1tHV163CaotnFQ==
X-Received: by 2002:a50:fe0c:: with SMTP id f12mr496188edt.360.1595438681135;
        Wed, 22 Jul 2020 10:24:41 -0700 (PDT)
Received: from localhost.localdomain ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id bt26sm311517edb.17.2020.07.22.10.24.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2020 10:24:40 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     robh+dt@kernel.org, shawnguo@kernel.org, mpe@ellerman.id.au,
        devicetree@vger.kernel.org
Cc:     benh@kernel.crashing.org, paulus@samba.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, madalin.bucur@oss.nxp.com,
        radu-andrei.bulie@nxp.com, fido_max@inbox.ru
Subject: [PATCH devicetree 1/4] powerpc: dts: t1040: add bindings for Seville Ethernet switch
Date:   Wed, 22 Jul 2020 20:24:19 +0300
Message-Id: <20200722172422.2590489-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200722172422.2590489-1-olteanv@gmail.com>
References: <20200722172422.2590489-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the description of the embedded L2 switch inside the SoC dtsi file
for NXP T1040.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 arch/powerpc/boot/dts/fsl/t1040si-post.dtsi | 75 +++++++++++++++++++++
 1 file changed, 75 insertions(+)

diff --git a/arch/powerpc/boot/dts/fsl/t1040si-post.dtsi b/arch/powerpc/boot/dts/fsl/t1040si-post.dtsi
index 315d0557eefc..4af856dcc6a3 100644
--- a/arch/powerpc/boot/dts/fsl/t1040si-post.dtsi
+++ b/arch/powerpc/boot/dts/fsl/t1040si-post.dtsi
@@ -628,6 +628,81 @@ mdio@fd000 {
 			status = "disabled";
 		};
 	};
+
+	seville_switch: ethernet-switch@800000 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "mscc,vsc9953-switch";
+		little-endian;
+		reg = <0x800000 0x290000>;
+
+		ports {
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			seville_port0: port@0 {
+				reg = <0>;
+				status = "disabled";
+			};
+
+			seville_port1: port@1 {
+				reg = <1>;
+				status = "disabled";
+			};
+
+			seville_port2: port@2 {
+				reg = <2>;
+				status = "disabled";
+			};
+
+			seville_port3: port@3 {
+				reg = <3>;
+				status = "disabled";
+			};
+
+			seville_port4: port@4 {
+				reg = <4>;
+				status = "disabled";
+			};
+
+			seville_port5: port@5 {
+				reg = <5>;
+				status = "disabled";
+			};
+
+			seville_port6: port@6 {
+				reg = <6>;
+				status = "disabled";
+			};
+
+			seville_port7: port@7 {
+				reg = <7>;
+				status = "disabled";
+			};
+
+			seville_port8: port@8 {
+				reg = <8>;
+				phy-mode = "internal";
+				status = "disabled";
+
+				fixed-link {
+					speed = <2500>;
+					full-duplex;
+				};
+			};
+
+			seville_port9: port@9 {
+				reg = <9>;
+				phy-mode = "internal";
+				status = "disabled";
+
+				fixed-link {
+					speed = <2500>;
+					full-duplex;
+				};
+			};
+		};
+	};
 };
 
 &qe {
-- 
2.25.1

