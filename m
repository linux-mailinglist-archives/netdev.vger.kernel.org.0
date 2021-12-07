Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFA5D46B761
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 10:35:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234276AbhLGJi1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 04:38:27 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:33561 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234184AbhLGJiM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 04:38:12 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id E22295C0240;
        Tue,  7 Dec 2021 04:34:39 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 07 Dec 2021 04:34:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=361/qsKpxmkTKadI9
        zDiEmGWveoXfbrdfXhy8qfaj7I=; b=YOzijgQIfI/tz5YR2H7lcL+tTaxAuLZL8
        E3Xlz0YkcJJgp7bIkT+o0c/j2272bDRP+E9SbcO18rMN6SA2mtAO1fw6PDkTXnAi
        CLJ+N3lqLlALAFDcywV3JTgU28/Y6tI0jUwrXLJQho4737sSlZ5CavPcXaJD1f+2
        dDDIO4hF7cf8Hp/4Y75NtuYoCBIsY9b9qOpPHx+4oK7QPu+Xs+Q9Aeg5yri8qSN6
        nyT0WPapG6J+9d1+A+NWXVKDZ3SYxAHT/GSHMtSZHFq3cph7llLGuNZ+F6wevzQL
        sNv7quKEGkHwWDPDnR1lTjuanl1pVoHjTjnU+T0oghPHICQcPyDGw==
X-ME-Sender: <xms:ryqvYR7b0dFBOl5oszdpwiE_jS-2lXc4BuyieHOEa1uG9-qHgfW8vw>
    <xme:ryqvYe5b1SzyKo6Mc05c6Tr49lCgr6Yhlemk7VCIcKX_4DLXp-iixSyoNfZZxeBo5
    Vh5L1GFcyfajNA>
X-ME-Received: <xmr:ryqvYYdQOOIw7cwsIB8tbGcm5aiPpcJ3U8qC01Ud-w1Oc2zG7_mCsydU6PNLXJlG6pnFGsd5vlAHjlMd78laxYZH-P6VPhEO0g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrjeehgddtiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghh
    rdhorhhgqeenucggtffrrghtthgvrhhnpeetveeghfevgffgffekueffuedvhfeuheehte
    ffieekgeehveefvdegledvffduhfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgr
    mhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:ryqvYaL_qn3ZsvYmMc1z3IlTv3SABkl-CMFUvbiPyYfWB2GbRcf9Hg>
    <xmx:ryqvYVIoFoXLsyXdDupdM7Pkj9fKz89UArD49ECBgINUIuDqTDOfyw>
    <xmx:ryqvYTxzJ1seW-Un-yo1hVAkFI7bw6mjf2674wliE0XSKxw7czDRwg>
    <xmx:ryqvYcUti2n7kJPDUhCmNFf6l8v1f7ib1BdgmVXdTWOCtaFD58YYjg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 7 Dec 2021 04:34:38 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     mkubecek@suse.cz, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH ethtool-next 0/3] ethtool: Add ability to control transceiver modules' power mode
Date:   Tue,  7 Dec 2021 11:33:56 +0200
Message-Id: <20211207093359.69974-1-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Patch #1 updates the UAPI headers.

Patch #2 adds the actual implementation that allows user space to
control transceiver modules' power mode. See the commit message for
example output.

Patch #3 adds support for a new module extended state to allow user
space to troubleshoot link down issues related to transceiver modules.

Ido Schimmel (3):
  Update UAPI header copies
  ethtool: Add ability to control transceiver modules' power mode
  ethtool: Add transceiver module extended state

 Makefile.am                   |   2 +-
 ethtool.8.in                  |  25 +++++
 ethtool.c                     |  12 +++
 netlink/desc-ethtool.c        |  11 +++
 netlink/extapi.h              |   4 +
 netlink/module.c              | 179 ++++++++++++++++++++++++++++++++++
 netlink/monitor.c             |   4 +
 netlink/netlink.h             |   1 +
 netlink/settings.c            |  10 ++
 shell-completion/bash/ethtool |  23 +++++
 uapi/linux/ethtool.h          |  30 ++++++
 uapi/linux/ethtool_netlink.h  |  22 ++++-
 uapi/linux/if_link.h          |   1 +
 13 files changed, 322 insertions(+), 2 deletions(-)
 create mode 100644 netlink/module.c

-- 
2.31.1

