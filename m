Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2D6F4943E7
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 00:39:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344552AbiASXjl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 18:39:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232430AbiASXjl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 18:39:41 -0500
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB53BC061574
        for <netdev@vger.kernel.org>; Wed, 19 Jan 2022 15:39:40 -0800 (PST)
Received: by mail-il1-x12f.google.com with SMTP id r16so3599794ile.8
        for <netdev@vger.kernel.org>; Wed, 19 Jan 2022 15:39:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=EWUN3fCMMbK+Oq5s7EIvqPqD5Q1Xqm+eRw/CeN9TqOg=;
        b=kCFqkCvdvk2+t4XrPEHZL71H3F4U+IAPEdY6TEJ7kzESrP5LCoTiu7CGUBK0HiOtKx
         zvEuTcCjnl1sRJT52prKyFigb1C4zgDuOwDJK5F+8uFW9JcnsWHHqrxz/Fk5gAezUbiY
         muuvu2+uGchlK+/Ig89QIwtXay4rJtbabKdCu21nsgkrS0qH93q79G1P4/5mKgKLzZmG
         fnAf8nK9tA6eixrDHsNXnG5Ru+BfEZu6rVFLyR9lBvFvvMzHzqE8JaLzHCOuhDGur0or
         HTOrXzag1r5Tvaw9cjKuJtVBXiVNbz6CDazPiW+HICLe1CgsoOSDbzrgCuGnQ3mVDpKW
         1bVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=EWUN3fCMMbK+Oq5s7EIvqPqD5Q1Xqm+eRw/CeN9TqOg=;
        b=KWURWvtvOheZdwJKQxjS6YpMtBdrY3sWPBjvaVUProWoIRGwgq7lnH6HYRaT5hYoaC
         7tCtt44b85c1tQPFOmYZ3QoJS8rpnmgcgxxgfVGqGaLoHSijhxD4c12jX7Z3TJQeH+zQ
         uJE6amEOI3okngoNAG24PziMNJoq/6yFcK59tHvrnML5vZkWuQrx7tGTRocpSkmky4OU
         eYvbf/6tIlTiT8KLl4bWbWZc/Du2WTULXKwfS4VJ57q3lbpyCnFk0pGxHaXMZYrdb3UP
         rs64d61WblCBS6JPi/9/ktMWxWaeLDKewWU9MXfd7q87LZ1UBJJBUGfCrFPqtv9oB4bl
         taZQ==
X-Gm-Message-State: AOAM5333V8EPHC82lA2i9c/dEa9zK8vcNOuHAIZ4M2zzFXA+lYQWwtPO
        MwjQ00nNm8SoTwBTUcftktg=
X-Google-Smtp-Source: ABdhPJzYz6Lv3A59aGuwDP38JY2ZiZ+HSpEszbUAxPTUBImL60GioCvTdodMjX+I4en7K5GUX82l9w==
X-Received: by 2002:a05:6e02:2189:: with SMTP id j9mr18426346ila.264.1642635580146;
        Wed, 19 Jan 2022 15:39:40 -0800 (PST)
Received: from ?IPV6:2601:282:800:dc80:61a6:f44a:ed04:6638? ([2601:282:800:dc80:61a6:f44a:ed04:6638])
        by smtp.googlemail.com with ESMTPSA id v3sm500196iol.43.2022.01.19.15.39.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Jan 2022 15:39:39 -0800 (PST)
Message-ID: <28fa20e8-6ac6-4761-54a9-04b5ed05b66b@gmail.com>
Date:   Wed, 19 Jan 2022 16:39:38 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Subject: Re: [PATCH iproute2] dcb: app: Add missing "dcb app show dev X
 default-prio"
Content-Language: en-US
To:     Stephen Hemminger <stephen@networkplumber.org>,
        Petr Machata <petrm@nvidia.com>
Cc:     netdev@vger.kernel.org, Maksym Yaremchuk <maksymy@nvidia.com>
References: <f6e07ca31e33a673f641c9282e81ee9c3be03d3c.1642505737.git.petrm@nvidia.com>
 <0758f5ce-2461-95c2-edc0-9a24e44671d3@gmail.com> <87pmooove2.fsf@nvidia.com>
 <20220119123506.2360b139@hermes.local>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220119123506.2360b139@hermes.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/19/22 1:35 PM, Stephen Hemminger wrote:
> On Wed, 19 Jan 2022 11:38:54 +0100
> Petr Machata <petrm@nvidia.com> wrote:
> 
>>>
>>> In general, we are not allowing more uses of matches(). I think this one
>>> can be an exception for consistency with the other options, so really
>>> just a heads up.  
>>
>> The shortening that the matches() allows is very useful for typing. I do
>> stuff like "ip l sh dev X up" and "ip a a dev X 192.0.2.1/28" all the
>> time. I suppose there was a discussion about this, can you point me at
>> the thread, or where & when approximately it took place so I can look it
>> up?
> 
> The problem is that matches() doesn't handle conflicts well.
> Using your example:
>   ip l 
> could match "ip link" or "ip l2tp" and the choice of "link" is only because
> it was added first. This is bad UI, and creates tribal knowledge that makes
> it harder for new users. Other utilities don't allow ambiguous matches.

and the constant source of bugs when new options are added. This patch
being a good example as Stephen noted.
