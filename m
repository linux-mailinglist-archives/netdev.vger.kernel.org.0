Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBDEB1F0A88
	for <lists+netdev@lfdr.de>; Sun,  7 Jun 2020 10:37:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726425AbgFGIhP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jun 2020 04:37:15 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:60167 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726375AbgFGIhP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jun 2020 04:37:15 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 0C77F5C00B9;
        Sun,  7 Jun 2020 04:37:14 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 07 Jun 2020 04:37:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=hxm9gyl7r6+nrPg5f
        LDgKPLIACoqNZskwVNH/RzK2gg=; b=i6G2DrFJbSCV3amRkBcVKXIB6DJXTZT7o
        nFKlB5YdXe9Y2qt8rW2WWkC713Io05NxE2joRAHVeYq+EodzxMj2bOm10NPydVjM
        aTJxAaJipme5wOVxd8lJvaJbXzres9NPfxD5fOwdiV9vBk71I7l6q+Wq6r9Gf4B7
        Au/TFwb7L+2mHpfqXoYn0qW4LKbJmccPfuSDSfKp5uZak46Ddzh2hWuT+C/la5Dw
        WMiodIjFssYhnZZL4Jen6EFT+pi1CrjUg25c5+Yz1f3AWrPtFDWmZUGYWRPheMxz
        chn/Va0TTYOiLj0zjV0f5e7jhlHoVwDuQY+wVZJtE/gUhme99kvQQ==
X-ME-Sender: <xms:OafcXsy_byMXvuYt_RTWEDSZ_diDULcAAGMawTFhvwFylFP8Zc9CNQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudegledgtdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepteevgefhvefggfffkeeuffeuvdfhueehhe
    etffeikeegheevfedvgeelvdffudfhnecukfhppeejledrudejkedrgeehrddvvdefnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstg
    hhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:OafcXgQO7HyDHQARGUy6ym8cW2BJ2ep4s73dfvaVXmrRZR-KdwlJcA>
    <xmx:OafcXuXnKaAwivb-k3iWNoqY740nlBEjddp_nUQB3SEggVNE7OG1dw>
    <xmx:OafcXqjmLnpDnGWSYXs6l0339sWGPgy8SKACBUpcwfryWc1eHnEq9Q>
    <xmx:OqfcXv4e7aoaTw45trkA5xYqTxWmxk8aVHoJMaoIBG-QHESlI90UFg>
Received: from splinter.mtl.com (bzq-79-178-45-223.red.bezeqint.net [79.178.45.223])
        by mail.messagingengine.com (Postfix) with ESMTPA id 75976328005A;
        Sun,  7 Jun 2020 04:37:12 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH iproute2 0/2] Two devlink-trap enhancements
Date:   Sun,  7 Jun 2020 11:36:45 +0300
Message-Id: <20200607083647.2022510-1-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

This patch set contains two small devlink-trap enhancements for code
that is already present in mainline.

Patch #1 adds 'control' trap type.

Patch #2 adds 'mirror' trap action.

The 'devlink' bash completion and 'devlink-trap' man page are extended
accordingly.

Ido Schimmel (2):
  devlink: Add 'control' trap type
  devlink: Add 'mirror' trap action

 bash-completion/devlink |  4 ++--
 devlink/devlink.c       | 10 ++++++++--
 man/man8/devlink-trap.8 | 11 +++++++----
 3 files changed, 17 insertions(+), 8 deletions(-)

-- 
2.26.2

