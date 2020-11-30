Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8395A2C89E6
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 17:49:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728963AbgK3QsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 11:48:17 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:17817 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725859AbgK3QsR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 11:48:17 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fc522250002>; Mon, 30 Nov 2020 08:47:33 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 30 Nov
 2020 16:47:36 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <netdev@vger.kernel.org>, <stephen@networkplumber.org>,
        <dsahern@kernel.org>
CC:     Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH iproute2-next] devlink: Extend man page for port function set command
Date:   Mon, 30 Nov 2020 18:47:12 +0200
Message-ID: <20201130164712.571540-1-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606754853; bh=//MbXbg2hK+ciij/PwLU77XTyvmCuDFOMbfTwaNTbaE=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
         Content-Transfer-Encoding:Content-Type:X-Originating-IP:
         X-ClientProxiedBy;
        b=rbfuMN9DCyqrIUV7zc5akEwSq9RdlkcPW7b3Eu9FcbWw+ArO97BCTTETWNtv5mCsI
         aE2UCpoOmyOwBVPS5wbUkbdLZJpY2BuCY03MAqqrS640wUEG7mOHnUnBJQIbgQSZKS
         D1TiKYUzO2ioPyVvWMmmYEn67Hx98I8P3G5+48d2ayLE9QGeEXglLA+vME/f94WUxi
         Kwcw7YsGKsab4ATNt5XzcpnRfwu8cV3/z3wZTnBOpj4BLMc9NGidtPFCr+8msLDorb
         T9vMyDqT40SriKB0pp9Y+uxEnEg66Xil6gw7CYxeDwQKNq5kB2GM7gkXZeZO34K/be
         R0rDuXMPxjVVg==
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

