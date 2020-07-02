Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7C9F2128DC
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 18:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbgGBQC1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 12:02:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbgGBQC1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 12:02:27 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24A54C08C5C1
        for <netdev@vger.kernel.org>; Thu,  2 Jul 2020 09:02:27 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id z3so3436344pfn.12
        for <netdev@vger.kernel.org>; Thu, 02 Jul 2020 09:02:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=yKkFGqwJrE7f7IGosPa3wCX2L311lQtkmer9npPxNoU=;
        b=ghNRiSYhpR4sAtvAv7ODlZduEXbUb/bulNoeXY7BCqsjQnnjKT+LArwFS+9cSt49ll
         MhX87nTfDZuI4aolmYoz8chnjvdkVEZoOuDoNEavcZZV5tNEr7MKZxvO/AmQpQixifAN
         9ijHPK17n1qQyI6qwntAULaXT+AO1tQqT0VY2jSHGtVvN710XpCFrMByRzNQHjQtyHZ5
         escHCjYc0XXCmXYPwz3cFbFbH00sgSJ8Zho9oQgv/zIVZ8YchLY5aLTnsI4GSc/1lzYx
         1o/Fhkqh+/8kIhVrAxQLqMTv3ejVYcS3EDVo0TXePlG93bnsZHGGV/AtDPT71AV7EfyZ
         DRWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=yKkFGqwJrE7f7IGosPa3wCX2L311lQtkmer9npPxNoU=;
        b=p/rslJVTLimIKrZxBkxHA7Q8VgXhQDQ6rZkR+48T26HQzjoSwtFmCCNDnE0kCyabqw
         Muuwjgd0mR/1MUTRNL0EWPXPfYWEfsbWbdpVWnuxpVq9pAbEXPY4dmLLxJEdf7NuV59i
         uzzY+cm+SWrcqgkQIr+LBuHKQbB4xVjeUIo8S2VuuRxERl+9bi9kFqRWEmzu22kH6WS/
         bZwlWRefKpaobBowudQ8WFGyuvsQO6DHMocgaatQK4VI0e0YgIpoaWtATk/82ph1zeTY
         Q6/zwGFECRHj/Zw1HZj11W2ROAzlODT+6EaCsIdrlnP/4zfjGP0mF1Vvu5o9sPlTpTaR
         EzOw==
X-Gm-Message-State: AOAM530Yb+heAJlARXPh3YbGNUNFXOjhCrTRdF6/xHTLRCK0PTaka/2w
        4iajqd8ztnTGe3DB86ODWnYvrijD
X-Google-Smtp-Source: ABdhPJzFoUgcKB/loFZvfZTgRMxv9SJXAdgvfRVnLNrp/H/fjDlVkS1nyRgnZkOYn/0wfk3/zyzlmg==
X-Received: by 2002:aa7:84d3:: with SMTP id x19mr17176515pfn.155.1593705745931;
        Thu, 02 Jul 2020 09:02:25 -0700 (PDT)
Received: from martin-VirtualBox ([117.202.89.119])
        by smtp.gmail.com with ESMTPSA id y69sm10054669pfg.207.2020.07.02.09.02.24
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Thu, 02 Jul 2020 09:02:25 -0700 (PDT)
Date:   Thu, 2 Jul 2020 21:32:21 +0530
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
Subject: Re: [PATCH iproute2] ip link: initial support for bareudp devices
Message-ID: <20200702160221.GA3720@martin-VirtualBox>
References: <f3401f1acfce2f472abe6f89fe059a5fade148a3.1593630794.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f3401f1acfce2f472abe6f89fe059a5fade148a3.1593630794.git.gnault@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 01, 2020 at 09:45:04PM +0200, Guillaume Nault wrote:
> Bareudp devices provide a generic L3 encapsulation for tunnelling
> different protocols like MPLS, IP, NSH, etc. inside a UDP tunnel.
> 
> This patch is based on original work from Martin Varghese:
> https://lore.kernel.org/netdev/1570532361-15163-1-git-send-email-martinvarghesenokia@gmail.com/
> 
> Examples:
> 
>   - ip link add dev bareudp0 type bareudp dstport 6635 ethertype mpls_uc
> 
> This creates a bareudp tunnel device which tunnels L3 traffic with
> ethertype 0x8847 (unicast MPLS traffic). The destination port of the
> UDP header will be set to 6635. The device will listen on UDP port 6635
> to receive traffic.
> 
>   - ip link add dev bareudp0 type bareudp dstport 6635 ethertype ipv4 multiproto
> 
> Same as the MPLS example, but for IPv4. The "multiproto" keyword allows
> the device to also tunnel IPv6 traffic.
> 
> Signed-off-by: Guillaume Nault <gnault@redhat.com>
> ---
>  ip/Makefile           |   2 +-
>  ip/iplink.c           |   2 +-
>  ip/iplink_bareudp.c   | 150 ++++++++++++++++++++++++++++++++++++++++++
>  man/man8/ip-link.8.in |  44 +++++++++++++
>  4 files changed, 196 insertions(+), 2 deletions(-)
>  create mode 100644 ip/iplink_bareudp.c
> 
> diff --git a/ip/Makefile b/ip/Makefile
> index 8735b8e4..4cad619c 100644
> --- a/ip/Makefile
> +++ b/ip/Makefile
> @@ -11,7 +11,7 @@ IPOBJ=ip.o ipaddress.o ipaddrlabel.o iproute.o iprule.o ipnetns.o \
>      iplink_bridge.o iplink_bridge_slave.o ipfou.o iplink_ipvlan.o \
>      iplink_geneve.o iplink_vrf.o iproute_lwtunnel.o ipmacsec.o ipila.o \
>      ipvrf.o iplink_xstats.o ipseg6.o iplink_netdevsim.o iplink_rmnet.o \
> -    ipnexthop.o ipmptcp.o
> +    ipnexthop.o ipmptcp.o iplink_bareudp.o
>  
>  RTMONOBJ=rtmon.o
>  
> diff --git a/ip/iplink.c b/ip/iplink.c
> index 47f73988..7d4b244d 100644
> --- a/ip/iplink.c
> +++ b/ip/iplink.c
> @@ -124,7 +124,7 @@ void iplink_usage(void)
>  			"	   bridge | bond | team | ipoib | ip6tnl | ipip | sit | vxlan |\n"
>  			"	   gre | gretap | erspan | ip6gre | ip6gretap | ip6erspan |\n"
>  			"	   vti | nlmon | team_slave | bond_slave | bridge_slave |\n"
> -			"	   ipvlan | ipvtap | geneve | vrf | macsec | netdevsim | rmnet |\n"
> +			"	   ipvlan | ipvtap | geneve | bareudp | vrf | macsec | netdevsim | rmnet |\n"
>  			"	   xfrm }\n");
>  	}
>  	exit(-1);
> diff --git a/ip/iplink_bareudp.c b/ip/iplink_bareudp.c
> new file mode 100644
> index 00000000..885e1110
> --- /dev/null
> +++ b/ip/iplink_bareudp.c
> @@ -0,0 +1,150 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +#include <stdio.h>
> +
> +#include "libnetlink.h"
> +#include "linux/if_ether.h"
> +#include "linux/if_link.h"
> +#include "linux/netlink.h"
> +#include "linux/rtnetlink.h"
> +#include "rt_names.h"
> +#include "utils.h"
> +#include "ip_common.h"
> +#include "json_print.h"
> +
> +#define BAREUDP_ATTRSET(attrs, type) (((attrs) & (1L << (type))) != 0)
> +
> +static void print_explain(FILE *f)
> +{
> +	fprintf(f,
> +		"Usage: ... bareudp dstport PORT\n"
> +		"		ethertype PROTO\n"
> +		"		[ srcportmin PORT ]\n"
> +		"		[ [no]multiproto ]\n"
> +		"\n"
> +		"Where:	PORT       := 0-65535\n"
> +		"	PROTO      := NUMBER | ip | mpls\n"
> +		"	SRCPORTMIN := 0-65535\n"
> +	);
> +}
> +
> +static void explain(void)
> +{
> +	print_explain(stderr);
> +}
> +
> +static void check_duparg(__u64 *attrs, int type, const char *key,
> +			 const char *argv)
> +{
> +	if (!BAREUDP_ATTRSET(*attrs, type)) {
> +		*attrs |= (1L << type);
> +		return;
> +	}
> +	duparg2(key, argv);
> +}
> +
> +static int bareudp_parse_opt(struct link_util *lu, int argc, char **argv,
> +			     struct nlmsghdr *n)
> +{
> +	bool multiproto = false;
> +	__u16 srcportmin = 0;
> +	__be16 ethertype = 0;
> +	__be16 dstport = 0;
> +	__u64 attrs = 0;
> +
> +	while (argc > 0) {
> +		if (matches(*argv, "dstport") == 0) {
> +			NEXT_ARG();
> +			check_duparg(&attrs, IFLA_BAREUDP_PORT, "dstport",
> +				     *argv);
> +			if (get_be16(&dstport, *argv, 0))
> +				invarg("dstport", *argv);
> +		} else if (matches(*argv, "ethertype") == 0)  {
> +			NEXT_ARG();
> +			check_duparg(&attrs, IFLA_BAREUDP_ETHERTYPE,
> +				     "ethertype", *argv);
> +			if (ll_proto_a2n(&ethertype, *argv))
> +				invarg("ethertype", *argv);
> +		} else if (matches(*argv, "srcportmin") == 0) {
> +			NEXT_ARG();
> +			check_duparg(&attrs, IFLA_BAREUDP_SRCPORT_MIN,
> +				     "srcportmin", *argv);
> +			if (get_u16(&srcportmin, *argv, 0))
> +				invarg("srcportmin", *argv);
> +		} else if (matches(*argv, "multiproto") == 0) {
> +			check_duparg(&attrs, IFLA_BAREUDP_MULTIPROTO_MODE,
> +				     *argv, *argv);
> +			multiproto = true;
> +		} else if (matches(*argv, "nomultiproto") == 0) {
> +			check_duparg(&attrs, IFLA_BAREUDP_MULTIPROTO_MODE,
> +				     *argv, *argv);
> +			multiproto = false;
> +		} else if (matches(*argv, "help") == 0) {
> +			explain();
> +			return -1;
> +		} else {
> +			fprintf(stderr, "bareudp: unknown command \"%s\"?\n",
> +				*argv);
> +			explain();
> +			return -1;
> +		}
> +		argc--, argv++;
> +	}
> +
> +	if (!BAREUDP_ATTRSET(attrs, IFLA_BAREUDP_PORT))
> +		missarg("dstport");
> +	if (!BAREUDP_ATTRSET(attrs, IFLA_BAREUDP_ETHERTYPE))
> +		missarg("ethertype");
> +
> +	addattr16(n, 1024, IFLA_BAREUDP_PORT, dstport);
> +	addattr16(n, 1024, IFLA_BAREUDP_ETHERTYPE, ethertype);
> +	if (BAREUDP_ATTRSET(attrs, IFLA_BAREUDP_SRCPORT_MIN))
> +		addattr16(n, 1024, IFLA_BAREUDP_SRCPORT_MIN, srcportmin);
> +	if (multiproto)
> +		addattr(n, 1024, IFLA_BAREUDP_MULTIPROTO_MODE);
> +
> +	return 0;
> +}
> +
> +static void bareudp_print_opt(struct link_util *lu, FILE *f,
> +			      struct rtattr *tb[])
> +{
> +	if (!tb)
> +		return;
> +
> +	if (tb[IFLA_BAREUDP_PORT])
> +		print_uint(PRINT_ANY, "dstport", "dstport %u ",
> +			   rta_getattr_be16(tb[IFLA_BAREUDP_PORT]));
> +
> +	if (tb[IFLA_BAREUDP_ETHERTYPE]) {
> +		struct rtattr *attr = tb[IFLA_BAREUDP_ETHERTYPE];
> +		SPRINT_BUF(ethertype);
> +
> +		print_string(PRINT_ANY, "ethertype", "ethertype %s ",
> +			     ll_proto_n2a(rta_getattr_u16(attr),
> +					  ethertype, sizeof(ethertype)));
> +	}
> +
> +	if (tb[IFLA_BAREUDP_SRCPORT_MIN])
> +		print_uint(PRINT_ANY, "srcportmin", "srcportmin %u ",
> +			   rta_getattr_u16(tb[IFLA_BAREUDP_SRCPORT_MIN]));
> +
> +	if (tb[IFLA_BAREUDP_MULTIPROTO_MODE])
> +		print_bool(PRINT_ANY, "multiproto", "multiproto ", true);
> +	else
> +		print_bool(PRINT_ANY, "multiproto", "nomultiproto ", false);
> +}
> +
> +static void bareudp_print_help(struct link_util *lu, int argc, char **argv,
> +			       FILE *f)
> +{
> +	print_explain(f);
> +}
> +
> +struct link_util bareudp_link_util = {
> +	.id		= "bareudp",
> +	.maxattr	= IFLA_BAREUDP_MAX,
> +	.parse_opt	= bareudp_parse_opt,
> +	.print_opt	= bareudp_print_opt,
> +	.print_help	= bareudp_print_help,
> +};
> diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
> index e8a25451..c6bd2c53 100644
> --- a/man/man8/ip-link.8.in
> +++ b/man/man8/ip-link.8.in
> @@ -223,6 +223,7 @@ ip-link \- network device configuration
>  .BR ipvtap " |"
>  .BR lowpan " |"
>  .BR geneve " |"
> +.BR bareudp " |"
>  .BR vrf " |"
>  .BR macsec " |"
>  .BR netdevsim " |"
> @@ -356,6 +357,9 @@ Link types:
>  .BR geneve
>  - GEneric NEtwork Virtualization Encapsulation
>  .sp
> +.BR bareudp
> +- Bare UDP L3 encapsulation support
> +.sp
>  .BR macsec
>  - Interface for IEEE 802.1AE MAC Security (MACsec)
>  .sp
> @@ -1293,6 +1297,46 @@ options.
>  
>  .in -8
>  
> +.TP
> +Bareudp Type Support
> +For a link of type
> +.I Bareudp
> +the following additional arguments are supported:
> +
> +.BI "ip link add " DEVICE
> +.BI type " bareudp " dstport " PORT " ethertype " ETHERTYPE"
> +[
> +.BI srcportmin " SRCPORTMIN "
> +] [
> +.RB [ no ] multiproto
> +]
> +
> +.in +8
> +.sp
> +.BI dstport " PORT"
> +- specifies the destination port for the UDP tunnel.
> +
> +.sp
> +.BI ethertype " ETHERTYPE"
> +- specifies the ethertype of the L3 protocol being tunnelled.
> +
> +.sp
> +.BI srcportmin " SRCPORTMIN"
> +- selects the lowest value of the UDP tunnel source port range.
> +
> +.sp
> +.RB [ no ] multiproto
> +- activates support for protocols similar to the one
> +.RB "specified by " ethertype .
> +When
> +.I ETHERTYPE
> +is "mpls_uc" (that is, unicast MPLS), this allows the tunnel to also handle
> +multicast MPLS.
> +When
> +.I ETHERTYPE
> +is "ipv4", this allows the tunnel to also handle IPv6. This option is disabled
> +by default.
> +
>  .TP
>  MACVLAN and MACVTAP Type Support
>  For a link of type
> -- 


I couldnt apply the patch to master.Could you please confirm if it was rebased to the master
> 2.21.3
> 
