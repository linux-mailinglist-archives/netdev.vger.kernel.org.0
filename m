Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1FB826F79E
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 10:03:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbgIRIDT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 04:03:19 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:10952 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726359AbgIRIDT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 04:03:19 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f6469ba0000>; Fri, 18 Sep 2020 01:03:06 -0700
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 18 Sep
 2020 08:03:18 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <netdev@vger.kernel.org>, <stephen@networkplumber.org>,
        <dsahern@kernel.org>
CC:     Parav Pandit <parav@nvidia.com>
Subject: [PATCH net-next 0/3] devlink show controller and external info
Date:   Fri, 18 Sep 2020 11:02:57 +0300
Message-ID: <20200918080300.35132-1-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600416186; bh=kPP9KncKILyqjGSEKP65pWzMgBxiayppcWL4Ky9CGtE=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
         Content-Transfer-Encoding:Content-Type:X-Originating-IP:
         X-ClientProxiedBy;
        b=nZ/egXqcvKnO1YnLPZkhgvWZpoqOsd28PkOGDAOWrp2UZws8xxch2OdHoEhPcgJBl
         zZbHtAZIFBZOVPR2q7UQvcU3dGdV3IHvy32F6vRG1tlK5LLuqg+0kH+zZ5Ay+QocIf
         4x8RydNOUndS7jGbDuKMUskm7vNpINUWX0Jcm0EsZ7QgbrNx2d+v+7hPLD2woHvL8J
         KhDUr6I3h7lzn9tG3wuQBtOdBMAA9+SsxPypMSp3+BwNd2s2gz9g3O76qLZXUaBO2p
         9GSomzTYc9GEwYUwp8ND8va4oTvWCTKDHflVZ++U667pmWs2qLCZkfiugWa4Tly7dO
         OfVZoAh9JcRFQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For certain devlink port flavours controller number and optionally external=
 attributes are reported by the kernel.

(a) controller number indicates that a given port belong to which local or =
external controller.
(b) external port attribute indicates that if a given port is for external =
or local controller.

This short series shows this attributes to user.

Patch summary:
Patch-1 updates the kernel header
Patch-2 shows external attribute
Patch-3 show controller number

Parav Pandit (3):
  devlink: Update kernel headers
  devlink: Show external port attribute
  devlink: Show controller number of a devlink port

 devlink/devlink.c            | 9 +++++++++
 include/uapi/linux/devlink.h | 4 ++++
 2 files changed, 13 insertions(+)

--=20
2.26.2

