Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FAAF29BD0
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 18:08:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390346AbfEXQIc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 12:08:32 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:46832 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389888AbfEXQIb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 12:08:31 -0400
Received: by mail-pg1-f196.google.com with SMTP id o11so684500pgm.13
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 09:08:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OBjekqXTaIYagGeHbNnOLG1Qs3CYmYihsglQhVomIIA=;
        b=jng1ylerFYFgINJEVMm4NDYv09Qa1aSPPjGRCVY7wAWLlDLWdlCCLQjnywWwTxi/uv
         h7NZ05gfW4Ak5x2l5uIQdq3Ye9MYPjwQ6cfynAcSQD80RYuoxVGHl/WkN2/U6nNNTbFk
         eeaGc9o0Q9xuGoHjjr3m7ZnTPNvyh75Pw4NLAOXK812USpIGHbAJnX1bVukhGSOz65rw
         mVtC2zTEjIqnhUq4LFl6yzE7N+PC73WxGDyMm2+pyRk34YjyaDDpLXYdwsVHn/JWmZSI
         3gtfgI4tih7f5o0R41Hkdb6WPnTTB7gF7zBqwVNHGbx6Mr7H1Qa4oKpwWJeowH7KwF0D
         UVCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OBjekqXTaIYagGeHbNnOLG1Qs3CYmYihsglQhVomIIA=;
        b=JYiuiy7uAxGroZefdWSjGz9n6ibyHsB7VECl2CnzPM6mMH0VcpbdhW23JTkDrq85KJ
         71c4RymI9pIX3mVwtw9o8llrTsN/oa0MS6ynqPabpYS+9tgAbD+jYrYp9uavUdLjvi9Q
         0oeiWYXsEeNx+oTTsfKQoJuiZAbmfD+DnIDg8YmaPY4k/6TyA4PHWAcHx9b3LzaAs3My
         wtInUXQ9kaapx6H+l7iubdwcgggqAwhdoFzGT1AcwYGkflXuOQm8MJCojVvFtEBTcml1
         yLwUCzaQShQxbQjhVnisGd9DgLTe/pEbMlHJ/MakQ8AbPkyQbEP8Nk1DoyxY+B9lkISQ
         NTOA==
X-Gm-Message-State: APjAAAX3HkISu81k//Ij7tB4ojVofOSQX0ZPqTYZ0Rdy44ldNek5WoYD
        WX9ySIl6j+qSxwlCwoay/j8T6qWx
X-Google-Smtp-Source: APXvYqzvrIEdMUvJdHSAvefLGq5kuBwJaCTI/icQgQ1NCE1qOGSUBn9UOXe0AhnjeDwF16WbPU2zWA==
X-Received: by 2002:a17:90a:b004:: with SMTP id x4mr10347566pjq.60.1558714110671;
        Fri, 24 May 2019 09:08:30 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:59ee:6a57:8906:e2a1? ([2601:282:800:fd80:59ee:6a57:8906:e2a1])
        by smtp.googlemail.com with ESMTPSA id k3sm3126551pfa.36.2019.05.24.09.08.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 May 2019 09:08:29 -0700 (PDT)
Subject: Re: [PATCH iproute2] lib: suppress error msg when filling the cache
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        stephen@networkplumber.org
Cc:     netdev@vger.kernel.org,
        Philippe Guibert <philippe.guibert@6wind.com>
References: <20190524085910.16018-1-nicolas.dichtel@6wind.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <bc4ad34f-96d4-68e2-a67e-afa9e391906e@gmail.com>
Date:   Fri, 24 May 2019 10:08:28 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190524085910.16018-1-nicolas.dichtel@6wind.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/24/19 2:59 AM, Nicolas Dichtel wrote:
> Before the patch:
> $ ip netns add foo
> $ ip link add name veth1 address 2a:a5:5c:b9:52:89 type veth peer name veth2 address 2a:a5:5c:b9:53:90 netns foo
> RTNETLINK answers: No such device
> RTNETLINK answers: No such device
> 
> But the command was successful. This may break script. Let's remove those
> error messages.
> 
> Fixes: 55870dfe7f8b ("Improve batch and dump times by caching link lookups")
> Reported-by: Philippe Guibert <philippe.guibert@6wind.com>
> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> ---
>  lib/ll_map.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/ll_map.c b/lib/ll_map.c
> index 2d7b65dcb8f7..e0ed54bf77c9 100644
> --- a/lib/ll_map.c
> +++ b/lib/ll_map.c
> @@ -177,7 +177,7 @@ static int ll_link_get(const char *name, int index)
>  		addattr_l(&req.n, sizeof(req), IFLA_IFNAME, name,
>  			  strlen(name) + 1);
>  
> -	if (rtnl_talk(&rth, &req.n, &answer) < 0)
> +	if (rtnl_talk_suppress_rtnl_errmsg(&rth, &req.n, &answer) < 0)
>  		goto out;
>  
>  	/* add entry to cache */
> 

In general, ll_link_get suppressing the error message seems like the
right thing to do.

For the example above, seems like nl_get_ll_addr_len is the cause of the
error messages, and it should not be called for this use case (NEWLINK
with NLM_F_CREATE set)
