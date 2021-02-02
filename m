Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0925730C9C7
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 19:30:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238674AbhBBS3A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 13:29:00 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:1733 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238593AbhBBS01 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 13:26:27 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B601999240000>; Tue, 02 Feb 2021 10:25:40 -0800
Received: from dev-r-vrt-156.mtr.labs.mlnx (172.20.145.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3; Tue, 2 Feb 2021 18:25:38 +0000
From:   Danielle Ratson <danieller@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <mkubecek@suse.cz>, <f.fainelli@gmail.com>, <kuba@kernel.org>,
        <andrew@lunn.ch>, <mlxsw@nvidia.com>,
        Danielle Ratson <danieller@nvidia.com>
Subject: [PATCH ethtool v2 5/5] man: Add man page for setting lanes parameter
Date:   Tue, 2 Feb 2021 20:25:13 +0200
Message-ID: <20210202182513.325864-6-danieller@nvidia.com>
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
        t=1612290340; bh=lJN+XR69IOEVB/YZ4idOOmkI3khbeamZqAvWYp4mJn4=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=i//nTFxCBayCoNxZ9NuSxwuaSo49d2v76PG80kgfnsmvUfRulsCCYblt3plW7HyNr
         K7eZaY4/uGFQwUyYtKwUbDvlF4KcK0pfTUvRO6noCsZEZ6GLyXudlcYMCjPXBT80U2
         0y9PiIbrRUMUBKvRd2mFXmm2cZhrHgmFMvrOz6KI1EcdmO+WNB62io7/mUBUOTmF2c
         d/MhcQLnIMOr/iqMQm47Myz2B53/TrhK7pmAocvlXJTt6dfU9gkk7AE1BqKC5VwAzn
         O4tYXtrjsZFqMzi00MdODlDpj5FdkCt7gj1FUpSvAvrwjhK4AoBvMrmCiU6VfY1y07
         jaz+WmL4krwGg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lanes parameter was added for setting using ethtool.

Update the man page to include the new parameter.

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
---
 ethtool.8.in | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/ethtool.8.in b/ethtool.8.in
index ba4e245..fe49b66 100644
--- a/ethtool.8.in
+++ b/ethtool.8.in
@@ -251,6 +251,7 @@ ethtool \- query or control network driver and hardware=
 settings
 .B ethtool \-s
 .I devname
 .BN speed
+.BN lanes
 .B2 duplex half full
 .B4 port tp aui bnc mii fibre da
 .B3 mdix auto on off
@@ -685,6 +686,9 @@ Set speed in Mb/s.
 .B ethtool
 with just the device name as an argument will show you the supported devic=
e speeds.
 .TP
+.BI lanes \ N
+Set number of lanes.
+.TP
 .A2 duplex half full
 Sets full or half duplex mode.
 .TP
--=20
2.26.2

