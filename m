Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06BD14FC64E
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 23:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236250AbiDKVIE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 17:08:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230074AbiDKVIC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 17:08:02 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E428B1C3;
        Mon, 11 Apr 2022 14:05:47 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id 88-20020a9d0ee1000000b005d0ae4e126fso12136836otj.5;
        Mon, 11 Apr 2022 14:05:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yxvMPm4Er+k4XJD+1T3NqzNOxccKbRO/T6RynpjDsiI=;
        b=hdB/UTz3V1XEYy9ZsFEeDNEmhNmZyWZdVOugUlwHb/KntYpTlqZ5jjy/JE1m3aJ3RX
         /0vK/8jKlgXu1ihYZ5yeHWUGyKk5nBeDgs7RFvo9K+vgVMuOBReeIHz6+oEkFS646C1I
         0Ehoeq+Prd3bbTgrlKfJq22gN5bZULuT78Ns7Od4FRs7FAmewwPBEb9/tx05TpHpKzUa
         hZiAEyjbcN84orkofRba9VaHml/RSwzi95v+5xMZKpYzgiNcPVCZkhdc24HrMMg1BeMp
         sZfV1lTlMntFRiE249+yMGMz22VNSYP5vMvQM30AFZHqZQmur3+J9JnP5mh0Kjbr6ukN
         z3+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yxvMPm4Er+k4XJD+1T3NqzNOxccKbRO/T6RynpjDsiI=;
        b=RSW8sSpqtn5cRLw3CIi9kqWT0VBZCzD6eMcga1pYADM4AaItYBl2ILCh446Q/wW4/G
         pVLHlPBLRqwRe+F6oD9fkph5VE+SuXyfsOML4tuvvJlMlq+bSXmhtYDQ/JVpT//IjAWp
         JL5Bzqgkm+OIVSu+HzsZqVAmGUze3nkCKFG/qG1lwbxG3b8Cfr1cEmMMPJnX2wtQLgto
         1sNdImdZaq630EV9+czwF+bQhzV2wSrPi4I0I157sPNqEuQoXqLUSIKrnnlsgoZHf+UF
         0T+/308sWVJKi34aqflsSkiKKxND8bpMT/H3toAExvHFgXbuv4ADG5FjIV1M4svKyAzI
         hOIQ==
X-Gm-Message-State: AOAM532NNINuDa/BHQU0eIKtAwiuEaH2kF6I+RCsv5glALrogDD2zE60
        pn28r1Cu7lE8/Kra0DI3aL0p97RS5hRcRA==
X-Google-Smtp-Source: ABdhPJyDdgma6U7O/MrlZEQ94di4kWlbOTGUGk8PHodDppNYjdLS4SE3n634uL9fc6swAiDTKdweMQ==
X-Received: by 2002:a05:6830:11c2:b0:5cd:9272:326a with SMTP id v2-20020a05683011c200b005cd9272326amr11868693otq.102.1649711146712;
        Mon, 11 Apr 2022 14:05:46 -0700 (PDT)
Received: from tresc043793.tre-sc.gov.br ([187.94.103.218])
        by smtp.gmail.com with ESMTPSA id d1-20020a056830138100b005cf2f29d89csm12377462otq.77.2022.04.11.14.05.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 14:05:46 -0700 (PDT)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linux-doc@vger.kernel.org, tobias@waldekranz.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vladimir.oltean@nxp.com, corbet@lwn.net,
        kuba@kernel.org, davem@davemloft.net,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>
Subject: [PATCH net-next] net: dsa: realtek: add compatible strings for RTL8367RB-VB
Date:   Mon, 11 Apr 2022 18:04:07 -0300
Message-Id: <20220411210406.21404-1-luizluca@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RTL8367RB-VB was not mentioned in the compatible table, nor in the
Kconfig help text.

The driver still detects the variant by itself and ignores which
compatible string was used to select it. So, any compatible string will
work for any compatible model.

Reported-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
---
 drivers/net/dsa/realtek/Kconfig        | 3 ++-
 drivers/net/dsa/realtek/realtek-mdio.c | 1 +
 drivers/net/dsa/realtek/realtek-smi.c  | 4 ++++
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/realtek/Kconfig b/drivers/net/dsa/realtek/Kconfig
index b7427a8292b2..8eb5148bcc00 100644
--- a/drivers/net/dsa/realtek/Kconfig
+++ b/drivers/net/dsa/realtek/Kconfig
@@ -29,7 +29,8 @@ config NET_DSA_REALTEK_RTL8365MB
 	depends on NET_DSA_REALTEK_SMI || NET_DSA_REALTEK_MDIO
 	select NET_DSA_TAG_RTL8_4
 	help
-	  Select to enable support for Realtek RTL8365MB-VC and RTL8367S.
+	  Select to enable support for Realtek RTL8365MB-VC, RTL8367RB-VB
+	  and RTL8367S.
 
 config NET_DSA_REALTEK_RTL8366RB
 	tristate "Realtek RTL8366RB switch subdriver"
diff --git a/drivers/net/dsa/realtek/realtek-mdio.c b/drivers/net/dsa/realtek/realtek-mdio.c
index 31e1f100e48e..a36b0d8f17ff 100644
--- a/drivers/net/dsa/realtek/realtek-mdio.c
+++ b/drivers/net/dsa/realtek/realtek-mdio.c
@@ -267,6 +267,7 @@ static const struct of_device_id realtek_mdio_of_match[] = {
 #endif
 #if IS_ENABLED(CONFIG_NET_DSA_REALTEK_RTL8365MB)
 	{ .compatible = "realtek,rtl8365mb", .data = &rtl8365mb_variant, },
+	{ .compatible = "realtek,rtl8367rb", .data = &rtl8365mb_variant, },
 	{ .compatible = "realtek,rtl8367s", .data = &rtl8365mb_variant, },
 #endif
 	{ /* sentinel */ },
diff --git a/drivers/net/dsa/realtek/realtek-smi.c b/drivers/net/dsa/realtek/realtek-smi.c
index 2243d3da55b2..c2200bd23448 100644
--- a/drivers/net/dsa/realtek/realtek-smi.c
+++ b/drivers/net/dsa/realtek/realtek-smi.c
@@ -556,6 +556,10 @@ static const struct of_device_id realtek_smi_of_match[] = {
 		.compatible = "realtek,rtl8365mb",
 		.data = &rtl8365mb_variant,
 	},
+	{
+		.compatible = "realtek,rtl8367rb",
+		.data = &rtl8365mb_variant,
+	},
 	{
 		.compatible = "realtek,rtl8367s",
 		.data = &rtl8365mb_variant,
-- 
2.35.1

