Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 272904363DD
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 16:15:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231169AbhJUORT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 10:17:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229878AbhJUORS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 10:17:18 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1109BC0613B9
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 07:15:03 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id n63so1022540oif.7
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 07:15:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=AieOc/K1d8+oS+AryIe4P7MSKrRVOEc29bIp3H51JMM=;
        b=l6vpSYhQUCDhLOkbsPj6mHf7w1T+4eAW0uLVBdAusxA1Np30f6rLXgPQEdYyZTaSpW
         dZL/xugFr8KNgCT4k9+mI0IHsnAjr/EkaUX2dLXqfldc/HjdlohXM6ZpDI11pH0ilk6T
         Y3BlFNT2kkOdVt/rSMw9mPbuKqefFsumTPrE7x1fsmDGvGjwDxrzWmltqoDy1yfOHEEB
         9WkfgoOQWsUAD3ODr6CG5kNYQT/mu/ZM5U2mykY+3fdegHkSnBwS4Llet8VcYIYHGIfL
         9chgaTH5SSkKEeMmfeuJ/Hu/H0KZb/DIuVUE5JTxHIPx9pd1+zzLDPqtfaXT1tpuNetj
         WSkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=AieOc/K1d8+oS+AryIe4P7MSKrRVOEc29bIp3H51JMM=;
        b=LXIYAwZTNINRGGf03XPKRD00/96tQg60kK93PA3vb7It/l9LpnN2DODEBQQ+WMh7zi
         6SofOqwKOjadpcXc6KIGNCcG9QykpFYonY9qSzn3ELmMebwVU+cMYc4NbIcwgliiuq9s
         zuORxesy0fXMe21z20stch9l15On0+NeDWgC0FwUlnk4E1d2gCisNPSIB/B5HpmGmm3y
         H9T/4ABEdS8hrFYXZQKKZwHamhZ4b8PbNBye5otiQOETlRi+taNZtviuQAADk+5Uv4+f
         iCKqyVS52qhNw8MCnxXMmT0jz0SCyvwNUPcqPfHSudJr1RZIJVlwWhY9xybyE7EqpUf/
         LknA==
X-Gm-Message-State: AOAM530Ji9YB/nMUaWQh0OVZ6JlfEpvNlUGGVvQ8MopVIMLE9FF8Ktqd
        63kPQD7nFzGPY2IBOuxgzcY=
X-Google-Smtp-Source: ABdhPJwDUundAnX59r2D99D39bk3lwCkNC7r2rX3U9KM/wzFzsT9RL/kepUHIgvPHP9Qwp/ASPDdig==
X-Received: by 2002:aca:3656:: with SMTP id d83mr5055763oia.176.1634825702179;
        Thu, 21 Oct 2021 07:15:02 -0700 (PDT)
Received: from [172.16.0.2] ([8.48.134.34])
        by smtp.googlemail.com with ESMTPSA id v5sm1080453oix.6.2021.10.21.07.15.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Oct 2021 07:15:01 -0700 (PDT)
Message-ID: <dc0b9353-0eea-63e2-ccba-681bd07288b0@gmail.com>
Date:   Thu, 21 Oct 2021 08:15:00 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.0
Subject: Re: [PATCH v5 2/2] net: ndisc: introduce ndisc_evict_nocarrier sysctl
 parameter
Content-Language: en-US
To:     James Prestwood <prestwoj@gmail.com>, netdev@vger.kernel.org
References: <20211021003212.878786-1-prestwoj@gmail.com>
 <20211021003212.878786-3-prestwoj@gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20211021003212.878786-3-prestwoj@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/20/21 6:32 PM, James Prestwood wrote:
> diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
> index 184190b9ea25..4db58c29ab53 100644
> --- a/net/ipv6/ndisc.c
> +++ b/net/ipv6/ndisc.c
> @@ -1810,10 +1811,16 @@ static int ndisc_netdev_event(struct notifier_block *this, unsigned long event,
>  		in6_dev_put(idev);
>  		break;
>  	case NETDEV_CHANGE:
> +		idev = in6_dev_get(dev);
> +		if (!idev)
> +			evict_nocarrier = true;
> +		else
> +			evict_nocarrier = idev->cnf.ndisc_evict_nocarrier;
> +

missing in6_dev_put here


>  		change_info = ptr;
>  		if (change_info->flags_changed & IFF_NOARP)
>  			neigh_changeaddr(&nd_tbl, dev);
> -		if (!netif_carrier_ok(dev))
> +		if (evict_nocarrier && !netif_carrier_ok(dev))
>  			neigh_carrier_down(&nd_tbl, dev);
>  		break;
>  	case NETDEV_DOWN:
> 

