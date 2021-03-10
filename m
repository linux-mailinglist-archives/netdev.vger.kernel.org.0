Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5DA1333AF8
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 12:04:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231197AbhCJLDw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 06:03:52 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:46579 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231424AbhCJLDc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 06:03:32 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 951485C00B2;
        Wed, 10 Mar 2021 06:03:31 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 10 Mar 2021 06:03:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Al81jmWHNxGp/avWW
        t+e5SNDdqZBZgtlyOT+56axnSo=; b=EER2exN4DTpWnzoSUMVo4DFCVB1ZdByu1
        dP+nQ8+HQIlr7uC8/jINCAvWtzXSsLJkskQbqYrsFC4vMHZnRsORWgfiXN3fQ0Nr
        OzHbmmdEDcTBlCh6jUlr+8m5JnCRl4/ZCxcnowt18TcudJi637AUoq5LJ/rGQ3Zc
        NIWJcr5zLATMIWVTiUX8L71/xJQtJKHAYG1ioNO4W6TQ60jn5LYkippwYZnlOzNs
        0UvpeM+0+TRNs1pL+SEinrbj+E21/Ou4QNAmKsIqFWwvmgDPIIcWGfoE8d4fbYa2
        4Uq3NVP20z7X70EmEWQFAq8ym7ejlRQCWTzClNDHix933PzLaXP8g==
X-ME-Sender: <xms:g6dIYNSc0TgEYHVzxMKp5-VdnD7Keq3XsDVOT2p-k656IhxhCt27gA>
    <xme:g6dIYGxajDeERk1r7vq9Lee3KPN_ARM7N8cEpkC9C28i9RIuVkyM8TCMYCEq5AGRe
    kCB6PPZeO8TUk4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddukedgvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepteevgefhvefggfffkeeuffeuvdfhueehhe
    etffeikeegheevfedvgeelvdffudfhnecukfhppeekgedrvddvledrudehfedrgeegnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstg
    hhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:g6dIYC3g77qNOIXXGKNXqIsZiR7KZ83GYJWCAA8rLHdh8Zc77OlgAw>
    <xmx:g6dIYFBN6g9JtJGq6Fgc8oGmJIo5S1Dkmft8XwsbRgLtEBhzZ1LnXw>
    <xmx:g6dIYGiPPCotV0fukb2_fBmLYXN_n7MVOUUn1QInUAGXJHYOYzu1aw>
    <xmx:g6dIYIY9wc1v7pM4wTfh9cpS7HpWhaVxQahc1kNq1GTN8e4K88Isiw>
Received: from shredder.mellanox.com (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0BDFA1080066;
        Wed, 10 Mar 2021 06:03:28 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        danieller@nvidia.com, amcohen@nvidia.com, petrm@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 0/6] mlxsw: Misc updates
Date:   Wed, 10 Mar 2021 13:02:14 +0200
Message-Id: <20210310110220.2534350-1-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

This patch set contains miscellaneous updates for mlxsw.

Patches #1-#2 reword an extack message to make it clearer and fix a
comment.

Patch #3 bumps the minimum firmware version enforced by mlxsw. This is
needed for two upcoming features: Resilient hashing and per-flow
sampling.

Patches #4-#6 improve the information reported via devlink-health for
'fw_fatal' events.

Amit Cohen (1):
  mlxsw: reg: Fix comment about slot_index field in PMAOS register

Danielle Ratson (4):
  mlxsw: spectrum: Reword an error message for Q-in-Q veto
  mlxsw: reg: Extend MFDE register with new log_ip field
  mlxsw: core: Expose MFDE.log_ip to devlink health
  mlxsw: Adjust some MFDE fields shift and size to fw implementation

Petr Machata (1):
  mlxsw: spectrum: Bump minimum FW version to xx.2008.2406

 drivers/net/ethernet/mellanox/mlxsw/core.c     |  6 +++++-
 drivers/net/ethernet/mellanox/mlxsw/reg.h      | 13 ++++++++++---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c |  8 ++++----
 3 files changed, 19 insertions(+), 8 deletions(-)

-- 
2.29.2

