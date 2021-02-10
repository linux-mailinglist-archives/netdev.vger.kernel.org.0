Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42F4D31684C
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 14:50:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231311AbhBJNua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 08:50:30 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:6470 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230394AbhBJNuH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 08:50:07 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6023e4670001>; Wed, 10 Feb 2021 05:49:27 -0800
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 10 Feb
 2021 13:49:27 +0000
Received: from dev-r-vrt-156.mtr.labs.mlnx (172.20.145.6) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1473.3; Wed, 10 Feb 2021 13:49:24 +0000
From:   Danielle Ratson <danieller@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <mkubecek@suse.cz>, <f.fainelli@gmail.com>, <kuba@kernel.org>,
        <andrew@lunn.ch>, <mlxsw@nvidia.com>,
        Danielle Ratson <danieller@nvidia.com>
Subject: [PATCH ethtool v3 5/5] man: Add man page for setting lanes parameter
Date:   Wed, 10 Feb 2021 15:48:40 +0200
Message-ID: <20210210134840.2187696-6-danieller@nvidia.com>
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
        t=1612964967; bh=lJN+XR69IOEVB/YZ4idOOmkI3khbeamZqAvWYp4mJn4=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=i5yz7Jkxx80+JboZplqLgkmUgTMP/hwRoU5Al4l64Q29W8w0cW3yAwErO0xiHvmJm
         TPh1dTlcTBq/Ujw9v/nqHRbpVYZ9pewP3rRrnMB+fbB9VtPYAf9MSsXMv+bKh8rXIb
         biJOvm01Sl0+4zaE6zQ1SCUpJFX/FuZYhRzTHu+tj9lVXh22OsLo1hyW3zffUObpoi
         3aVOGdwJM7TOZJAvcqNNjX7fZbce4zIipaYXCbhwsAZ273C4X/Pki1pLG4Eni6zuhU
         NZNtDZAgShP+T1HRir6BpOgDUsejt3p683ZrPVxQnKlgZZMzASisFHCzDfT3QDOF/I
         8YTs5nQJtZ31Q==
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

