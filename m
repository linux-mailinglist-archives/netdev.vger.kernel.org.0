Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BCDD26FA3E
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 12:17:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726433AbgIRKRH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 06:17:07 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:8789 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726253AbgIRKRE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 06:17:04 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f6489130001>; Fri, 18 Sep 2020 03:16:51 -0700
Received: from sw-mtx-036.mtx.labs.mlnx (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 18 Sep
 2020 10:17:03 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <netdev@vger.kernel.org>, <stephen@networkplumber.org>,
        <dsahern@kernel.org>
CC:     Parav Pandit <parav@nvidia.com>
Subject: [PATCH iproute2-next RESEND 1/3] devlink: Update kernel headers
Date:   Fri, 18 Sep 2020 13:16:47 +0300
Message-ID: <20200918101649.60086-2-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200918101649.60086-1-parav@nvidia.com>
References: <20200918080300.35132-1-parav@nvidia.com>
 <20200918101649.60086-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600424211; bh=9x4XeV5I53rYvbhAY5dJ+R768l7h67r/AS3hL9BT4b4=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=pbNxAFTOlEnYzK+z1zmjZiAFM7gXXCehHY3yD+SCFme/0KoVnjxLN0NRVQobB7lEG
         esbs3wRf/tnIx9W1aP+eN4I7zJbuOw07n7QOLQghKGUCBq9o2tL++C9N8IMPa9ZGhT
         j2p/U2tOihymeASfk/E4wuWeMpqg0JhQBm72pOnX1CO1nLqQeEW1ykLlcvxDMkXS89
         3l0TYj0ik78YrYvYHAl3KMfir8jIAt5XZqv+gpMez3GYtGrq3r6iD4fDRCtcqmXcnw
         tHr7ZkXU1zSBevdw1Pf3be+YYgyM5CQO1t9papOnUgAFNpJ76ObgYrF+UbLZxqebgt
         C/dSweKoSt8Cw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update kernel headers to commit:
   e2ce94dc1d89 ("devlink: introduce the health reporter test command")

Signed-off-by: Parav Pandit <parav@nvidia.com>
---
 include/uapi/linux/devlink.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index b7f23faa..3d64b48e 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -122,6 +122,8 @@ enum devlink_command {
 	DEVLINK_CMD_TRAP_POLICER_NEW,
 	DEVLINK_CMD_TRAP_POLICER_DEL,
=20
+	DEVLINK_CMD_HEALTH_REPORTER_TEST,
+
 	/* add new commands above here */
 	__DEVLINK_CMD_MAX,
 	DEVLINK_CMD_MAX =3D __DEVLINK_CMD_MAX - 1
@@ -458,6 +460,8 @@ enum devlink_attr {
 	DEVLINK_ATTR_PORT_LANES,			/* u32 */
 	DEVLINK_ATTR_PORT_SPLITTABLE,			/* u8 */
=20
+	DEVLINK_ATTR_PORT_EXTERNAL,		/* u8 */
+	DEVLINK_ATTR_PORT_CONTROLLER_NUMBER,	/* u32 */
 	/* add new attributes above here, update the policy in devlink.c */
=20
 	__DEVLINK_ATTR_MAX,
--=20
2.26.2

