Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D459A206598
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 23:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388508AbgFWUGk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 16:06:40 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:51345 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388496AbgFWUGi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 16:06:38 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id B49A25C0105;
        Tue, 23 Jun 2020 16:06:36 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 23 Jun 2020 16:06:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=3Gpu7I8LI/ryapUWb
        zXgaIzYX5lKGPDrkGqRSl41XRE=; b=H+8wDnKbOJuE8OMHf1Uop55brAsu9vszk
        iUp8fDSK8PqBef4eD1+ep8ErC//4wcRSpSI3NegSylCUTz0c+TFdd9U8Fg/4KpSl
        /9lTxOY5D8rcRTj5KbeDvejQAarHD+XeQhQyyZsISqCrL1WcP9pDHCL2KORUP4ld
        x0KEnmPV4Dgt3XZOWXbKv/GejXnNy8EzpjgnPjXKIIamBvog9Rl5ij+qMHbWNJ6Q
        p1O6+oLyerzBlotkxF0LHND3+SM1bq13rHJcjSJbEbABL3m0sTJ4AzcqFUZyEdp2
        3TotABu/kBdUWfsoJDLpiFM28EBvBMDmoSIfE8OPfaaiURyayIMNg==
X-ME-Sender: <xms:zGDyXsWjxkbrCfz--bAVcvL0_21SHotz6dhj6S-7s6f3UfvSfu2LiQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudekhedguddukecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeetveeghfevgffgffekueffuedvhfeuhe
    ehteffieekgeehveefvdegledvffduhfenucfkphepjeelrddukeefrdeihedrkeejnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstg
    hhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:zGDyXgnVSLH00HJJsKg5igT9Yg-zEEPOPSGFiwUNeDY9CvpthX8Yng>
    <xmx:zGDyXgYjFRVDTGgYtZFQO5XUUx7DTaDplYmq1fuog6Hv-brK60tIQw>
    <xmx:zGDyXrW54rnAzXtx5NR8fsqbIbA4Qm8gl592KRZlgcd2VwvdbvrUFg>
    <xmx:zGDyXqtmESVvEkHlowxlPakuO7slH6XSEb_7o67RIlmX2i7-FQaVlQ>
Received: from shredder.mtl.com (bzq-79-183-65-87.red.bezeqint.net [79.183.65.87])
        by mail.messagingengine.com (Postfix) with ESMTPA id 32F8030674E6;
        Tue, 23 Jun 2020 16:06:35 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com,
        alexanderk@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [iproute2 master] devlink: Document zero policer identifier
Date:   Tue, 23 Jun 2020 23:06:09 +0300
Message-Id: <20200623200609.77470-1-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

When setting a policer to a trap group, a value of "0" will unbind the
currently bound policer from the group.

The behavior is intentional and tested in kernel selftests, so document
it.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Suggested-by: Alex Kushnarov <alexanderk@mellanox.com>
---
 man/man8/devlink-trap.8 | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/man/man8/devlink-trap.8 b/man/man8/devlink-trap.8
index 1e69342758d5..f5e66412f1b7 100644
--- a/man/man8/devlink-trap.8
+++ b/man/man8/devlink-trap.8
@@ -118,7 +118,8 @@ skipped.
 
 .TP
 .BI policer " POLICER"
-packet trap policer. The policer to bind to the packet trap group.
+packet trap policer. The policer to bind to the packet trap group. A value of
+"0" will unbind the currently bound policer.
 
 .TP
 .B nopolicer
-- 
2.26.2

