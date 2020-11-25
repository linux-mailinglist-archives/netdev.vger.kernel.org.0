Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D85772C3BCE
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 10:18:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727123AbgKYJQx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 04:16:53 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:6700 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726928AbgKYJQw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 04:16:52 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fbe21040000>; Wed, 25 Nov 2020 01:16:52 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 25 Nov
 2020 09:16:52 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <kuba@kernel.org>, <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <jiri@nvidia.com>
CC:     Parav Pandit <parav@nvidia.com>
Subject: [PATCH net v2 0/2] devlink port attribute fixes
Date:   Wed, 25 Nov 2020 11:16:18 +0200
Message-ID: <20201125091620.6781-1-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201122061257.60425-3-parav@nvidia.com>
References: <20201122061257.60425-3-parav@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606295812; bh=eVDIyxXMtVgDvznPe+BsQ8kBxvYPNv0hu/lJovRtaSg=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=a20aXsoTDyrKoeBMqvZ/eDiZqkXWqjk0ukEWWyAN0PakV2Ix+nKdfm9nDtSajzYmc
         nIOkHDqOTTbaWxFd8MlH4F0qmHZKRgqFpAYOn+4mcyait7CxsFQQxgY1QsfNVFWXDF
         U3vaU5E7T9tyZabwvm24uQm6WHhya3eCRgAKKuUgaP/9bS2rVzq2ApnVb4NrRNLQd5
         dzOn1aWzuWlxVDownaS7y5uldCp3lMsCnA4Y2S4XalFX7W6CQmni5zNFfSXd7CWJfx
         Gzy1wqegiqsPaWluFMalVew0bM8oBEvNpm6QDCtAKMDVoupMg2unM0ieMDNSkR742M
         /ZGxy/8F3al2A==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset contains 2 small fixes for devlink port attributes.

Patch summary:
Patch-1 synchronize the devlink port attribute reader
        with net namespace change operation
Patch-2 Ensure to return devlink port's netdevice attributes
        when netdev and devlink instance belong to same net namespace

---
Changelog:
v1->v2:
 - avoided refactoring the port fill attribute routine


Parav Pandit (2):
  devlink: Hold rtnl lock while reading netdev attributes
  devlink: Make sure devlink instance and port are in same net namespace

 net/core/devlink.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--=20
2.26.2

