Return-Path: <netdev+bounces-5417-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9338F711359
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 20:12:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3E8F62815D6
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 18:12:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5738423C62;
	Thu, 25 May 2023 18:11:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CC542261D
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 18:11:12 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B42D5D8
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 11:11:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1685038269; x=1716574269;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=6+QWEVz4aCT5UwKze9znK07ssiPNqha49g+7PmmsCPU=;
  b=aHdhEMmd3NmOYuyOngZHGzVMcbJ8+s2Jrg/YjEKJFJ5UDF+WLNIzk+0q
   WEgLm4bCsZHAdRAWxXoJTclI3a0wg/oVnkr3RBbLc0Nonp+IvEN7Du9+S
   xHhbjxYbUX+lzzo+ZIEUFWZnjkqkpC1PQg+NjaOa4O8Q14Gm4e39o4ZTK
   IppbSx69Q0jmBv48ugm3ob+/rEhRkm46rShT6KBJ+ma8qOjdYkN4XcVkJ
   rwO8L+wY/9QVeab5N+HT2ra6AwTxfwvUpxzXVXu/QhVOYjFBYB4wIHijS
   OLgOpJzOI4Ig9jmVJhk0JBD9LxfSsXxakmtq7pGnClWqUnxjGY2Dxo0kc
   w==;
X-IronPort-AV: E=Sophos;i="6.00,191,1681196400"; 
   d="scan'208";a="227026000"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 May 2023 11:11:09 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 25 May 2023 11:11:09 -0700
Received: from [10.205.21.38] (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Thu, 25 May 2023 11:11:07 -0700
From: Daniel Machon <daniel.machon@microchip.com>
Date: Thu, 25 May 2023 20:10:26 +0200
Subject: [PATCH iproute2-next v2 6/8] man: dcb-rewr: add new manpage for
 dcb-rewr
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20230510-dcb-rewr-v2-6-9f38e688117e@microchip.com>
References: <20230510-dcb-rewr-v2-0-9f38e688117e@microchip.com>
In-Reply-To: <20230510-dcb-rewr-v2-0-9f38e688117e@microchip.com>
To: <netdev@vger.kernel.org>
CC: <dsahern@kernel.org>, <stephen@networkplumber.org>, <petrm@nvidia.com>,
	<UNGLinuxDriver@microchip.com>, <daniel.machon@microchip.com>
X-Mailer: b4 0.12.2
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add a new manpage for dcb-rewr. Most of the content is copied over from
dcb-app, as the same set of commands and parameters (in reverse) applies
to dcb-rewr.

Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
---
 man/man8/dcb-rewr.8 | 206 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 206 insertions(+)

diff --git a/man/man8/dcb-rewr.8 b/man/man8/dcb-rewr.8
new file mode 100644
index 000000000000..03b59cf4837c
--- /dev/null
+++ b/man/man8/dcb-rewr.8
@@ -0,0 +1,206 @@
+.TH DCB-REWR 8 "15 may 2023" "iproute2" "Linux"
+.SH NAME
+dcb-rewr \- show / manipulate the rewrite table of
+the DCB (Data Center Bridging) subsystem
+.SH SYNOPSIS
+.sp
+.ad l
+.in +8
+
+.ti -8
+.B dcb
+.RI "[ " OPTIONS " ] "
+.B rewr
+.RI "{ " COMMAND " | " help " }"
+.sp
+
+.ti -8
+.B dcb rewr " { " show " | " flush " } " dev
+.RI DEV
+.RB "[ " prio-dscp " ]"
+.RB "[ " prio-pcp " ]"
+
+.ti -8
+.B dcb rewr " { " add " | " del " | " replace " } " dev
+.RI DEV
+.RB "[ " prio-dscp " " \fIDSCP-MAP\fB " ]"
+.RB "[ " prio-pcp " " \fIPCP-MAP\fB " ]"
+
+.ti -8
+.IR DSCP-MAP " := [ " DSCP-MAP " ] " DSCP-MAPPING
+
+.ti -8
+.IR DSCP-MAPPING " := " \fIPRIO \fB:\fR "{ " DSCP " | " \fBall\fR " }"
+
+.ti -8
+.IR PCP-MAP " := [ " PCP-MAP " ] " PCP-MAPPING
+
+.ti -8
+.IR PCP-MAPPING " := " \fIPRIO \fB:\fR PCP\fR
+
+.ti -8
+.IR DSCP " := { " \fB0\fR " .. " \fB63\fR " }"
+
+.ti -8
+.IR PCP " := { " \fB0(nd/de)\fR " .. " \fB7(nd/de)\fR " }"
+
+.ti -8
+.IR PRIO " := { " \fB0\fR " .. " \fB7\fR " }"
+
+.SH DESCRIPTION
+
+.B dcb rewr
+is used to configure the rewrite table, in the DCB (Data Center Bridging)
+subsystem.  The rewrite table is used to rewrite certain values in the packet
+headers, based on packet priority.
+
+DCB rewrite entries are, like DCB APP entries, 3-tuples of selector, protocol
+ID, and priority. Selector is an enumeration that picks one of the
+prioritization namespaces. Currently, only the DSCP and PCP selector namespaces
+are supported by dcb rewr.
+
+The rewrite table is a list of DCB rewrite rules, that applies to packets
+with matching priority.  Notably, it is valid to have conflicting rewrite
+assignment for the same selector and priority. For example, the set of two
+rewrite entries (DSCP, 10, 1) and (DSCP, 11, 1), where packets with priority 1
+should have its DSCP value rewritten to both 10 and 11, form a well-defined
+rewrite table.
+.B dcb rewr
+tool allows low-level management of the rewrite table by adding and deleting
+individual rewrite 3-tuples through
+.B add
+and
+.B del
+commands. On the other hand, the command
+.B replace
+does what one would typically want in this situation--first adds the new
+configuration, and then removes the obsolete one, so that only one
+rewrite rule is in effect for a given selector and priority.
+
+.SH COMMANDS
+
+.TP
+.B show
+Display all entries with a given selector. When no selector is given, shows all
+rewrite table entries categorized per selector.
+
+.TP
+.B flush
+Remove all entries with a given selector. When no selector is given, removes all
+rewrite table entries.
+
+.TP
+.B add
+.TQ
+.B del
+Add and, respectively, remove individual rewrite 3-tuples to and from the DCB
+rewrite table.
+
+.TP
+.B replace
+Take the list of entries mentioned as parameter, and add those that are not
+present in the rewrite table yet. Then remove those entries, whose selector and
+priority have been mentioned as parameter, but not with the exact same
+protocol ID. This has the effect of, for the given selector and priority,
+causing that the table only contains the protocol ID (or ID's) given as
+parameter.
+
+.SH PARAMETERS
+
+The following table shows parameters in a way that they would be used with
+\fBadd\fR, \fBdel\fR and \fBreplace\fR commands. For \fBshow\fR and
+\fBflush\fR, the parameter name is to be used as a simple keyword without
+further arguments.
+
+.TP
+.B prio-dscp \fIDSCP-MAP
+\fIDSCP-MAP\fR uses the array parameter syntax, see
+.BR dcb (8)
+for details. Keys are priorities, values are DSCP points for traffic
+with matching priority. DSCP points can be written either directly as numeric
+values, or using symbolic names specified in
+.B /etc/iproute2/rt_dsfield
+(however note that the file specifies full 8-bit dsfield values, whereas
+.B dcb rewr
+will only use the higher six bits).
+.B dcb rewr show
+will similarly format DSCP values as symbolic names if possible. The
+command line option
+.B -N
+turns the show translation off.
+
+.TP
+.B prio-pcp \fIPCP-MAP
+\fIPCP-MAP\fR uses the array parameter syntax, see
+.BR dcb (8)
+for details. Keys are priorities. Values are PCP/DEI for traffic with
+matching priority. PCP/DEI values are written as a combination of numeric- and
+symbolic values, to accommodate for both. PCP always in numeric form e.g 0 ..
+7 and DEI in symbolic form e.g 'de' (drop-eligible), indicating that the DEI
+bit is 1 or 'nd' (not-drop-eligible), indicating that the DEI bit is 0.  In
+combination 1:2de translates to a mapping of priority 1 to PCP=2 and DEI=1.
+
+.SH EXAMPLE & USAGE
+
+Add a rule to rewrite DSCP to 0, 24 and 48 for traffic with priority 0, 3 and
+6, respectively:
+.P
+# dcb rewr add dev eth0 prio-dscp 0:0 3:24 6:48
+
+Add a rule to rewrite DSCP to 25 for traffic with priority 3:
+.P
+# dcb rewr add dev eth0 prio-dscp 3:25
+.br
+# dcb rewr show dev eth0 prio-dscp
+.br
+prio-dscp 0:0 3:CS3 3:25 6:CS6
+.br
+# dcb -N rewr show dev eth0 prio-dscp
+.br
+prio-dscp 0:0 3:24 3:25 6:48
+
+Reconfigure the table so that only one rule exists for rewriting traffic with
+priority 3.
+
+.P
+# dcb rewr replace dev eth0 prio-dscp 3:26
+.br
+# dcb rewr -N show dev eth0 prio-dscp
+.br
+prio-dscp 0:0 3:26 6:48
+
+Flush all DSCP rules:
+
+.P
+# dcb rewr flush dev eth0 prio-dscp
+.br
+# dcb rewr show dev eth0 prio-dscp
+.br
+(nothing)
+
+Add a rule to rewrite PCP to 1 and DEI to 0 for traffic with priority 1 and a
+rule to rewrite PCP to 2 and DEI to 1 for traffic with priority 2:
+
+.P
+# dcb rewr add dev eth0 prio-pcp 1:1nd 2:2de
+.br
+# dcb rewr show dev eth0 prio-pcp
+.br
+prio-pcp 1:1nd 2:2de
+
+.SH EXIT STATUS
+Exit status is 0 if command was successful or a positive integer upon failure.
+
+.SH SEE ALSO
+.BR dcb (8)
+.BR dcb-app (8)
+.BR dcb-apptrust (8)
+
+.SH REPORTING BUGS
+Report any bugs to the Network Developers mailing list
+.B <netdev@vger.kernel.org>
+where the development and maintenance is primarily done.  You do not have to be
+subscribed to the list to send a message there.
+
+.SH AUTHOR
+Daniel Machon <daniel.machon@microchip.com>

-- 
2.34.1


