Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99EFD229E7C
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 19:25:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732272AbgGVRYs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 13:24:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731775AbgGVRYo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 13:24:44 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A91A3C0619DC;
        Wed, 22 Jul 2020 10:24:43 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id w6so3075059ejq.6;
        Wed, 22 Jul 2020 10:24:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DhWfch+PbL1rQUKAB1Yk9Mz5NfmZT5/0+GFbc58nQRA=;
        b=JPgnN6drMAWSqcalRvAHbi0jprbFBhTZt1Fn+Up3YHmEI9TXEVsbihS5m2v2jujTKi
         th+lqbLKWG8TJ9CK6MfNGiug1PEN44TkCOkoClPK/KoD1Cqe/ML8+pjQth/jdEGj+0s1
         AY0Mw4qCAXD87ReSQhInThTLddZMtBMGwtjqbnNeNy/GVDzQ4itqL74NXieTbN2AFm1C
         q+KKie38osW0q36ugZHVa8jtjoyRwyFmjoGPS564y8uHeU+WRIb+ARpMl2n/VqNZflml
         12WXUwRj/OS8cLeEaOhl4UdhyKWuDrMkX+VVl0WZavZNQle66LP+ClKDqvc2MEijcLrM
         7gOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DhWfch+PbL1rQUKAB1Yk9Mz5NfmZT5/0+GFbc58nQRA=;
        b=NUe/6hF4jFOLArLYdPNcEG1Tp45VmsGSoZiv1d0ABZsProAZl+vbYY/kmsp9WoHqUD
         Yiz4P0kBjFc73n4KouTTquCokgg055xTbzwQ6pha1Jk9zibDXjRhzpmnXdlaNtk1eOeL
         3LO7tK3Fy7YGw5GZ/2vwcIO8g0O5Aue1aVbn/sz96IG0/3QB0i0xQF5i0y6LGnnw3Fji
         tMOjqKphCmPcGMY8bD0PWvfcNqSFWIDGWcSi0BArzwsUlFKOi/nwkOWPAllTl9+OS+gH
         cSkeZULdWyUy/aaJzSGOaXGGNnoNqeTCtsKYWE16PRHVG3oXGIS6IlS1UuWUBsctnIca
         BlWw==
X-Gm-Message-State: AOAM530UVF+A07JWMKWMd7RaqSgFvNeOkk1pehpKkMfydDskGdB+kkNb
        dSR8mEs42AtUGtS5bYUSt9Q=
X-Google-Smtp-Source: ABdhPJwYA3wRe1o4pTeacQVi3bgm1z+xiH580Qd8+l/C/geLfJNkokneg3yRCMBmAP0GNjMZ2wgNiw==
X-Received: by 2002:a17:906:a253:: with SMTP id bi19mr588879ejb.338.1595438682371;
        Wed, 22 Jul 2020 10:24:42 -0700 (PDT)
Received: from localhost.localdomain ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id bt26sm311517edb.17.2020.07.22.10.24.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2020 10:24:41 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     robh+dt@kernel.org, shawnguo@kernel.org, mpe@ellerman.id.au,
        devicetree@vger.kernel.org
Cc:     benh@kernel.crashing.org, paulus@samba.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, madalin.bucur@oss.nxp.com,
        radu-andrei.bulie@nxp.com, fido_max@inbox.ru
Subject: [PATCH devicetree 2/4] powerpc: dts: t1040: label the 2 MDIO controllers
Date:   Wed, 22 Jul 2020 20:24:20 +0300
Message-Id: <20200722172422.2590489-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200722172422.2590489-1-olteanv@gmail.com>
References: <20200722172422.2590489-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation of referencing the MDIO nodes from board DTS files (so
that we can add PHY nodes easier), add labels to mdio0 and mdio1.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 arch/powerpc/boot/dts/fsl/t1040si-post.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/boot/dts/fsl/t1040si-post.dtsi b/arch/powerpc/boot/dts/fsl/t1040si-post.dtsi
index 4af856dcc6a3..e1b138b3c714 100644
--- a/arch/powerpc/boot/dts/fsl/t1040si-post.dtsi
+++ b/arch/powerpc/boot/dts/fsl/t1040si-post.dtsi
@@ -620,11 +620,11 @@ enet3: ethernet@e6000 {
 		enet4: ethernet@e8000 {
 		};
 
-		mdio@fc000 {
+		mdio0: mdio@fc000 {
 			interrupts = <100 1 0 0>;
 		};
 
-		mdio@fd000 {
+		mdio1: mdio@fd000 {
 			status = "disabled";
 		};
 	};
-- 
2.25.1

