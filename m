Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B1C020CAFC
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 00:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726399AbgF1Wq3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jun 2020 18:46:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgF1Wq3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jun 2020 18:46:29 -0400
Received: from inpost.hi.is (inpost.hi.is [IPv6:2a00:c88:4000:1650::165:62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01823C03E979
        for <netdev@vger.kernel.org>; Sun, 28 Jun 2020 15:46:28 -0700 (PDT)
Received: from hekla.rhi.hi.is (hekla.rhi.hi.is [IPv6:2a00:c88:4000:1650::165:2])
        by inpost.hi.is (8.14.7/8.14.7) with ESMTP id 05SMkQk5002325
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
        for <netdev@vger.kernel.org>; Sun, 28 Jun 2020 22:46:27 GMT
DKIM-Filter: OpenDKIM Filter v2.11.0 inpost.hi.is 05SMkQk5002325
Received: from hekla.rhi.hi.is (localhost [127.0.0.1])
        by hekla.rhi.hi.is (8.14.4/8.14.4) with ESMTP id 05SMkQMi013122
        for <netdev@vger.kernel.org>; Sun, 28 Jun 2020 22:46:26 GMT
Received: (from bjarniig@localhost)
        by hekla.rhi.hi.is (8.14.4/8.14.4/Submit) id 05SMkQ9c013121
        for netdev@vger.kernel.org; Sun, 28 Jun 2020 22:46:26 GMT
Date:   Sun, 28 Jun 2020 22:46:26 +0000
From:   Bjarni Ingi Gislason <bjarniig@rhi.hi.is>
To:     netdev@vger.kernel.org
Subject: [PATCH] man8/bridge.8: fix misuse of two-fonts macros
Message-ID: <20200628224626.GA13050@rhi.hi.is>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  Use a single-font macro for a single argument.

Signed-off-by: Bjarni Ingi Gislason <bjarniig@rhi.hi.is>
---
 man/man8/bridge.8 | 39 +++++++++++++++++++--------------------
 1 file changed, 19 insertions(+), 20 deletions(-)

diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index fa8c0049..ad05cd7c 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -28,10 +28,9 @@ bridge \- show / manipulate bridge addresses and devices
 \fB\-o\fR[\fIneline\fr] }
 
 .ti -8
-.BR "bridge link set"
+.B "bridge link set"
 .B dev
-.IR DEV
-.IR " [ "
+.IR DEV " [ "
 .B cost
 .IR COST " ] [ "
 .B priority
@@ -108,9 +107,9 @@ bridge \- show / manipulate bridge addresses and devices
 .ti -8
 .BR "bridge mdb" " { " add " | " del " } "
 .B dev
-.IR DEV
+.I DEV
 .B port
-.IR PORT
+.I PORT
 .B grp
 .IR GROUP " [ "
 .BR permanent " | " temp " ] [ "
@@ -125,10 +124,10 @@ bridge \- show / manipulate bridge addresses and devices
 .ti -8
 .BR "bridge vlan" " { " add " | " del " } "
 .B dev
-.IR DEV
+.I DEV
 .B vid
 .IR VID " [ "
-.BR tunnel_info
+.B tunnel_info
 .IR TUNNEL_ID " ] [ "
 .BR pvid " ] [ " untagged " ] [ "
 .BR self " ] [ " master " ] "
@@ -168,7 +167,7 @@ to the specified network namespace
 Actually it just simplifies executing of:
 
 .B ip netns exec
-.IR NETNS
+.I NETNS
 .B bridge
 .RI "[ " OPTIONS " ] " OBJECT " { " COMMAND " | "
 .BR help " }"
@@ -185,7 +184,7 @@ Read commands from provided file or standard input and invoke them.
 First failure will cause termination of bridge command.
 
 .TP
-.BR "\-force"
+.B "\-force"
 Don't terminate bridge command on errors in batch mode.
 If there were any errors during execution of the commands, the application
 return code will be non zero.
@@ -395,7 +394,7 @@ bridge FDB.
 Controls whether a given port will flood unicast traffic for which there is no FDB entry. By default this flag is on.
 
 .TP
-.BI hwmode
+.B hwmode
 Some network interface cards support HW bridge functionality and they may be
 configured in different modes. Currently support modes are:
 
@@ -419,7 +418,7 @@ instead of multicast. By default this flag is off.
 This is done by copying the packet per host and
 changing the multicast destination MAC to a unicast one accordingly.
 
-.BR mcast_to_unicast
+.B mcast_to_unicast
 works on top of the multicast snooping feature of
 the bridge. Which means unicast copies are only delivered to hosts which
 are interested in it and signalized this via IGMP/MLD reports
@@ -464,15 +463,15 @@ If the port loses carrier all traffic will be redirected to the
 configured backup port
 
 .TP
-.BR nobackup_port
+.B nobackup_port
 Removes the currently configured backup port
 
 .TP
-.BI self
+.B self
 link setting is configured on specified physical device
 
 .TP
-.BI master
+.B master
 link setting is configured on the software bridge (default)
 
 .TP
@@ -501,7 +500,7 @@ and delete old ones.
 This command creates a new fdb entry.
 
 .TP
-.BI "LLADDR"
+.B LLADDR
 the Ethernet MAC address.
 
 .TP
@@ -633,7 +632,7 @@ and last used time for each entry.
 lookup a bridge forwarding table entry.
 
 .TP
-.BI "LLADDR"
+.B LLADDR
 the Ethernet MAC address.
 
 .TP
@@ -757,21 +756,21 @@ dst_metadata for every packet that belongs to this vlan (applicable to
 bridge ports with vlan_tunnel flag set).
 
 .TP
-.BI pvid
+.B pvid
 the vlan specified is to be considered a PVID at ingress.
 Any untagged frames will be assigned to this VLAN.
 
 .TP
-.BI untagged
+.B untagged
 the vlan specified is to be treated as untagged on egress.
 
 .TP
-.BI self
+.B self
 the vlan is configured on the specified physical device. Required if the
 device is the bridge device.
 
 .TP
-.BI master
+.B master
 the vlan is configured on the software bridge (default).
 
 .SS bridge vlan delete - delete a vlan filter entry
-- 
2.27.0
