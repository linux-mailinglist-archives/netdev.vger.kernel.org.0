Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBF693F571D
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 06:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbhHXEUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 00:20:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbhHXEUn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 00:20:43 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF525C061575
        for <netdev@vger.kernel.org>; Mon, 23 Aug 2021 21:19:58 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id ot2-20020a17090b3b4200b0019127f8ed87so1195613pjb.1
        for <netdev@vger.kernel.org>; Mon, 23 Aug 2021 21:19:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KpQlvp6FnPGGoU/OoVVShh8HJzA1vHFR1Y4BeWf0NJw=;
        b=pQVgE41/FdSu/GgJd6ABmE7NDoWvaWtV/1lvLgHLcmQoq1ljEea6TKdB2W9/mWhJqe
         jwPAdEAw/pOTpW7rHlo4/goalI6l1OqZWsgiZ7IuhQjH0a+QK3IB6TRpMIqHI1C270d4
         p3l+oB1ZORdQQtflkrHUyMHMId8DmqbBIRrkaJs3wOpm4mkoxdf3VszDkLnPqU2+OQYk
         IzZP32aGGvPTbwP68qQIASczpc5qXXaqVqOJ5RhV+PwWEoc1KOK3P+odwfAcO4QYUAl5
         V0bNsvtSGh0mYkB4zWddWs4rYc99WoxzZ+8ikRQbFN3ohzoiHVfX2v+vp2/Nkh8C+hQW
         XXww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KpQlvp6FnPGGoU/OoVVShh8HJzA1vHFR1Y4BeWf0NJw=;
        b=QpPbw9P3EK5CQnJSrpwJoqJcV5QEBaxRvhGQ2KKlAvYB8XUHv6j9qUqOYGgRyVmWZv
         FjWOPrBRPkU8H9KPU0IV+O0Dw5006Ty5FWIcBzh7tfK5b8VUMpGE1JCQxf0UxThqptnf
         uJNjCKW1AhJtmSCHe48SikbqiodX2hsTPtg2RVPrgPm6tubJDTxijmmgC7Ho2jpm9QPN
         kWMqCjbsyf5dfjuMDqKQtfQWtuiQm23z8BCcDAbNjP8BUqGc7XsrTVSLyUcWAzMj2f2x
         OSfXgYq+cSYuJ+tO4W1z2N5Xqqt6v/OMXPc3nqcs0x6CDE9EjF6E89fjBtYKlOCJznpP
         3OgQ==
X-Gm-Message-State: AOAM531Ry1vc6v6nGlWR00sKOi32rIP71S0AowGMSthIIKUx2EQyqS95
        v+70+OJb1UFeVq3x6TolbJk=
X-Google-Smtp-Source: ABdhPJwxBZ43DkWl6B5Cr/Jto20yG1m7n7MzjljCRF4RgyWK87KFW+xBEEvtWjFox5Z/BvARS3rD2A==
X-Received: by 2002:a17:902:b102:b0:134:a329:c2f8 with SMTP id q2-20020a170902b10200b00134a329c2f8mr6829783plr.71.1629778798381;
        Mon, 23 Aug 2021 21:19:58 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.45.42.119])
        by smtp.googlemail.com with ESMTPSA id 11sm17113552pfl.41.2021.08.23.21.19.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Aug 2021 21:19:57 -0700 (PDT)
Subject: Re: [PATCH] ip: Support filter links/neighs with no master
To:     Lahav Schlesinger <lschlesinger@drivenets.com>,
        netdev@vger.kernel.org
Cc:     dsahern@kernel.org
References: <20210819104522.6429-1-lschlesinger@drivenets.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <8b8762b4-6675-6dbc-bfe5-ed9443c8d54f@gmail.com>
Date:   Mon, 23 Aug 2021 21:19:56 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210819104522.6429-1-lschlesinger@drivenets.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/19/21 4:45 AM, Lahav Schlesinger wrote:
> Commit d3432bf10f17 ("net: Support filtering interfaces on no master")
> in the kernel added support for filtering interfaces/neighbours that
> have no master interface.
> 
> This patch completes it and adds this support to iproute2:
> 1. ip link show nomaster
> 2. ip address show nomaster
> 3. ip neighbour {show | flush} nomaster
> 
> Signed-off-by: Lahav Schlesinger <lschlesinger@drivenets.com>
> ---
>  ip/ipaddress.c           | 4 +++-
>  ip/iplink.c              | 2 +-
>  ip/ipneigh.c             | 4 +++-
>  man/man8/ip-address.8.in | 7 ++++++-
>  man/man8/ip-link.8.in    | 7 ++++++-
>  man/man8/ip-neighbour.8  | 7 ++++++-
>  6 files changed, 25 insertions(+), 6 deletions(-)
> 
> diff --git a/ip/ipaddress.c b/ip/ipaddress.c
> index 85534aaf..a5b683f5 100644
> --- a/ip/ipaddress.c
> +++ b/ip/ipaddress.c
> @@ -61,7 +61,7 @@ static void usage(void)
>  		"                            [ to PREFIX ] [ FLAG-LIST ] [ label LABEL ] [up]\n"
>  		"       ip address [ show [ dev IFNAME ] [ scope SCOPE-ID ] [ master DEVICE ]\n"

move [ nomaster ] to here on a new line to keep the existing line
length, and

>  		"                         [ type TYPE ] [ to PREFIX ] [ FLAG-LIST ]\n"
> -		"                         [ label LABEL ] [up] [ vrf NAME ] ]\n"
> +		"                         [ label LABEL ] [up] [ vrf NAME ] [ nomaster ] ]\n"

make this 'novrf' for consistency with existing syntax.

Similarly for the other 2 commands.

>  		"       ip address {showdump|restore}\n"
>  		"IFADDR := PREFIX | ADDR peer PREFIX\n"
>  		"          [ broadcast ADDR ] [ anycast ADDR ]\n"
> @@ -2123,6 +2123,8 @@ static int ipaddr_list_flush_or_save(int argc, char **argv, int action)
>  			if (!name_is_vrf(*argv))
>  				invarg("Not a valid VRF name\n", *argv);
>  			filter.master = ifindex;
> +		} else if (strcmp(*argv, "nomaster") == 0) {

and of course make this a compound check for novrf.

> +			filter.master = -1;
>  		} else if (strcmp(*argv, "type") == 0) {
>  			int soff;
>  
> diff --git a/ip/iplink.c b/ip/iplink.c
> index 18b2ea25..f017f1f3 100644
> --- a/ip/iplink.c
> +++ b/ip/iplink.c
> @@ -119,7 +119,7 @@ void iplink_usage(void)
>  		"		[ protodown_reason PREASON { on | off } ]\n"
>  		"		[ gso_max_size BYTES ] | [ gso_max_segs PACKETS ]\n"
>  		"\n"
> -		"	ip link show [ DEVICE | group GROUP ] [up] [master DEV] [vrf NAME] [type TYPE]\n"
> +		"	ip link show [ DEVICE | group GROUP ] [up] [master DEV] [vrf NAME] [type TYPE] [nomaster]\n"

this line is already too long so add the new options on a new line.

>  		"\n"
>  		"	ip link xstats type TYPE [ ARGS ]\n"
>  		"\n"
> diff --git a/ip/ipneigh.c b/ip/ipneigh.c
> index 95bde520..b4a2f6df 100644
> --- a/ip/ipneigh.c
> +++ b/ip/ipneigh.c
> @@ -54,7 +54,7 @@ static void usage(void)
>  		"		[ dev DEV ] [ router ] [ extern_learn ] [ protocol PROTO ]\n"
>  		"\n"
>  		"	ip neigh { show | flush } [ proxy ] [ to PREFIX ] [ dev DEV ] [ nud STATE ]\n"
> -		"				  [ vrf NAME ]\n"
> +		"				  [ vrf NAME ] [ nomaster ]\n"
>  		"	ip neigh get { ADDR | proxy ADDR } dev DEV\n"
>  		"\n"
>  		"STATE := { delay | failed | incomplete | noarp | none |\n"
> @@ -536,6 +536,8 @@ static int do_show_or_flush(int argc, char **argv, int flush)
>  			if (!name_is_vrf(*argv))
>  				invarg("Not a valid VRF name\n", *argv);
>  			filter.master = ifindex;
> +		} else if (strcmp(*argv, "nomaster") == 0) {
> +			filter.master = -1;
>  		} else if (strcmp(*argv, "unused") == 0) {
>  			filter.unused_only = 1;
>  		} else if (strcmp(*argv, "nud") == 0) {


