Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA1C14600A
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 16:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728764AbfFNOHK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 10:07:10 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:43485 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727382AbfFNOHK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 10:07:10 -0400
Received: by mail-pf1-f196.google.com with SMTP id i189so1520525pfg.10;
        Fri, 14 Jun 2019 07:07:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LJg9268+LDPIRhGrkFTLGpEAlX1lCnLtO8bJQ4QN05M=;
        b=QJy/6MnsHsECy1HYz/rqZ3HHq3OQroAc6nX9BCwm9YFf2YbvaicxGQ6bvxsH5aqSZa
         6yEn9yuIgjL95131ax2bk6Pe0PoU3AeVPdqf2QS1c19ftcVhh5zHh1wq7wvqwGxu4MvP
         O4s1ytatGdrM1WwgTMFFgxxyEVplOnOrE3ydAcx+o9F1Dw3n5E4uHMbJqtLK8zKEJjmY
         42i0Umlo3Z+ig8IkvNchp8izRNDzR4Mr6YoT9wb5iO+PuscND4uR+e/Fq6S8mKsFykpB
         bInllyf25qaS7Vgi5WvgHtvepVsxg+HmjvOEycPObi0biMGp1BsUEqhg0MSF2oaKEN8V
         hpOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LJg9268+LDPIRhGrkFTLGpEAlX1lCnLtO8bJQ4QN05M=;
        b=rRQfi4eOIYRHtLcmGARFp/JWGvoHqxOQRTz86tUVhFb+u4Qcrg3pMLjDcYQbW33Yy7
         ZbOA4fyGxmcFwGSTh1oLMOFUnNuIqJESZWJS80zwsiY+ojaOojy0RijuqCJO0JUTaSpE
         jD+hjQ5RLW1n5ANg0dR0UhRMBP85kQEfmNJDd3qUC2LOKKb4FZcEzUwCUGg/ne8ANJuy
         NUKGl7Dch5/doIInl0fpBAyk+u4eSO+jLr8xFNmSONIKnkjTnrJZZiY4xN6DQfTbuj54
         RdE8v8j8UMtvRINRp6l6aIaiD4BPGcI3Rq0T3CTeerX5d4o/KhcEjARjvBX9t1JiayGC
         IZLg==
X-Gm-Message-State: APjAAAVX8iLJT+MShvgQ3lgQbOPReFpzKupXw13BNhUXCUi89dkCea6x
        SyryCSsUjuzbTnttIVdwMH+SXWoZQ9U=
X-Google-Smtp-Source: APXvYqzcEOiZIn73KTG+EBoUQLrcnli4yGKqfYpCbo2WD10sB9flhtjQ3YZWE5gdb0osUBpoEcTbUA==
X-Received: by 2002:a62:1ec1:: with SMTP id e184mr8001336pfe.185.1560521229311;
        Fri, 14 Jun 2019 07:07:09 -0700 (PDT)
Received: from [172.27.227.167] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id i3sm3418766pfo.138.2019.06.14.07.07.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Jun 2019 07:07:08 -0700 (PDT)
Subject: Re: [PATCH net] mpls: fix af_mpls dependencies
To:     Arnd Bergmann <arnd@arndb.de>, Randy Dunlap <rdunlap@infradead.org>
Cc:     Matteo Croce <mcroce@redhat.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>
References: <20190608125019.417-1-mcroce@redhat.com>
 <20190609.195742.739339469351067643.davem@davemloft.net>
 <d19abcd4-799c-ac2f-ffcb-fa749d17950c@infradead.org>
 <CAGnkfhyS15NPEO2ygkjazECULtUDkJgPk8wCYFhA9zL2+w27pg@mail.gmail.com>
 <49b58181-90da-4ee4-cbb0-80e226d040fc@infradead.org>
 <CAK8P3a1mwnDFeD3xnQ6bm1x8C6yX=YEccxN2jknvTbRiCfD=Bg@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <47f1889a-e919-e3fd-f90c-39c26cb1ccbb@gmail.com>
Date:   Fri, 14 Jun 2019 08:07:06 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <CAK8P3a1mwnDFeD3xnQ6bm1x8C6yX=YEccxN2jknvTbRiCfD=Bg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/14/19 8:01 AM, Arnd Bergmann wrote:
> On Wed, Jun 12, 2019 at 9:41 AM Randy Dunlap <rdunlap@infradead.org> wrote:
>> On 6/11/19 5:08 PM, Matteo Croce wrote:
>>> On Wed, Jun 12, 2019 at 1:07 AM Randy Dunlap <rdunlap@infradead.org> wrote:
>>> * Configure standard kernel features (expert users)
>>> *
>>> Configure standard kernel features (expert users) (EXPERT) [Y/?] y
>>>   Multiple users, groups and capabilities support (MULTIUSER) [Y/n/?] y
>>>   sgetmask/ssetmask syscalls support (SGETMASK_SYSCALL) [N/y/?] n
>>>   Sysfs syscall support (SYSFS_SYSCALL) [N/y/?] n
>>>   Sysctl syscall support (SYSCTL_SYSCALL) [N/y/?] (NEW)
>>
>> So I still say that MPLS_ROUTING should depend on PROC_SYSCTL,
>> not select it.
> 
> It clearly shouldn't select PROC_SYSCTL, but I think it should not
> have a 'depends on' statement either. I think the correct fix for the
> original problem would have been something like
> 
> --- a/net/mpls/af_mpls.c
> +++ b/net/mpls/af_mpls.c
> @@ -2659,6 +2659,9 @@ static int mpls_net_init(struct net *net)
>         net->mpls.ip_ttl_propagate = 1;
>         net->mpls.default_ttl = 255;
> 
> +       if (!IS_ENABLED(CONFIG_PROC_SYSCTL))
> +               return 0;
> +
>         table = kmemdup(mpls_table, sizeof(mpls_table), GFP_KERNEL);
>         if (table == NULL)
>                 return -ENOMEM;
> 

Without sysctl, the entire mpls_router code is disabled. So if sysctl is
not enabled there is no point in building this file.
