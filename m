Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC9C3191A17
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 20:37:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbgCXTgf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 15:36:35 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:33407 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725835AbgCXTgf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 15:36:35 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 5842658022F;
        Tue, 24 Mar 2020 15:36:34 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 24 Mar 2020 15:36:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=bX66RHjsKZtifcv/Q
        hBirvxq6MbwWI6QoLznXaWBNbs=; b=TC17wBc4UaDbq7SY0Bvm2TFz9xkYipeyC
        b5ZVUL/b/s/7Y1is2HK2LCNt/2fr/TadwJwor8LDcUEff98FsBzWhBnFlKzuJPdc
        QhXzj1wqg67hDciBmNWV/PlrwTzn7jnr8iGbY5fQ46J26DEGRekAuIseZagB/0Mx
        KItAsdYmsoJq8SE5U5XI9ajDIuZPVAaZsu8HW1dR0OzPqsQOz4CU4E5VH3S0QFV+
        lYzrxdzFq5T+leb/aSaDFf4heUAa9f5FfC4ecvniRpLXYOjeiycP0VkPihRXeCCV
        JbLP29pYmWe3+GRXZ7HQa6O+zrlE/DJbvF38iK4S/ekirWc/Lk81g==
X-ME-Sender: <xms:P2F6XqlkgM3A7EbRumMFYbRZkGDrsjuxCdJtNr5MbveAxPaZuhidkg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudehuddgleeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecukfhppeejledrudektddrleegrddvvdehnecuvehluhhsthgvrhfuih
    iivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdr
    ohhrgh
X-ME-Proxy: <xmx:P2F6Xk1oha5o8Xnd3HN2Er1Alf8h_asfW1rB2tyv295IQ-zucY52pg>
    <xmx:P2F6XkSZgvPFE3i69xGEbGs1AaXUVw8ZhymvoVT1Ro6qaD9v9XwXbw>
    <xmx:P2F6XtTkxYkvPlTXepgrVF7h8AASfJXPpMo3NfXQ0aBPUrRjlDWQYw>
    <xmx:QmF6XjGPpvApBYT3qiDreCLRLY0hEeZeLgJqH8QS_eEZJvru6UXaBw>
Received: from splinter.mtl.com (bzq-79-180-94-225.red.bezeqint.net [79.180.94.225])
        by mail.messagingengine.com (Postfix) with ESMTPA id 00A923280068;
        Tue, 24 Mar 2020 15:36:27 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, jiri@mellanox.com, kuba@kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH iproute2-next 0/2] Add devlink-trap policers support
Date:   Tue, 24 Mar 2020 21:35:59 +0200
Message-Id: <20200324193601.1322252-1-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

This patch set adds devlink-trap policers support in iproute2.

Patch #1 adds devlink trap policer set and show commands.

Patch #2 adds ability to bind a policer to a trap group.

See individual commit messages for example usage and output.

Ido Schimmel (2):
  devlink: Add devlink trap policer set and show commands
  devlink: Add ability to bind policer to trap group

 devlink/devlink.c          | 185 ++++++++++++++++++++++++++++++++++++-
 man/man8/devlink-monitor.8 |   2 +-
 man/man8/devlink-trap.8    |  52 +++++++++++
 3 files changed, 235 insertions(+), 4 deletions(-)

-- 
2.24.1

