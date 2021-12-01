Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87A02464950
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 09:13:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347769AbhLAIQr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 03:16:47 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:40759 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347861AbhLAIQo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 03:16:44 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id CD22A5C0125;
        Wed,  1 Dec 2021 03:13:17 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Wed, 01 Dec 2021 03:13:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=UBxFs8mw/kzemE+7p
        PeAbS1In9uxzFgEpNm6QE8bqOI=; b=ID86FFHXDiMsRtWMOI3L+FC27FJjpqCg2
        juybcbJvSQ9g7wyyCyUuIBg9Su5p4VDIeuCrk6HdR16DjmLyHNTgw+wC2LmhIQZM
        cvhbA1VSDEBomabWKQlhHNLwl11YqjVT99/XBo0mxoWqhckgFs6fRB6dMMadVaC+
        TX4OHtHhXvS8Ti9Y+BID6uTOi+cy/hekafSiioojT/W8mC2pf+3DRXKv0r7mh+PA
        TUgN3HrqI6RkvjhPt5e86CV0hS07sXLMQM66D2UO6oHFX426mGPlpug0OrXZVloN
        AQ9Aj7N21kEhd3qgSyLxYelDlAAx9rn+U6gCwCBqia2+7HpwiFnaw==
X-ME-Sender: <xms:nS6nYeCzE3spiRobn3roGgC5F44rfW2UTKrlL4tD9CiYPww5vZQYHw>
    <xme:nS6nYYjydHU3_tRZ-u_rIeXNx_heVuhPPIcBaZ6e-BeNS2kLd8-wvjHq4L_lYeCdZ
    kP0LItwo2-qSDs>
X-ME-Received: <xmr:nS6nYRnMcZHGl9XrFLduS4W4T_pglxnOPZAIRXc7NfwWpz7-wse_N_ukFbql6ufIRMz-Cya8RrB1gAvlACnc_bltEyUhy2AQx6FVczYlEQfqlA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddriedvgdduudekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepteevgefhvefggfffkeeuffeuvdfhueehhe
    etffeikeegheevfedvgeelvdffudfhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghr
    rghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:nS6nYczIwUReEe26-8q9XKZIo7DqmBoFjEn76mnkXYw_Z7iOUlEzpg>
    <xmx:nS6nYTSLPaFYjyeeH7tSoCI-bl6Rs_nJVglXsXa-uM9W27xcng5KMw>
    <xmx:nS6nYXaZG9_Tf3ZXGSWQspDtwiMW-j6wtmq3D0MxUZUsNb_qlFgHug>
    <xmx:nS6nYRPQFkLHC_EFN2XUQaV-uEg6etTckn6T_uiFi825lvC37n5Obg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 1 Dec 2021 03:13:15 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        amcohen@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 00/10] mlxsw: Spectrum-4 preparations
Date:   Wed,  1 Dec 2021 10:12:30 +0200
Message-Id: <20211201081240.3767366-1-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The Spectrum-4 ASIC will support more than 256 ports, unlike existing
ASICs. As such, various device registers were extended with two
additional bits to encode a 10 bit local port. In some cases, new
(Version 2) registers were introduced.

This patchset prepares mlxsw for Spectrum-4 support by encoding local
port in a 'u16' instead of a 'u8' and by extending the definitions of
the various registers to support the extended local port form.

Amit Cohen (10):
  mlxsw: spectrum: Bump minimum FW version to xx.2010.1006
  mlxsw: reg: Remove unused functions
  mlxsw: item: Add support for local_port field in a split form
  mlxsw: reg: Align existing registers to use extended local_port field
  mlxsw: reg: Increase 'port_num' field in PMTDB register
  mlxsw: reg: Adjust PPCNT register to support local port 255
  mlxsw: Use u16 for local_port field instead of u8
  mlxsw: Add support for more than 256 ports in SBSR register
  mlxsw: Use Switch Flooding Table Register Version 2
  mlxsw: Use Switch Multicast ID Register Version 2

 drivers/net/ethernet/mellanox/mlxsw/core.c    |  42 +-
 drivers/net/ethernet/mellanox/mlxsw/core.h    |  44 +-
 .../mellanox/mlxsw/core_acl_flex_actions.c    |  22 +-
 .../mellanox/mlxsw/core_acl_flex_actions.h    |  16 +-
 drivers/net/ethernet/mellanox/mlxsw/item.h    |  36 ++
 drivers/net/ethernet/mellanox/mlxsw/minimal.c |  10 +-
 drivers/net/ethernet/mellanox/mlxsw/reg.h     | 487 +++++++++---------
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  60 +--
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  20 +-
 .../ethernet/mellanox/mlxsw/spectrum_acl.c    |   2 +-
 .../mlxsw/spectrum_acl_flex_actions.c         |  14 +-
 .../mellanox/mlxsw/spectrum_buffers.c         |  58 ++-
 .../mellanox/mlxsw/spectrum_ethtool.c         |   4 +-
 .../ethernet/mellanox/mlxsw/spectrum_fid.c    |  30 +-
 .../ethernet/mellanox/mlxsw/spectrum_ptp.c    |  12 +-
 .../ethernet/mellanox/mlxsw/spectrum_ptp.h    |  16 +-
 .../ethernet/mellanox/mlxsw/spectrum_router.c |   2 +-
 .../ethernet/mellanox/mlxsw/spectrum_span.c   |  20 +-
 .../mellanox/mlxsw/spectrum_switchdev.c       |  60 +--
 .../ethernet/mellanox/mlxsw/spectrum_trap.c   |  24 +-
 20 files changed, 515 insertions(+), 464 deletions(-)

-- 
2.31.1

