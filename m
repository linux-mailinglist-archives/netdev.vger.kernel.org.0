Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EDA541FA83
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 11:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232645AbhJBJGT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Oct 2021 05:06:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:55664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232611AbhJBJGT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 2 Oct 2021 05:06:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D55CE61AA9;
        Sat,  2 Oct 2021 09:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633165473;
        bh=m1O8K7AIaIxHDsI0pUGbMNZV2m4sU+hqM4GI4F3pMkc=;
        h=From:To:Cc:Subject:Date:From;
        b=sTdxKn8qyKWpiRchR6DAnM055Iw2NWr0zra85aX++Y+szXBuCE8d4tDtjcQcsmNKm
         yu1ly+zjpXtROj1NcDH+HLRSTY2uJSJVM5LOAY2eZT/Hc/Yw9EzaLIAtacAuOA4vsy
         ex3HL9UDu41G+6BmByAKwbuANMWWFSQt1dCA97ghiXOQd3DMdRhLJBfCzXy1GT2gas
         +OrApDhDcV3kuR8FN3gQ8XSENL+q/ZcpJfiF3Kl3paa8uwB/uWrzfJGx5pGI8iXmFW
         KwBoempfJjqIyaQz/eiBVDo5+5OerYY1TIZ9sw2sRDtlc82Gdwa1sL+/I3Taj06sJa
         vw6CgL0eHpdCA==
Received: by pali.im (Postfix)
        id 4EF0F1087; Sat,  2 Oct 2021 11:04:30 +0200 (CEST)
From:   =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     Russell King <linux@armlinux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RESEND PATCH] powerpc/fsl/dts: Fix phy-connection-type for fm1mac3
Date:   Sat,  2 Oct 2021 11:04:09 +0200
Message-Id: <20211002090409.3833-1-pali@kernel.org>
X-Mailer: git-send-email 2.20.1
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
Acked-by: Scott Wood <oss@buserror.net>
---
Per Andrew's request I'm resending this patch again:
https://patchwork.kernel.org/project/netdevbpf/patch/20210704134325.24842-1-pali@kernel.org/
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

