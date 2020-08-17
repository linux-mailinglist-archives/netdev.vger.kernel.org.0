Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B9152466BB
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 14:56:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728464AbgHQM4U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 08:56:20 -0400
Received: from wnew3-smtp.messagingengine.com ([64.147.123.17]:39935 "EHLO
        wnew3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726727AbgHQM4S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 08:56:18 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.west.internal (Postfix) with ESMTP id 0B2F33BE;
        Mon, 17 Aug 2020 08:56:16 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 17 Aug 2020 08:56:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=sjEgAgYbOHiE2/JrM
        ndq6KayPafdzirUZaDk9wblZ9g=; b=HB89IfN9HyYehOhVQo3USrLm+AqimCW5E
        oeeVEvTmCvO930eemicuG8tX6h+07DzFaPJneznETRhAB45/G7wk3eJJqtNIQ8HD
        tCS1398K1ESu6YsXqCt/3MChu3MfagHpGZNWvR84ilUT5QYKE1B13kEXb+64sr3T
        tjT4338LsrMjMvw8/ElsjJaGpUQNWVBbvL9J6LexfDb3zybKLgj2xexY+F6hBOt0
        WR7CBjg3oXMiQAMVOPjJCQNURwXhKtr2bR+YGZokg+IeTvGRKJ57DfbTFaTfwmKD
        OD+i5QnLGAa7Itcdq8267yHyeGXaS+oGJ/5W2Rbsn8ygwZgEnGEdw==
X-ME-Sender: <xms:b346X-Pwt1nCJ4zj9fb9p79bslgruI1WRfgz8nDpgmD5uijrzCCskw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtfedgheejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepteevgefhvefggfffkeeuffeuvdfhueehhe
    etffeikeegheevfedvgeelvdffudfhnecukfhppeejledrudekvddrieefrdegvdenucev
    lhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthh
    esihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:b346X8-e96hThxF5Uubr6SXkJxkYnwVJhaWmrUK8h5nGyyykxRI19A>
    <xmx:b346X1TwUEoCol2iwSjwbOR7j1KvFtjQS49V2UwS8lkXo5OYDuwQgw>
    <xmx:b346X-s3tQaugJWSHVXasZRWWFm6dF82WWuSI4gLr02YYrh1BJilug>
    <xmx:cH46X99HZH3-2gIM40hTwmjY8gbi0Rpgr-BZzaf-uQ8MXm9ijl-bDxOF5Jw>
Received: from localhost.localdomain (bzq-79-182-63-42.red.bezeqint.net [79.182.63.42])
        by mail.messagingengine.com (Postfix) with ESMTPA id F32723280065;
        Mon, 17 Aug 2020 08:56:08 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        amcohen@nvidia.com, danieller@nvidia.com, mlxsw@nvidia.com,
        roopa@nvidia.com, dsahern@gmail.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com, saeedm@nvidia.com,
        tariqt@nvidia.com, ayal@nvidia.com, eranbe@nvidia.com,
        mkubecek@suse.cz, Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH iproute2-next 0/2] Add devlink-metric support
Date:   Mon, 17 Aug 2020 15:55:39 +0300
Message-Id: <20200817125541.193590-1-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

This patch set adds devlink-metric support in iproute2.

Patch #1 updates the kernel headers.

Patch #2 adds actual devlink-metric support including associated bash
completion support. See commit message for example usage and output.

Danielle Ratson (2):
  Update kernel headers
  devlink: Add device metric set and show commands

 bash-completion/devlink      |  67 ++++++++++++-
 devlink/devlink.c            | 185 ++++++++++++++++++++++++++++++++++-
 include/uapi/linux/devlink.h |  19 ++++
 3 files changed, 267 insertions(+), 4 deletions(-)

-- 
2.26.2

