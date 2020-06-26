Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3630820B3F6
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 16:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727865AbgFZOsT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 10:48:19 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:43589 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727112AbgFZOsT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 10:48:19 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 41E6F5C008E;
        Fri, 26 Jun 2020 10:48:18 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 26 Jun 2020 10:48:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=oRsWiVi5MezKEG51F
        WhYTAR1ofuTUQ+gNLN4/e/NaRc=; b=YcHfgwILUZ5lb59Js+9s29eFfQzX/KcQL
        9fl6i0UkI/dC9Nx1RAgh79qISk6w64dcXVQVyBWdnK/mvhS5sF8Ppdfvwa/nU4tS
        dlgopL0FUihqdtxtxrOSfr9lFQuI2vTuy0PXrVDhtBUEmIUOrXkkjd69AtV/+CEx
        xIREIl8/skWFQBCKhVpqld7xPab7rY3dfP+/CED/QsfH2szDmzVXblKBNQvwEEuF
        mw2r/DEQFpnwCaIZFzLMSFslDRE40/ez6+wW4hyHBBJJQdIyLY3FFK08kMvi3rJC
        usakUgGk94dI3Rl5yCfdW6FGIDhmh81GgOvMFr3Fu2Gvfo+QPZ/pQ==
X-ME-Sender: <xms:sQr2XuB-eqcJalY1nIvp3QZSI6ke2YuE3ujm49tAwa_lpNQfKtp1NQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudeluddgkedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepteevgefhvefggfffkeeuffeuvdfhueehhe
    etffeikeegheevfedvgeelvdffudfhnecukfhppedutdelrdeiiedrudelrddufeefnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstg
    hhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:sQr2Xohhm9u_fe0gvLXNr3FLyCCvbKSWltNTnnikSTH3KraQD6W6-A>
    <xmx:sQr2XhkPieuIdvZWLWjJoRi-pAICyCYZbpxgHRFvSVBj_pauE_KUdg>
    <xmx:sQr2XsxP20qOkYb2iQj58DWCdIxme7xUjhM4kKnrvlFtZWUgvPjlhQ>
    <xmx:sgr2XhOj-g4k-l7bhFy9YRcTr0vzCMZQRQl0IFru87VqUbJlE5tXXA>
Received: from shredder.mtl.com (bzq-109-66-19-133.red.bezeqint.net [109.66.19.133])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5823B3067939;
        Fri, 26 Jun 2020 10:48:14 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        vadimp@mellanox.com, andrew@lunn.ch, popadrian1996@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 0/2] mlxsw: Add support for QSFP-DD transceiver type
Date:   Fri, 26 Jun 2020 17:47:22 +0300
Message-Id: <20200626144724.224372-1-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

This patch set from Vadim adds support for Quad Small Form Factor
Pluggable Double Density (QSFP-DD) modules in mlxsw.

Patch #1 enables dumping of QSFP-DD module information through ethtool.

Patch #2 enables reading of temperature thresholds from QSFP-DD modules
for hwmon and thermal zone purposes.

Vadim Pasternak (2):
  mlxsw: core: Add ethtool support for QSFP-DD transceivers
  mlxsw: core: Add support for temperature thresholds reading for
    QSFP-DD transceivers

 .../net/ethernet/mellanox/mlxsw/core_env.c    | 47 +++++++++++++++----
 drivers/net/ethernet/mellanox/mlxsw/reg.h     |  3 ++
 2 files changed, 41 insertions(+), 9 deletions(-)

-- 
2.26.2

