Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 443BC26F79F
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 10:03:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbgIRIDV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 04:03:21 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:4408 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726623AbgIRIDU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 04:03:20 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f64699c0000>; Fri, 18 Sep 2020 01:02:36 -0700
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 18 Sep
 2020 08:03:19 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <netdev@vger.kernel.org>, <stephen@networkplumber.org>,
        <dsahern@kernel.org>
CC:     Parav Pandit <parav@nvidia.com>
Subject: [PATCH net-next 1/3] devlink: Update kernel headers
Date:   Fri, 18 Sep 2020 11:02:58 +0300
Message-ID: <20200918080300.35132-2-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200918080300.35132-1-parav@nvidia.com>
References: <20200918080300.35132-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600416156; bh=9x4XeV5I53rYvbhAY5dJ+R768l7h67r/AS3hL9BT4b4=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=PHHltst6/SOgmw0WPv+j1hvTCTuTLJy7s2Q158tr06ngH5q1JI0SFUw1kGACuiy7/
         KHCuBnYTQvWX5HmuytWeHlzJc4fsen15dTNH4tEaQpSOGBTkCBg3QIsmPraroqYOFt
         ip4VSuWJ5lBRzROW0JO2ogba+RMJco48FVw3/MUWQ4tqCda+Q2+4UVjVw28WxRnh/i
         Q9IzcNXK76IDURumsGaB4SjV0k+mqTNMBgDTDVSwSRMGxULKKIo225OVgOUFDlbPoB
         AchHPjtuZMi4KX5U8QmG41ugIJQ7I8iITILCiZWgAC15yt3jMQA4VZ8htgpVpk8lS6
         E79eL6rQmpkcg==
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

