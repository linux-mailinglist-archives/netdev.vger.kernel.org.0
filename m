Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA5123E4E49
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 23:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236393AbhHIVMF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 17:12:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbhHIVMF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 17:12:05 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CC81C0613D3
        for <netdev@vger.kernel.org>; Mon,  9 Aug 2021 14:11:44 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id gs8so31277883ejc.13
        for <netdev@vger.kernel.org>; Mon, 09 Aug 2021 14:11:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UA7hYWuVSGkJdUHSbZwH7c8vTylXPNawIPoB6hnqjAY=;
        b=Qq+b7FH92RNrB0qTJ6xSRNAtFrdhCUdHDnLLupHDbfNpYgvi4tE/Xc5YwCf3J11biu
         3oNwrx5UKVlo4lLEi/JcyenIpuISEE2DlnVjyt9a9MiJ4g9TDsBC/vTMmLgEzpZD605n
         cinINw0iXCeYhJKH7uNMOUoR64sQJUBzSrWRLe+wy4Ux7ZB929OFngvd+0Y8Ua9vdZQc
         0gy/USp8th1HYjIl+Oul7Vq06dEor5tIxQJzLwF54jAS1/daCM+5JS1gPZgZ+URbyCBs
         Zd2+WJsVv0Dq2BXHH/tBMQ1u6wXZkAl/EwUOwfSgepuGmc57EnvChOP61IOVNAK5Kw1z
         ClOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UA7hYWuVSGkJdUHSbZwH7c8vTylXPNawIPoB6hnqjAY=;
        b=IwM2PbIS2TkeaGyvbWjpzAnn9aUTUZCAZiJDCGQrrsVwNlrqQvxuvKawkewA1kOSH8
         J/ngms2rEkW3xHeIdk6A4kWHozK21VsbSlPRU8RxoUDNvU8Tl8m0SAz+sMSPthDhxW+Z
         f6eRx31DGs1ciPx3W0UMKCAr6j3/cKKHQZid17oLhKGOcavb7rzFUPKFlq2GrWFTmfv6
         3r/KipQrQrGMIHkb+l7wnnQLlBlVBcBd1kZG90DR2eynngyj4tb0NryFe9jepI7ZQZyl
         qmZvopsl7BKLiM7x68Z58RFq5Bdy7i8LiAZSyU6nyoyhIB60zx6RB8XXuODEe5tCjlay
         w5NQ==
X-Gm-Message-State: AOAM531RmJujBbAgqjGD+Dl1jjx276Yu5L1BDoAU1UuwHWCxUDBazBEq
        O/K4yb5FGI5Bq0tLOLRYgfs=
X-Google-Smtp-Source: ABdhPJwDwjdVrVNxnk9DkGk2xQZ7C+O5DrS3E3RZTsOFSbElia+EOOFZvSpki3rRdIXrmBjPKaf7hQ==
X-Received: by 2002:a17:906:c055:: with SMTP id bm21mr24780163ejb.350.1628543502608;
        Mon, 09 Aug 2021 14:11:42 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id kk14sm799268ejc.29.2021.08.09.14.11.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 14:11:42 -0700 (PDT)
Date:   Tue, 10 Aug 2021 00:11:40 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Anton Danilov <littlesmilingcloud@gmail.com>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org
Subject: Re: [PATCH iproute2] bridge: fdb: the 'dynamic' option in the
 show/get commands
Message-ID: <20210809211140.utmgqj6lse7kldrk@skbuf>
References: <20200727132606.251041-1-littlesmilingcloud@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200727132606.251041-1-littlesmilingcloud@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Anton,

On Mon, Jul 27, 2020 at 04:26:07PM +0300, Anton Danilov wrote:
> In most of cases a user wants to see only the dynamic mac addresses
> in the fdb output. But currently the 'fdb show' displays tons of
> various self entries, those only waste the output without any useful
> goal.
> 
> New option 'dynamic' for 'show' and 'get' commands forces display
> only relevant records.
> 
> Signed-off-by: Anton Danilov <littlesmilingcloud@gmail.com>
> ---
>  bridge/fdb.c      | 17 +++++++++++++----
>  man/man8/bridge.8 | 30 ++++++++++++++++++------------
>  2 files changed, 31 insertions(+), 16 deletions(-)
> 
> diff --git a/bridge/fdb.c b/bridge/fdb.c
> index 710dfc99..78aaaa5a 100644
> --- a/bridge/fdb.c
> +++ b/bridge/fdb.c
> @@ -30,7 +30,8 @@
>  #include "rt_names.h"
>  #include "utils.h"
>  
> -static unsigned int filter_index, filter_vlan, filter_state, filter_master;
> +static unsigned int filter_index, filter_dynamic, filter_master,
> +	filter_state, filter_vlan;
>  
>  static void usage(void)
>  {
> @@ -40,9 +41,10 @@ static void usage(void)
>  		"              [ sticky ] [ local | static | dynamic ] [ dst IPADDR ]\n"
>  		"              [ vlan VID ] [ port PORT] [ vni VNI ] [ via DEV ]\n"
>  		"              [ src_vni VNI ]\n"
> -		"       bridge fdb [ show [ br BRDEV ] [ brport DEV ] [ vlan VID ] [ state STATE ] ]\n"
> -		"       bridge fdb get ADDR [ br BRDEV ] { brport |dev }  DEV [ vlan VID ]\n"
> -		"              [ vni VNI ]\n");
> +		"       bridge fdb [ show [ br BRDEV ] [ brport DEV ] [ vlan VID ]\n"
> +		"              [ state STATE ] [ dynamic ] ]\n"
> +		"       bridge fdb get [ to ] LLADDR [ br BRDEV ] { brport | dev } DEV\n"
> +		"              [ vlan VID ] [ vni VNI ] [ self ] [ master ] [ dynamic ]\n");
>  	exit(-1);
>  }
>  
> @@ -167,6 +169,9 @@ int print_fdb(struct nlmsghdr *n, void *arg)
>  	if (filter_vlan && filter_vlan != vid)
>  		return 0;
>  
> +	if (filter_dynamic && (r->ndm_state & NUD_PERMANENT))
> +		return 0;
> +
>  	open_json_object(NULL);
>  	if (n->nlmsg_type == RTM_DELNEIGH)
>  		print_bool(PRINT_ANY, "deleted", "Deleted ", true);
> @@ -322,6 +327,8 @@ static int fdb_show(int argc, char **argv)
>  			if (state_a2n(&state, *argv))
>  				invarg("invalid state", *argv);
>  			filter_state |= state;
> +		} else if (strcmp(*argv, "dynamic") == 0) {
> +			filter_dynamic = 1;
>  		} else {
>  			if (matches(*argv, "help") == 0)
>  				usage();
> @@ -566,6 +573,8 @@ static int fdb_get(int argc, char **argv)
>  				duparg2("vlan", *argv);
>  			NEXT_ARG();
>  			vlan = atoi(*argv);
> +		} else if (matches(*argv, "dynamic") == 0) {
> +			filter_dynamic = 1;
>  		} else {
>  			if (strcmp(*argv, "to") == 0)
>  				NEXT_ARG();
> diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
> index 71f2e890..5aa83e15 100644
> --- a/man/man8/bridge.8
> +++ b/man/man8/bridge.8
> @@ -77,12 +77,12 @@ bridge \- show / manipulate bridge addresses and devices
>  .B port
>  .IR PORT " ] ["
>  .B via
> -.IR DEVICE " ]"
> +.IR DEVICE " ] ["
> +.B src_vni
> +.IR VNI " ]"
>  
>  .ti -8
> -.BR "bridge fdb" " [ " show " ] [ "
> -.B dev
> -.IR DEV " ] [ "
> +.BR "bridge fdb" " [ [ " show " ] [ "
>  .B br
>  .IR BRDEV " ] [ "
>  .B brport
> @@ -90,18 +90,24 @@ bridge \- show / manipulate bridge addresses and devices
>  .B vlan
>  .IR VID " ] [ "
>  .B state
> -.IR STATE " ]"
> +.IR STATE " ] ["
> +.B dynamic
> +.IR "] ]"
>  
>  .ti -8
> -.B bridge fdb get
> -.I LLADDR " [ "
> -.B dev
> -.IR DEV " ] [ "
> +.BR "bridge fdb get" " ["
> +.B to
> +.IR "]"
> +.I LLADDR "[ "
>  .B br
> -.IR BRDEV " ] [ "
> +.IR BRDEV " ]"
> +.B { brport | dev }
> +.IR DEV " [ "
>  .B vlan
> -.IR VID  " ] ["
> -.BR self " ] [ " master " ]"
> +.IR VID  " ] [ "
> +.B vni
> +.IR VNI " ] ["
> +.BR self " ] [ " master " ] [ " dynamic " ]"
>  
>  .ti -8
>  .BR "bridge mdb" " { " add " | " del " } "
> -- 
> 2.27.0
> 

Are the 'static' entries 'dynamic'?

bridge fdb add dev sw0p2 00:01:02:03:04:05 master static
bridge fdb show dev sw0p2 dynamic | grep 00:01:02:03:04:05
00:01:02:03:04:05 vlan 1 offload master br0 static
00:01:02:03:04:05 offload master br0 static
