Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD3BD64627
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 14:27:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726458AbfGJM1e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 08:27:34 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:40778 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725929AbfGJM1e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 08:27:34 -0400
Received: by mail-io1-f66.google.com with SMTP id h6so4235210iom.7
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 05:27:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nqi0j2v2A7vNfewZCu5tNIJMwgGMWzIzZ9SqEPE/czA=;
        b=bpV582WRgPrbdwAt12+AhtDsBIGOaGNEimRK6Asoli0M7ttS6UtANZJIoNwFU8Cqi0
         DDsHxWQWSP+KCP2tbnOXGncCsWwpmiTgSLbnZWyEYmFwFSHmzuOOtjAXNt9PTgu7YTcG
         Dm2maIXSy15g0xY89yulki4gTZqhJAEZK6+57FQ34wshnLFvz+OsZBVT4dN6TT1Wy8tI
         8f1NI81yizXl+6Wd4TSBmZ6mEhkAYNYiI/VAoQUrGXOt71w2D6diOfd4t040ypcSPrTC
         6CQo1qzXOuviYE36eqkLKJL8GKQ4Vz1dUnK+Zg8cICdaWyWe62bYo7cZvxVodG1GfON0
         YbtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nqi0j2v2A7vNfewZCu5tNIJMwgGMWzIzZ9SqEPE/czA=;
        b=apaqk+GHaXeq0mYmdlx+jUHCrPeWjmmeXkPLFAnk21YsNjCvILk2w2KsDKpSyrotiS
         jQLxUg58rGcSceR1Qk7HRjgq19WxJ9jYm7uzIVi3Y56aREzWyplcmQuBLh7Wdl09VVuE
         crqssfsjC3XHKjSHH8SK/gyYASzp6w2X6vHcfiPVjFjBNu9+cizptjYdd+56DWE2tLch
         SGmJMXgxbzbYGOo3nwPWVUZvuUvJISBtvGjTrCYF6WVOfUbZ00lSZWTpfsRG4C9peU9u
         RFzluODP9uNi3/SIaXh6XHauuuRGlwr3+SN6+Eax4EtPBxf4kiHXKbMYoRaH9rQdXe6e
         vuHw==
X-Gm-Message-State: APjAAAU1nByMjCv92VZKgQqwvT+wkqeEifiPB2MHTTb6DIOMBilyzvpA
        WHxAMkZ/9GFzAwW1mnnWSweGpQCS
X-Google-Smtp-Source: APXvYqxBFxnoUG74bWZoqRf6ZnbuT2dPxku2fg76U9i2r4jIyMlHHc8fORy9BgSbRB46gpRm8acNwA==
X-Received: by 2002:a02:b016:: with SMTP id p22mr35701972jah.121.1562761653485;
        Wed, 10 Jul 2019 05:27:33 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:d059:3694:77c1:5391? ([2601:282:800:fd80:d059:3694:77c1:5391])
        by smtp.googlemail.com with ESMTPSA id x13sm1458840ioj.18.2019.07.10.05.27.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Jul 2019 05:27:32 -0700 (PDT)
Subject: Re: Question about linux kernel commit: "net/ipv6: move metrics from
 dst to rt6_info"
To:     Jan Szewczyk <jan.szewczyk@ericsson.com>,
        "davem@davemloft.net" <davem@davemloft.net>
References: <AM6PR07MB56397A8BC53D9A525BC9C489F2F00@AM6PR07MB5639.eurprd07.prod.outlook.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <cb0674df-8593-f14b-f680-ce278042c88c@gmail.com>
Date:   Wed, 10 Jul 2019 06:27:31 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <AM6PR07MB56397A8BC53D9A525BC9C489F2F00@AM6PR07MB5639.eurprd07.prod.outlook.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ adding netdev so others can chime in ]

On 7/10/19 2:28 AM, Jan Szewczyk wrote:
> Hi guys!
> 
> We can see different behavior of one of our commands that supposed to
> show pmtu information.
> 
> It’s using netlink message RTM_GETROUTE to get the information and in
> Linux kernel version 4.12 after sending big packet (and triggering
> “packet too big”) there is an entry with PMTU and expiration time.
> 
> In the version 4.18 unfortunately the entry looks different and there is
> no PMTU information.

Can you try with 4.19.58 (latest stable release for 4.19)? Perhaps there
was a bugfix that is missing from 4.18.

The kernel has 2 commands under tools/testing/selftests/net -- pmtu.sh
and icmp_redirect.sh -- that verify exceptions are created and use 'ip
ro get' to verify the mtu.


> 
> I can see that in your commit
> https://github.com/torvalds/linux/commit/d4ead6b34b67fd711639324b6465a050bcb197d4,
> these lines disappeared from route.c:
> 
>  
> 
>      if (rt->rt6i_pmtu)
> 
>            metrics[RTAX_MTU - 1] = rt->rt6i_pmtu;
> 
>  
> 
> I’m very beginner in linux kernel code, can you help me and tell me if
> that could cause this different behavior?
> 
>  
> 
>  
> 
> BR,
> 
> Jan Szewczyk
> 

