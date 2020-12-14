Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB8FB2D9D2F
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 18:05:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502014AbgLNREU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 12:04:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729090AbgLNREO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 12:04:14 -0500
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15080C0613D6
        for <netdev@vger.kernel.org>; Mon, 14 Dec 2020 09:03:34 -0800 (PST)
Received: by mail-ot1-x343.google.com with SMTP id h18so16392185otq.12
        for <netdev@vger.kernel.org>; Mon, 14 Dec 2020 09:03:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=t+thNa4RGpIpddH6vkAaUdDUhN4JK2Trs+HeUv6x634=;
        b=d/397qoZdHRtMDdLtPIfzj1c/B0Rhq4NcSzwi2rSSEGf9IIFHP/FcNKY8OX07spYi5
         s4E2oAG46N54cjeT60o+geVjcN3X8/lzKpqQPCPaSN7kRLpbnubTZSGNnMewcUGwDENW
         9rwij+qyFKl0gT1CkHKu0Y6h2RiEAoJc3+a1xiDFI2JH7tB7iqAHUzrEaXioQjwmbW4m
         EC31VSqhMpZfhxyHu7WM4wo6vg6jGz0GVprAdRTgPBbB2B3FW9PTmhedcnnnp1xCLAsq
         XV1trjlmTDVwXbnKUiNeOdjF/m/dazQmH31TH30d9k7hsryFDmyAviiOuy01DDf+kKqo
         OzPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=t+thNa4RGpIpddH6vkAaUdDUhN4JK2Trs+HeUv6x634=;
        b=lHsoxbK0BAWkdjmoTCxy0gxSxbfYFdtGSj96jj8Pq/yKwF6ZLA67mq/D3hh+LmzYrd
         0uLVMN7LAVWjvmiysZLPmvtilo4dhX4C+xLJmWYaQfu8tZ7mbfZjfBSDjn1zONYaeGJr
         7iL25bO4gSPJz37qmnOiIMSxrRuFYtS44Dka4vI9p1DNQUJJqpuLZwyqu5GLah2yWJ1H
         zIrjgBpbBNVUkCnJ2mYNBviDgBeXTfd9r/2prSUJlcVye7tbyN3EQR12ZhGbaRXZaB/k
         TvCnWvSH3+ekOcVBpKwQtZi0x/x+Qq9UXwI4pYjJ7lgSSo4qLN8NNxWI8LcCK/XIY9QP
         ej3Q==
X-Gm-Message-State: AOAM533rDVqe0f8QtuPmcAoImu1SWKmPtXdwu5ccHxHkwFVkgIPoZ6rc
        E6wBztr7BcU6TEVcV3UpAfo=
X-Google-Smtp-Source: ABdhPJyua08r9DQg+vXd4w2fFJ8CKw3Ywx4ZF/KFWh3zV3JYQmuXfjbyOooNq3K8tqQUFZtO+aCqNQ==
X-Received: by 2002:a9d:65d3:: with SMTP id z19mr11337078oth.57.1607965413333;
        Mon, 14 Dec 2020 09:03:33 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.51])
        by smtp.googlemail.com with ESMTPSA id z3sm548919ooj.26.2020.12.14.09.03.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Dec 2020 09:03:32 -0800 (PST)
Subject: Re: [PATCH iproute2-next v2] iplink:macvlan: Added bcqueuelen
 parameter
To:     Thomas Karlsson <thomas.karlsson@paneda.se>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        dsahern@gmail.com
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, stephen@networkplumber.org,
        kuznet@ms2.inr.ac.ru
References: <485531aec7e243659ee4e3bb7fa2186d@paneda.se>
 <147b704ac1d5426fbaa8617289dad648@paneda.se>
 <20201123143052.1176407d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <892be191-c948-4538-e46d-437c3f3a118c@paneda.se>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <25e06e96-3c8d-06c0-4148-3409d7cecc6a@gmail.com>
Date:   Mon, 14 Dec 2020 10:03:29 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <892be191-c948-4538-e46d-437c3f3a118c@paneda.se>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/14/20 3:42 AM, Thomas Karlsson wrote:
> This patch allows the user to set and retrieve the
> IFLA_MACVLAN_BC_QUEUE_LEN parameter via the bcqueuelen
> command line argument
> 
> This parameter controls the requested size of the queue for
> broadcast and multicast packages in the macvlan driver.
> 
> If not specified, the driver default (1000) will be used.
> 
> Note: The request is per macvlan but the actually used queue
> length per port is the maximum of any request to any macvlan
> connected to the same port.
> 
> For this reason, the used queue length IFLA_MACVLAN_BC_QUEUE_LEN_USED
> is also retrieved and displayed in order to aid in the understanding
> of the setting. However, it can of course not be directly set.
> 
> Signed-off-by: Thomas Karlsson <thomas.karlsson@paneda.se>
> ---
> 
> Note: This patch controls the parameter added in net-next
> with commit d4bff72c8401e6f56194ecf455db70ebc22929e2
> 
> v2 Rebased on origin/main
> v1 Initial version
> 
>  ip/iplink_macvlan.c   | 33 +++++++++++++++++++++++++++++++--
>  man/man8/ip-link.8.in | 33 +++++++++++++++++++++++++++++++++
>  2 files changed, 64 insertions(+), 2 deletions(-)
> 
> diff --git a/ip/iplink_macvlan.c b/ip/iplink_macvlan.c
> index b966a615..302a3748 100644
> --- a/ip/iplink_macvlan.c
> +++ b/ip/iplink_macvlan.c
> @@ -30,12 +30,13 @@
>  static void print_explain(struct link_util *lu, FILE *f)
>  {
>  	fprintf(f,
> -		"Usage: ... %s mode MODE [flag MODE_FLAG] MODE_OPTS\n"
> +		"Usage: ... %s mode MODE [flag MODE_FLAG] MODE_OPTS [bcqueuelen BC_QUEUE_LEN]\n"
>  		"\n"
>  		"MODE: private | vepa | bridge | passthru | source\n"
>  		"MODE_FLAG: null | nopromisc\n"
>  		"MODE_OPTS: for mode \"source\":\n"
> -		"\tmacaddr { { add | del } <macaddr> | set [ <macaddr> [ <macaddr>  ... ] ] | flush }\n",
> +		"\tmacaddr { { add | del } <macaddr> | set [ <macaddr> [ <macaddr>  ... ] ] | flush }\n"
> +		"BC_QUEUE_LEN: Length of the rx queue for broadcast/multicast: [0-4294967295]\n",

Are we really allowing a BC queue up to 4G? seems a bit much. is a u16
and 64k not more than sufficient?


>  		lu->id
>  	);
>  }
> @@ -62,6 +63,14 @@ static int flag_arg(const char *arg)
>  	return -1;
>  }
>  
> +static int bc_queue_len_arg(const char *arg)
> +{
> +	fprintf(stderr,
> +		"Error: argument of \"bcqueuelen\" must be a positive integer [0-4294967295], not \"%s\"\n",
> +		arg);
> +	return -1;
> +}
> +
>  static int macvlan_parse_opt(struct link_util *lu, int argc, char **argv,
>  			  struct nlmsghdr *n)
>  {
> @@ -150,6 +159,14 @@ static int macvlan_parse_opt(struct link_util *lu, int argc, char **argv,
>  		} else if (matches(*argv, "nopromisc") == 0) {
>  			flags |= MACVLAN_FLAG_NOPROMISC;
>  			has_flags = 1;
> +		} else if (matches(*argv, "bcqueuelen") == 0) {
> +			__u32 bc_queue_len;
> +			NEXT_ARG();
> +			
> +			if (get_u32(&bc_queue_len, *argv, 0)) {
> +				return bc_queue_len_arg(*argv);
> +			}
> +			addattr32(n, 1024, IFLA_MACVLAN_BC_QUEUE_LEN, bc_queue_len);
>  		} else if (matches(*argv, "help") == 0) {
>  			explain(lu);
>  			return -1;
> @@ -212,6 +229,18 @@ static void macvlan_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[]
>  	if (flags & MACVLAN_FLAG_NOPROMISC)
>  		print_bool(PRINT_ANY, "nopromisc", "nopromisc ", true);
>  
> +	if (tb[IFLA_MACVLAN_BC_QUEUE_LEN] &&
> +		RTA_PAYLOAD(tb[IFLA_MACVLAN_BC_QUEUE_LEN]) >= sizeof(__u32)) {
> +		__u32 bc_queue_len = rta_getattr_u32(tb[IFLA_MACVLAN_BC_QUEUE_LEN]);
> +		print_luint(PRINT_ANY, "bcqueuelen", "bcqueuelen %lu ", bc_queue_len);
> +	}
> +
> +	if (tb[IFLA_MACVLAN_BC_QUEUE_LEN_USED] &&
> +		RTA_PAYLOAD(tb[IFLA_MACVLAN_BC_QUEUE_LEN_USED]) >= sizeof(__u32)) {
> +		__u32 bc_queue_len = rta_getattr_u32(tb[IFLA_MACVLAN_BC_QUEUE_LEN_USED]);
> +		print_luint(PRINT_ANY, "usedbcqueuelen", "usedbcqueuelen %lu ", bc_queue_len);
> +	}
> +
>  	/* in source mode, there are more options to print */
>  
>  	if (mode != MACVLAN_MODE_SOURCE)
> diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
> index 1ff01744..3516765a 100644
> --- a/man/man8/ip-link.8.in
> +++ b/man/man8/ip-link.8.in
> @@ -1352,6 +1352,7 @@ the following additional arguments are supported:
>  .BR type " { " macvlan " | " macvtap " } "
>  .BR mode " { " private " | " vepa " | " bridge " | " passthru
>  .RB " [ " nopromisc " ] | " source " } "
> +.RB " [ " bcqueuelen " { " LENGTH " } ] "
>  
>  .in +8
>  .sp
> @@ -1395,6 +1396,18 @@ against source mac address from received frames on underlying interface. This
>  allows creating mac based VLAN associations, instead of standard port or tag
>  based. The feature is useful to deploy 802.1x mac based behavior,
>  where drivers of underlying interfaces doesn't allows that.
> +
> +.BR bcqueuelen " { " LENGTH " } "
> +- Set the length of the RX queue used to process broadcast and multicast packets.
> +.BR LENGTH " must be a positive integer in the range [0-4294967295]."
> +Setting a length of 0 will effectively drop all broadcast/multicast traffic.
> +If not specified the macvlan driver default (1000) is used.
> +Note that all macvlans that share the same underlying device are using the same
> +.RB "queue. The parameter here is a " request ", the actual queue length used"
> +will be the maximum length that any macvlan interface has requested.
> +When listing device parameters both the bcqueuelen parameter
> +as well as the actual used bcqueuelen are listed to better help
> +the user understand the setting.
>  .in -8
>  
>  .TP
> @@ -2451,6 +2464,26 @@ Commands:
>  .sp
>  .in -8
>  
> +Update the broadcast/multicast queue length.
> +
> +.B "ip link set type { macvlan | macvap } "
> +[
> +.BI bcqueuelen "  LENGTH  "
> +]
> +
> +.in +8
> +.BI bcqueuelen " LENGTH "
> +- Set the length of the RX queue used to process broadcast and multicast packets.
> +.IR LENGTH " must be a positive integer in the range [0-4294967295]."
> +Setting a length of 0 will effectively drop all broadcast/multicast traffic.
> +If not specified the macvlan driver default (1000) is used.
> +Note that all macvlans that share the same underlying device are using the same
> +.RB "queue. The parameter here is a " request ", the actual queue length used"
> +will be the maximum length that any macvlan interface has requested.
> +When listing device parameters both the bcqueuelen parameter
> +as well as the actual used bcqueuelen are listed to better help
> +the user understand the setting.
> +.in -8
>  
>  .SS  ip link show - display device attributes
>  
> 

