Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9532540FA7E
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 16:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243284AbhIQOmj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 10:42:39 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:52523 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343539AbhIQOmc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 10:42:32 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 80C265C01CF;
        Fri, 17 Sep 2021 10:41:10 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Fri, 17 Sep 2021 10:41:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=JJIeBqEx0vh8sMu7xDyH85/7PXTPW1rsvs7aQcd3Gy8=; b=ETb1kRqU
        Llyav/3S09cetcpR+NXnMbrwqABLR1rmacv6rataUQbjsBaR6r93vzQqXCksj6+9
        rdbgQV5kiaBxpTiyVkDeHN7Me/4LyLBkfKRBiMyc1TQhB2zhh8/Nv8sPgeCL+3fG
        cRaJkvg+dCdGfBnM+imo/2G4Ng0yMGdwxZ9es09+PW+FTIc3C4m8M7bw5aldM5kr
        tyTNi9au7HI6GVAHuPvIwgjTrofpnwZ5kah18Mx7NsffsXYCTXrTGzXNlxKBJ94c
        BFj7ky41Jc1k7eJLP3diyU9m2idAo0P8PgBwG9LAQDZ5yVNX+fHZ9eW7FYKO73I0
        yUYMXnzcjM41hw==
X-ME-Sender: <xms:BalEYbzusISEjO-UY0BMoh5aJXPfVqh7gBab_oRZdC2A4JwhkzHTSg>
    <xme:BalEYTSqGNsl2UKmRWLRWR2yrkUJOU-vbwsmBWKTW5921i_fLGoXaHvCrxVvK7Q-P
    rWlD4UR2BK1xSI>
X-ME-Received: <xmr:BalEYVWIu2kE1FSDvQwZsLdZ3_Zbu6OTVJLvef-CihQ4otFK9g9HALMHSaZ1ZFK4Fmy7QqMuTS16f3QpU9AfL2gOxAN11x-amA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudehiedgjeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgepudenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:BalEYVjWlCro4m9d1LZ2zmnIiCnm5K_Dg-7hCgqVjKoRBx7-DKNoKw>
    <xmx:BalEYdAXVv-lMmVEwXPwDqkGMcNG4CQQ_3-kTqDQCxlys1rs24CQEQ>
    <xmx:BalEYeKfs-X_uH4RxmoVTHrEiGjkh-j1DR19eFOF2DS8nIr64wrKRw>
    <xmx:BqlEYY-XRN4Kw-nkbMhE8hN7_98swlAOe9yGqURJm-mk8DgRUbXr2w>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 17 Sep 2021 10:41:07 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     mkubecek@suse.cz, vadimp@nvidia.com, moshe@nvidia.com,
        popadrian1996@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH ethtool-next 4/7] sff-8636: Remove incorrect comment
Date:   Fri, 17 Sep 2021 17:40:40 +0300
Message-Id: <20210917144043.566049-5-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210917144043.566049-1-idosch@idosch.org>
References: <20210917144043.566049-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The comment was copied from SFF-8472 (i.e., sfpdiag.c) where the
diagnostic page is at I2C address 0x51. SFF-8636 only uses I2C address
0x50.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 qsfp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/qsfp.c b/qsfp.c
index e84226bc1554..263cf188377d 100644
--- a/qsfp.c
+++ b/qsfp.c
@@ -64,7 +64,7 @@
 
 static struct sff8636_aw_flags {
 	const char *str;        /* Human-readable string, null at the end */
-	int offset;             /* A2-relative address offset */
+	int offset;
 	__u8 value;             /* Alarm is on if (offset & value) != 0. */
 } sff8636_aw_flags[] = {
 	{ "Laser bias current high alarm   (Chan 1)",
-- 
2.31.1

