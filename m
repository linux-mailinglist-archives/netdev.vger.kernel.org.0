Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF3D92B1F86
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 17:06:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbgKMQGc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 11:06:32 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:46573 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726503AbgKMQGb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 11:06:31 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id B7E2B5C018D;
        Fri, 13 Nov 2020 11:06:30 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Fri, 13 Nov 2020 11:06:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=5EyIgtsm3MUPjZ2XN
        AEt5cMRG1yLnaZN5s+MoQv0JlE=; b=md4ll/K50YNZSj2jrWNMEv/5f3GjpCF1+
        5irgQTLM7cMw22aoTRG9ZGSWnwqG8uqAQcaT48Su7g9OTa4ouZPRMZ1jcmEW6Kgj
        j5DEK/9j70ZF9nSDGfPssWO0Ja36aZQZC2DG/q6ufiHYGqEmPVS3mdN3+reoymwP
        Aq4G4b63KMISaSvXKu5IYkUbY8BDmIHKHN8O6o1iDfQS520fYtKL167CiVhLgeBN
        4hovuhe5q9lGQsvPUFH9+KXaQtx0nDY9dQkgI2ZmU1C+nlTmSm0jaMsfVEzSOkY0
        PIZBiHrvypV0Z1xxG4pO/eSmRqj0NBDqa7fdNRlExB2kQCp4MaxfA==
X-ME-Sender: <xms:Bq-uXykQXF5kg62TRnpHQgobs1fE436BSt05aYs10Ly4x6ssuQ9gkw>
    <xme:Bq-uX53TeZ9XIRW0trSoByZh6Shco20TUou2zqgonYwV4V2YoGY_-TTcOhTyIQY-C
    bu5gREp9VK0FCY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddvhedgkeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepkeekgfetgeeuvddtgeffieetgfeuieeiud
    ethfdthfekteetlefgveelteeuieegnecuffhomhgrihhnpehgihhthhhusgdrtghomhen
    ucfkphepkeegrddvvdelrdduheegrddugeejnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:Bq-uXwqAGo3TDshqLVkXwBvVYpp_i458vet5dH_QYZSuvd-VFNObrw>
    <xmx:Bq-uX2nsbN3--bgKgEfnIQZ-dbOSZFu9ribIKlE2E4qkHT7A5Z4T3A>
    <xmx:Bq-uXw3D1l75D7zTkoCZjHYLvAoNE1g-5yQH0xVjwpwha4lQcf6yXw>
    <xmx:Bq-uX9yc_RpmjNQo4HpfLemn8suTMm-TCONc5vQRgmi43vnWW3Utgg>
Received: from shredder.lan (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id 71B093280059;
        Fri, 13 Nov 2020 11:06:28 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 00/15] mlxsw: Preparations for nexthop objects support - part 1/2
Date:   Fri, 13 Nov 2020 18:05:44 +0200
Message-Id: <20201113160559.22148-1-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

This patch set contains small and non-functional changes aimed at making
it easier to support nexthop objects in mlxsw. Follow up patches can be
found here [1].

Patches #1-#4 add a type field to the nexthop group struct instead of
the existing protocol field. This will be used later on to add a nexthop
object type, which can contain both IPv4 and IPv6 nexthops.

Patches #5-#7 move the IPv4 FIB info pointer (i.e., 'struct fib_info')
from the nexthop group struct to the route. The pointer will not be
available when the nexthop group is a nexthop object, but it needs to be
accessible to routes regardless.

Patch #8 is the biggest change, but it is an entirely cosmetic change
and should therefore be easy to review. The motivation and the change
itself are explained in detail in the commit message.

Patches #9-#12 perform small changes so that two functions that are
currently split between IPv4 and IPv6 could be consolidated in patches
#13 and #14. The functions will be reused for nexthop objects.

Patch #15 removes an outdated comment.

[1] https://github.com/idosch/linux/tree/submit/nexthop_objects

Ido Schimmel (15):
  mlxsw: spectrum_router: Compare key with correct object type
  mlxsw: spectrum_router: Add nexthop group type field
  mlxsw: spectrum_router: Use nexthop group type in hash table key
  mlxsw: spectrum_router: Associate neighbour table with nexthop instead
    of group
  mlxsw: spectrum_router: Store FIB info in route
  mlxsw: spectrum_router: Remove unused field 'prio' from IPv4 FIB entry
    struct
  mlxsw: spectrum_router: Move IPv4 FIB info into a union in nexthop
    group struct
  mlxsw: spectrum_router: Split nexthop group configuration to a
    different struct
  mlxsw: spectrum_ipip: Remove overlay protocol from can_offload()
    callback
  mlxsw: spectrum_router: Pass nexthop netdev to
    mlxsw_sp_nexthop6_type_init()
  mlxsw: spectrum_router: Pass nexthop netdev to
    mlxsw_sp_nexthop4_type_init()
  mlxsw: spectrum_router: Remove unused argument from
    mlxsw_sp_nexthop6_type_init()
  mlxsw: spectrum_router: Consolidate mlxsw_sp_nexthop{4, 6}_type_init()
  mlxsw: spectrum_router: Consolidate mlxsw_sp_nexthop{4, 6}_type_fini()
  mlxsw: spectrum_router: Remove outdated comment

 .../ethernet/mellanox/mlxsw/spectrum_ipip.c   |   3 +-
 .../ethernet/mellanox/mlxsw/spectrum_ipip.h   |   3 +-
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 580 +++++++++---------
 3 files changed, 300 insertions(+), 286 deletions(-)

-- 
2.28.0

