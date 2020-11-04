Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 849322A6DDB
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 20:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730737AbgKDTaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 14:30:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725889AbgKDTaY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 14:30:24 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76D37C0613D3
        for <netdev@vger.kernel.org>; Wed,  4 Nov 2020 11:30:24 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id b9so13468046edu.10
        for <netdev@vger.kernel.org>; Wed, 04 Nov 2020 11:30:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QQyPadoUOHYBOoA5+l0Qrj97nqWwN8g6Qn0Ly8GOILk=;
        b=sKUP9T/VP1HDyxmJMLmeedQceCZ+UirBA7rRDhDU9jwg+PGFAKXSQQLEQJaDgFImTw
         SHflBh6ALFo5ibgx5gVz0CmUTv6Fw5u668+8FxLfos8F09tCqqAsdFVIbmzyfgoKGPRi
         4vRqAnGuNRAELs0QFo5QNZCPA+mmOmj+pltr4c0LNlm+freczQTOa3qI2k83+dIR+UwO
         Quo6wpVynvRdO4/5UYfKLAvpGmyJgjd3c1pqcPOkcA7BPtwJIaEuKqRECWdWrezmKv7C
         5++r5u8GGc1uDfy7ONUax9NjnwGT/oJD0tPbtWljTD1EsHJAx5cRal02eNMYSOwkg9Cp
         6wzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QQyPadoUOHYBOoA5+l0Qrj97nqWwN8g6Qn0Ly8GOILk=;
        b=oUlT/t+3CbDiHlxO6q9ss5YLffZwp4eYuAvtNnV83HU+lDACH6JKXxEp2+ePkLScmI
         kNhqOBW8qjUdCjfdIj1Amsk5CBc21w1K2YqmptQ3JTs5J5XOStrY2qaGdTGo9eYKqqZO
         qP7Ma5py8OS+yqFrk8oGccuUnfYzbsUJynUE0ckwoetvNKce8F8yQ9mpcCSyO4LEuHj5
         pryBCbHLJJegTW7UaRP7PFqoXjjVW4cfo8fI29usDfvl0vm2mVR2QMzr+CvsR22yNxhD
         M2EwVqADZy6/SCLH7Jzp32Q+Pez6r1raaBw4BCDl9Quk0bs8DtVZthe3Fug7SnDWu0Pq
         4pLQ==
X-Gm-Message-State: AOAM530Ogfjs6cryVvykKhvVWrzfQ/gap+JInSku3psR/paaE870HRt7
        tZva8zn+Tslifs3kJZgtItU=
X-Google-Smtp-Source: ABdhPJzJeJg5G08oNTmWbeLyhn052UMiUZ7x+uLPy8kAODYPc8llwtUG/O/dB2biolTQF10wfNgvkw==
X-Received: by 2002:a05:6402:1112:: with SMTP id u18mr29254635edv.349.1604518223047;
        Wed, 04 Nov 2020 11:30:23 -0800 (PST)
Received: from ?IPv6:2a0f:6480:3:1:6c3b:b371:86f7:b3f1? ([2a0f:6480:3:1:6c3b:b371:86f7:b3f1])
        by smtp.gmail.com with ESMTPSA id z14sm1454847ejl.110.2020.11.04.11.30.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2020 11:30:22 -0800 (PST)
Subject: Re: [PATCH] IPv6: Set SIT tunnel hard_header_len to zero
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>
References: <20201103104133.GA1573211@tws>
 <CA+FuTSdf35EqALizep-65_sF46pk46_RqmEhS9gjw_5rF5cr1Q@mail.gmail.com>
From:   Oliver Herms <oliver.peter.herms@gmail.com>
Message-ID: <dc8f00ff-d484-f5cf-97a3-9f6d8984160e@gmail.com>
Date:   Wed, 4 Nov 2020 20:30:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CA+FuTSdf35EqALizep-65_sF46pk46_RqmEhS9gjw_5rF5cr1Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03.11.20 19:42, Willem de Bruijn wrote:
> Thanks. Yes, this is long overdue.
> 
> The hard_header_len issue was also recently discussed in the context
> of GRE in commit fdafed459998 ("ip_gre: set dev->hard_header_len and
> dev->needed_headroom properly").
> 
> Question is whether we should reserve room in needed_headroom instead.
> AFAIK this existing update logic in ip6_tnl_xmit is sufficient
> 
> "
>         /* Calculate max headroom for all the headers and adjust
>          * needed_headroom if necessary.
>          */
>         max_headroom = LL_RESERVED_SPACE(dst->dev) + sizeof(struct ipv6hdr)
>                         + dst->header_len + t->hlen;
>         if (max_headroom > dev->needed_headroom)
>                 dev->needed_headroom = max_headroom;
> "I think that's enough. At least it definitely works in my test and prod environment.
Would be good to get another opinion on this though.

>> Fixes: c54419321455 ("GRE: Refactor GRE tunneling code.")
> 
> How did you arrive at this SHA1?
I think the legacy usage of hard_header_len in ipv6/sit.c was overseen in c54419321455.
Please correct me if I'm wrong.
