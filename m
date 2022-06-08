Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45ABC543BDC
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 20:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233188AbiFHS7T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 14:59:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230366AbiFHS7R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 14:59:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA9713A1AF
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 11:59:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 518BB61C2E
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 18:59:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96207C34116;
        Wed,  8 Jun 2022 18:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654714754;
        bh=qht3EpzNZOJ9WBWM+E4VAD9uNFalCLNhcd8s9qNHtsY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tp+TyccEZC0xEu80RTZHAklDjYXJxMrdr2XIEGJX9lHEeggJDS6SQ9KtOcuVPdE78
         pbUr13pdJHnzG2Jrfv0hz9r1gYIcLx2iqaK5iA43DoQLMDQzeB+C78ZIsIyKpvkFY9
         Ii7xXyPdOErs3sSeJsts5RwhuanqyrpYW11RzewUBbrtGXG3BPzPSX5i8opUkhaKUM
         oqnPcyvAPcPE3pharK4fV9oTjXNgh4gttHKmQfk298RvzV9avjQtBsyOFtshDFUYW8
         U4dukbkOCl9knTBoSF8/Z0KBCnln1GY2q+qM2M2kbjbGWIQH3VuGA8kFHhQ/klsND9
         p20n+A7oP9mjg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org, Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 1/6] MAINTAINERS: adjust MELLANOX ETHERNET INNOVA DRIVERS to TLS support removal
Date:   Wed,  8 Jun 2022 11:58:50 -0700
Message-Id: <20220608185855.19818-2-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220608185855.19818-1-saeed@kernel.org>
References: <20220608185855.19818-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lukas Bulwahn <lukas.bulwahn@gmail.com>

Commit 40379a0084c2 ("net/mlx5_fpga: Drop INNOVA TLS support") removes all
files in the directory drivers/net/ethernet/mellanox/mlx5/core/accel/, but
misses to adjust its reference in MAINTAINERS.

Hence, ./scripts/get_maintainer.pl --self-test=patterns complains about a
broken reference.

Remove the file entry to the removed directory in MELLANOX ETHERNET INNOVA
DRIVERS.

Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 033a01b07f8f..bab9e131ec9c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12651,7 +12651,6 @@ L:	netdev@vger.kernel.org
 S:	Supported
 W:	http://www.mellanox.com
 Q:	https://patchwork.kernel.org/project/netdevbpf/list/
-F:	drivers/net/ethernet/mellanox/mlx5/core/accel/*
 F:	drivers/net/ethernet/mellanox/mlx5/core/en_accel/*
 F:	drivers/net/ethernet/mellanox/mlx5/core/fpga/*
 F:	include/linux/mlx5/mlx5_ifc_fpga.h
-- 
2.36.1

