Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35E2E205B8E
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 21:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387513AbgFWTOW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 15:14:22 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:39427 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387459AbgFWTOV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 15:14:21 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id A893F5C011C;
        Tue, 23 Jun 2020 15:14:19 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 23 Jun 2020 15:14:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=G02HympLxNHq+Ir844PVBR7A7axtTRvc/rwrGFi/V3s=; b=uqR2qFvR
        BwJVT58MRtisx5ZkunSCFFbB9hi3ssOjujU+n4iuzjypfVGKeR8ZjxtlnE/wLu/R
        EomRKDCeDZ9QI6vvcqbGcwGGbyXlYgX00al+zU3i6muMGE18eVEDIhoBFfMX3znP
        gOdih9xZH4V5H54iBjwJA0+Yz4ivYIWBmgmfWO2aZ0M3F81tscFWNoMrtjBndEQ3
        fEFTz4Hs5uOMtNqLHKHMID0vzC0HteOKgBr5tUwjof3aA5C+/3m+1+LznM8XhWxS
        d/wmQhjtNYjz8tymWXhhYS6/hOG+oZxw7QAGxq334kPS8TPFITgaw6llk8WiI8ce
        8EgLTQM09zUGbA==
X-ME-Sender: <xms:i1TyXjwb_CapBU1mZJ335BSo18p1AcSaWNOh1yqvA4PWf_Qk7ec2Zg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudekhedguddtjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucfkphepjeelrddukeefrdeihedrkeej
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:i1TyXrScFYWpr9hbnr-5PvHnJDpx9Y01NydqHY3FW176BeChCrukQw>
    <xmx:i1TyXtXITZproVYfu_9cMrmH2Wj8vkB6_pXG_S2MzC8pKtvS2yI2lw>
    <xmx:i1TyXthMzbQOUOHdNDlgpo7BgpkSfs5yP0L4MVnrEK1_aXcyTreu7A>
    <xmx:i1TyXoPTSaFkLWXyI0dwAzVf6GyEHyiNUF1vYJIEhCSMTXwsKP9Qfg>
Received: from shredder.mtl.com (bzq-79-183-65-87.red.bezeqint.net [79.183.65.87])
        by mail.messagingengine.com (Postfix) with ESMTPA id 46D173280065;
        Tue, 23 Jun 2020 15:14:18 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@mellanox.com,
        jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 1/2] mlxsw: Bump firmware version to XX.2007.1168
Date:   Tue, 23 Jun 2020 22:13:45 +0300
Message-Id: <20200623191346.75121-2-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200623191346.75121-1-idosch@idosch.org>
References: <20200623191346.75121-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

This version comes with fixes to the following problems, among others:

- Wrong shaper configuration on Spectrum-1
- Bogus temperature reading on Spectrum-2
- Problems in setting egress buffer size after MTU change on Spectrum-2

Signed-off-by: Petr Machata <petrm@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 7d7ebd99f09e..371c1ae0afb4 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -45,8 +45,8 @@
 #include "../mlxfw/mlxfw.h"
 
 #define MLXSW_SP1_FWREV_MAJOR 13
-#define MLXSW_SP1_FWREV_MINOR 2000
-#define MLXSW_SP1_FWREV_SUBMINOR 2714
+#define MLXSW_SP1_FWREV_MINOR 2007
+#define MLXSW_SP1_FWREV_SUBMINOR 1168
 #define MLXSW_SP1_FWREV_CAN_RESET_MINOR 1702
 
 static const struct mlxsw_fw_rev mlxsw_sp1_fw_rev = {
@@ -62,8 +62,8 @@ static const struct mlxsw_fw_rev mlxsw_sp1_fw_rev = {
 	"." __stringify(MLXSW_SP1_FWREV_SUBMINOR) ".mfa2"
 
 #define MLXSW_SP2_FWREV_MAJOR 29
-#define MLXSW_SP2_FWREV_MINOR 2000
-#define MLXSW_SP2_FWREV_SUBMINOR 2714
+#define MLXSW_SP2_FWREV_MINOR 2007
+#define MLXSW_SP2_FWREV_SUBMINOR 1168
 
 static const struct mlxsw_fw_rev mlxsw_sp2_fw_rev = {
 	.major = MLXSW_SP2_FWREV_MAJOR,
-- 
2.26.2

