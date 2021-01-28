Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A44C306C15
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 05:19:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231386AbhA1EPc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 23:15:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231337AbhA1EPL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 23:15:11 -0500
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 098BCC061794
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 19:52:02 -0800 (PST)
Received: by mail-oi1-x22b.google.com with SMTP id p5so4645030oif.7
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 19:52:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dLjsEotKD44k7zbRbXP+ccEF7hXQAy5VN+lfZ+i3BWY=;
        b=YmKJhGZDQqSZMHXGKzhsp91vJneTFoMtA7yNNXjUuCWOigx7tPNSGiptzx/O3m+SiA
         uQlxkZhu3uwDdwWp2uKacckeOa4p59jDz3JslcDyoAVCJ+pON9EAOyz4+ldRsMnC/jL0
         cvRPpSexF1Wok5nB+w/6/M2/g4ekaHHQFlQWfQ69NjeIGOXoOBWZeIFY1Gq2X5bhMrW7
         69A7Gc93fEVmfuY6Q6uTmlYP+d71kQBlBNxUTaVKRK9HiZU2nYq/jK7Y3ckp42QXQGAh
         3NRMSZjUyGFc/Mu8z2D99WB+D/CCk/vCbQdQTzkH5aPCSYGfMnqo59JYO6T7bIlNecG4
         BccQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dLjsEotKD44k7zbRbXP+ccEF7hXQAy5VN+lfZ+i3BWY=;
        b=qBxITg/oyVIFf8F6KnqO1qk6WoADPZUBMT6Ty3w02eOkSQ+hvmYd1gHXhECi0tHCJS
         3k4NBF60eUhNiEufH2sEL9v7BjH8wOo/hkEvhUlTR1s09nxC23QRSpGrMmU8CKrbXQHc
         GcK4md7EMeL51zIs1enoSgujz+E9x7nKv50c6hXiBtc4bU7yMjup6bYgD5CFQoWYXfb4
         YeVkqay+Fc4Tnil8B84jQN8szl5aZSLKmkqMcio4iikKXywsdVr8G/xkR2dExTKKmffz
         P5ufuKmwbvcvhn2YlQcI7DmCZDOKtdy4TK8hg+xmhXZhDz3epU5ySlz8KfKS/70BVA9t
         qUgQ==
X-Gm-Message-State: AOAM530J8SVyLzU8WLd5UM3XyYjZHefOpm9TYeVs81JV2/70OaLkCBM6
        520O+TciF5uTvsYscJe42iw=
X-Google-Smtp-Source: ABdhPJziae5ptSN/ksdumK7UgetH0MTdhQmHMPXrKeLrfyrXOmTGWUUn9mIDpS6egEohJ1MJ1E8nPA==
X-Received: by 2002:a54:4e03:: with SMTP id a3mr5477060oiy.108.1611805921545;
        Wed, 27 Jan 2021 19:52:01 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.50])
        by smtp.googlemail.com with ESMTPSA id t16sm777663otq.17.2021.01.27.19.52.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Jan 2021 19:52:00 -0800 (PST)
Subject: Re: [PATCH iproute2-next v2 1/2] iplink: print warning for missing VF
 data
To:     Edwin Peer <edwin.peer@broadcom.com>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Andrew Gospodarek <andrew.gospodarek@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Michal Kubecek <mkubecek@suse.cz>
References: <20210126174054.185084-1-edwin.peer@broadcom.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <4e6dac6d-7b2a-ada4-6168-87a1b5f36a0c@gmail.com>
Date:   Wed, 27 Jan 2021 20:51:56 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210126174054.185084-1-edwin.peer@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/26/21 10:40 AM, Edwin Peer wrote:
> The kernel might truncate VF info in IFLA_VFINFO_LIST. Compare the
> expected number of VFs in IFLA_NUM_VF to how many were found in the
> list and warn accordingly.
> 
> Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
> ---
>  ip/ipaddress.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/ip/ipaddress.c b/ip/ipaddress.c
> index 571346b15cc3..0bbcee2b3bb2 100644
> --- a/ip/ipaddress.c
> +++ b/ip/ipaddress.c
> @@ -922,6 +922,7 @@ int print_linkinfo(struct nlmsghdr *n, void *arg)
>  	const char *name;
>  	unsigned int m_flag = 0;
>  	SPRINT_BUF(b1);
> +	bool truncated_vfs = false;
>  
>  	if (n->nlmsg_type != RTM_NEWLINK && n->nlmsg_type != RTM_DELLINK)
>  		return 0;
> @@ -1199,15 +1200,18 @@ int print_linkinfo(struct nlmsghdr *n, void *arg)
>  
>  	if ((do_link || show_details) && tb[IFLA_VFINFO_LIST] && tb[IFLA_NUM_VF]) {
>  		struct rtattr *i, *vflist = tb[IFLA_VFINFO_LIST];
> -		int rem = RTA_PAYLOAD(vflist);
> +		int rem = RTA_PAYLOAD(vflist), count = 0;
>  
>  		open_json_array(PRINT_JSON, "vfinfo_list");
>  		for (i = RTA_DATA(vflist); RTA_OK(i, rem); i = RTA_NEXT(i, rem)) {
>  			open_json_object(NULL);
>  			print_vfinfo(fp, ifi, i);
>  			close_json_object();
> +			count++;
>  		}
>  		close_json_array(PRINT_JSON, NULL);
> +		if (count != rta_getattr_u32(tb[IFLA_NUM_VF]))
> +			truncated_vfs = true;
>  	}
>  
>  	if (tb[IFLA_PROP_LIST]) {
> @@ -1228,6 +1232,9 @@ int print_linkinfo(struct nlmsghdr *n, void *arg)
>  
>  	print_string(PRINT_FP, NULL, "%s", "\n");
>  	fflush(fp);
> +	/* prettier here if stderr and stdout go to the same place */
> +	if (truncated_vfs)
> +		fprintf(stderr, "Truncated VF list: %s\n", name);
>  	return 1;
>  }
>  
> 

LGTM. I think it should go to the main branch versus -next.
