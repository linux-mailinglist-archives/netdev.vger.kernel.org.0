Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5A4B426B85
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 15:13:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242461AbhJHNPC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 09:15:02 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:35131 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242410AbhJHNPB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Oct 2021 09:15:01 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 12AE95C00B2;
        Fri,  8 Oct 2021 09:13:06 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Fri, 08 Oct 2021 09:13:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Tu6KOZnUNSHFrIYAu
        P0di5wKRZjWa8yXiJFyTGbvHjQ=; b=Ph75ZdeKJEioLimn5F0B6cqBRdro+tWf7
        AGLDfA9mdyHtojwCNJc+hrUGkglB15YEZpQL9rrFHTryMYxMVH12vp8rr13Wlerc
        jf4k+NmS8QlqPC4b0FgVeXGU5hllVqrS/MFqcSdh8iu1IWOgrqwl5IXlpJknyFlU
        JEm/7reO7xoPr5Ps7Kc7AdJkSa+S3Hxs7Vn3W1lqNg0Z2EoPbk17206q8TyhfF+2
        6F1Dpi8cy6XReIGeu9vEKzTGNJeq9PpYXd69Sv5lVigTLUbVPVR9DyAqweHK3ZQx
        mXEqn5QIXINgJ3j4pYAkB6DQXId/L6J3s6960X5vkPdyMqPfRIJ1g==
X-ME-Sender: <xms:4UNgYUHOMXXcxs0TcaYb3bPdVTyuChKNcso8vTsGmNnmcjBF6qWFHA>
    <xme:4UNgYdVTZW-_-FIuo1MNAdt71wyUsk4mqqNhlVwwuPI0GoNZfk5ueLAdsUiCuWIY4
    jXAn7qFd7kRT9Y>
X-ME-Received: <xmr:4UNgYeJnMm3x1HruEN5nRiG84t2YYHswHXW4saOTqXBHF76chninzdOdKI-CoC62zyXHSIMm4TTJcGl8uMyOaYkq-26Ka0r3pnaSuPNhash_cA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvddttddgheelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepteevgefhvefggfffkeeuffeuvdfhueehhe
    etffeikeegheevfedvgeelvdffudfhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghr
    rghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:4UNgYWGzBs1IbTbZaqBl-wdmCIqEcw4N_VQj5tfDnrYMEeKeHo75DQ>
    <xmx:4UNgYaVKswh7AzTONtgQc8q3bAkQ__dWM_AA1-CIGDEWIZ0HNR6Qsw>
    <xmx:4UNgYZOiaTA2ekyrjjRD84NgHHQeo2BXEk6HPwYnmuQR23_VlWjRRg>
    <xmx:4kNgYYzxf9w0ndV6hjQXvzSRSB3-Gq69diCXNRuuYA5bHe2kEX_1pg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 8 Oct 2021 09:13:03 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, amcohen@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 0/8] selftests: forwarding: Add ip6gre tests
Date:   Fri,  8 Oct 2021 16:12:33 +0300
Message-Id: <20211008131241.85038-1-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

This patchset adds forwarding selftests for ip6gre. The tests can be run
with veth pairs or with physical loopbacks.

Patch #1 adds a new config option to determine if 'skip_sw' / 'skip_hw'
flags are used when installing tc filters. By default, it is not set
which means the flags are not used. 'skip_sw' is useful to ensure
traffic is forwarded by the hardware data path.

Patch #2 adds a new helper function.

Patches #3-#4 add the forwarding selftests.

Patch #5 adds a mlxsw-specific selftest to validate correct behavior of
the 'decap_error' trap with IPv6 underlay.

Patches #6-#8 align the corresponding IPv4 underlay test to the IPv6
one.

Amit Cohen (8):
  testing: selftests: forwarding.config.sample: Add tc flag
  testing: selftests: tc_common: Add tc_check_at_least_x_packets()
  selftests: forwarding: Add IPv6 GRE flat tests
  selftests: forwarding: Add IPv6 GRE hierarchical tests
  selftests: mlxsw: devlink_trap_tunnel_ipip6: Add test case for IPv6
    decap_error
  selftests: mlxsw: devlink_trap_tunnel_ipip: Align topology drawing
    correctly
  selftests: mlxsw: devlink_trap_tunnel_ipip: Remove code duplication
  selftests: mlxsw: devlink_trap_tunnel_ipip: Send a full-length key

 .../net/mlxsw/devlink_trap_tunnel_ipip.sh     |  50 +-
 .../spectrum-2/devlink_trap_tunnel_ipip6.sh   | 250 ++++++++++
 .../net/forwarding/forwarding.config.sample   |   3 +
 .../selftests/net/forwarding/ip6gre_flat.sh   |  65 +++
 .../net/forwarding/ip6gre_flat_key.sh         |  65 +++
 .../net/forwarding/ip6gre_flat_keys.sh        |  65 +++
 .../selftests/net/forwarding/ip6gre_hier.sh   |  65 +++
 .../net/forwarding/ip6gre_hier_key.sh         |  65 +++
 .../net/forwarding/ip6gre_hier_keys.sh        |  65 +++
 .../selftests/net/forwarding/ip6gre_lib.sh    | 438 ++++++++++++++++++
 .../selftests/net/forwarding/tc_common.sh     |  10 +
 11 files changed, 1109 insertions(+), 32 deletions(-)
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/spectrum-2/devlink_trap_tunnel_ipip6.sh
 create mode 100755 tools/testing/selftests/net/forwarding/ip6gre_flat.sh
 create mode 100755 tools/testing/selftests/net/forwarding/ip6gre_flat_key.sh
 create mode 100755 tools/testing/selftests/net/forwarding/ip6gre_flat_keys.sh
 create mode 100755 tools/testing/selftests/net/forwarding/ip6gre_hier.sh
 create mode 100755 tools/testing/selftests/net/forwarding/ip6gre_hier_key.sh
 create mode 100755 tools/testing/selftests/net/forwarding/ip6gre_hier_keys.sh
 create mode 100644 tools/testing/selftests/net/forwarding/ip6gre_lib.sh

-- 
2.31.1

