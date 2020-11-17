Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D60D32B6C23
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 18:47:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730041AbgKQRrd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 12:47:33 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:46421 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729008AbgKQRrc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 12:47:32 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id C560FE1E;
        Tue, 17 Nov 2020 12:47:31 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 17 Nov 2020 12:47:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=6b55sRAYsLo5iat64
        YbDb7bn3ld7aWq1dMHb1kwA/lk=; b=K5FBMckvXLnyJZmOfxkBeyPKYX90+dt6L
        NPKbQzLzTGbss4SFWp2GTwlYoSN85TO3BOTusHsKJcPrSqvmHZEyLJCSYkDoSjmj
        k11NqjCi8gkMYjoBOcFaNYd3YaJT4ovMzJUNcPzNpORq/xt2omMakCs+gpkE7ziQ
        M7TS9gJBqeZQQRNPsb/ihZw/DTcbm15FzdNmckXnnmtuktFcpUubdcI6vXt3wZC9
        QoNSUqOn58iqjOiyoK1Ypy9UiuZx0HrZ4OkOswnyo2MLYPpZHf3nz0+NPJeogA3p
        W48oLfX5j9nqsNtMc0bed5b5eFh2N0LbADB5Cra2NNi+AYdkOpS4g==
X-ME-Sender: <xms:sgy0X1yFNX5Zg0lFfc9Y7mtdEH95FeI3yYmd9M2S9FgHxbILWV5b9Q>
    <xme:sgy0X1SMYNM9NobeFZaEg9cy44Dj3XJua7qsRq59FbQHGxrQvLkqGOK0v9Mkq14BT
    qcKIp-cEZ-emCI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudeffedguddthecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeekkefgteeguedvtdegffeitefgueeiie
    dutefhtdfhkeetteelgfevleetueeigeenucffohhmrghinhepghhithhhuhgsrdgtohhm
    necukfhppeekgedrvddvledrudehgedrudegjeenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:sgy0X_WP_-rOr6IMpgepnZyngLKz9M8BQDe3e6_Kz9VZba3gJ1hyAw>
    <xmx:sgy0X3jV5Rrce7CHJLh7W3Kow6D0qFpbEb8NRyGOOJ_xcSXNQTJ8QQ>
    <xmx:sgy0X3B4iQhxHHtCtB9SUYiiIGzToqHIDhJ6Rs2SualnA7RRMpdnxA>
    <xmx:swy0X-OnQ_C_Q2MCCiHHJb-yD_rJ6qSXEb8Gk1JsPS6ng1D30HdioA>
Received: from shredder.lan (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id 878BC328005D;
        Tue, 17 Nov 2020 12:47:29 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 0/9] mlxsw: Preparations for nexthop objects support - part 2/2
Date:   Tue, 17 Nov 2020 19:46:55 +0200
Message-Id: <20201117174704.291990-1-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

This patch set contains the second round of preparations towards nexthop
objects support in mlxsw. Follow up patches can be found here [1].

The patches are mostly small and trivial and contain non-functional
changes aimed at making it easier to integrate nexthop objects with
mlxsw.

Patch #1 is a fix for an issue introduced in previous submission. Found
by Coverity.

[1] https://github.com/idosch/linux/tree/submit/nexthop_objects

Ido Schimmel (9):
  mlxsw: spectrum_router: Fix wrong kfree() in error path
  mlxsw: spectrum_router: Set ifindex for IPv4 nexthops
  mlxsw: spectrum_router: Pass ifindex to
    mlxsw_sp_ipip_entry_find_by_decap()
  mlxsw: spectrum_router: Set FIB entry's type after creating nexthop
    group
  mlxsw: spectrum_router: Set FIB entry's type based on nexthop group
  mlxsw: spectrum_router: Re-order mlxsw_sp_nexthop6_group_get()
  mlxsw: spectrum_router: Only clear offload indication from valid IPv6
    FIB info
  mlxsw: spectrum_router: Add an indication if a nexthop group can be
    destroyed
  mlxsw: spectrum_router: Allow returning errors from
    mlxsw_sp_nexthop_group_refresh()

 .../ethernet/mellanox/mlxsw/spectrum_router.c | 103 ++++++++++++------
 1 file changed, 67 insertions(+), 36 deletions(-)

-- 
2.28.0

