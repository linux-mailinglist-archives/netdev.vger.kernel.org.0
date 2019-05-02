Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7B341180A
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 13:13:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbfEBLNv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 07:13:51 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:42389 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726267AbfEBLNu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 May 2019 07:13:50 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 48ACE2574C;
        Thu,  2 May 2019 07:13:49 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 02 May 2019 07:13:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=fXXOEsy3mGZS4YxOMFLmTDBvXPwAp4NUYZAOS8veX/A=; b=Pyhe+tx/
        pYeuTKrCNlQeqR+jO1JLdXjtmAFc2Vaim8AEROjGro1cydaLnf5OEZZZk/M/pQcC
        EFUxci1LFnQyxUvOFJG1D6oQgc5SC84IhQhGZrGuQCNZ/v4MnNQN3gzd7y22ccFf
        5HBukt2YHl6bFdb3sJ4IvC4UPx+a/tWeef8X9f5UauXcDjZmBcoE4Arl533mzf/6
        F+hqkYu7FIy4KZsJLW/Wv4wa06PM+i0TphMr0C/s/lPKbftx2Pd+LvJUbcjidOKZ
        T7UeBqkzN2rq9Fg6PjmoEnfKogH4x2+dr+QaUukrDfXabHZUSYVML9huN7U3fmou
        9zhGycmgKk59mg==
X-ME-Sender: <xms:7dDKXCT7jklc_RH6qLlm7ZAtuYB42VSuNx_b5j5kKcLAikRkwHpr9g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrieelgdeflecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgeptd
X-ME-Proxy: <xmx:7dDKXN5K4h8HRQh8A31qZgkMn2kimLbP5pbJF4_LDuYspZCYPp8d7w>
    <xmx:7dDKXFb8ABZowbdcIPdFwMPp7WzkEAkP2pAshTcoSexBkQj1KDLpVA>
    <xmx:7dDKXBZSjrojHk2gdVcDvnxPg7Hz1dADi542_dkK4Jd9VqwoZmDyeQ>
    <xmx:7dDKXMZHSlFSF64Zi5TSRAVT1AXPZvVgJgd7V3vj8Q6ckWUrb00z0w>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id DDC28E474A;
        Thu,  2 May 2019 07:13:47 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 1/3] mlxsw: Bump firmware version to 13.2000.1122
Date:   Thu,  2 May 2019 14:13:07 +0300
Message-Id: <20190502111309.6590-2-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190502111309.6590-1-idosch@idosch.org>
References: <20190502111309.6590-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

The new version supports two features that are required by upcoming
changes in the driver:

* Querying of new resources allowing port split into two ports on
Spectrum-2 systems

* Querying of number of gearboxes on supported systems such as SN3800

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 12b176d1d6ef..d3c9f8ce945e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -46,8 +46,8 @@
 #define MLXSW_SP_FWREV_MINOR_TO_BRANCH(minor) ((minor) / 100)
 
 #define MLXSW_SP1_FWREV_MAJOR 13
-#define MLXSW_SP1_FWREV_MINOR 1910
-#define MLXSW_SP1_FWREV_SUBMINOR 622
+#define MLXSW_SP1_FWREV_MINOR 2000
+#define MLXSW_SP1_FWREV_SUBMINOR 1122
 #define MLXSW_SP1_FWREV_CAN_RESET_MINOR 1702
 
 static const struct mlxsw_fw_rev mlxsw_sp1_fw_rev = {
-- 
2.20.1

