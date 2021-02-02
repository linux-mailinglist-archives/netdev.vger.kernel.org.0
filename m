Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9F430C9C1
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 19:30:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238669AbhBBS2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 13:28:01 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:1728 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237570AbhBBS01 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 13:26:27 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B601999210003>; Tue, 02 Feb 2021 10:25:37 -0800
Received: from dev-r-vrt-156.mtr.labs.mlnx (172.20.145.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3; Tue, 2 Feb 2021 18:25:35 +0000
From:   Danielle Ratson <danieller@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <mkubecek@suse.cz>, <f.fainelli@gmail.com>, <kuba@kernel.org>,
        <andrew@lunn.ch>, <mlxsw@nvidia.com>,
        Danielle Ratson <danieller@nvidia.com>
Subject: [PATCH ethtool v2 4/5] shell-completion: Add completion for lanes
Date:   Tue, 2 Feb 2021 20:25:12 +0200
Message-ID: <20210202182513.325864-5-danieller@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210202182513.325864-1-danieller@nvidia.com>
References: <20210202182513.325864-1-danieller@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612290337; bh=hYdZvoYpxqLdWb+8Aj7vDDVSwW9pDXsMLJmkcuDw5i0=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=InbZPDfsgXaxgGNDF9D00phbQc/LjmwfXfYbf53oXhHfBuhQJ85kuW6tz+uSbtgy0
         8KHpMPhoknQx1nU7dcmN9phWGRw4LkyrR9gCnJWmgMzDa1yoCXvW39POBPPsxAZUWV
         6shMNr8LmpjmVRzP6GMoLdAEtyR5SQwO0FyYsWCZWPwaW7RWcMoxEvIn6QPvDeSIhX
         r16BswDfisDfXINqzkOJin+HsCQULlIh1wLv0FI+23ttckCjQCrQiQcSQF0L7zttRR
         AEacWA+aXvTnOPSmyGDKvD0dHTFuxrBNbHfpzZFSrO7Omfp2KHN7wQqCu9dp93ZQKD
         AVKsPjVLWvUVw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lanes was added as a new link mode setting in ethtool.

Support completion for lanes when setting parameters.

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
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

