Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE9AE7971
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 20:54:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbfJ1Tyd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 15:54:33 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:44051 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725839AbfJ1Tyd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 15:54:33 -0400
Received: by mail-wr1-f66.google.com with SMTP id z11so11165762wro.11
        for <netdev@vger.kernel.org>; Mon, 28 Oct 2019 12:54:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=M2WVc9lKRCOuYEQFeZsUPETWAveUARatIRlRJMzE7gc=;
        b=BfaorQN51gCvuORiTxvV8zSYHOo4MD+/DY+idIK7Ha/DHBpRNkvR9gFTT7P6KRAVYn
         3XDKM74DxGxzt0rtvUT/mGRIs7mtH3Zg0CmaaoKUF39uC5DB4VKUFvQeFi8igh9izzfU
         bIPoMitzHYLdoT1HgBOTvMr91D/TT0cvYnNS+uqemGUuZz2L9mU0DywJct25+MscMmoP
         WFpXte+FpvDD6NO75RX3qGA+aTHzVm0pssWmj4E5pv8qFeDA4dJBAjJzKu+7ilpggzBl
         FuF4eLAwCs+P64sR2YkHDFp+3nL+XD2SZfWsPPa37+87hokLUxBr7nwfkBcmimc5Dbn3
         4TtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=M2WVc9lKRCOuYEQFeZsUPETWAveUARatIRlRJMzE7gc=;
        b=fP0tZnWjctThH3aueHGAXtbaOH1VUmuBlXQ202kBUcd9MpuHTWcicf5SfInBYxdeTG
         Fc+bJ1H9dwRBEhjH1I92OwTsqh+zbl1poKeO3KBnsH3bff7JGsWpxEsVCrTci6ydCec2
         Kf4GoIxyfX4Vb4s98SLgJTlGUBmufB/3Hj4BVWWGJQz/qfnwHV2aXnrm5Zkq53mygDhp
         qiDQHxXMYlhEIwE3XMWX+Zrs+j0sHmas281UsglvFOX6A8Fl9ThYA7ytHCkfarcI7wQA
         E5/mnuF1OqnUj6RhIlmnE9ctPgdy9ks2lWd5D9uBapbWcF9WZc0yEWkc4n2NvxDmTKxI
         keMA==
X-Gm-Message-State: APjAAAVsnsleGcMVVoBC0fZ4owURgwYJJNktgm3sNNBoTGf2g6BZqA6T
        0s1YBU0wJ3io0L9xHBfJ49E=
X-Google-Smtp-Source: APXvYqzRrTAJZkWdgN5z6MpCi/up9V0bFADd3BzNC4TCioOquWQ3XJvoJr1MG+x9aWFy6KKRsC820w==
X-Received: by 2002:a05:6000:1252:: with SMTP id j18mr16134526wrx.23.1572292471209;
        Mon, 28 Oct 2019 12:54:31 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f17:6e00:9578:29b8:2cd4:8cd8? (p200300EA8F176E00957829B82CD48CD8.dip0.t-ipconnect.de. [2003:ea:8f17:6e00:9578:29b8:2cd4:8cd8])
        by smtp.googlemail.com with ESMTPSA id y26sm588627wma.31.2019.10.28.12.54.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Oct 2019 12:54:30 -0700 (PDT)
Subject: [PATCH net-next 1/4] net: phy: marvell: fix typo in constant
 MII_M1011_PHY_SRC_DOWNSHIFT_MASK
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Chris Healy <Chris.Healy@zii.aero>
References: <4ae7d05a-4d1d-024f-ebdf-c92798f1a770@gmail.com>
Message-ID: <8828cb2a-4628-a58c-8dbb-104ada3bf37a@gmail.com>
Date:   Mon, 28 Oct 2019 20:52:22 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <4ae7d05a-4d1d-024f-ebdf-c92798f1a770@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix typo and use PHY_SCR for PHY-specific Control Register.

Fixes: a3bdfce7bf9c ("net: phy: marvell: support downshift as PHY tunable")
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/marvell.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 0a814fde1..e77fc25ba 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -53,7 +53,7 @@
 
 #define MII_M1011_PHY_SCR			0x10
 #define MII_M1011_PHY_SCR_DOWNSHIFT_EN		BIT(11)
-#define MII_M1011_PHY_SRC_DOWNSHIFT_MASK	GENMASK(14, 12)
+#define MII_M1011_PHY_SCR_DOWNSHIFT_MASK	GENMASK(14, 12)
 #define MII_M1011_PHY_SCR_DOWNSHIFT_MAX		8
 #define MII_M1011_PHY_SCR_MDI			(0x0 << 5)
 #define MII_M1011_PHY_SCR_MDI_X			(0x1 << 5)
@@ -793,7 +793,7 @@ static int m88e1111_get_downshift(struct phy_device *phydev, u8 *data)
 		return val;
 
 	enable = FIELD_GET(MII_M1011_PHY_SCR_DOWNSHIFT_EN, val);
-	cnt = FIELD_GET(MII_M1011_PHY_SRC_DOWNSHIFT_MASK, val) + 1;
+	cnt = FIELD_GET(MII_M1011_PHY_SCR_DOWNSHIFT_MASK, val) + 1;
 
 	*data = enable ? cnt : DOWNSHIFT_DEV_DISABLE;
 
@@ -812,11 +812,11 @@ static int m88e1111_set_downshift(struct phy_device *phydev, u8 cnt)
 				      MII_M1011_PHY_SCR_DOWNSHIFT_EN);
 
 	val = MII_M1011_PHY_SCR_DOWNSHIFT_EN;
-	val |= FIELD_PREP(MII_M1011_PHY_SRC_DOWNSHIFT_MASK, cnt - 1);
+	val |= FIELD_PREP(MII_M1011_PHY_SCR_DOWNSHIFT_MASK, cnt - 1);
 
 	return phy_modify(phydev, MII_M1011_PHY_SCR,
 			  MII_M1011_PHY_SCR_DOWNSHIFT_EN |
-			  MII_M1011_PHY_SRC_DOWNSHIFT_MASK,
+			  MII_M1011_PHY_SCR_DOWNSHIFT_MASK,
 			  val);
 }
 
-- 
2.23.0


