Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A9A34227BF
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 15:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234909AbhJEN3B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 09:29:01 -0400
Received: from smtp-8fae.mail.infomaniak.ch ([83.166.143.174]:39629 "EHLO
        smtp-8fae.mail.infomaniak.ch" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234103AbhJEN3A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 09:29:00 -0400
X-Greylist: delayed 446 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Oct 2021 09:29:00 EDT
Received: from smtp-2-0000.mail.infomaniak.ch (unknown [10.5.36.107])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4HNyqH6tm3zMq6pZ;
        Tue,  5 Oct 2021 15:19:39 +0200 (CEST)
Received: from [IPv6:2001:1600:0:cccc:e000::68] (unknown [IPV6:2001:1600:0:cccc:e000::68])
        by smtp-2-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4HNyqH37JgzlhP4p;
        Tue,  5 Oct 2021 15:19:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=infomaniak.com;
        s=s1024; t=1633439979;
        bh=2bUZ/I7uU4fVXq1akyiTcFutQC5eVAAE+SxP0BrMIcs=;
        h=From:Subject:To:Cc:Date:From;
        b=Bil1GM0+42mcbXnYSYxKzthD/0eF8kcKy2L0ijwF2eZpv6IBIdQW0CmTJe+QZt7pv
         wy3LI/mf9ST2aZ2taJOtkncJa1HPs8cjpo/bzGUWd8hXzMK4L20aokbVksvN33Iq6a
         JsR9fWAo17RoR0LLa2yra4c0sfmljsLVK0soXnBE=
From:   Frank Villaro-Dixon <frank.villaro@infomaniak.com>
Subject: [PATCH iproute2] cmd: use spaces instead of tabs for usage
 indentation
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        frank.villaro@infomaniak.com
Organization: =?UTF-8?B?8J+Suw==?=
Message-ID: <774a7d49-a49b-6dcd-f3e6-ffb09919fe8c@infomaniak.com>
Date:   Tue, 5 Oct 2021 15:19:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Frank Villaro-Dixon <frank.villaro@infomaniak.com>

Fix rogue "tab after spaces" used for indentation of the documentation.
This causes rendering issues on terminals using a non-standard tab width.

Signed-off-by: Frank Villaro-Dixon <frank.villaro@infomaniak.com>
---
 bridge/bridge.c |  8 ++++----
 ip/ipmroute.c   |  4 ++--
 ip/ipneigh.c    | 11 ++++++-----
 ip/ipntable.c   | 12 ++++++------
 ip/iproute.c    |  2 +-
 ip/ipseg6.c     |  8 ++++----
 ip/iptunnel.c   | 22 +++++++++++-----------
 ip/iptuntap.c   |  8 ++++----
 ip/rtmon.c      |  2 +-
 misc/nstat.c    | 22 +++++++++++-----------
 10 files changed, 50 insertions(+), 49 deletions(-)

diff --git a/bridge/bridge.c b/bridge/bridge.c
index 48b0e7f846f6..f3a4f08ff5f3 100644
--- a/bridge/bridge.c
+++ b/bridge/bridge.c
@@ -37,10 +37,10 @@ static void usage(void)
 	fprintf(stderr,
 "Usage: bridge [ OPTIONS ] OBJECT { COMMAND | help }\n"
 "       bridge [ -force ] -batch filename\n"
-"where	OBJECT := { link | fdb | mdb | vlan | monitor }\n"
-"	OPTIONS := { -V[ersion] | -s[tatistics] | -d[etails] |\n"
-"		     -o[neline] | -t[imestamp] | -n[etns] name |\n"
-"		     -c[ompressvlans] -color -p[retty] -j[son] }\n");
+"where  OBJECT := { link | fdb | mdb | vlan | monitor }\n"
+"       OPTIONS := { -V[ersion] | -s[tatistics] | -d[etails] |\n"
+"                    -o[neline] | -t[imestamp] | -n[etns] name |\n"
+"                    -c[ompressvlans] -color -p[retty] -j[son] }\n");
 	exit(-1);
 }
 
diff --git a/ip/ipmroute.c b/ip/ipmroute.c
index 656ea0dc3483..981baf2acd94 100644
--- a/ip/ipmroute.c
+++ b/ip/ipmroute.c
@@ -37,8 +37,8 @@ static void usage(void)
 {
 	fprintf(stderr,
 		"Usage: ip mroute show [ [ to ] PREFIX ] [ from PREFIX ] [ iif DEVICE ]\n"
-	"			[ table TABLE_ID ]\n"
-	"TABLE_ID := [ local | main | default | all | NUMBER ]\n"
+		"                      [ table TABLE_ID ]\n"
+		"TABLE_ID := [ local | main | default | all | NUMBER ]\n"
 #if 0
 	"Usage: ip mroute [ add | del ] DESTINATION from SOURCE [ iif DEVICE ] [ oif DEVICE ]\n"
 #endif
diff --git a/ip/ipneigh.c b/ip/ipneigh.c
index b778de00b242..4db776d75f75 100644
--- a/ip/ipneigh.c
+++ b/ip/ipneigh.c
@@ -50,12 +50,13 @@ static void usage(void)
 {
 	fprintf(stderr,
 		"Usage: ip neigh { add | del | change | replace }\n"
-		"		{ ADDR [ lladdr LLADDR ] [ nud STATE ] proxy ADDR }\n"
-		"		[ dev DEV ] [ router ] [ extern_learn ] [ protocol PROTO ]\n"
+		"                { ADDR [ lladdr LLADDR ] [ nud STATE ] proxy ADDR }\n"
+		"                [ dev DEV ] [ router ] [ extern_learn ] [ protocol PROTO ]\n"
 		"\n"
-		"	ip neigh { show | flush } [ proxy ] [ to PREFIX ] [ dev DEV ] [ nud STATE ]\n"
-		"				  [ vrf NAME ]\n"
-		"	ip neigh get { ADDR | proxy ADDR } dev DEV\n"
+		"       ip neigh { show | flush } [ proxy ] [ to PREFIX ] [ dev DEV ] [ nud STATE ]\n"
+		"                                 [ vrf NAME ]\n"
+		"\n"
+		"       ip neigh get { ADDR | proxy ADDR } dev DEV\n"
 		"\n"
 		"STATE := { delay | failed | incomplete | noarp | none |\n"
 		"           permanent | probe | reachable | stale }\n");
diff --git a/ip/ipntable.c b/ip/ipntable.c
index b5b06a3b06fa..762c790d10fc 100644
--- a/ip/ipntable.c
+++ b/ip/ipntable.c
@@ -47,15 +47,15 @@ static void usage(void)
 {
 	fprintf(stderr,
 		"Usage: ip ntable change name NAME [ dev DEV ]\n"
-		"	 [ thresh1 VAL ] [ thresh2 VAL ] [ thresh3 VAL ] [ gc_int MSEC ]\n"
-		"	 [ PARMS ]\n"
+		"        [ thresh1 VAL ] [ thresh2 VAL ] [ thresh3 VAL ] [ gc_int MSEC ]\n"
+		"        [ PARMS ]\n"
 		"Usage: ip ntable show [ dev DEV ] [ name NAME ]\n"
 
 		"PARMS := [ base_reachable MSEC ] [ retrans MSEC ] [ gc_stale MSEC ]\n"
-		"	 [ delay_probe MSEC ] [ queue LEN ]\n"
-		"	 [ app_probes VAL ] [ ucast_probes VAL ] [ mcast_probes VAL ]\n"
-		"	 [ anycast_delay MSEC ] [ proxy_delay MSEC ] [ proxy_queue LEN ]\n"
-		"	 [ locktime MSEC ]\n"
+		"         [ delay_probe MSEC ] [ queue LEN ]\n"
+		"         [ app_probes VAL ] [ ucast_probes VAL ] [ mcast_probes VAL ]\n"
+		"         [ anycast_delay MSEC ] [ proxy_delay MSEC ] [ proxy_queue LEN ]\n"
+		"         [ locktime MSEC ]\n"
 		);
 
 	exit(-1);
diff --git a/ip/iproute.c b/ip/iproute.c
index 1e5e2002d2ed..9922cb044331 100644
--- a/ip/iproute.c
+++ b/ip/iproute.c
@@ -82,7 +82,7 @@ static void usage(void)
 		"             [ ttl-propagate { enabled | disabled } ]\n"
 		"INFO_SPEC := { NH | nhid ID } OPTIONS FLAGS [ nexthop NH ]...\n"
 		"NH := [ encap ENCAPTYPE ENCAPHDR ] [ via [ FAMILY ] ADDRESS ]\n"
-		"	    [ dev STRING ] [ weight NUMBER ] NHFLAGS\n"
+		"      [ dev STRING ] [ weight NUMBER ] NHFLAGS\n"
 		"FAMILY := [ inet | inet6 | mpls | bridge | link ]\n"
 		"OPTIONS := FLAGS [ mtu NUMBER ] [ advmss NUMBER ] [ as [ to ] ADDRESS ]\n"
 		"           [ rtt TIME ] [ rttvar TIME ] [ reordering NUMBER ]\n"
diff --git a/ip/ipseg6.c b/ip/ipseg6.c
index 56a76996a6ca..4f541ae4232c 100644
--- a/ip/ipseg6.c
+++ b/ip/ipseg6.c
@@ -34,10 +34,10 @@ static void usage(void)
 {
 	fprintf(stderr,
 		"Usage: ip sr { COMMAND | help }\n"
-		"	   ip sr hmac show\n"
-		"	   ip sr hmac set KEYID ALGO\n"
-		"	   ip sr tunsrc show\n"
-		"	   ip sr tunsrc set ADDRESS\n"
+		"          ip sr hmac show\n"
+		"          ip sr hmac set KEYID ALGO\n"
+		"          ip sr tunsrc show\n"
+		"          ip sr tunsrc set ADDRESS\n"
 		"where  ALGO := { sha1 | sha256 }\n");
 	exit(-1);
 }
diff --git a/ip/iptunnel.c b/ip/iptunnel.c
index 2369ee062ced..7a0e723714cc 100644
--- a/ip/iptunnel.c
+++ b/ip/iptunnel.c
@@ -34,18 +34,18 @@ static void usage(void)
 {
 	fprintf(stderr,
 		"Usage: ip tunnel { add | change | del | show | prl | 6rd } [ NAME ]\n"
-		"	 [ mode { gre | ipip | isatap | sit | vti } ]\n"
-		"	 [ remote ADDR ] [ local ADDR ]\n"
-		"	 [ [i|o]seq ] [ [i|o]key KEY ] [ [i|o]csum ]\n"
-		"	 [ prl-default ADDR ] [ prl-nodefault ADDR ] [ prl-delete ADDR ]\n"
-		"	 [ 6rd-prefix ADDR ] [ 6rd-relay_prefix ADDR ] [ 6rd-reset ]\n"
-		"	 [ ttl TTL ] [ tos TOS ] [ [no]pmtudisc ] [ dev PHYS_DEV ]\n"
+		"        [ mode { gre | ipip | isatap | sit | vti } ]\n"
+		"        [ remote ADDR ] [ local ADDR ]\n"
+		"        [ [i|o]seq ] [ [i|o]key KEY ] [ [i|o]csum ]\n"
+		"        [ prl-default ADDR ] [ prl-nodefault ADDR ] [ prl-delete ADDR ]\n"
+		"        [ 6rd-prefix ADDR ] [ 6rd-relay_prefix ADDR ] [ 6rd-reset ]\n"
+		"        [ ttl TTL ] [ tos TOS ] [ [no]pmtudisc ] [ dev PHYS_DEV ]\n"
 		"\n"
-		"Where:	NAME := STRING\n"
-		"	ADDR := { IP_ADDRESS | any }\n"
-		"	TOS  := { STRING | 00..ff | inherit | inherit/STRING | inherit/00..ff }\n"
-		"	TTL  := { 1..255 | inherit }\n"
-		"	KEY  := { DOTTED_QUAD | NUMBER }\n");
+		"Where: NAME := STRING\n"
+		"       ADDR := { IP_ADDRESS | any }\n"
+		"       TOS  := { STRING | 00..ff | inherit | inherit/STRING | inherit/00..ff }\n"
+		"       TTL  := { 1..255 | inherit }\n"
+		"       KEY  := { DOTTED_QUAD | NUMBER }\n");
 	exit(-1);
 }
 
diff --git a/ip/iptuntap.c b/ip/iptuntap.c
index 96ca1ae72d33..385d2bd806b2 100644
--- a/ip/iptuntap.c
+++ b/ip/iptuntap.c
@@ -42,11 +42,11 @@ static void usage(void)
 {
 	fprintf(stderr,
 		"Usage: ip tuntap { add | del | show | list | lst | help } [ dev PHYS_DEV ]\n"
-		"	[ mode { tun | tap } ] [ user USER ] [ group GROUP ]\n"
-		"	[ one_queue ] [ pi ] [ vnet_hdr ] [ multi_queue ] [ name NAME ]\n"
+		"       [ mode { tun | tap } ] [ user USER ] [ group GROUP ]\n"
+		"       [ one_queue ] [ pi ] [ vnet_hdr ] [ multi_queue ] [ name NAME ]\n"
 		"\n"
-		"Where:	USER  := { STRING | NUMBER }\n"
-		"	GROUP := { STRING | NUMBER }\n");
+		"Where: USER  := { STRING | NUMBER }\n"
+		"       GROUP := { STRING | NUMBER }\n");
 	exit(-1);
 }
 
diff --git a/ip/rtmon.c b/ip/rtmon.c
index 01c19c80a30a..b021f773d071 100644
--- a/ip/rtmon.c
+++ b/ip/rtmon.c
@@ -65,7 +65,7 @@ static void usage(void)
 	fprintf(stderr,
 		"Usage: rtmon [ OPTIONS ] file FILE [ all | LISTofOBJECTS ]\n"
 		"OPTIONS := { -f[amily] { inet | inet6 | link | help } |\n"
-		"	     -4 | -6 | -0 | -V[ersion] }\n"
+		"             -4 | -6 | -0 | -V[ersion] }\n"
 		"LISTofOBJECTS := [ link ] [ address ] [ route ]\n");
 	exit(-1);
 }
diff --git a/misc/nstat.c b/misc/nstat.c
index ecdd4ce8266d..7160c59be222 100644
--- a/misc/nstat.c
+++ b/misc/nstat.c
@@ -547,17 +547,17 @@ static void usage(void)
 {
 	fprintf(stderr,
 		"Usage: nstat [OPTION] [ PATTERN [ PATTERN ] ]\n"
-		"   -h, --help		this message\n"
-		"   -a, --ignore	ignore history\n"
-		"   -d, --scan=SECS	sample every statistics every SECS\n"
-		"   -j, --json		format output in JSON\n"
-		"   -n, --nooutput	do history only\n"
-		"   -p, --pretty	pretty print\n"
-		"   -r, --reset		reset history\n"
-		"   -s, --noupdate	don't update history\n"
-		"   -t, --interval=SECS	report average over the last SECS\n"
-		"   -V, --version	output version information\n"
-		"   -z, --zeros		show entries with zero activity\n");
+		"   -h, --help          this message\n"
+		"   -a, --ignore        ignore history\n"
+		"   -d, --scan=SECS     sample every statistics every SECS\n"
+		"   -j, --json          format output in JSON\n"
+		"   -n, --nooutput      do history only\n"
+		"   -p, --pretty        pretty print\n"
+		"   -r, --reset         reset history\n"
+		"   -s, --noupdate      don't update history\n"
+		"   -t, --interval=SECS report average over the last SECS\n"
+		"   -V, --version       output version information\n"
+		"   -z, --zeros         show entries with zero activity\n");
 	exit(-1);
 }
 
-- 
2.17.1

