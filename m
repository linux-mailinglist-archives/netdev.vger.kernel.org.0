Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F71A39E3F4
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 18:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234631AbhFGQ2g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 12:28:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232573AbhFGQ0W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 12:26:22 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A981C0604C5;
        Mon,  7 Jun 2021 09:20:57 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id i12-20020a05683033ecb02903346fa0f74dso17250157otu.10;
        Mon, 07 Jun 2021 09:20:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=NCnduflce68YkMnn3i+unqWk8SYuVU7hs0nySniBIqo=;
        b=NqbK6nDyy6LvMfquS66sa0nUEDrX7atPQMGjlhl1ZFugtyvAjezaTleeVNnhdRGWLa
         F7CYeHqE0qgkFY83UNGtW7eeCDZSjh8M37KwkDrJIQZHNwpi63a2pXWE/noNkEJTM9IE
         ZXdYL3H3/JO6REQrqENp2NSQHg0rNwDsSZdx1Q7tfboer6KbJK69LGRx2xx6rCRa8sOI
         SEQeI8HjFtX37olEP/ILtonHJAX+Q9X2CgWfIC2mJei4KroAgWcoDTOQ0qyjeXbi/WtW
         UKHcRmo7GNTu/y22jVmJwv/hwT/DNQcRKgpdPC6IfPT4fDNCz2/cV6NOeAH3Ni+O4cwu
         xQvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NCnduflce68YkMnn3i+unqWk8SYuVU7hs0nySniBIqo=;
        b=cjmAyet+sy6sZT83+oAbKXpFThZWZ3Z6k4gSJnwyu53cAf77hyDADxZp+NJrI8FJXd
         lBTmqteH2gdOc6ab6LT+4Y1PNHoGrcS43EDLQOeGzD/lw4yBcgAHl2JAefUvVNwDADPq
         d5MdBgQ8T+As4bf28OrBtceiJ1QWXVR86Nk0NunYUnm7zMhhoox1qoc2BU+xiNwK99nk
         yay0vpE0ZPbH3Wt8NAbFqz3xmqf3VmCSrF4ZgwEFqs7rEd7vn2/2InCEXoY5N9HEw3vB
         jZqrtxVDhuBttoPXti6wDBXhpAqgLBLoiHJqaj4ZE3+JbU6khnh48eo/aM4EPAXq2NVR
         Gw6w==
X-Gm-Message-State: AOAM531ROZdzfdiBI0CHAT7UxaXT+a8BltHL2dnRtTKrVAC+1QscQCnx
        qoXHst8FKJf43a36VtuCMebKcuh1FdE=
X-Google-Smtp-Source: ABdhPJxWDfzJm1mcMJbUJOfYtNE2NGOlVfTBtBG+2Py222H6hSWCZ8dmX9wMmAqIVaN1ckkVGiq1ow==
X-Received: by 2002:a05:6830:1d72:: with SMTP id l18mr2388313oti.150.1623082856345;
        Mon, 07 Jun 2021 09:20:56 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.22])
        by smtp.googlemail.com with ESMTPSA id n17sm2372879oij.57.2021.06.07.09.20.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Jun 2021 09:20:56 -0700 (PDT)
Subject: Re: [PATCH net-next] net: ipv4: Remove unneed BUG() function
To:     Zheng Yongjun <zhengyongjun3@huawei.com>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210607143909.2844407-1-zhengyongjun3@huawei.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <9274e18e-dc57-f6c2-e0cc-0d06841df54e@gmail.com>
Date:   Mon, 7 Jun 2021 10:20:54 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210607143909.2844407-1-zhengyongjun3@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/7/21 8:39 AM, Zheng Yongjun wrote:
> When 'nla_parse_nested_deprecated' failed, it's no need to
> BUG() here, return -EINVAL is ok.
> 
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
> ---
>  net/ipv4/devinet.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
> index 2e35f68da40a..1c6429c353a9 100644
> --- a/net/ipv4/devinet.c
> +++ b/net/ipv4/devinet.c
> @@ -1989,7 +1989,7 @@ static int inet_set_link_af(struct net_device *dev, const struct nlattr *nla,
>  		return -EAFNOSUPPORT;
>  
>  	if (nla_parse_nested_deprecated(tb, IFLA_INET_MAX, nla, NULL, NULL) < 0)

Avoid assumptions on the failure reason:

	int err;

	err = nla_parse_nested_deprecated();
	if (err < 0)
		return err;

> -		BUG();
> +		return -EINVAL;
>  
>  	if (tb[IFLA_INET_CONF]) {
>  		nla_for_each_nested(a, tb[IFLA_INET_CONF], rem)
> 

seems like this patch and a similar fix for the IPv6 version of
set_link_af should go to net rather than net-next.

