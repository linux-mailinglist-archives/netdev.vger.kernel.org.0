Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6828B8B287
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 10:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728221AbfHMIcT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 04:32:19 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:50545 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728218AbfHMIcS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 04:32:18 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 3B63121FA7;
        Tue, 13 Aug 2019 04:32:17 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 13 Aug 2019 04:32:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=3UUPlgJW82yNKTSse1GLnKEOLmUEo7zaaM5euBJtAjM=; b=PfZX0k/L
        6MKYZsKcN6sHmuE1LmXd/sOohOV4Ij/W+MmFb8slzO3Q1SKferwZiZmz/3uLMqck
        8bgwcJ9abeQ+rniPtlCp/iyntie25OYdz7qA13tdD6dVufCLpto9SI7CqCGGvKeu
        9zxt/WoIgFouEDL9ejMwUPUawSlxdXVAuoHCIRxLlAMCzD32+MZeNUsrODH5SXge
        njdHnFe1b0uGRF9jyewfoN4lGj4DdRBCVJIrX+k3ov4ZIqHl2yXRUk+RCXs5zggq
        p0jwV8/ValDqE8Ilph5UEdECA0gstdhkRRngoaXIaNT55heKoTVSVRxkcDtg5uuo
        9/Jc6clhXI+3Pw==
X-ME-Sender: <xms:kXVSXfW2XUf-0GChTun94CSAllnlGmqxSwVXFdWM8uAMvhegTmiFSA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddviedgtddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedu
X-ME-Proxy: <xmx:kXVSXUR_FiLPUQblF5lf37MA2iTgYvUAapqeg1ATgRkx2ObT2VI7yw>
    <xmx:kXVSXb269QNmdJ_28QY4L4RtpQvfA9MaRWA2_HsIRNqHa13PGnXyzg>
    <xmx:kXVSXQ5s3uWvEyY9cvyZ6qEg3c1QeWj0vFyhpque460bE9qaHRIVDA>
    <xmx:kXVSXQVDHlYEieELmqlmuX4ySZUyQPS3RPW-CuChiuUyFvzHlTpmdQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id A7B728005C;
        Tue, 13 Aug 2019 04:32:15 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH iproute2-next v2 4/4] devlink: Add man page for devlink-trap
Date:   Tue, 13 Aug 2019 11:31:43 +0300
Message-Id: <20190813083143.13509-5-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190813083143.13509-1-idosch@idosch.org>
References: <20190813083143.13509-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 man/man8/devlink-monitor.8 |   3 +-
 man/man8/devlink-trap.8    | 138 +++++++++++++++++++++++++++++++++++++
 man/man8/devlink.8         |  11 ++-
 3 files changed, 150 insertions(+), 2 deletions(-)
 create mode 100644 man/man8/devlink-trap.8

diff --git a/man/man8/devlink-monitor.8 b/man/man8/devlink-monitor.8
index 13fe641dc8f5..fffab3a4ce88 100644
--- a/man/man8/devlink-monitor.8
+++ b/man/man8/devlink-monitor.8
@@ -21,7 +21,7 @@ command is the first in the command line and then the object list.
 .I OBJECT-LIST
 is the list of object types that we want to monitor.
 It may contain
-.BR dev ", " port ".
+.BR dev ", " port ", " trap ", " trap-group .
 
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
index 000000000000..4f079eb86d7b
--- /dev/null
+++ b/man/man8/devlink-trap.8
@@ -0,0 +1,138 @@
+.TH DEVLINK\-TRAP 8 "2 August 2019" "iproute2" "Linux"
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
2.21.0

