Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7CAA438C5E
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 00:35:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbhJXWh3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 18:37:29 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:60973 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229533AbhJXWh3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Oct 2021 18:37:29 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 4C70D5C074F;
        Sun, 24 Oct 2021 03:19:34 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 24 Oct 2021 03:19:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=qj5sfF6aAvuIeA1En
        gphnEb0M1o3h3U+wKT8vBxOwEE=; b=E6tn0KGi+in7SDHDZQCcltZVZjwoHxgbA
        Ox/BnJDm78qTKuLsESwC4b/6mw8a2bJCXdKmdhoUp2jQ1eX4MF/dvu1DiDr7CurP
        3QdzrW6VYnMnEt/8D0y6P/J/COgZK41tZ7Sk7ZuTmTxy1KcYXcZr6pg1CIZPFosl
        mePWWdloPspgbPoOLUpfkxPoQuLIx0Sps1ZgliUeng9Wa27pfjwiWaQQGeQqRLHf
        WcJ7swAHSakeG8XZrS4zEqKo8EQq/ODYU1vmxY109MGsqm5e6ylTXhcXu1W3opNo
        56jxB4cwZU4qG01HR66T3TsOG4RwCtqVyvqIjJ5TEesR1QKo8Wm/A==
X-ME-Sender: <xms:BQl1YUs_zWtuML5QhPia3IEiXUc_ukFlzzxDYzBx9E5uH0Dsm0PWhw>
    <xme:BQl1YRdxW_ithHap7cs2DxgoUj_HuC4GCXM1-xGkEaEiM_J2SeEqFOgVsGNQRcqLE
    KqTAI9aMefYPJc>
X-ME-Received: <xmr:BQl1YfwoHhGpHyeWa_zoeZplqD03ctwiGxHvSrp1sUjCouVQQJtwvxwcLNPY0UiEWaygl0li_1eQtFBNF_iIFe3BAzT9yhA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvdefvddgudekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepteevgefhvefggfffkeeuffeuvdfhueehhe
    etffeikeegheevfedvgeelvdffudfhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghr
    rghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:BQl1YXNH3fdCBRutRvHPRswrrtvtcvvaxacxQJMAYcoB-UXi0fgFVw>
    <xmx:BQl1YU-CsCvwkUyHM1UMP2SSlAt6rkKRKgyFtH0DzQbDH8DnxTVl8w>
    <xmx:BQl1YfUR9VLyPLa2vtjh57jUpSMJR5bcXdtrQmUtUbE9WLLM2kufmA>
    <xmx:Bgl1YYYHNbcjjAOpXBjUiPSD1z6_ex84xORLdhvdffhtffL52mXBmQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 24 Oct 2021 03:19:31 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 0/3] selftests: mlxsw: Various updates
Date:   Sun, 24 Oct 2021 10:19:08 +0300
Message-Id: <20211024071911.1064322-1-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

This patchset contains various updates to mlxsw selftests.

Patch #1 replaces open-coded compatibility checks with dedicated
helpers. These helpers are used to skip tests when run on incompatible
machines.

Patch #2 avoids spurious failures in some tests by using permanent
neighbours instead of reachable ones.

Patch #3 reduces the run time of a test by not iterating over all the
available trap policers.

Ido Schimmel (2):
  selftests: mlxsw: Use permanent neighbours instead of reachable ones
  selftests: mlxsw: Reduce test run time

Petr Machata (1):
  selftests: mlxsw: Add helpers for skipping selftests

 .../drivers/net/mlxsw/devlink_trap_control.sh |  7 ++-
 .../drivers/net/mlxsw/devlink_trap_policer.sh | 32 +++++++-----
 .../selftests/drivers/net/mlxsw/mlxsw_lib.sh  | 50 +++++++++++++++++++
 .../selftests/drivers/net/mlxsw/rtnetlink.sh  | 22 ++++----
 .../drivers/net/mlxsw/sch_red_core.sh         | 10 ++--
 .../net/mlxsw/spectrum-2/resource_scale.sh    |  7 +--
 .../mlxsw/spectrum/devlink_lib_spectrum.sh    |  6 +--
 .../drivers/net/mlxsw/tc_restrictions.sh      |  3 +-
 .../selftests/drivers/net/mlxsw/tc_sample.sh  | 13 ++---
 .../selftests/net/forwarding/devlink_lib.sh   |  6 ---
 tools/testing/selftests/net/forwarding/lib.sh |  9 ++++
 11 files changed, 112 insertions(+), 53 deletions(-)

-- 
2.31.1

