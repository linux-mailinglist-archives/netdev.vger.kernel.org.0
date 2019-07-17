Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41DA36BB24
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 13:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726684AbfGQLLZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 07:11:25 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:33085 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbfGQLLZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jul 2019 07:11:25 -0400
Received: by mail-io1-f66.google.com with SMTP id z3so45113327iog.0
        for <netdev@vger.kernel.org>; Wed, 17 Jul 2019 04:11:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SACJv24NIh5QWD4dxyuU7XHP5qCAdqnOapmlPfJ1QB4=;
        b=XguqZy366rqUtdUNgc0ANQKqRNdTNoYvHBRGUl34IFiF76Bq9zUqrRiUDnD+BMSu35
         wFjaq1y/6xbqIYl4uq7iNEZkZNKAV7DspJ/8ANIT7i6lx7TrhxMUY/50m2OTBzFhOO3u
         UJIrS/SReH5zpQ9cYDonsgNGpkbWqwqbYMQeTuma3E59nJ8nwRFO9a/CmuFh8wIRc/3k
         2+tjpkFOvjhMsvRcfJTgPGRL/1vkvVDdesLsnQDyCa8OM3yyaSZ5/V0GyjrFMrHO998H
         dphswSkJWg+EQdo/Pci5qPW9VOmFoj+p+OpxbF0tSbljP2mnaOro4tSrVpH4TC5mt0Tj
         k85g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SACJv24NIh5QWD4dxyuU7XHP5qCAdqnOapmlPfJ1QB4=;
        b=DeTQK9VH25nCga7vp0H4ykn2BiWmsgZ5x7/ppiu5KY9WxsSGdXT/58Ba40Qfw6p3Bu
         QHsYlQVZm9PfBItWVATwDpuozzJ8g49zx3oITE/0X/Yl4Y3k5fg/pc99Y6j2yrQtLF7x
         ds6ABZu7cfhQQwraC0zQCaEiHrn4u/k2qMED6ewzRQaEiXXlQrbO0NAkl036Tx025vqb
         U6Vk594oqlD02bK2l3mQLOqpGxLhFfe2oTcDalZ6uSuax7EnZTvlk7Nqt3ChA9c1mCpb
         Hlv0/qTjZLr491Fijbtjy41ohqjot4y89YeaMpRVACEL1Z61gmgeWvHoKdEKKyil793G
         gLeA==
X-Gm-Message-State: APjAAAUq33rsCR/C4fwO04wXh5O5HdvTTnaUkaMwQ+6QPjNuPr6wp81k
        EuBx8r5lyeBFUoO8WEjqOKVlIX1s
X-Google-Smtp-Source: APXvYqyYK/v0w9Ux/4RPGgx44DQPLmRSyMeXvAUKGdZAMbdb+Se/He/xWesS5TwKgvnmQL4r4jWzXA==
X-Received: by 2002:a5e:8f08:: with SMTP id c8mr36000560iok.52.1563361883868;
        Wed, 17 Jul 2019 04:11:23 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:fda7:64be:4fdc:5bca? ([2601:282:800:fd80:fda7:64be:4fdc:5bca])
        by smtp.googlemail.com with ESMTPSA id s10sm70870830iod.46.2019.07.17.04.11.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 17 Jul 2019 04:11:23 -0700 (PDT)
Subject: Re: IPv6 L2TP issues related to 93531c67
To:     Paul Donohue <linux-kernel@PaulSD.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org
References: <20190715161827.GB2622@TopQuark.net>
 <d6db74f5-5add-7500-1b7a-fa62302a455f@gmail.com>
 <20190716135646.GE2622@TopQuark.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <22e3eabc-526d-8265-ac39-a6aefc9ef7db@gmail.com>
Date:   Wed, 17 Jul 2019 05:11:21 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190716135646.GE2622@TopQuark.net>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/16/19 7:56 AM, Paul Donohue wrote:
> 
> Unfortunately, I have a fairly complicated setup, so it took me a while to figure out which pieces were relevant ... But I think I've finally got it.  The missing piece was IPsec.
> 
> After establishing an IPsec tunnel to carry the L2TP traffic, the first L2TP packet through the IPsec tunnel permanently breaks the associated L2TP tunnel.  Tearing down the IPsec tunnel does not restore functionality of the L2TP tunnel - I have to tear down and re-create the L2TP tunnel before it will work again.  In my real-world use case, I have two L2TP tunnels running over the same IPsec tunnel, and the first L2TP tunnel to send a packet after IPsec is established gets permanently broken, while the other L2TP tunnel works fine.
> 
> I've attached a modified version of the script which demonstrates this issue.

This fixes the test script (whitespace damaged but simple enough to
manually patch). See if it fixes the problem with your more complex
setup. If so I will send a formal patch.

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 4d2e6b31a8d6..6fe3097b9ab7 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -2563,7 +2563,7 @@ static struct dst_entry *rt6_check(struct rt6_info
*rt,
 {
        u32 rt_cookie = 0;

-       if ((from && !fib6_get_cookie_safe(from, &rt_cookie)) ||
+       if (!from || !fib6_get_cookie_safe(from, &rt_cookie) ||
            rt_cookie != cookie)
                return NULL;

