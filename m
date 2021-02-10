Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C247E316850
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 14:51:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231445AbhBJNuz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 08:50:55 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:15534 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231148AbhBJNuk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 08:50:40 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6023e4640000>; Wed, 10 Feb 2021 05:49:25 -0800
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 10 Feb
 2021 13:49:24 +0000
Received: from dev-r-vrt-156.mtr.labs.mlnx (172.20.145.6) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1473.3; Wed, 10 Feb 2021 13:49:22 +0000
From:   Danielle Ratson <danieller@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <mkubecek@suse.cz>, <f.fainelli@gmail.com>, <kuba@kernel.org>,
        <andrew@lunn.ch>, <mlxsw@nvidia.com>,
        Danielle Ratson <danieller@mellanox.com>
Subject: [PATCH ethtool v3 4/5] shell-completion: Add completion for lanes
Date:   Wed, 10 Feb 2021 15:48:39 +0200
Message-ID: <20210210134840.2187696-5-danieller@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210210134840.2187696-1-danieller@nvidia.com>
References: <20210210134840.2187696-1-danieller@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612964965; bh=hsBr97skxaxGgtopj9RDwAb0KvONnOCtmcDRL+W1NJk=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=XKZtnr8MgGBydGvw9VsZYJAuYDoCsmfYRXdidJnhIpqO0XaxHht0tpPW4S8+R72mn
         KeBy/HEmQrub38+r5xvh1pjZWH+wyvTf+dV9A/PpnORYAaUr52m0P7O+JFtsw0m77m
         TvNeNo32vL1vOZTO9izV7kINOHf5uKGiwDvZ4EkWsupXhQf0ZCSXRQbgbEVrGxbWEM
         AUGQHhNynY0cx3ypwgFjx0lU97nGQS7TMh1zhoQJtkLsbQl8iadFhqYHWDZtAKwsQb
         oYMS3oyjpV/Q3NhamnP5L3EsgNuEynL2eduBB8RRv9+EOInIV+aian6SHeGCRufO/6
         Frt0xCGAqLLhA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@mellanox.com>

Lanes was added as a new link mode setting in ethtool.

Support completion for lanes when setting parameters.

Signed-off-by: Danielle Ratson <danieller@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 shell-completion/bash/ethtool | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/shell-completion/bash/ethtool b/shell-completion/bash/ethtool
index 5305559..4557341 100644
--- a/shell-completion/bash/ethtool
+++ b/shell-completion/bash/ethtool
@@ -97,6 +97,7 @@ _ethtool_change()
 		[speed]=3Dnotseen
 		[wol]=3Dnotseen
 		[xcvr]=3Dnotseen
+		[lanes]=3Dnotseen
 	)
=20
 	local -A msgtypes=3D(
@@ -175,6 +176,9 @@ _ethtool_change()
 		xcvr)
 			COMPREPLY=3D( $( compgen -W 'internal external' -- "$cur" ) )
 			return ;;
+		lanes)
+			# Number
+			return ;;
 	esac
=20
 	local -a comp_words=3D()
--=20
2.26.2

