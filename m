Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7525C1AF81C
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 09:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726007AbgDSHB4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 03:01:56 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:44985 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725446AbgDSHB4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 03:01:56 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 143075C0077;
        Sun, 19 Apr 2020 03:01:55 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 19 Apr 2020 03:01:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=bFD0HkQoGZ/M66y3z
        I0MgY8yxvfwBN4x4bvQ9zrMBzs=; b=MWgt9cmIBaOSEfEGEL3/wWlVsCff4jMHz
        3p/Ll0Mvf3eFs+09jcndp+DBv5ueDw76fZocSKFTQ3lnuSi1X9XMApVW5C1i25na
        4+5uS6QgwjSIYf8cq2WX9IVgDGTKgBfvOooGpBEJ7/2GVs+X9ix4fKRoEdFAN2tT
        tIBSzFmD2EQXRXjRGt5Wk0gE8Wc7azXiM8uBpKJ9fwk9f20JKD7dbC54kShnCFWI
        ZYhYQxL6Libg2CfeBtwRxDiLQpi4dFVCD0DoB+go+3NaXFJeNl9eyUM4LXd8iU1b
        3AYgyZlmhu+0wnqhArAyk6leCMSHN89HKY8b0bIrGD1peKzLolgcQ==
X-ME-Sender: <xms:YvebXkvAea3c7Q_g0UrsTtEaGCneDXKF8X7fBhwpUFsX29CZM4jAgg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrgedtgdduudduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecukfhppeejledrudektddrheegrdduudeinecuvehluhhsthgvrhfuih
    iivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdr
    ohhrgh
X-ME-Proxy: <xmx:YvebXqoXe8D-FdzAfZp3aic5D17GJjJw_PxN5Op2FwX6eRrvYuyRlg>
    <xmx:YvebXkACUWUDQYcjEWcqCMvW5Nn_Q0oHv0bP6hQh4fG6uVb-YmRdWQ>
    <xmx:YvebXs93641aA2j1q7hm0F5VT-5-bRE6WmMQEeOzgz1Qofd6TzWMrQ>
    <xmx:Y_ebXiZ19dpxJLwxLP5FkxYYVhhiWAcv17o7nxM60nbgdyxYi43g6w>
Received: from localhost.localdomain (bzq-79-180-54-116.red.bezeqint.net [79.180.54.116])
        by mail.messagingengine.com (Postfix) with ESMTPA id B998E3280059;
        Sun, 19 Apr 2020 03:01:53 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 0/2] mlxsw: Two small changes
Date:   Sun, 19 Apr 2020 10:01:04 +0300
Message-Id: <20200419070106.3471528-1-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Patch #1 increases the scale of supported IPv6 nexthops groups when each
group has one nexthop and all are using the same nexthop device, but
with a different gateway IP.

Patch #2 adjusts a register definition in accordance with recent
firmware changes.

Ido Schimmel (2):
  mlxsw: spectrum_router: Re-increase scale of IPv6 nexthop groups
  mlxsw: reg: Increase register field length to 13 bits

 drivers/net/ethernet/mellanox/mlxsw/reg.h             | 2 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 8 ++++++--
 2 files changed, 7 insertions(+), 3 deletions(-)

-- 
2.24.1

