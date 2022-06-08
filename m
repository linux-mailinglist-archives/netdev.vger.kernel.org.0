Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C5A0543D51
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 22:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233870AbiFHUFc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 16:05:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233904AbiFHUF1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 16:05:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F19C3374270;
        Wed,  8 Jun 2022 13:05:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B492961978;
        Wed,  8 Jun 2022 20:05:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11EA3C34116;
        Wed,  8 Jun 2022 20:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654718725;
        bh=Xsitfxpa9SAiyjEFJ3rFzKOoSCANgcCbda2AMgv57kQ=;
        h=From:To:Cc:Subject:Date:From;
        b=ueHbtuB8zXtwlhLpmBo0kGP/RjMBO4pdgXF1Cag+GIbhRsDplAu6tLOJ22u4imHvo
         dSGplBnEXtou/SuVBlqZwiJDsM2A5O9zV5yf2oNGqk4XXOvdl3c/U2yBFYTNRcPTNc
         PsmujyopG0AH/5pHp0/HmdB3FB3gSW76Uj032luV6dQ5PSmA5vin66ll6HZKjEC4Oq
         1ceESMw7chQbRBGJ+hOAuItCAfOfwNUg0NFx6Fo8WIWyRFO87Y/HvZ2A5Bt4wbBbLm
         EoWaaxyJo0kqUVjt+/qfAkCsfZ/1Z/5hV3ViXm1mwycNIvVUjPqNNB7TAce9w8Wjj0
         y97wG9sVLqDgA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH mlx5-next 0/6] mlx5-next HW bits and definitions updates 2022-06-08
Date:   Wed,  8 Jun 2022 13:04:46 -0700
Message-Id: <20220608200452.43880-1-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
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

From: Saeed Mahameed <saeedm@nvidia.com>

Updates to mlx5 HW bits and definitions for upcoming rdma and netdev
features.

Jianbo Liu (2):
  net/mlx5: Add IFC bits and enums for flow meter
  net/mlx5: Add support EXECUTE_ASO action for flow entry

Ofer Levi (1):
  net/mlx5: Add bits and fields to support enhanced CQE compression

Saeed Mahameed (1):
  net/mlx5: Add HW definitions of vport debug counters

Shay Drory (2):
  net/mlx5: group fdb cleanup to single function
  net/mlx5: Remove not used MLX5_CAP_BITS_RW_MASK

 .../net/ethernet/mellanox/mlx5/core/fs_cmd.c  |  33 ++++
 .../net/ethernet/mellanox/mlx5/core/fs_core.c |  18 ++-
 .../net/ethernet/mellanox/mlx5/core/main.c    |   7 -
 include/linux/mlx5/device.h                   |  36 ++---
 include/linux/mlx5/fs.h                       |  14 ++
 include/linux/mlx5/mlx5_ifc.h                 | 144 ++++++++++++++++--
 6 files changed, 207 insertions(+), 45 deletions(-)

-- 
2.36.1

