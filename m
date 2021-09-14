Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8BB540AE75
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 14:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233042AbhINNAF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 09:00:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:33492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233079AbhINNAE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Sep 2021 09:00:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D3C7610D1;
        Tue, 14 Sep 2021 12:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631624327;
        bh=nFfeA9sHpcp+w+QUh5ay5DLkvdZa597yBXLuj4bIZrE=;
        h=From:To:Cc:Subject:Date:From;
        b=rQsnaxHUM+ieyjoXP7KpviTx5KrPONuXldNNDPQ5Moos4rGDTS0dWK57GdK5vl31Z
         KKbwh89BrGe4dpu2nfAFs6U8zLAN4rs+f1uD5wJgJz2wP4G8V1fHGBu+e76hW5riOH
         +/klvlBeRISRwygn3aZjSJbeXn1wnzPDl9cu8Y419gpoFrQS5USeskv92c4hznCE7m
         5ZS51eU5EN+Z4F8pgA4OXZmZ2UdkRmwo4+c6s4Ld2v1CixhIH6z7YiJTCkvYPkgZeH
         AqdxVlmh8CbPkuKImr2oFlaDTw+og0qzv1PhmFxnw0JWOdNz6fnPkl/7MP+YyFf58/
         s7vNmAEXkOzMg==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>, Aya Levin <ayal@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next 0/2] Delete publish of single parameter API
Date:   Tue, 14 Sep 2021 15:58:27 +0300
Message-Id: <cover.1631623748.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Hi,

This short series removes the single parameter publish/unpublish API
that does nothing expect mimics already existing
devlink_paramss_*publish calls.

In near future, we will be able to delete devlink_paramss_*publish too.

Thanks

Leon Romanovsky (2):
  net/mlx5: Publish and unpublish all devlink parameters at once
  devlink: Delete not-used single parameter notification APIs

 .../net/ethernet/mellanox/mlx5/core/devlink.c | 10 +---
 include/net/devlink.h                         |  4 --
 net/core/devlink.c                            | 48 -------------------
 3 files changed, 2 insertions(+), 60 deletions(-)

-- 
2.31.1

