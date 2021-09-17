Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3251A40FA78
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 16:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343701AbhIQOmZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 10:42:25 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:46429 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343687AbhIQOmX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 10:42:23 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 507335C021D;
        Fri, 17 Sep 2021 10:40:59 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Fri, 17 Sep 2021 10:40:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=k0VuJVseJk8EiPmzf
        T1+LZH15xIAXa6ooxZiPnNbTEc=; b=oBNWh016Zy4IqLGfba5WGoxA4xAMdkQBU
        CFaq72PhqXhwYaPonCZFkFTAU+XH4xR+VWrq25y1sZTS87oil1xNxwyTObEq0kSz
        rZoLHCKc2la6f6LLwKXThmdmribMrheZozrOi/dlUa6DfpsBz9tFrgJvUfbW23PP
        JJAlf25b0LTqIcRNQNlz+W2LP5hHUXc2scDK5qViUzyJBvsiFr+P6GaU0WjACrJF
        SQxvPcJMU6zASf62iNfzfooW2dLYOiFoAXku02Ood6IZaH5czID91Fc7EF7C0/1w
        mWg3OuI1jAhQVVg+AwuUjQMRRKAQRG5bzGynOvTxdS/2NhJYHHBgg==
X-ME-Sender: <xms:-qhEYUSuqQrvjLFa7D_XSyHXlDYcC2D9Y3c2lH_ei56eUfI7FT_Ukg>
    <xme:-qhEYRxnduMvf7ILeVFkTRCv2b2Y0KZeHNVH9llXmPDJWVQe1VT9Iso9ZrSmxxk11
    Y57j_CZJmHFL2Y>
X-ME-Received: <xmr:-qhEYR1nPYe1Bt9Q1dNIGWVRkeGn3hq3eGDPIzAgZq3M-Lry3YKWTyNEUqMftl1Gxg5Bq2yzjST0DqloBlM6BsTkiMARd9hKGg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudehiedgjeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepteevgefhvefggfffkeeuffeuvdfhueehhe
    etffeikeegheevfedvgeelvdffudfhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghr
    rghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:-qhEYYBhaDmedLPXam7f4M4_sGTAjelraCQlQEREfDgaYZNoNGg7lg>
    <xmx:-qhEYdhHTleV9hc7qLMqvdlbA3BBUz1bJNiSp0UvoyDAOpAl4n_ugA>
    <xmx:-qhEYUpD54w50NOVLtKmg2tm8drMl__BYCjIXfRwHNEnmlfCCKmcHw>
    <xmx:-6hEYde74oTNV1p2VCFuO1QszFUUDkXvNmO5rpFeGJZB_6Ja2ObDTg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 17 Sep 2021 10:40:56 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     mkubecek@suse.cz, vadimp@nvidia.com, moshe@nvidia.com,
        popadrian1996@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH ethtool-next 0/7] ethtool: Small EEPROM changes
Date:   Fri, 17 Sep 2021 17:40:36 +0300
Message-Id: <20210917144043.566049-1-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

This patchset contains small patches for various issues I noticed while
working on the module EEPROM parsing code.

Ido Schimmel (7):
  cmis: Fix CLEI code parsing
  cmis: Fix wrong define name
  cmis: Correct comment
  sff-8636: Remove incorrect comment
  sff-8636: Fix incorrect function name
  sff-8636: Convert if statement to switch-case
  sff-8636: Remove extra blank lines

 cmis.c | 12 +++++++-----
 cmis.h |  5 ++---
 qsfp.c | 18 +++++++++---------
 3 files changed, 18 insertions(+), 17 deletions(-)

-- 
2.31.1

