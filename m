Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E06BD21B761
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 15:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728208AbgGJN6d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 09:58:33 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:42923 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726832AbgGJN6b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 09:58:31 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 9642B58058A;
        Fri, 10 Jul 2020 09:58:30 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 10 Jul 2020 09:58:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=vmfC79TsNsez2Zs9reURvIWYj20QOcgf4gCsymBQrK0=; b=hBItTu1y
        W2cSF5kCx36zU7f5U8+o/3qBCbAaIOj5MVbnQNCmDklw/FHJuZdIKSyJbAHrj1qs
        rfRCWonIIDXTWtqis8PjPc06FxTdHCBfjKZn7R6GIqHIs9LvGyLm+pmVk20nsUtR
        5cVDGtCusG6xm384y8uG6hEV5E4l4nk4ujR9yJkl+vgziRifbDFJbpTINc6HFCBb
        cd2qR7BoV8FbVIb8QvBbBx0NLQqGK2fXGNo+HiABMM3iH5YdGcyg3IQzH6/SAhY2
        Kz3hKlZZWnsg30z2x5AHGN55n9hzDHmpApzQZf0DCLGXoR0TVeKOvXZafLmNDWyH
        A8i5i40RF58JpQ==
X-ME-Sender: <xms:BnQIXx2qLrAp6Nwwiakk8IGi6xTIQ89znONQjarFF9hkvABTf0ZSfQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrvddugdejgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepuddtledrieeirdduledrudeffeen
    ucevlhhushhtvghrufhiiigvpeeknecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:BnQIX4GYZjGuD0rKwH12zpux7jV_Pifeg_dIncaXg7nfcI1P5hbuoA>
    <xmx:BnQIXx4t_6GHJdoHmvVUJ25XYRhOGoMWA7eXIjEHsYPj9kHsBuLDYw>
    <xmx:BnQIX-2VuhxYdNbFfqCx27zGHcFq435KD_Mrqh6DWWWS_pevMkrMxw>
    <xmx:BnQIX3-Wehvfm6iPGwavGAZaDDJuEogMe1tBEEpYtIOoCunQSAO2_g>
Received: from shredder.mtl.com (bzq-109-66-19-133.red.bezeqint.net [109.66.19.133])
        by mail.messagingengine.com (Postfix) with ESMTPA id C33EB3280063;
        Fri, 10 Jul 2020 09:58:26 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, mlxsw@mellanox.com, michael.chan@broadcom.com,
        saeedm@mellanox.com, leon@kernel.org, pablo@netfilter.org,
        kadlec@netfilter.org, fw@strlen.de, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, simon.horman@netronome.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 09/13] mlxsw: spectrum_flow: Drop an unused field
Date:   Fri, 10 Jul 2020 16:57:02 +0300
Message-Id: <20200710135706.601409-10-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200710135706.601409-1-idosch@idosch.org>
References: <20200710135706.601409-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

The field "dev" in struct mlxsw_sp_flow_block_binding is not used. Drop it.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 18c64f7b265d..ab54790d2955 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -710,7 +710,6 @@ struct mlxsw_sp_flow_block {
 
 struct mlxsw_sp_flow_block_binding {
 	struct list_head list;
-	struct net_device *dev;
 	struct mlxsw_sp_port *mlxsw_sp_port;
 	bool ingress;
 };
-- 
2.26.2

