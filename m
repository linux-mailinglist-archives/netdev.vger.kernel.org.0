Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B423745AA33
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 18:41:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239225AbhKWRoh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 12:44:37 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:41013 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233491AbhKWRog (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 12:44:36 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id AE4405C00F7;
        Tue, 23 Nov 2021 12:41:27 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 23 Nov 2021 12:41:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=FgZ96pTkfJRsWMQ5w7DpJFNDbGcJGgNmkxL2+zaAdN8=; b=gdwAm1qJ
        AVoPwFLH/dCNUlw7DQf+k7qVuPNTPiJlqElBisLY0BC++uDV7h9+GALK8dROFO7M
        i1EgmCAtk7yc0WB8HnfRZxFkoVMBFEgtCBIS1xjBlSx3awX1EpJSEzVTxpYpJVrz
        7p67iOxWlApG4eZXmTw8Z4lJWzMdi6qX+XiZxdV2wCgJ/W239ingy0UdC4he6gpB
        uZLObjHQNpyeDLtRr6I/FrhXyG8DrRtFNSw6hRpBWph4iW4UapJdvQtSs0Q68fIL
        J+7Z2p/lrHB2tfFHf7pF6TW9U2BfV6ajokcoIdrrjhpIHZi1q1YtifJkEG0llKwZ
        U3DH6+OB6aEbXA==
X-ME-Sender: <xms:xyedYWRIImoZpOBqW2O38bsPBoKxRDPosqC08EwY5e-IOsBleDrXdg>
    <xme:xyedYbzGyLkfT3N8BkuSm296wbK2MgtbloRoExjDjbVn-uehsqNOhvg6_fXTGaZjv
    yIuWaZxh-uA5lU>
X-ME-Received: <xmr:xyedYT3eubHGMK-Bn7Z-Q15NAzekHEflZQWYFimB0v5VTPosp4O6QkqIGqopUyYgWuXFxHuhzjDHAhM9bAElrQK_S7RDPK4HTudKTigD19vcng>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrgeeigddutdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgepudenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:xyedYSDa7bQ9TvvjwE1z-7vvl8y3EWVmzKO94_42lgKNTA25jV112g>
    <xmx:xyedYfhjAs0p59Yx635WwVDKbp_KjeLlSrwAJ4c--aLUaHl2rgkQTQ>
    <xmx:xyedYer8WylNkL9huAnQhdc1LBJBfSwFM106a1ohsd1z5qK3j09ZoA>
    <xmx:xyedYfeIf9YROS4Lrpu5_qOurhhtGYEev-jwK50INvILSHc2LFqp-g>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 23 Nov 2021 12:41:26 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     mkubecek@suse.cz, popadrian1996@gmail.com, andrew@lunn.ch,
        mlxsw@nvidia.com, moshe@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH ethtool-next 2/8] sff-common: Move OFFSET_TO_U16_PTR() to common header file
Date:   Tue, 23 Nov 2021 19:40:56 +0200
Message-Id: <20211123174102.3242294-3-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211123174102.3242294-1-idosch@idosch.org>
References: <20211123174102.3242294-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The define is also useful for CMIS, so move it from SFF-8636 to the
common header file.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 qsfp.c       | 1 -
 sff-common.h | 4 ++--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/qsfp.c b/qsfp.c
index 58c4c4775e9b..b3c9e1516af9 100644
--- a/qsfp.c
+++ b/qsfp.c
@@ -700,7 +700,6 @@ sff8636_show_wavelength_or_copper_compliance(const struct sff8636_memory_map *ma
  * Second byte are 1/256th of degree, which are added to the dec part.
  */
 #define SFF8636_OFFSET_TO_TEMP(offset) ((__s16)OFFSET_TO_U16(offset))
-#define OFFSET_TO_U16_PTR(ptr, offset) (ptr[offset] << 8 | ptr[(offset) + 1])
 
 static void sff8636_dom_parse(const struct sff8636_memory_map *map,
 			      struct sff_diags *sd)
diff --git a/sff-common.h b/sff-common.h
index aab306e0b74f..9e323008ba19 100644
--- a/sff-common.h
+++ b/sff-common.h
@@ -126,8 +126,8 @@
 #define  SFF8024_ENCODING_PAM4			0x08
 
 /* Most common case: 16-bit unsigned integer in a certain unit */
-#define OFFSET_TO_U16(offset) \
-		(id[offset] << 8 | id[(offset) + 1])
+#define OFFSET_TO_U16_PTR(ptr, offset) (ptr[offset] << 8 | ptr[(offset) + 1])
+#define OFFSET_TO_U16(offset) OFFSET_TO_U16_PTR(id, offset)
 
 # define PRINT_xX_PWR(string, var)                             \
 		printf("\t%-41s : %.4f mW / %.2f dBm\n", (string),         \
-- 
2.31.1

