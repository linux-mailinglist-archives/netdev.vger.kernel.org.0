Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEED5483B7
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 15:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727703AbfFQNSR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 09:18:17 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:42356 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbfFQNSQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 09:18:16 -0400
Received: by mail-io1-f68.google.com with SMTP id u19so20972263ior.9
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 06:18:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nTeIw60hUFURhpVY68TtWKeGZD0Gs/oRMnQY0Nlgiv0=;
        b=OEQlFv6flVX4D4rsAzYHBbViShPnwp/kLFMFu8vWJu3IWLw6PDh87VIoIiurJqrInQ
         y6pm1oYqJWDTGKdTiuz8jUKdqGUJeYw0qQ0kJ1H+SjJ1jMPB9ryAECaHs8IUpnT/xWSF
         Hhp5t/XmYuH/p8+tE1buNtouuRk1UlyWBQJHThesu/miX9+c0z4rOE7LtaTvqlHgMphb
         NW8+w6aw/JXfnOGE8civZ3N2ttZ1ExpZBe4i88upZ1/gdkmHhgLoQ1Cfw4sUWK1m/Qhf
         xthjqBN4wWkQLQUkU+cj2GuQ/kInAmKzzYmV/IbwK6gS/1LkqTpwhkTx5wr+uFk/zJQe
         T8Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nTeIw60hUFURhpVY68TtWKeGZD0Gs/oRMnQY0Nlgiv0=;
        b=FrnUdCGNi/FAtFLWa6EuzWk9IKfy867EbwVPvbY1naDb7tUErTniKoMor0035aG83d
         DuSTv8MQhX4yWx9Fd+ULQeZyZtQZvWWGrdvD9QVihz1OuUHChka/gmwwKNv7vdaHf6NH
         W9k4/lOr3ywx0x6EEKh7YdqEebwrNxlwDMZwxTCQpk8roJqDqWA80h92R408L3+KIfRF
         Yoe+ou/IT/+pPTiPpn8LCLuhrb8T76FvKiGEuA40/MLQYio0E0G2WIoCLFbrwNsRJ2BL
         NorAqAYhnJARaezrJqp4mXLhJ6ocq4LC7wET0kewwHv3sq1HjAm2MPCvGHYWgPpUW6JN
         Uy/g==
X-Gm-Message-State: APjAAAXDx/SmUJAWNGoofJdTr1Qy+LNg6PYmn1gHiGybs+qDbDK+yz1d
        rkgGvu9ZQmOyGYrubiHMfVERR/1Z
X-Google-Smtp-Source: APXvYqzMR06amf2Ekzd6SF/NjEhoy2Tg8JuLObTQPvfV/lVxFiiGddwfvk89uDBoi1eo7+jCxt1m0g==
X-Received: by 2002:a02:298b:: with SMTP id p133mr88452796jap.37.1560777495874;
        Mon, 17 Jun 2019 06:18:15 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:f1:4f12:3a05:d55e? ([2601:282:800:fd80:f1:4f12:3a05:d55e])
        by smtp.googlemail.com with ESMTPSA id z15sm4250081ioc.68.2019.06.17.06.18.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jun 2019 06:18:15 -0700 (PDT)
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
 <20190615052705.66f3fe62@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <f6ed8beb-0892-059a-2b08-90e782226115@gmail.com>
Date:   Mon, 17 Jun 2019 07:18:10 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190615052705.66f3fe62@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/14/19 9:27 PM, Stefano Brivio wrote:
>>>> Can you explain why this patch is needed? The existing function requires
>>>> strict mode and is needed to enable any of the kernel side filtering
>>>> beyond the RTM_F_CLONED setting in rtm_flags.  
>>>
>>> It's mostly to have proper NLM_F_MATCH support. Let's pick an iproute2
>>> version without strict checking support (< 5.0), that sets NLM_F_MATCH
>>> though. Then we need this check:
>>>
>>> 	if (nlh->nlmsg_len < nlmsg_msg_size(sizeof(*rtm)))  
>>
>> but that check existed long before any of the strict checking and kernel
>> side filtering was added.
> 
> Indeed. And now I'm recycling it, even if strict checking is not
> requested.
> 
>>> and to set filter parameters not just based on flags (i.e. RTM_F_CLONED),
>>> but also on table, protocol, etc.  
>>
>> and to do that you *must* have strict checking. There is no way to trust
>> userspace without that strict flag set because iproute2 for the longest
>> time sent the wrong header for almost all dump requests.
> 
> So you're implying that:
> 
> - we shouldn't support NLM_F_MATCH
> 
> - we should keep this broken for iproute2 < 5.0.0?
> 
> I guess this might be acceptable, but please state it clearly.
> 
> By the way, if really needed, we can do strict checking even if not
> requested. But this might add more and more userspace breakage, I guess.
> 

Prior to 5.0 and strict checking, iproute2 was sending ifinfomsg as the
header struct - which is wrong for routes. ifi_flags just happens to
have the same offset as rtm_flags so the check for RTM_F_CLONED is ok,
but nothing else sent in the get request (e.g., potentially appended
attributes) can be trusted, so the !strict path you are adding with
nlmsg_parse_deprecated is wrong. The kernel side filter argument can be
used and treating RTM_F_CLONED as a filter is ok, but not the new
parsing code.
