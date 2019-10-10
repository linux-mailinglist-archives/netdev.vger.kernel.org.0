Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC8FBD20CE
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 08:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732893AbfJJGcm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 02:32:42 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:46613 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729045AbfJJGcl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 02:32:41 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 86E9521CC3;
        Thu, 10 Oct 2019 02:32:40 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 10 Oct 2019 02:32:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=E7SNJRDI1V4kzD+2D
        61rfaGeR1U+ChD7XIjoSM9djaY=; b=me6ZjNlsfp1JFZnT/+5ylK/ZJ/zmGfHaH
        OSbHUteZGfIvcv87oJLGijbr/4pPXtqR0SMnbuWHfNLaLrUYI8vpJg+u+kd+0HR6
        8pkTNz6FT8dGfXaIWu6DhwA1EUIBALDnIGpYB84N24WDiBeX/a7KL+3y5Joo3MNk
        /Md8katBHFjXkjphb91LaQB+ww/QG9+0Heuk17T9A7PQP0VZ1fhG0iiyBBllbWDE
        DD3gi87w38pZ46YFC0ZPi3q0MK9+cd6+BttlwIQZuFUIULs4TlEPuCJbBtzBVX8m
        f2cOOSBXMC0Ly8outc+yE95Ob6HWrLUqTNuKyc1IUoibf4UQ5jwMQ==
X-ME-Sender: <xms:htCeXUOe5feSH86RWbdn-yPH-kjgcMdoWlNF4A7WX2YfkCdKn-Uijg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedriedvgdduuddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpehmrg
    hilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghrufhi
    iigvpedt
X-ME-Proxy: <xmx:htCeXaHPQ6GUVZ56SNAjd7kqtwCOfcM4NJ7nfyuoXpTSg3mDLEGEgQ>
    <xmx:htCeXQQgVJfkkAhrA1TlbF-ZC4q_L8nmGtwgZCxT96faKKdRiHc7UQ>
    <xmx:htCeXcRMSZnn_4WdLHZuiTH2_mzzc4jx52R_ODQQI9fk1SKW0aRmBw>
    <xmx:iNCeXXpyJ6RvDgxfCC_GFy_sWEntqkNrDEUKIlTYcsjlH-H3sq4iRw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1C421D60057;
        Thu, 10 Oct 2019 02:32:36 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        jiri@mellanox.com, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 0/2] mlxsw: Add support for 400Gbps (50Gbps per lane) link modes
Date:   Thu, 10 Oct 2019 09:32:01 +0300
Message-Id: <20191010063203.31577-1-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Jiri says:

Add 400Gbps bits to ethtool and introduce support in mlxsw. These modes
are supported by the Spectrum-2 switch ASIC.

Jiri Pirko (2):
  ethtool: Add support for 400Gbps (50Gbps per lane) link modes
  mlxsw: spectrum: Add support for 400Gbps (50Gbps per lane) link modes

 drivers/net/ethernet/mellanox/mlxsw/reg.h     |  1 +
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 52 +++++++++++++++----
 drivers/net/phy/phy-core.c                    | 10 +++-
 include/uapi/linux/ethtool.h                  |  6 +++
 4 files changed, 58 insertions(+), 11 deletions(-)

-- 
2.21.0

