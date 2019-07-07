Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D8996145E
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 10:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727339AbfGGICu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 04:02:50 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:41677 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727259AbfGGICu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 04:02:50 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 3CC181D07;
        Sun,  7 Jul 2019 04:02:49 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 07 Jul 2019 04:02:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=RO0/hDQ3OxHfEx7QvDLJIJtC6pIo2/aOj9yjk4fd74s=; b=M08+tLwk
        N3RvQ4N5r0IQYnXGECG6Jvph+8Swf/sVxk3924/WSvFF2p01Bfnju3O6/8Ez/izn
        3v4DlJAgLbFm2mog2HemeWjrkI8ho+ySUQnbLDnGcHbUjOcODlNVg/AmxXiQaGCE
        JH8JOyBidGnx4fua2fRo81PE9ImXO2vbM9fvlfhSQ9LSqwOdviVjxM/nM9txe0WO
        99Qi0TXIdaKlrRfTT4Gc91k8y2Kbuey3M3tdrVNYjVjEisl4tRNGpcgn/90PS5DW
        ZTld64O1Ci1lKDcg/ieUSnFPE3mawgrZBw+nKEsoHeIsjonZ+3Ihxjrt0RXxqUZs
        STmKTcheLDxhtg==
X-ME-Sender: <xms:KKchXdXBbNnEOSb5yTk_DiBWAFxju_m-Vu1P17DPc8cGycX8fjOpIA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrfeejgdduvdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:KachXR3b9FDGJoTrJhxHSPDldaplaMZmUmb_iw5bvg4qcyTuiDKQDA>
    <xmx:KachXUZGhFu7y4eva__65LWsuFmns_i8PXpp5gEbm4DpO0VYaSKy7Q>
    <xmx:KachXUrZ-1lD7dhVjwOv3hXAFHX2ORoKzJpkwsQ4T_hP7VlQuh4zdg>
    <xmx:KachXfvW5QsVoj4sIikjFcyQ-Dtrvo_-69mMZ3QCcNv7CWq2vAcb8A>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 77B388005C;
        Sun,  7 Jul 2019 04:02:46 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, andy@greyhouse.net,
        pablo@netfilter.org, jakub.kicinski@netronome.com,
        pieter.jansenvanvuuren@netronome.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH iproute2-next 7/7] devlink: Add man page for devlink-trap
Date:   Sun,  7 Jul 2019 11:02:00 +0300
Message-Id: <20190707080200.3699-8-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190707080200.3699-1-idosch@idosch.org>
References: <20190707075828.3315-1-idosch@idosch.org>
 <20190707080200.3699-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 man/man8/devlink-monitor.8 |   3 +-
 man/man8/devlink-trap.8    | 166 +++++++++++++++++++++++++++++++++++++
 man/man8/devlink.8         |  11 ++-
 3 files changed, 178 insertions(+), 2 deletions(-)
 create mode 100644 man/man8/devlink-trap.8

diff --git a/man/man8/devlink-monitor.8 b/man/man8/devlink-monitor.8
index 13fe641dc8f5..84f0442aa272 100644
--- a/man/man8/devlink-monitor.8
+++ b/man/man8/devlink-monitor.8
@@ -21,7 +21,7 @@ command is the first in the command line and then the object list.
 .I OBJECT-LIST
 is the list of object types that we want to monitor.
 It may contain
-.BR dev ", " port ".
+.BR dev ", " port ", " trap ", " trap-group ", " trap-report .
 
 .B devlink
 opens Devlink Netlink socket, listens on it and dumps state changes.
@@ -31,6 +31,7 @@ opens Devlink Netlink socket, listens on it and dumps state changes.
 .BR devlink-dev (8),
 .BR devlink-sb (8),
 .BR devlink-port (8),
+.BR devlink-trap (8),
 .br
 
 .SH AUTHOR
diff --git a/man/man8/devlink-trap.8 b/man/man8/devlink-trap.8
new file mode 100644
index 000000000000..8877df484749
--- /dev/null
+++ b/man/man8/devlink-trap.8
@@ -0,0 +1,166 @@
+.TH DEVLINK\-TRAP 8 "11 June 2019" "iproute2" "Linux"
+.SH NAME
+devlink-trap \- devlink trap configuration
+.SH SYNOPSIS
+.sp
+.ad l
+.in +8
+.ti -8
+.B devlink
+.RI "[ " OPTIONS " ]"
+.B trap
+.RI "{ " COMMAND " |"
+.BR help " }"
+.sp
+
+.ti -8
+.IR OPTIONS " := { "
+\fB\-v\fR[\fIerbose\fR] |
+\fB\-s\fR[\fItatistics\fR] }
+
+.ti -8
+.B "devlink trap show"
+.RI "[ " DEV
+.B trap
+.IR TRAP " ]"
+
+.ti -8
+.BI "devlink trap set " DEV " trap " TRAP
+.RB "[ " report " { " true " | " false " } ]"
+.br
+.RB "[ " action " { " trap " | " drop " } ]"
+
+.ti -8
+.B "devlink trap group show"
+.RI "[ " DEV
+.B group
+.IR GROUP " ]"
+
+.ti -8
+.BI "devlink trap group set " DEV " group " GROUP
+.RB "[ " report " { " true " | " false " } ]"
+.br
+.RB "[ " action " { " trap " | " drop " } ]"
+
+.ti -8
+.B devlink trap help
+
+.SH "DESCRIPTION"
+.SS devlink trap show - display available packet traps and their attributes
+
+.PP
+.I "DEV"
+- specifies the devlink device from which to show packet traps.
+If this argument is omitted all packet traps of all devices are listed.
+
+.PP
+.BI "trap " TRAP
+- specifies the packet trap.
+Only applicable if a devlink device is also specified.
+
+.SS devlink trap set - set attributes of a packet trap
+
+.PP
+.I "DEV"
+- specifies the devlink device the packet trap belongs to.
+
+.PP
+.BI "trap " TRAP
+- specifies the packet trap.
+
+.TP
+.BR report " { " true " | " false " } "
+whether to report trapped packets to user space or not.
+
+.TP
+.BR action " { " trap " | " drop " } "
+packet trap action.
+
+.I trap
+- the sole copy of the packet is sent to the CPU.
+
+.I drop
+- the packet is dropped by the underlying device and a copy is not sent to the CPU.
+
+.SS devlink trap group show - display available packet trap groups and their attributes
+
+.PP
+.I "DEV"
+- specifies the devlink device from which to show packet trap groups.
+If this argument is omitted all packet trap groups of all devices are listed.
+
+.PP
+.BI "group " GROUP
+- specifies the packet trap group.
+Only applicable if a devlink device is also specified.
+
+.SS devlink trap group set - set attributes of a packet trap group
+
+.PP
+.I "DEV"
+- specifies the devlink device the packet trap group belongs to.
+
+.PP
+.BI "group " GROUP
+- specifies the packet trap group.
+
+.TP
+.BR report " { " true " | " false " } "
+whether to report trapped packets from traps member in the trap group to user
+space or not.
+
+.TP
+.BR action " { " trap " | " drop " } "
+packet trap action. The action is set for all the packet traps member in the
+trap group. The actions of non-drop traps cannot be changed and are thus
+skipped.
+
+.SH "EXAMPLES"
+.PP
+devlink trap show
+.RS 4
+List available packet traps.
+.RE
+.PP
+devlink trap group show
+.RS 4
+List available packet trap groups.
+.RE
+.PP
+devlink -vs trap show pci/0000:01:00.0 trap source_mac_is_multicast
+.RS 4
+Show attributes and statistics of a specific packet trap.
+.RE
+.PP
+devlink -s trap group show pci/0000:01:00.0 group l2_drops
+.RS 4
+Show attributes and statistics of a specific packet trap group.
+.RE
+.PP
+devlink trap set pci/0000:01:00.0 trap source_mac_is_multicast action trap
+.RS 4
+Set the action of a specific packet trap to 'trap'.
+.RE
+.PP
+devlink trap set pci/0000:01:00.0 trap source_mac_is_multicast report true
+.RS 4
+Set the report status a specific packet trap to 'true'.
+.RE
+.PP
+devlink trap group set pci/0000:01:00.0 group l2_drops report true
+.RS 4
+Set the report status a specific packet trap group to 'true'.
+.RE
+.PP
+devlink -v monitor trap-report
+.RS 4
+Monitor trapped packets.
+
+.SH SEE ALSO
+.BR devlink (8),
+.BR devlink-dev (8),
+.BR devlink-monitor (8),
+.br
+
+.SH AUTHOR
+Ido Schimmel <idosch@mellanox.com>
diff --git a/man/man8/devlink.8 b/man/man8/devlink.8
index 13d4dcd908b3..12d489440a3d 100644
--- a/man/man8/devlink.8
+++ b/man/man8/devlink.8
@@ -7,7 +7,7 @@ devlink \- Devlink tool
 .in +8
 .ti -8
 .B devlink
-.RI "[ " OPTIONS " ] { " dev | port | monitor | sb | resource | region | health " } { " COMMAND " | "
+.RI "[ " OPTIONS " ] { " dev | port | monitor | sb | resource | region | health | trap " } { " COMMAND " | "
 .BR help " }"
 .sp
 
@@ -51,6 +51,10 @@ When combined with -j generate a pretty JSON output.
 .BR "\-v" , " --verbose"
 Turn on verbose output.
 
+.TP
+.BR "\-s" , " --statistics"
+Output statistics.
+
 .SS
 .I OBJECT
 
@@ -82,6 +86,10 @@ Turn on verbose output.
 .B health
 - devlink reporting and recovery
 
+.TP
+.B trap
+- devlink trap configuration
+
 .SS
 .I COMMAND
 
@@ -114,6 +122,7 @@ Exit status is 0 if command was successful or a positive integer upon failure.
 .BR devlink-resource (8),
 .BR devlink-region (8),
 .BR devlink-health (8),
+.BR devlink-trap (8),
 .br
 
 .SH REPORTING BUGS
-- 
2.20.1

