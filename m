Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FFA4229E7A
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 19:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732366AbgGVRYt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 13:24:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732022AbgGVRYq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 13:24:46 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D2F3C0619E1;
        Wed, 22 Jul 2020 10:24:46 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id d18so2245518edv.6;
        Wed, 22 Jul 2020 10:24:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IwiK0U+Dhjv5R+D7L68/33/y00cq8SjNmUGfjDZfVnI=;
        b=d0fnGmpqyawQ6ZYxmbsWP6gl4hH8VZ6oUxfyea9jfSgAlL1mLymyW1fokoRJvAxg+H
         nlvajnhjmIzmBmnwyvX5fIjTcEWEPB4zIn0sYqns8vUqTWhFpX9fkQV21VFg7foAKeJm
         KLb48FjP3k9d5Q6Bq0GxgeCjC04cq0vnYj/KDJP94v7UEGtsQdSIaLDi3vOQlC5aVhEV
         qFj9sYBIjqlkHNfabEpR2Yp6ukw/GsWQfMrQHeUwKFlbmgdWiKpyQMmbC2CWDrSEVp+M
         zMyn/VPPsXBwVsmG+3TBI6HR3KTrdmUNyXEaSut29/0TdDxDrCyqwPa9oGLlBijDxvnA
         omsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IwiK0U+Dhjv5R+D7L68/33/y00cq8SjNmUGfjDZfVnI=;
        b=E5mu/xmy1omN0iNebeoETrWOREbhgh7iW7QIvrAHMElxpWM3o/g0SNIXJVRASDaMsP
         mXHMpgVuvVVOqwQxifRlG5Uu+yzeIrhUtocLsmZZPNJgaD8NZkgWWb8+aeacs/RHeUsq
         7lcw6fQ4UmNBkW6gWVmH7dDMlsk5gC9OOiOwsYIY2TX0zfdM5sTxDcwgAZUpTQOoA6OM
         yilwWYfqn41qEj2YQhyXH09k4UCg1fmqxBMZm7F/+Z3g/pQheSWlLGLg/JMRSB7MFTrx
         JOo8guWORMpbVyU1enZKITCyArVURmsv9vvSINarXekWlE1h6TzaaBXLZWhX2/mys5Pt
         VC+w==
X-Gm-Message-State: AOAM5307h4zdTF33Y9aBDiX5Mw0QEcvquW7XltEfmtaxCoKPHaO7gFTk
        H+pAIW8p0qvg1RJw5KZt79I=
X-Google-Smtp-Source: ABdhPJwN32en1tjwVds6TL6SW0e/xdD/1wt15akze77kDflk28RHrFyCzGDTRIFEKftNULw8jz/XBQ==
X-Received: by 2002:a50:d55b:: with SMTP id f27mr514751edj.312.1595438684854;
        Wed, 22 Jul 2020 10:24:44 -0700 (PDT)
Received: from localhost.localdomain ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id bt26sm311517edb.17.2020.07.22.10.24.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2020 10:24:44 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     robh+dt@kernel.org, shawnguo@kernel.org, mpe@ellerman.id.au,
        devicetree@vger.kernel.org
Cc:     benh@kernel.crashing.org, paulus@samba.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, madalin.bucur@oss.nxp.com,
        radu-andrei.bulie@nxp.com, fido_max@inbox.ru
Subject: [PATCH devicetree 4/4] powerpc: dts: t1040rdb: add ports for Seville Ethernet switch
Date:   Wed, 22 Jul 2020 20:24:22 +0300
Message-Id: <20200722172422.2590489-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200722172422.2590489-1-olteanv@gmail.com>
References: <20200722172422.2590489-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define the network interface names for the switch ports and hook them up
to the 2 QSGMII PHYs that are onboard.

A conscious decision was taken to go along with the numbers that are
written on the front panel of the board and not with the hardware
numbers of the switch chip ports. The 2 are shifted by 4.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 arch/powerpc/boot/dts/fsl/t1040rdb.dts | 111 +++++++++++++++++++++++++
 1 file changed, 111 insertions(+)

diff --git a/arch/powerpc/boot/dts/fsl/t1040rdb.dts b/arch/powerpc/boot/dts/fsl/t1040rdb.dts
index 40d7126dbe90..28ee06a1706d 100644
--- a/arch/powerpc/boot/dts/fsl/t1040rdb.dts
+++ b/arch/powerpc/boot/dts/fsl/t1040rdb.dts
@@ -75,4 +75,115 @@ &mdio0 {
 	phy_sgmii_2: ethernet-phy@3 {
 		reg = <0x3>;
 	};
+
+	/* VSC8514 QSGMII PHY */
+	phy_qsgmii_0: ethernet-phy@4 {
+		reg = <0x4>;
+	};
+
+	phy_qsgmii_1: ethernet-phy@5 {
+		reg = <0x5>;
+	};
+
+	phy_qsgmii_2: ethernet-phy@6 {
+		reg = <0x6>;
+	};
+
+	phy_qsgmii_3: ethernet-phy@7 {
+		reg = <0x7>;
+	};
+
+	/* VSC8514 QSGMII PHY */
+	phy_qsgmii_4: ethernet-phy@8 {
+		reg = <0x8>;
+	};
+
+	phy_qsgmii_5: ethernet-phy@9 {
+		reg = <0x9>;
+	};
+
+	phy_qsgmii_6: ethernet-phy@a {
+		reg = <0xa>;
+	};
+
+	phy_qsgmii_7: ethernet-phy@b {
+		reg = <0xb>;
+	};
+};
+
+&seville_port0 {
+	managed = "in-band-status";
+	phy-handle = <&phy_qsgmii_0>;
+	phy-mode = "qsgmii";
+	/* ETH4 written on chassis */
+	label = "swp4";
+	status = "okay";
+};
+
+&seville_port1 {
+	managed = "in-band-status";
+	phy-handle = <&phy_qsgmii_1>;
+	phy-mode = "qsgmii";
+	/* ETH5 written on chassis */
+	label = "swp5";
+	status = "okay";
+};
+
+&seville_port2 {
+	managed = "in-band-status";
+	phy-handle = <&phy_qsgmii_2>;
+	phy-mode = "qsgmii";
+	/* ETH6 written on chassis */
+	label = "swp6";
+	status = "okay";
+};
+
+&seville_port3 {
+	managed = "in-band-status";
+	phy-handle = <&phy_qsgmii_3>;
+	phy-mode = "qsgmii";
+	/* ETH7 written on chassis */
+	label = "swp7";
+	status = "okay";
+};
+
+&seville_port4 {
+	managed = "in-band-status";
+	phy-handle = <&phy_qsgmii_4>;
+	phy-mode = "qsgmii";
+	/* ETH8 written on chassis */
+	label = "swp8";
+	status = "okay";
+};
+
+&seville_port5 {
+	managed = "in-band-status";
+	phy-handle = <&phy_qsgmii_5>;
+	phy-mode = "qsgmii";
+	/* ETH9 written on chassis */
+	label = "swp9";
+	status = "okay";
+};
+
+&seville_port6 {
+	managed = "in-band-status";
+	phy-handle = <&phy_qsgmii_6>;
+	phy-mode = "qsgmii";
+	/* ETH10 written on chassis */
+	label = "swp10";
+	status = "okay";
+};
+
+&seville_port7 {
+	managed = "in-band-status";
+	phy-handle = <&phy_qsgmii_7>;
+	phy-mode = "qsgmii";
+	/* ETH11 written on chassis */
+	label = "swp11";
+	status = "okay";
+};
+
+&seville_port8 {
+	ethernet = <&enet0>;
+	status = "okay";
 };
-- 
2.25.1

