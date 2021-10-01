Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9743941F087
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 17:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355002AbhJAPIs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 11:08:48 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:52505 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1354928AbhJAPIj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 11:08:39 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 985BE5C010C;
        Fri,  1 Oct 2021 11:06:54 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 01 Oct 2021 11:06:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=zLIS/hTj/HKHMWnSaxvMoogtTMk5af1V4BQ4ZGCD/9I=; b=diUTGukL
        mAjrCkTlW4oEIfec1MO4x9go6WJQqtpRlU5GGnKnNyixGDrM9+f095Bo6dgLn3G2
        UYfbNZHRhqX0UCVpMtzBgRrIfMnjJMPX6wVfCxiSJCdDwaFN78/b9dHOuZsUOyt7
        J+iW+7vPE44a81szQhFz/HXPIxx/ZxeGyPathRDhd+xlcgxVfw3iznjbuAhHoiQc
        XhVdnQjWJ61JDb1ue9nbTowZN1Y26ACQvUo8bWXRScSt0rPt5t/QuQy0gY6UxMe0
        3VifL42YaMfhGF7hmrFdQTsU2gAQAIxER28arNYEh9Q4RiorQwFZ6Ux/IUuTGQCS
        C6lY1WeeTH5iGw==
X-ME-Sender: <xms:DiRXYRvMXwukIOpaZHIcigcAxJ14sRa84XDkOcKqPxy0SBqHrwIDng>
    <xme:DiRXYadFBMRzWzA2WtDxOZhIQaXbgSxj1DqFrkm1M7-hrnS2ocf8l3oihljxFGU1b
    T0qQRAC59Kzps4>
X-ME-Received: <xmr:DiRXYUwKukv7jm7Brz9YJ00PtXabFv3HzlF7h8MTF6rZKlZeljY42Uph0h1KJI9t1UaKZeWcmR21yjw1uAoOm-TjSPWJ8IOMmQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudekiedgkedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:DiRXYYMWag4VEzjMSiB_NXkjxS5jNmLzSawkWjwLvf18rVPMPKaIxg>
    <xmx:DiRXYR8MbQrs0XJzGMT37O1l1HQYHrxM5Fhw7yBJp6YnCAT5GGGfrA>
    <xmx:DiRXYYWfzPgMYARuqRNJ0EJ03RgvOANCoYH1DRfuF77B1fmqfMXadg>
    <xmx:DiRXYTLe29A72uBxlB2W2HlKg6TXk9isjl2D7ozFBjspT0nArCo6aw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 1 Oct 2021 11:06:53 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     mkubecek@suse.cz, popadrian1996@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH ethtool-next v2 3/7] cmis: Correct comment
Date:   Fri,  1 Oct 2021 18:06:23 +0300
Message-Id: <20211001150627.1353209-4-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211001150627.1353209-1-idosch@idosch.org>
References: <20211001150627.1353209-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The file is concerned with CMIS support, not QSFP-DD which is the
physical form factor.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 cmis.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cmis.c b/cmis.c
index 408db6f26c3b..591cc72953b7 100644
--- a/cmis.c
+++ b/cmis.c
@@ -1,7 +1,7 @@
 /**
  * Description:
  *
- * This module adds QSFP-DD support to ethtool. The changes are similar to
+ * This module adds CMIS support to ethtool. The changes are similar to
  * the ones already existing in qsfp.c, but customized to use the memory
  * addresses and logic as defined in the specification's document.
  *
-- 
2.31.1

