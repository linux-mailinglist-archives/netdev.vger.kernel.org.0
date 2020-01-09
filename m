Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C41A413610C
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 20:27:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730127AbgAIT1l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 14:27:41 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:48289 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729754AbgAIT1l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 14:27:41 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 26D7F21FC5;
        Thu,  9 Jan 2020 14:27:40 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 09 Jan 2020 14:27:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=HGVdhRerNfeYkstgV
        AoWJVSWwnrXzsVLbDjkDIhe8wM=; b=mWWxahWXyohN+vugTKL7HtLuGKGgLSU9Y
        LiMX54Uy5AF/egI4MNX73cS4xKL19gslVoj+Pe4fOAD/t0R1u6zfgmdUzmd2L5Pd
        R4xz4srg+cBswHWpxU+QbzDYAOvs2BPI3fqmU6QkWCWfZhC78EVlDPj/yiFlT1nX
        hXrzOK5hXh9R78yAvuBzS9oGnIKIKNPcpQXfv3vvzGWb0Izg4zBaWjkRqHNCRDM+
        vtCHQw9OS6zuFphgi+p8TNvvrAQQOIT8VfdrDAYVuHXShCmJ7TXGYcNMajpnoI8Z
        A6hv0xmViIlMAfhX45Gw9vV5eSxYD+dnoTjNuuTFiR3xeufOZzYeA==
X-ME-Sender: <xms:q34XXoQTGlqEaTbx1TnEeMAoxMMaUcFrAxTe3kqRtrMA6VjAd1eucg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdeiuddgledtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpehmrg
    hilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghrufhi
    iigvpedt
X-ME-Proxy: <xmx:q34XXgP16wlSM11EZyfWTYwS686bVZBG5WOCIpm3QVOgXSc3aw7FAw>
    <xmx:q34XXtWCxgJGJG0uuTHNdwPTDJEzmoC6oMHkdsg-03NPvQlvLX_diQ>
    <xmx:q34XXjg0XVfKMwVvulzSdRxPlX4QPEg5vofnXv1XSpTp0ZMYx-rJFA>
    <xmx:rH4XXrJF10j4L_PcmLYlwoevgXGu7Qqi3jFPNEU8fKuypAa24sTsyw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id A502C30607BE;
        Thu,  9 Jan 2020 14:27:38 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 0/2] mlxsw: Firmware version updates
Date:   Thu,  9 Jan 2020 21:27:20 +0200
Message-Id: <20200109192722.297496-1-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

This patch sets contains two firmware-related updates.

Patch #1 bumps the required firmware version in order to support 2x50
Gb/s split on SN3800 systems.

Patch #2 changes the driver to only enforce a minimum required firmware
version, which should allow us to reduce the frequency in which we need
to update the driver.

Ido Schimmel (2):
  mlxsw: spectrum: Update firmware version to xx.2000.2714
  mlxsw: spectrum: Only require minimum firmware version

 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

-- 
2.24.1

