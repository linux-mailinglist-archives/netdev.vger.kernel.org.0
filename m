Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74C99652159
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 14:20:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231609AbiLTNUB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 08:20:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbiLTNT5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 08:19:57 -0500
Received: from mail.savoirfairelinux.com (mail.savoirfairelinux.com [208.88.110.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 127A212A8D
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 05:19:56 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id 69C2F9C0868;
        Tue, 20 Dec 2022 08:19:55 -0500 (EST)
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id vLZcXDDTd5ej; Tue, 20 Dec 2022 08:19:55 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id 00EFC9C088E;
        Tue, 20 Dec 2022 08:19:55 -0500 (EST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.savoirfairelinux.com 00EFC9C088E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=savoirfairelinux.com; s=DFC430D2-D198-11EC-948E-34200CB392D2;
        t=1671542395; bh=us9wY1mhy6t+amK8ctrerw0mOAEoPYFNCW6Y5EcVkco=;
        h=From:To:Date:Message-Id:MIME-Version;
        b=ofXnrEVJDqul7h47+9zfj2U4L60mnfDMDKcGrOPXTIZhm5qBTB9T8Ya3LMFPWuzO6
         RcuMmzd20+blGvlXmeLB6wG3O5aQ+QOmdQlDu3okAVPdbrTlXmO3kw3NZZrG0bIHTr
         P4Xek5zaFylWRT2dSkvtelDjRtvIJc3wOQOg7uNKQ8IDCelI8xnADmZH7dApsdaaSx
         BGP3+gzW0jKwhjrD1RqCs76c5rdQ+X1Pbf6Zy1O0Lb+SEZGKZjepoVXUFc/QwA0DsI
         UatQUTiSDgWY+dHXhE+gUncSQVCZ9+kOBoPdJsj+vZFT/uh6A9mVn4yczZCwBGD/vV
         Pe064mjAilqNA==
X-Virus-Scanned: amavisd-new at mail.savoirfairelinux.com
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 1FL65iPdiSwE; Tue, 20 Dec 2022 08:19:54 -0500 (EST)
Received: from sfl-deribaucourt.rennes.sfl (mtl.savoirfairelinux.net [192.168.50.3])
        by mail.savoirfairelinux.com (Postfix) with ESMTPSA id 18B469C0868;
        Tue, 20 Dec 2022 08:19:54 -0500 (EST)
From:   Enguerrand de Ribaucourt 
        <enguerrand.de-ribaucourt@savoirfairelinux.com>
To:     netdev@vger.kernel.org
Cc:     pabeni@redhat.com, woojung.huh@microchip.com, davem@davemloft.net,
        UNGLinuxDriver@microchip.com,
        Enguerrand de Ribaucourt 
        <enguerrand.de-ribaucourt@savoirfairelinux.com>
Subject: [PATCH v3 1/3] net: phy: add EXPORT_SYMBOL to phy_disable_interrupts()
Date:   Tue, 20 Dec 2022 14:19:21 +0100
Message-Id: <20221220131921.806365-2-enguerrand.de-ribaucourt@savoirfairelinux.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <9235D6609DB808459E95D78E17F2E43D408987FF@CHN-SV-EXMX02.mchp-main.com>
References: <9235D6609DB808459E95D78E17F2E43D408987FF@CHN-SV-EXMX02.mchp-main.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It seems EXPORT_SYMBOL was forgotten when phy_disable_interrupts() was
made non static. For consistency with the other exported functions in
this file, EXPORT_SYMBOL should be used.

Fixes: 3dd4ef1bdbac ("net: phy: make phy_disable_interrupts() non-static"=
)
Signed-off-by: Enguerrand de Ribaucourt <enguerrand.de-ribaucourt@savoirf=
airelinux.com>
---
 drivers/net/phy/phy.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index e5b6cb1a77f9..33250da76466 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -992,6 +992,7 @@ int phy_disable_interrupts(struct phy_device *phydev)
 	/* Disable PHY interrupts */
 	return phy_config_interrupt(phydev, PHY_INTERRUPT_DISABLED);
 }
+EXPORT_SYMBOL(phy_disable_interrupts);
=20
 /**
  * phy_interrupt - PHY interrupt handler
--=20
2.25.1

