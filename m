Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E25A3BAD20
	for <lists+netdev@lfdr.de>; Sun,  4 Jul 2021 15:44:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbhGDNqn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Jul 2021 09:46:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:49570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229492AbhGDNqn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Jul 2021 09:46:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C8BF56135E;
        Sun,  4 Jul 2021 13:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625406247;
        bh=MYohB4g8eApmOYH22PeGUHcPJsvJYRC200dPF1gqeaI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ew+n/prGNPaa3srnHCKUkgf+P7ZwGiulDvzud8sJJfd61GMUxDiIDUzt1ICwKd4jh
         BMFK1jM6hXfrbDUxZLR92IUDeFFDfCjkpvjWwdn4RZEVjpeAPSyCuCtg2LmYZDx7E0
         uEGxzwWGeZqhcrGT+n9lXpvzMF0WfPeCNulmiFLWODj1XJmpFBYpP1FKaPCi++3gX6
         rvENgFbzyESRpRYAHNEG+kGxIt0uR0fgIIuJhA89FRQd7RzuPmMCCEF8ykSB4C423E
         Ythv5tXlSm0vbHpv3AdVdUGrE2A63ULQB1ZWNAHCb4tvAy4Ldk1QmjecrfR1Ei0DdU
         5iixdfXFDmVcw==
Received: by pali.im (Postfix)
        id 8114E9CA; Sun,  4 Jul 2021 15:44:05 +0200 (CEST)
From:   =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>, Russell King <linux@armlinux.org.uk>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "Camelia Alexandra Groza (OSS)" <camelia.groza@oss.nxp.com>
Cc:     Scott Wood <oss@buserror.net>, Rob Herring <robh+dt@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] powerpc/fsl/dts: Fix phy-connection-type for fm1mac3
Date:   Sun,  4 Jul 2021 15:43:25 +0200
Message-Id: <20210704134325.24842-1-pali@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210604233455.fwcu2chlsed2gwmu@pali>
References: <20210604233455.fwcu2chlsed2gwmu@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Property phy-connection-type contains invalid value "sgmii-2500" per scheme
defined in file ethernet-controller.yaml.

Correct phy-connection-type value should be "2500base-x".

Signed-off-by: Pali Rohár <pali@kernel.org>
Fixes: 84e0f1c13806 ("powerpc/mpc85xx: Add MDIO bus muxing support to the board device tree(s)")
---
 arch/powerpc/boot/dts/fsl/t1023rdb.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/boot/dts/fsl/t1023rdb.dts b/arch/powerpc/boot/dts/fsl/t1023rdb.dts
index 5ba6fbfca274..f82f85c65964 100644
--- a/arch/powerpc/boot/dts/fsl/t1023rdb.dts
+++ b/arch/powerpc/boot/dts/fsl/t1023rdb.dts
@@ -154,7 +154,7 @@
 
 			fm1mac3: ethernet@e4000 {
 				phy-handle = <&sgmii_aqr_phy3>;
-				phy-connection-type = "sgmii-2500";
+				phy-connection-type = "2500base-x";
 				sleep = <&rcpm 0x20000000>;
 			};
 
-- 
2.20.1

