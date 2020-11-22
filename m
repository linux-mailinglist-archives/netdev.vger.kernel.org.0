Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9DE42BC43A
	for <lists+netdev@lfdr.de>; Sun, 22 Nov 2020 07:14:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727343AbgKVGNU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Nov 2020 01:13:20 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:19496 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727244AbgKVGNT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Nov 2020 01:13:19 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fba01810001>; Sat, 21 Nov 2020 22:13:21 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sun, 22 Nov
 2020 06:13:18 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <kuba@kernel.org>, <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <jiri@nvidia.com>
CC:     Parav Pandit <parav@nvidia.com>
Subject: [PATCH net 0/2] devlink port attribute fixes
Date:   Sun, 22 Nov 2020 08:12:55 +0200
Message-ID: <20201122061257.60425-1-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606025602; bh=4hf+sM6RuaeZKlLfkO+B0gkJBFyGYx97tyWJp2TkjUE=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
         Content-Transfer-Encoding:Content-Type:X-Originating-IP:
         X-ClientProxiedBy;
        b=CfWY3b3dD2+lmhzcRHKsgPZmFJaUMnrMyRxqUlfkVTlvC1Bs5iDU9ITrmqT+5E8PE
         fo5e+CI2pBt3Zn9BXq0lddYLRnXWOwn/5K+z/WniHejbDJKNYqLfiVkXGS3NRcq/fV
         YUWudLirRzPOjNpI4wiaZGAgfCfnVb5riZSaSo552v1+NVNsYsp2QzwhX1OHEm3gDw
         FvWWSjVoRZ/GeCrmfzCTdYneUdYPEiV2Y7s5lKTYEAKewBum0LslP8gzGxmx0hiskf
         77H5jMgr7ih7YLK0+pc2E/qHxLWaet0FRqq95KWcZDbPfhsCFhcyMDTmrrWCqT9vIM
         0HJFKMnG5+h0g==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset contains 2 small fixes for devlink port attributes.

Patch summary:
Patch-1 synchronize the devlink port attribute reader
        with net namespace change operation
Patch-2 Ensure to return devlink port's netdevice attributes
        when netdev and devlink instance belong to same net namespace

Parav Pandit (2):
  devlink: Hold rtnl lock while reading netdev attributes
  devlink: Make sure devlink instance and port are in same net namespace

 net/core/devlink.c | 33 +++++++++++++++++++++++++++------
 1 file changed, 27 insertions(+), 6 deletions(-)

--=20
2.26.2

