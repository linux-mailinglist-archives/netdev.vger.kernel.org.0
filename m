Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E69E2D019A
	for <lists+netdev@lfdr.de>; Sun,  6 Dec 2020 09:24:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbgLFIYB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Dec 2020 03:24:01 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:54627 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726318AbgLFIYA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Dec 2020 03:24:00 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id EC6DCC58;
        Sun,  6 Dec 2020 03:22:51 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 06 Dec 2020 03:22:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=6tkzuIqLCE0uwghkP
        Jj9AwLoN2rrRcaG4KitthslakY=; b=PIPDtssRL9uKdtWnmHxXZdyaLMSeyNc43
        el9N0790SqRwwQPmLmUJsbVAIIF4iKSQcXBmn73RRB9qDCQ64PRYgC6c/namP7hz
        1CL5IiO/mLiRofShsQ7eN+cOK+8GmH9Eu3O98Tz6P7G0DwvaHOygm93FEpFkZQSB
        GHziEf/6KsuRsep3lUmI0I2XkL/oSPmeSOx5oxLut89TMRC9pdlwSjx7yFGkfqNP
        qCubijpwSDL+Tk5brdF1PfwJjWGYL0bjzWiFU4oOVOmf/WxCjNgVgVCWi+Tu8D+T
        Ymjr4W9QWyrUtfsDH7+h9wrR7vQWCdwq2ojgqrI70GmWuyUcB/MAA==
X-ME-Sender: <xms:25TMX7_V0a4_u4kE3dOaJQGid3Rai7NPTZ4CwlTsIkVb2ZQMhpBURg>
    <xme:25TMX3u4a-upZsqXNVkyFQWTOm3-J3NE3NI6DhKwiMAUs3ciFH0UnFZh8QDrZtURg
    pUjqHUV0j6cd-M>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudejuddguddukecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeetveeghfevgffgffekueffuedvhfeuhe
    ehteffieekgeehveefvdegledvffduhfenucfkphepkeegrddvvdelrdduheegrddvfeeg
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:25TMX5BmYLfpg_WsCtCCUwgoNcER6wNOlxHju0bgof9Q6FLHPdlseQ>
    <xmx:25TMX3d31GEtOJo6WaWle9H_k3qWERAgzLWnmelNpHh2WmO3GcpgtA>
    <xmx:25TMXwOMwxrvODhrFGccQaS_Ka3iJ-M2XZSlvO0Gt_X4N3YkqLArDg>
    <xmx:25TMX1rLzs6VPPOtK830e22k4nBsdsLACuqpIKQAB4ZOAjh4zGRymw>
Received: from shredder.lan (igld-84-229-154-234.inter.net.il [84.229.154.234])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1B60A108005B;
        Sun,  6 Dec 2020 03:22:49 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 0/7] mlxsw: Misc updates
Date:   Sun,  6 Dec 2020 10:22:20 +0200
Message-Id: <20201206082227.1857042-1-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

This patch set contains various updates for mlxsw in various areas.

Patch #1 fixes a corner case in router interface (RIF) configuration.
Targeted at net-next since this is not a regression. Patch #2 adds a
test case.

Patch #3 enables tracing of EMAD events via 'devlink:devlink_hwmsg'
tracepoint, in addition to the existing request / response EMAD
messages. It enables a more complete logging of all the exchanged
hardware messages.

Patches #4-#5 suppress "WARNING use flexible-array member instead"
coccinelle warnings.

Patch #6 bumps the minimum firmware version enforced by the driver.

Patch #7 is a small refactoring in IPinIP code.

Ido Schimmel (5):
  mlxsw: spectrum: Apply RIF configuration when joining a LAG
  selftests: mlxsw: Test RIF's reference count when joining a LAG
  mlxsw: core: Trace EMAD events
  mlxsw: spectrum_mr: Use flexible-array member instead of zero-length
    array
  mlxsw: core_acl: Use an array instead of a struct with a zero-length
    array

Jiri Pirko (1):
  mlxsw: spectrum_router: Reduce mlxsw_sp_ipip_fib_entry_op_gre4()

Petr Machata (1):
  mlxsw: spectrum: Bump minimum FW version to xx.2008.2018

 drivers/net/ethernet/mellanox/mlxsw/core.c    |  7 +++
 .../mellanox/mlxsw/core_acl_flex_keys.c       | 26 +++++-----
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 23 +++++++--
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  4 ++
 .../ethernet/mellanox/mlxsw/spectrum_ipip.c   | 45 ++---------------
 .../ethernet/mellanox/mlxsw/spectrum_ipip.h   |  8 +--
 .../net/ethernet/mellanox/mlxsw/spectrum_mr.c |  2 +-
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 49 +++++++++++++++----
 .../ethernet/mellanox/mlxsw/spectrum_router.h |  4 --
 .../selftests/drivers/net/mlxsw/rtnetlink.sh  | 43 ++++++++++++++++
 10 files changed, 129 insertions(+), 82 deletions(-)

-- 
2.28.0

