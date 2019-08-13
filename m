Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75A418B283
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 10:32:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728069AbfHMIcL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 04:32:11 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:42143 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727429AbfHMIcK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 04:32:10 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id D7E2120D89;
        Tue, 13 Aug 2019 04:32:09 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 13 Aug 2019 04:32:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=CXa4nktwbiW0EDDoP
        /L7DY0J9BULuigle86AxBzWCUo=; b=ro5b7Y7+L+YZQUSvpLoh5N2dM946kuZ95
        5m8phQXx1NZYXGguf7avKMbCaKvqFbtpyVaj0nYCUqyjvLSsCCE7E9qvxf8Zz6Cv
        Fx3kyPc0PtwXG8942aJkVKPHbhvJl96x4g/ZXXNoRKqgbFib3K4CW1meWV9XUT4W
        3rQxU7LhTWEZqoJZBdrRcfPtcbSEuMzp7q92nW36cpVgw699yXsJi39Hunwu3KAa
        fVt95UxTwaU+f16V0dX41mps4Yv50JWw9b7Ck+YMD4Yaeb0TJ7wlgpwnaOMmVRzE
        QzojWUU1KW69Envd7LKSm+VriklTUXyqcjU0tba2a7f+2gNYrmlMQ==
X-ME-Sender: <xms:iXVSXWGwTc-Ucv7-qRXKF0hb0ihBTyWc2pN7WFwHtbglBM-ue1AyVw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddviedgtddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpehmrg
    hilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghrufhi
    iigvpedt
X-ME-Proxy: <xmx:iXVSXRkWj4s8DMWWNVcQacjgpbYiL4mNNPEKZfJMMq17f0FG-E-eYA>
    <xmx:iXVSXZeBFKD-bLnTKtxne_zt6G3TxwjqpJqkkEQawbqbamLu6_XYwg>
    <xmx:iXVSXTbFV-3tkbt3rKJwCc4TqdJx2-qAuVTRCFwyZND3_TfwM00hYw>
    <xmx:iXVSXV-kkLqMVnl_vfHejp6FCvZf2pqeJS9eumyW6nC8SaktAwKEiw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id C86CC8005A;
        Tue, 13 Aug 2019 04:32:07 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH iproute2-next v2 0/4] Add devlink-trap support
Date:   Tue, 13 Aug 2019 11:31:39 +0300
Message-Id: <20190813083143.13509-1-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

This patchset adds devlink-trap support in iproute2.

Patch #1 increases the number of options devlink can handle.

Patches #2-#3 gradually add support for all devlink-trap commands.

Patch #4 adds a man page for devlink-trap.

See individual commit messages for example usage and output.

Changes in v2:
* Remove report option and monitor command since monitoring is done
  using drop monitor

Ido Schimmel (4):
  devlink: Increase number of supported options
  devlink: Add devlink trap set and show commands
  devlink: Add devlink trap group set and show commands
  devlink: Add man page for devlink-trap

 devlink/devlink.c          | 448 +++++++++++++++++++++++++++++++++++--
 man/man8/devlink-monitor.8 |   3 +-
 man/man8/devlink-trap.8    | 138 ++++++++++++
 man/man8/devlink.8         |  11 +-
 4 files changed, 581 insertions(+), 19 deletions(-)
 create mode 100644 man/man8/devlink-trap.8

-- 
2.21.0

