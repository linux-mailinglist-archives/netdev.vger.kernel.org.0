Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E11F92ED378
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 16:27:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726447AbhAGPZC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 10:25:02 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:52733 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726073AbhAGPZB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 10:25:01 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 4CABC144C;
        Thu,  7 Jan 2021 10:23:55 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 07 Jan 2021 10:23:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=pTlhgBm9pGOgfJCLA
        KkA7Sh9I7Ptcj8F1G4A3yrSVI8=; b=Ipi+AMSwfVrTO4SpxxRZ3w45a2pUPO7Yt
        kB+oh7JUMLfotSCcmXfaHi1Sbht7n7ikvl4tM20al8qmWYJYU6CjyS1jKij3UtVL
        +CkX3Qid9MLL6w8ncPTjc0C5wqrC3IE2TjiqS4pOBpXE/XjrRjLFiiWwlm8VxR3a
        P5HVP3YB8bCA7wxVunCc+5kORIeUVOKgqb5/jsjedo8ovbGUBQ+zCXK2clw7gJce
        uUbQwYfdjE2D5TPrEBPycDMG7qCSP7aHrIAV2euX8Uk/2VxB7SAd0hE0Yup5G0uj
        1DBdqrqf2pJjPxZJ8RKcMYzANDkw4P5bJV5acRH9U08AzW38iepMA==
X-ME-Sender: <xms:iif3XzFEB_nxAj0WkA9n_eIGgzi0q0bzMNi3hwLSCybLOONwKAqq8g>
    <xme:iif3XwUrfjJF_xrsyBxLMrfIp3EMqt7QOrUorDblOlJ2bxYO_tG6il7ems_WR_y-3
    KOOZ-LdBcYL4pA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdegvddgjeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepteevgefhvefggfffkeeuffeuvdfhueehhe
    etffeikeegheevfedvgeelvdffudfhnecukfhppeekgedrvddvledrudehfedrgeegnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstg
    hhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:iif3X1InW9Ac4MEm_ODtoRFZJ_Gx0OdhXgKphkeRX8noC01cSRHDnQ>
    <xmx:iif3XxHWnjwejocaFPkP10SEfAQ4WJDZr0Oc7wXFINfhcK9ntVH2ZQ>
    <xmx:iif3X5Uv5NVZfxyJne7TzDW6NzLPzubfytx22bLCsly-F7DMA8Rlrw>
    <xmx:iif3X2i6S3T4NYtpDSHpWALto9Cn96IlnR4NqE_u3hJD_pCaRxh4-A>
Received: from shredder.lan (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 32A9E240057;
        Thu,  7 Jan 2021 10:23:53 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com, petrm@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH iproute2 0/2] nexthop: Small usage improvements
Date:   Thu,  7 Jan 2021 17:23:25 +0200
Message-Id: <20210107152327.1141060-1-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Two small usage improvements in ip-nexthop and ip-monitor. Noticed while
adding support for resilient nexthop groups.

Ido Schimmel (2):
  nexthop: Fix usage output
  ipmonitor: Mention "nexthop" object in help and man page

 ip/ipmonitor.c        | 2 +-
 ip/ipnexthop.c        | 6 +++---
 man/man8/ip-monitor.8 | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

-- 
2.29.2

