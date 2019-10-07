Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70A71CEE7D
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 23:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729005AbfJGVh1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 17:37:27 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:37941 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728753AbfJGVh0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 17:37:26 -0400
Received: by mail-pg1-f194.google.com with SMTP id x10so9004043pgi.5
        for <netdev@vger.kernel.org>; Mon, 07 Oct 2019 14:37:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XdvqDVy8gO/+3SYTEk92oGWRWLr5CD7gQohiqxWPpKc=;
        b=LOxbT4O14nmbSdE+Lo8kg7+GqmA6rSvdU83/btJm087R65TlTt3h3S2IPJKeLvsE33
         uMAlZbP14Ki6ATN8PjVxFxiOgpyxs08Kq+1J6oAfDlSTPYuemPK0n3QCihM0C2VI6ztG
         TxIZRvbS1jXlnA6ZW/RxH9pOkev6bNHt/yRg/CDq/NY0Ai77gwOw1fHADHhLt1cNCFFr
         fi4+S6xiryQBYB8vnGKxfIbquTfAOXjHO45FmMPF8Pvqeb5KQTz8oh8ebR0Kkf17OiO9
         rpHjxGV5i+ycKVa0RBTg7XwNkry7AD8Vc1KHaKBnJCUYkNsTYxoB/4Jqd0CUYbd0sQ7K
         HfCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XdvqDVy8gO/+3SYTEk92oGWRWLr5CD7gQohiqxWPpKc=;
        b=NHQVg/ivEaKJut8gaJnWPVm9/m5KFr3qvLXaceBtw5KUYlMP4UvDLWl//DMqgM+cTd
         Of1nRALbQMCgjrKdaj0HV9pRjWiqeNT+qB5x/6kMaaOi8Qy1H91jopfn9SG2R+jXLgd1
         2H6qLenEZUtH2BrthjXRWxlKCUe/LGOU/7kKUrewWuRIMjyLCSq3FS7pXxL5uN4l1/sz
         j3/nvYy9WXazScm7LP2n/gqwfYt6ARpSsFqVa4OCFBq7UYtI9tqCDGJQge+7TOkRaBel
         H94qXMAJ+dEwP/6VPHtQ1hWo41/nr3wcfHPIt7WONpZvbAHnCP6eQknBX1H0EYE7JW7z
         P2QQ==
X-Gm-Message-State: APjAAAVfeW5TzOXdeDzOT0up5JHYu+kN9Uaxz3WINW3nvrfsKGy3K6pw
        ZSLu2YDP+cPQvYNUTimGB9s=
X-Google-Smtp-Source: APXvYqzDSQhu0j1svJAcXTUeE4P+W/LuXHB2defHRISCW9z8+EWmGxbR1Cg9ccxJPcYSuOCDr04mUw==
X-Received: by 2002:a65:6285:: with SMTP id f5mr19681506pgv.238.1570484245959;
        Mon, 07 Oct 2019 14:37:25 -0700 (PDT)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:dc58:1abd:13a8:f485])
        by smtp.googlemail.com with ESMTPSA id b20sm17221037pff.158.2019.10.07.14.37.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 07 Oct 2019 14:37:24 -0700 (PDT)
Subject: Re: [patch iproute2-next v2 1/2] ip: add support for alternative name
 addition/deletion/list
To:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        roopa@cumulusnetworks.com, dcbw@redhat.com,
        nikolay@cumulusnetworks.com, mkubecek@suse.cz, andrew@lunn.ch,
        parav@mellanox.com, saeedm@mellanox.com, f.fainelli@gmail.com,
        stephen@networkplumber.org, sd@queasysnail.net, sbrivio@redhat.com,
        pabeni@redhat.com, mlxsw@mellanox.com
References: <20191002105645.30756-1-jiri@resnulli.us>
 <20191002105645.30756-2-jiri@resnulli.us>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <48c341d6-d611-3f4e-a64d-85719af7ed45@gmail.com>
Date:   Mon, 7 Oct 2019 15:37:21 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191002105645.30756-2-jiri@resnulli.us>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/2/19 4:56 AM, Jiri Pirko wrote:
> diff --git a/ip/iplink.c b/ip/iplink.c
> index 212a088535da..e3f8a28fe94c 100644
> --- a/ip/iplink.c
> +++ b/ip/iplink.c
> @@ -111,7 +111,9 @@ void iplink_usage(void)
>  		"\n"
>  		"	ip link xstats type TYPE [ ARGS ]\n"
>  		"\n"
> -		"	ip link afstats [ dev DEVICE ]\n");
> +		"	ip link afstats [ dev DEVICE ]\n"
> +		"	ip link prop add dev DEVICE [ altname NAME .. ]\n"
> +		"	ip link prop del dev DEVICE [ altname NAME .. ]\n");

spell out 'property' here. The matches below on "prop" is fine, but the
help can show the full name.


> +
> +	if (matches(*argv, "add") == 0) {
> +		req.n.nlmsg_flags |= NLM_F_EXCL | NLM_F_CREATE | NLM_F_APPEND;
> +		req.n.nlmsg_type = RTM_NEWLINKPROP;
> +	} else if (matches(*argv, "del") == 0) {
> +		req.n.nlmsg_flags |= RTM_DELLINK;

RTM_DELLINK is a command not a netlink flag.


> +		req.n.nlmsg_type = RTM_DELLINKPROP;
> +	} else if (matches(*argv, "help") == 0) {
> +		usage();
> +	} else {
> +		fprintf(stderr, "Operator required\n");
> +		exit(-1);
> +	}
> +	return iplink_prop_mod(argc - 1, argv + 1, &req);
> +}
> +
>  static void do_help(int argc, char **argv)
>  {
>  	struct link_util *lu = NULL;
>

> diff --git a/lib/utils.c b/lib/utils.c
> index 95d46ff210aa..bbb3bdcfa80b 100644
> --- a/lib/utils.c
> +++ b/lib/utils.c
> @@ -824,14 +824,10 @@ int nodev(const char *dev)
>  	return -1;
>  }
>  
> -int check_ifname(const char *name)
> +static int __check_ifname(const char *name)
>  {
> -	/* These checks mimic kernel checks in dev_valid_name */
>  	if (*name == '\0')
>  		return -1;
> -	if (strlen(name) >= IFNAMSIZ)
> -		return -1;
> -
>  	while (*name) {
>  		if (*name == '/' || isspace(*name))
>  			return -1;
> @@ -840,6 +836,19 @@ int check_ifname(const char *name)
>  	return 0;
>  }
>  
> +int check_ifname(const char *name)
> +{
> +	/* These checks mimic kernel checks in dev_valid_name */
> +	if (strlen(name) >= IFNAMSIZ)
> +		return -1;
> +	return __check_ifname(name);
> +}
> +
> +int check_altifname(const char *name)
> +{
> +	return __check_ifname(name);
> +}
> +
>  /* buf is assumed to be IFNAMSIZ */
>  int get_ifname(char *buf, const char *name)
>  {
> diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
> index a8ae72d2b097..7cb4d56726d8 100644
> --- a/man/man8/ip-link.8.in
> +++ b/man/man8/ip-link.8.in
> @@ -244,6 +244,17 @@ ip-link \- network device configuration
>  .IR VLAN-QOS " ] ["
>  .B proto
>  .IR VLAN-PROTO " ] ]"
> +.in -8
> +
> +.ti -8
> +.BI "ip link prop add"
> +.RB "[ " altname
> +.IR NAME " .. ]"
> +
> +.ti -8
> +.BI "ip link prop del"
> +.RB "[ " altname
> +.IR NAME " .. ]"
>  
>  .SH "DESCRIPTION"
>  .SS ip link add - add virtual link
> 

