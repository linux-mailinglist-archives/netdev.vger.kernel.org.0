Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6508198EBF
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 10:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730139AbgCaIn0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 04:43:26 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:35169 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726528AbgCaInZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 04:43:25 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id AE0635C0236;
        Tue, 31 Mar 2020 04:43:24 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 31 Mar 2020 04:43:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=gRvsTQgEl+9a33vdp
        CfPNX4QPN2tEcR+bDJvJVQyoUM=; b=NnptMKvKqrTke2rFPbje9vmALnjBDFxKD
        hZWVGKjE2oOOLzMR58yD7ZUKq/8OoEuBCJMbctuqNUKCzMBBVWwv7ig749ajg1mq
        3UaQS8JSwwz3AHM+yZrvV6Xog7O/Nk6xvnfq1GvUt8IK44zYj2CJOWXYHthlJ1QG
        peqyTkUNZrq/rYh3qC7M2a+mDFkAJpPXRDqxPEt1WOm1NQLVu9ldqrFutced9x82
        b2IBQrmuQJtqamcu4ACa8qLRUoVdGePx/ZlgBpaL4vWnI+VIJylQAjpPQCgIW3yi
        lYL0TPZ02u4/qy2RHemQ8Y9TLFkCeSoPj9/D2C2ZtoL9tu+fcLDIg==
X-ME-Sender: <xms:rAKDXooWjHjAeT2SlJbHTa2YVzrxwnm_c81n04mkUoO9eQ62j3fZyw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudeijedgtdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecukfhppeejledrudekuddrudefvddrudeludenucevlhhushhtvghruf
    hiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghh
    rdhorhhg
X-ME-Proxy: <xmx:rAKDXtGljvWDvx4LbGjHaPFXJa0HeNQDDRPlCjzHZIXsJQRoYW842A>
    <xmx:rAKDXkXnztA6w6bY5PLpYtsTC9S8PUypQJxS_LvNxK8BTcjZ5BkAnA>
    <xmx:rAKDXjcrt4eRoYMU96KqOsy430QRMcfWl4ggtmyIwFYmPW4OQ1BdOw>
    <xmx:rAKDXu6INh8pIen3kw-PwcckLbtqrEtnDa8EeYJNvjNbH4cvFf43uw>
Received: from splinter.mtl.com (bzq-79-181-132-191.red.bezeqint.net [79.181.132.191])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1E17A328005D;
        Tue, 31 Mar 2020 04:43:22 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH iproute2-next v2 0/3] Add devlink-trap policers support
Date:   Tue, 31 Mar 2020 11:42:50 +0300
Message-Id: <20200331084253.2377588-1-idosch@idosch.org>
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

Patch #3 adds bash completion for new commands.

See individual commit messages for example usage and output.

v2:
* Add patch #3

Ido Schimmel (3):
  devlink: Add devlink trap policer set and show commands
  devlink: Add ability to bind policer to trap group
  bash-completion: devlink: Extend bash-completion for new commands

 bash-completion/devlink    | 131 +++++++++++++++++++++++++-
 devlink/devlink.c          | 185 ++++++++++++++++++++++++++++++++++++-
 man/man8/devlink-monitor.8 |   2 +-
 man/man8/devlink-trap.8    |  52 +++++++++++
 4 files changed, 365 insertions(+), 5 deletions(-)

-- 
2.24.1

