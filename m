Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAE561D6492
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 00:43:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726918AbgEPWnp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 18:43:45 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:56671 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726803AbgEPWnn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 May 2020 18:43:43 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 022F15C0065;
        Sat, 16 May 2020 18:43:42 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 16 May 2020 18:43:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=43CD3V4ucEPD5T2DkpES4ASNsWXEI6oDHmjWweURfR8=; b=ImqrOx9P
        9J3n7DrvKXWovSH4dZ4dO60Cd/0nX4ew/aR0snx1OoK4b1QzifE/CVymbdxvxaiw
        SjD5LNAwdjCWZ4szhsvaHvEpQOnHOR2KRMufr3ChK5KxwdmJAUmelHuf29y8dvhj
        yVFsiuVu3pjOqE+eTHPQyDkp+YT0GS4ef6vIHXhOErF99SUzp9uBmV7ju5RlHZCh
        lxz3cnfMCT4lN91HQWrHcwp8HAQM7CcBUdt3Q5RusWHBjNlz+Lnur/sQv50X11ar
        BHKJVbc3nW2UzrXrifaXGXBkpmlzlyYjjIb8raul5ZCy+/PxMTmX5r2N1341OQC4
        ouck3C29/kEU1Q==
X-ME-Sender: <xms:nWzAXvRLYHInZNTJ5YUTTuYC-m8hFmrK0NgYf7TFt4917oHwv6pg9w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddtuddguddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeejledrudejiedrvdegrddutdej
    necuvehluhhsthgvrhfuihiivgepfeenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:nWzAXgyrIxzB4LguV3pMPOf1NBA33dmVkDrvaFGQFv5biNmQQyudcg>
    <xmx:nWzAXk30TBW6Dwj0juBwZVdqufwK_2UOCgMkIWW-VetAo5W6BV5GDg>
    <xmx:nWzAXvCeIHd3HE5hx46CWd6Wt4-UvX9RVAuEjAaw2MCBVV6bGlQIhg>
    <xmx:nWzAXkaY8sHY0rL1WM2eRqSmd89k-z0c7DWmI6HCF58_KL3ZIdlVyg>
Received: from splinter.mtl.com (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id ADF66306639E;
        Sat, 16 May 2020 18:43:40 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 5/6] selftests: devlink_lib: Remove double blank line
Date:   Sun, 17 May 2020 01:43:09 +0300
Message-Id: <20200516224310.877237-6-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200516224310.877237-1-idosch@idosch.org>
References: <20200516224310.877237-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

One blank line is enough.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 tools/testing/selftests/net/forwarding/devlink_lib.sh | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/testing/selftests/net/forwarding/devlink_lib.sh b/tools/testing/selftests/net/forwarding/devlink_lib.sh
index 155d48bd4d9e..7b6390aea50b 100644
--- a/tools/testing/selftests/net/forwarding/devlink_lib.sh
+++ b/tools/testing/selftests/net/forwarding/devlink_lib.sh
@@ -390,7 +390,6 @@ devlink_trap_drop_test()
 	devlink_trap_group_stats_idle_test $group_name
 	check_err $? "Trap group stats not idle with initial drop action"
 
-
 	devlink_trap_action_set $trap_name "trap"
 	devlink_trap_stats_idle_test $trap_name
 	check_fail $? "Trap stats idle after setting action to trap"
-- 
2.26.2

