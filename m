Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 423233F9D51
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 19:12:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235700AbhH0RLP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 13:11:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234297AbhH0RLK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 13:11:10 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B673C061757
        for <netdev@vger.kernel.org>; Fri, 27 Aug 2021 10:10:21 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id q21so4340188plq.3
        for <netdev@vger.kernel.org>; Fri, 27 Aug 2021 10:10:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kk8VJ89rqeExU23M3TuZPkF3LQZNfRuGzhUAPyOyygc=;
        b=dS339us0rJ666sZ/PDbfjgbCcAVTXr23DZnx5qQFEuYq59O/7TLBiOvVlMaBhEESRF
         dqH0MzuwTgskloSVkYatWc+6PF5jDGnKG9fUa54Ne9HhnOzhyaI/guWyeIdpSwSzm/Nc
         8QFtWsKc/CDqimNG4su+yKq94HuxkoU1NswDqAvjbzwltYShlGaVKiOfhIdOVzt/amAe
         gfc0S1lQ/nGkIwHYb3+2a6QgrJnZEbTDe2adIhav2DirOlPfmSyh4GcIJBRw5G+ft0e+
         /QsIP+Tz5mGZn57DeIoV6qb0Im3EpXKWfm28yvP8Nj/KbqndoIjZ3N4unIcNSUWCHj/7
         YXMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kk8VJ89rqeExU23M3TuZPkF3LQZNfRuGzhUAPyOyygc=;
        b=jpZeV0D/1ub7YNVdmhK8GBn80GogfkggDYeQcIX3kOF7sMrHtxiaQrS4IACIYkTXcT
         HaLkRhr2MJ//cFVyV/S4NiOtzAijgCywnlqZThhYVhuHd8ssCLjz9KEDcrUIoOjXc68W
         jEEY0uYoFJ/49+S+JGdYZ/2sXU8JI9YiQ/1uxnZG2YAVfxUGHhltg/+OEYxBnQBqJeIP
         0JoQVZPmkXpgkClq0X7E3mujUCxTYv5WU0jOW9uNV4ItTKG54smwJF3ghLOIICNJ11I+
         Vzi3t1nVQtRj9pOEpfi+3F3JndmeUkaBebkX0Z+ZLEvh5fhZi4YW+Qs0NQou6QSUuSrU
         Occg==
X-Gm-Message-State: AOAM532JJmpRZwYdYyKjn/m73hYzwqW0Bt7K/VP3k/O7SMpemBQ8Rauo
        q0c25qthI1BLdb7bN/okY3axcWL9n1Y=
X-Google-Smtp-Source: ABdhPJyYlDphyWrBIgkWnNLA+jKFRHIkdJBX4HGH089f0V+3ObgwIE0hKeImf3XfynHXecOlhF6Gnw==
X-Received: by 2002:a17:902:c401:b0:12d:8258:bbb1 with SMTP id k1-20020a170902c40100b0012d8258bbb1mr9577815plk.6.1630084220494;
        Fri, 27 Aug 2021 10:10:20 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([72.164.175.30])
        by smtp.googlemail.com with ESMTPSA id y5sm6589841pfa.5.2021.08.27.10.10.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Aug 2021 10:10:19 -0700 (PDT)
Subject: Re: [PATCH iproute2-next 02/17] bridge: vlan: add support to show
 global vlan options
To:     Nikolay Aleksandrov <razor@blackwall.org>, netdev@vger.kernel.org
Cc:     roopa@nvidia.com, Joachim Wiberg <troglobit@gmail.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
References: <20210826130533.149111-1-razor@blackwall.org>
 <20210826130533.149111-3-razor@blackwall.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <028aa410-095f-73f8-8f8a-33f306ea5be6@gmail.com>
Date:   Fri, 27 Aug 2021 10:10:18 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210826130533.149111-3-razor@blackwall.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/26/21 6:05 AM, Nikolay Aleksandrov wrote:
> From: Nikolay Aleksandrov <nikolay@nvidia.com>
> 
> Add support for new bridge vlan command grouping called global which
> operates on global options. The first command it supports is "show".
> Man page and help are also updated with the new command.
> 
> Syntax is: $ bridge vlan global show [ vid VID ] [ dev DEV ]
> 
> Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
> ---
>  bridge/br_common.h |   3 +-
>  bridge/monitor.c   |   2 +-
>  bridge/vlan.c      | 229 ++++++++++++++++++++++++++++++++++-----------
>  man/man8/bridge.8  |  21 +++++
>  4 files changed, 200 insertions(+), 55 deletions(-)
> 
> diff --git a/bridge/br_common.h b/bridge/br_common.h
> index b9adafd98dea..09f42c814918 100644
> --- a/bridge/br_common.h
> +++ b/bridge/br_common.h
> @@ -12,7 +12,8 @@ int print_mdb_mon(struct nlmsghdr *n, void *arg);
>  int print_fdb(struct nlmsghdr *n, void *arg);
>  void print_stp_state(__u8 state);
>  int parse_stp_state(const char *arg);
> -int print_vlan_rtm(struct nlmsghdr *n, void *arg, bool monitor);
> +int print_vlan_rtm(struct nlmsghdr *n, void *arg, bool monitor,
> +		   bool global_only);
>  
>  int do_fdb(int argc, char **argv);
>  int do_mdb(int argc, char **argv);
> diff --git a/bridge/monitor.c b/bridge/monitor.c
> index 88f52f52f084..845e221abb49 100644
> --- a/bridge/monitor.c
> +++ b/bridge/monitor.c
> @@ -71,7 +71,7 @@ static int accept_msg(struct rtnl_ctrl_data *ctrl,
>  	case RTM_DELVLAN:
>  		if (prefix_banner)
>  			fprintf(fp, "[VLAN]");
> -		return print_vlan_rtm(n, arg, true);
> +		return print_vlan_rtm(n, arg, true, false);
>  
>  	default:
>  		return 0;
> diff --git a/bridge/vlan.c b/bridge/vlan.c
> index 9b6511f189ff..9e33995f8f33 100644
> --- a/bridge/vlan.c
> +++ b/bridge/vlan.c
> @@ -36,7 +36,8 @@ static void usage(void)
>  		"                                                     [ self ] [ master ]\n"
>  		"       bridge vlan { set } vid VLAN_ID dev DEV [ state STP_STATE ]\n"
>  		"       bridge vlan { show } [ dev DEV ] [ vid VLAN_ID ]\n"
> -		"       bridge vlan { tunnelshow } [ dev DEV ] [ vid VLAN_ID ]\n");
> +		"       bridge vlan { tunnelshow } [ dev DEV ] [ vid VLAN_ID ]\n"
> +		"       bridge vlan global { show } [ dev DEV ] [ vid VLAN_ID ]\n");
>  	exit(-1);
>  }
>  
> @@ -621,11 +622,89 @@ static int print_vlan_stats(struct nlmsghdr *n, void *arg)
>  	return 0;
>  }
>  
> -int print_vlan_rtm(struct nlmsghdr *n, void *arg, bool monitor)
> +static void print_vlan_global_opts(struct rtattr *a)
> +{
> +	struct rtattr *vtb[BRIDGE_VLANDB_GOPTS_MAX + 1];
> +	__u16 vid, vrange = 0;
> +
> +	if ((a->rta_type & NLA_TYPE_MASK) != BRIDGE_VLANDB_GLOBAL_OPTIONS)
> +		return;
> +
> +	parse_rtattr_flags(vtb, BRIDGE_VLANDB_GOPTS_MAX, RTA_DATA(a),
> +			   RTA_PAYLOAD(a), NLA_F_NESTED);
> +	vid = rta_getattr_u16(vtb[BRIDGE_VLANDB_GOPTS_ID]);
> +	if (vtb[BRIDGE_VLANDB_GOPTS_RANGE])
> +		vrange = rta_getattr_u16(vtb[BRIDGE_VLANDB_GOPTS_RANGE]);
> +	else
> +		vrange = vid;
> +	print_range("vlan", vid, vrange);
> +	print_nl();
> +}
> +
> +static void print_vlan_opts(struct rtattr *a)
> +{
> +	struct rtattr *vtb[BRIDGE_VLANDB_ENTRY_MAX + 1];
> +	struct bridge_vlan_xstats vstats;
> +	struct bridge_vlan_info *vinfo;
> +	__u16 vrange = 0;
> +	__u8 state = 0;
> +
> +	if ((a->rta_type & NLA_TYPE_MASK) != BRIDGE_VLANDB_ENTRY)
> +		return;
> +
> +	parse_rtattr_flags(vtb, BRIDGE_VLANDB_ENTRY_MAX, RTA_DATA(a),
> +			   RTA_PAYLOAD(a), NLA_F_NESTED);
> +	vinfo = RTA_DATA(vtb[BRIDGE_VLANDB_ENTRY_INFO]);
> +
> +	memset(&vstats, 0, sizeof(vstats));
> +	if (vtb[BRIDGE_VLANDB_ENTRY_RANGE])
> +		vrange = rta_getattr_u16(vtb[BRIDGE_VLANDB_ENTRY_RANGE]);
> +	else
> +		vrange = vinfo->vid;
> +
> +	if (vtb[BRIDGE_VLANDB_ENTRY_STATE])
> +		state = rta_getattr_u8(vtb[BRIDGE_VLANDB_ENTRY_STATE]);
> +
> +	if (vtb[BRIDGE_VLANDB_ENTRY_STATS]) {
> +		struct rtattr *stb[BRIDGE_VLANDB_STATS_MAX+1];
> +		struct rtattr *attr;
> +
> +		attr = vtb[BRIDGE_VLANDB_ENTRY_STATS];
> +		parse_rtattr(stb, BRIDGE_VLANDB_STATS_MAX, RTA_DATA(attr),
> +			     RTA_PAYLOAD(attr));
> +
> +		if (stb[BRIDGE_VLANDB_STATS_RX_BYTES]) {
> +			attr = stb[BRIDGE_VLANDB_STATS_RX_BYTES];
> +			vstats.rx_bytes = rta_getattr_u64(attr);
> +		}
> +		if (stb[BRIDGE_VLANDB_STATS_RX_PACKETS]) {
> +			attr = stb[BRIDGE_VLANDB_STATS_RX_PACKETS];
> +			vstats.rx_packets = rta_getattr_u64(attr);
> +		}
> +		if (stb[BRIDGE_VLANDB_STATS_TX_PACKETS]) {
> +			attr = stb[BRIDGE_VLANDB_STATS_TX_PACKETS];
> +			vstats.tx_packets = rta_getattr_u64(attr);
> +		}
> +		if (stb[BRIDGE_VLANDB_STATS_TX_BYTES]) {
> +			attr = stb[BRIDGE_VLANDB_STATS_TX_BYTES];
> +			vstats.tx_bytes = rta_getattr_u64(attr);
> +		}
> +	}
> +	print_range("vlan", vinfo->vid, vrange);
> +	print_vlan_flags(vinfo->flags);
> +	print_nl();
> +	print_string(PRINT_FP, NULL, "%-" __stringify(IFNAMSIZ) "s    ", "");
> +	print_stp_state(state);
> +	print_nl();
> +	if (show_stats)
> +		__print_one_vlan_stats(&vstats);
> +}
> +
> +int print_vlan_rtm(struct nlmsghdr *n, void *arg, bool monitor, bool global_only)
>  {
> -	struct rtattr *vtb[BRIDGE_VLANDB_ENTRY_MAX + 1], *a;
>  	struct br_vlan_msg *bvm = NLMSG_DATA(n);
>  	int len = n->nlmsg_len;
> +	struct rtattr *a;
>  	int rem;
>  
>  	if (n->nlmsg_type != RTM_NEWVLAN && n->nlmsg_type != RTM_DELVLAN &&
> @@ -660,49 +739,13 @@ int print_vlan_rtm(struct nlmsghdr *n, void *arg, bool monitor)
>  
>  	rem = len;
>  	for (a = BRVLAN_RTA(bvm); RTA_OK(a, rem); a = RTA_NEXT(a, rem)) {
> -		struct bridge_vlan_xstats vstats;
> -		struct bridge_vlan_info *vinfo;
> -		__u32 vrange = 0;
> -		__u8 state = 0;
> -
> -		parse_rtattr_flags(vtb, BRIDGE_VLANDB_ENTRY_MAX, RTA_DATA(a),
> -				   RTA_PAYLOAD(a), NLA_F_NESTED);
> -		vinfo = RTA_DATA(vtb[BRIDGE_VLANDB_ENTRY_INFO]);
> -
> -		memset(&vstats, 0, sizeof(vstats));
> -		if (vtb[BRIDGE_VLANDB_ENTRY_RANGE])
> -			vrange = rta_getattr_u16(vtb[BRIDGE_VLANDB_ENTRY_RANGE]);
> -		else
> -			vrange = vinfo->vid;
> -
> -		if (vtb[BRIDGE_VLANDB_ENTRY_STATE])
> -			state = rta_getattr_u8(vtb[BRIDGE_VLANDB_ENTRY_STATE]);
> +		unsigned short rta_type = a->rta_type & NLA_TYPE_MASK;
>  
> -		if (vtb[BRIDGE_VLANDB_ENTRY_STATS]) {
> -			struct rtattr *stb[BRIDGE_VLANDB_STATS_MAX+1];
> -			struct rtattr *attr;
> -
> -			attr = vtb[BRIDGE_VLANDB_ENTRY_STATS];
> -			parse_rtattr(stb, BRIDGE_VLANDB_STATS_MAX, RTA_DATA(attr),
> -				     RTA_PAYLOAD(attr));
> +		/* skip unknown attributes */
> +		if (rta_type > BRIDGE_VLANDB_MAX ||
> +		    (global_only && rta_type != BRIDGE_VLANDB_GLOBAL_OPTIONS))
> +			continue;
>  
> -			if (stb[BRIDGE_VLANDB_STATS_RX_BYTES]) {
> -				attr = stb[BRIDGE_VLANDB_STATS_RX_BYTES];
> -				vstats.rx_bytes = rta_getattr_u64(attr);
> -			}
> -			if (stb[BRIDGE_VLANDB_STATS_RX_PACKETS]) {
> -				attr = stb[BRIDGE_VLANDB_STATS_RX_PACKETS];
> -				vstats.rx_packets = rta_getattr_u64(attr);
> -			}
> -			if (stb[BRIDGE_VLANDB_STATS_TX_PACKETS]) {
> -				attr = stb[BRIDGE_VLANDB_STATS_TX_PACKETS];
> -				vstats.tx_packets = rta_getattr_u64(attr);
> -			}
> -			if (stb[BRIDGE_VLANDB_STATS_TX_BYTES]) {
> -				attr = stb[BRIDGE_VLANDB_STATS_TX_BYTES];
> -				vstats.tx_bytes = rta_getattr_u64(attr);
> -			}
> -		}
>  		if (vlan_rtm_cur_ifidx != bvm->ifindex) {
>  			open_vlan_port(bvm->ifindex, VLAN_SHOW_VLAN);
>  			open_json_object(NULL);

Split the refactoring of this code into a separate patch that only does
the refactoring.
