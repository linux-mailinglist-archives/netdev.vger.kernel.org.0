Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C28AA2FFBF6
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 06:03:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725854AbhAVFCz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 00:02:55 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:14224 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725468AbhAVFCy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 00:02:54 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B600a5c560000>; Thu, 21 Jan 2021 21:02:14 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 22 Jan
 2021 05:02:13 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <netdev@vger.kernel.org>, <stephen@networkplumber.org>,
        <dsahern@kernel.org>
CC:     Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH iproute2-next RESEND] devlink: Extend man page for port function set command
Date:   Fri, 22 Jan 2021 07:02:00 +0200
Message-ID: <20210122050200.207247-1-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201130164712.571540-1-parav@nvidia.com>
References: <20201130164712.571540-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611291734; bh=//MbXbg2hK+ciij/PwLU77XTyvmCuDFOMbfTwaNTbaE=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=UPvxgf3OwyQ8WkY0uVxGWzuZMLBpRfdEZaYa0+Im80VtfteoJBfN03AkEiomZhjiD
         94OCbFJB2k/1MTVJiZ/vKhdWiT1v/tWi69im+P7c+5AQI0yb9fW1ITUKMDJHWRkp/E
         amEU8c44wTlMGVwGx4sMAeHPUWSjz9ZdtQAo7O4fUgcnFvHUCHcCUBF6Wm2GOjFIpD
         cCgYn2bZyv1nYi/1szY5OR4fs3tRR9OsFQrqyGs20KHtq808blF4w4e8JSNp7AujNO
         DS5/a0FPyEWzdi8j2vJu9gRLUui2caBJjL7v5vPZYGmZiiKyvdHSggzKqvhZdFH1wK
         5r0RfjNSmDVzg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extended devlink-port man page for synopsis, description and
example for setting devlink port function attribute.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 man/man8/devlink-port.8 | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/man/man8/devlink-port.8 b/man/man8/devlink-port.8
index 966faae6..7e2dc110 100644
--- a/man/man8/devlink-port.8
+++ b/man/man8/devlink-port.8
@@ -46,6 +46,12 @@ devlink-port \- devlink port configuration
 .ti -8
 .B devlink port help
=20
+.ti -8
+.BR "devlink port function set "
+.RI "[ "
+.BR "hw_addr "
+.RI "ADDR ]"
+
 .SH "DESCRIPTION"
 .SS devlink port set - change devlink port attributes
=20
@@ -99,6 +105,16 @@ If this argument is omitted all ports are listed.
 Is an alias for
 .BR devlink-health (8).
=20
+.SS devlink port function set - Set the port function attribute.
+
+.PP
+.B "DEV/PORT_INDEX"
+- specifies the devlink port to operate on.
+
+.PP
+.BI hw_addr " ADDR"
+- hardware address of the function to set.
+
 .SH "EXAMPLES"
 .PP
 devlink port show
@@ -135,6 +151,11 @@ devlink port health show pci/0000:01:00.0/1 reporter t=
x
 .RS 4
 Shows status and configuration of tx reporter registered on pci/0000:01:00=
.0/1 devlink port.
 .RE
+.PP
+devlink port function set pci/0000:01:00.0/1 hw_addr 00:00:00:11:22:33
+.RS 4
+Configure hardware address of the PCI function represented by devlink port=
.
+.RE
=20
 .SH SEE ALSO
 .BR devlink (8),
--=20
2.26.2

