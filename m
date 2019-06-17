Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78DFB48438
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 15:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726243AbfFQNjA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 09:39:00 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:45476 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725973AbfFQNjA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 09:39:00 -0400
Received: by mail-io1-f65.google.com with SMTP id e3so21080122ioc.12
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 06:38:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=//pA/IsftzJeCh0PJhV/KXqgwznXQR4nG+ODrLNY/fE=;
        b=YbX6Fmg+Y19JcITycDwiwDeVqlg0Bvc0s9AshEjOKFi2Twst+YYaZMwvkecyoCPqbs
         vouPHEAwwy4vwN74KRuYnOSgIVGfxsbW7JHdA7V1DbbbP17KZvVMOeKQShmP29tRMBn+
         8LK340DXAWfRQzRnq78qzKRxFVsuwn8vsGfIw1a/BP9nyTJD48zIPE3JjkPe4+OcPHco
         g9cKnaZ5PmjOexFTKKUiA0vgUieBI7qYSDN4/pUeTRqq/vQKAuddT9NSYIg+IESeeh9w
         xFQTHkFA+IQSqz5xlZjeyLfB1xu4gQlwaJf7x+hMwLB4IeklXtlTHBdM9LrWDnUs7j74
         BdwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=//pA/IsftzJeCh0PJhV/KXqgwznXQR4nG+ODrLNY/fE=;
        b=eT+52kfBsWDtHGSpS/+o0+y0Bw3sbac5BoheHTkuiyIB/RMpUcil6QZ/KEFaAi/XIQ
         kNRIhXNHDPUyKI+O3WPHhnxdi5QiTB+n1HDqx4PcUm8mTY9MUacPw85TV/GI9yqv3EaJ
         FCsBMKqMw03IPcJjDexWgZbdOqm57KtGAQqFZFeEjZs3HlLUOzcskuTJFNTPU/ojLS4S
         JEAFrCTifgm1LBON92X0TxaGyLqSTkyNV0TOmGbfH75gfp/wwPvMv3HBK9jGwuNqq55N
         F3b0x+Avim/H7zHavIsFGcanVqGU5Q+7HNJZ91cHpOhy3VtaOVoQyh33rx0Sg9BR7UUB
         9Bgw==
X-Gm-Message-State: APjAAAUiJWcNR/XlildpygJuRHKwnbbJxPiXuRY+sTYVvRC4loppl17N
        6pB6LRLCK6GtPKZT9GalDdyldvF1
X-Google-Smtp-Source: APXvYqwVg6HPvI9V2AlRAYGbWVw96D/GfDGamRVD8By0j4rQmguaeYE8vjWm5POm8KtNfXVNdKJZiA==
X-Received: by 2002:a5d:80c3:: with SMTP id h3mr8403625ior.167.1560778739123;
        Mon, 17 Jun 2019 06:38:59 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:f1:4f12:3a05:d55e? ([2601:282:800:fd80:f1:4f12:3a05:d55e])
        by smtp.googlemail.com with ESMTPSA id p63sm13574155iof.45.2019.06.17.06.38.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jun 2019 06:38:58 -0700 (PDT)
Subject: Re: [PATCH net v4 1/8] ipv4/fib_frontend: Rename
 ip_valid_fib_dump_req, provide non-strict version
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     David Miller <davem@davemloft.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Jianlin Shi <jishi@redhat.com>, Wei Wang <weiwan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        netdev@vger.kernel.org
References: <cover.1560561432.git.sbrivio@redhat.com>
 <fb2bbc9568a7d7d21a00b791a2d4f488cfcd8a50.1560561432.git.sbrivio@redhat.com>
 <4dfbaf6a-5cff-13ea-341e-2b1f91c25d04@gmail.com>
 <20190615051342.7e32c2bb@redhat.com>
 <d780b664-bdbd-801f-7c61-d4854ff26192@gmail.com>
 <20190615052705.66f3fe62@redhat.com> <20190616220417.573be9a6@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <d3527e70-15aa-abf8-4451-91e5bae4f1ab@gmail.com>
Date:   Mon, 17 Jun 2019 07:38:54 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190616220417.573be9a6@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/16/19 2:04 PM, Stefano Brivio wrote:
> We could do this:
> 
> - strict checking enabled (iproute2 >= 5.0.0):
>   - in inet{,6}_dump_fib(): if NLM_F_MATCH is set, set
>     filter->filter_set in any case
> 
>   - in fn_trie_dump_leaf() and rt6_dump_route(): use filter->filter_set
>     to decide if we want to filter depending on RTM_F_CLONED being
>     set/unset. If other filters (rt_type, dev, protocol) are not set,
>     they are still wildcards (existing implementation)
> 
> - no strict checking (iproute2 < 5.0.0):
>   - we can't filter consistently, so apply no filters at all: dump all
>     the routes (filter->filter_set not set), cached and uncached. That
>     means more netlink messages, but no spam as iproute2 filters them
>     anyway, and list/flush cache commands work again.
> 
> I would drop 1/8, turn 2/8 and 6/8 into a straightforward:
> 
>  	if (cb->strict_check) {
>  		err = ip_valid_fib_dump_req(net, nlh, &filter, cb);
>  		if (err < 0)
>  			return err;
> +		if (nlh->nlmsg_flags & NLM_F_MATCH)
> +			filter.filter_set = 1;
>  	} else if (nlmsg_len(nlh) >= sizeof(struct rtmsg)) {
>  		struct rtmsg *rtm = nlmsg_data(nlh);
> 
> and other patches remain the same.
> 
> What do you think?
> 

With strict checking (5.0 and forward):
- RTM_F_CLONED NOT set means dump only FIB entries
- RTM_F_CLONED set means dump only exceptions

Without strict checking (old iproute2 on any kernel):
- dump all, userspace has to sort

Kernel side this can be handled with new field, dump_exceptions, in the
filter that defaults to true and then is reset in the strict path if the
flag is not set.
