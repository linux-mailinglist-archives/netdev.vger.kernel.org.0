Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86FC91435E2
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 04:22:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728042AbgAUDV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 22:21:56 -0500
Received: from mail-qk1-f180.google.com ([209.85.222.180]:36764 "EHLO
        mail-qk1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727009AbgAUDVz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 22:21:55 -0500
Received: by mail-qk1-f180.google.com with SMTP id a203so1388532qkc.3
        for <netdev@vger.kernel.org>; Mon, 20 Jan 2020 19:21:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=61ux2JhjAa2FtTyz00QYnjbVn3GttGHwu1uNCAdhllY=;
        b=rcs2WwE47CQusHVqEx3ssyL2r9/FDd11Ilo9ewuegcIetm68AmHPleprBuquhh2Q+K
         lqqWiJYI3R0z+UVf0RXSzH74kecvzaAWgKJb6HdYPUCZkROf9xmKFqHKUftIbfJx6P3b
         wQX7EElPjGj7CCF+GQGRzAcHaKfX7hbDSuAmrM2NvRa5uVW7cLiNekC42+T7+iru6L7x
         S+nTlIKxpTN7iV7p1PfZsKw4OthSXOxXoW3+XlbqH2dOkAu6QMEEZ0PpA9nMJoKK2ngU
         Inxp+NxqVAY79w8Sf5XNN+pStbIFEVZSP1wsd1O/kQ6HzFOW0QAuMshcYAFVJqnlYGB7
         AFPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=61ux2JhjAa2FtTyz00QYnjbVn3GttGHwu1uNCAdhllY=;
        b=pLC0qAfNlTAJE/5LUGzgV0vNRg1XInbtIs3p2y8jeZo/XFQA3iv0UMudZz7ty3wJtL
         KREHqisqhF3t6robhJ0VBu8tXaM2oJLlxTN9hT2rgXpZWObkYOuzkkXqRpVnDcTFec48
         TlhX2NtGy3C1VDGzO5PJQWJpvnsGyNAvnJv2aAtBXhp6h/Uj0jGW+ucnWw/dFWHy1fJX
         1l22+5vsQM+01puNEWEH+3TUO3BsVlCspN3vVCFv55MDeCK+KMOi4Y8zwRmZL7CBuxkX
         V3NZPRx4wCIrndHrmAmGo6uo3fcqO/isB7qP2OUgw5BhceAvkQqLxijT7kZICDHnbJHe
         W/Og==
X-Gm-Message-State: APjAAAXLRGeQZ7umILWboCbJqUJJqizhrsxNfjXgRl0dlX++MSHdQikD
        7l+1ingWBZdigfniyFj+ExZOSC2E
X-Google-Smtp-Source: APXvYqzxW0KeDEBqw2aYN8kCsZsg5hDglSz7/6yRWuY5DeAaiMYwlWJ7Vu86lJyLlDEgDlApOV0yXQ==
X-Received: by 2002:ae9:dc85:: with SMTP id q127mr2723408qkf.460.1579576914530;
        Mon, 20 Jan 2020 19:21:54 -0800 (PST)
Received: from ?IPv6:2601:282:803:7700:84c7:af62:d74:e501? ([2601:282:803:7700:84c7:af62:d74:e501])
        by smtp.googlemail.com with ESMTPSA id d184sm16847472qkb.128.2020.01.20.19.21.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jan 2020 19:21:53 -0800 (PST)
Subject: Re: vrf and ipsec xfrm routing problem
To:     Ben Greear <greearb@candelatech.com>,
        netdev <netdev@vger.kernel.org>
References: <1425d02c-de99-b708-e543-b7fe3f0ef07e@candelatech.com>
 <9893ae01-18a5-2afd-b485-459423b8adc0@candelatech.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <ce3ba3f4-b0dd-b3b5-fbb7-095122ed75b3@gmail.com>
Date:   Mon, 20 Jan 2020 20:21:51 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <9893ae01-18a5-2afd-b485-459423b8adc0@candelatech.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/17/20 2:52 PM, Ben Greear wrote:
>> I tried adding a route to specify the x_frm as source, but that does
>> not appear to work:
>>
>> [root@lf0313-63e7 lanforge]# ip route add 192.168.10.0/24 via
>> 192.168.5.1 dev x_eth4 table 4
>> [root@lf0313-63e7 lanforge]# ip route show vrf _vrf4
>> default via 192.168.5.1 dev eth4
>> 192.168.5.0/24 dev eth4 scope link src 192.168.5.4
>> 192.168.10.0/24 via 192.168.5.1 dev eth4
>>
>> I also tried this, but no luck:
>>
>> [root@lf0313-63e7 lanforge]# ip route add 192.168.10.0/24 via
>> 192.168.10.1 dev x_eth4 table 4
>> Error: Nexthop has invalid gateway.
> 
> I went looking for why this was failing.  The reason is that this code
> is hitting the error case
> in the code snippet below (from 5.2.21+ kernel).
> 
> The oif is that of _vrf4, not the x_eth4 device.
> 
> David:  Is this expected behaviour?  Do you know how to tell vrf to use
> the x_eth4

It is expected behavior for VRF. l3mdev_update_flow changes the oif to
the VRF device if the passed in oif is enslaved to a VRF.

> xfrm device as oif when routing output to certain destinations?
> 
>     rcu_read_lock();
>     {
>         struct fib_table *tbl = NULL;
>         struct flowi4 fl4 = {
>             .daddr = nh->fib_nh_gw4,
>             .flowi4_scope = scope + 1,
>             .flowi4_oif = nh->fib_nh_oif,
>             .flowi4_iif = LOOPBACK_IFINDEX,
>         };
> 
>         /* It is not necessary, but requires a bit of thinking */
>         if (fl4.flowi4_scope < RT_SCOPE_LINK)
>             fl4.flowi4_scope = RT_SCOPE_LINK;

If you put your debug here, flowi4_oif should be fib_nh_oif per the
above initialization. It gets changed by the call to fib_lookup.

--

Sabrina sent me a short script on using xfrm devices to help me get up
to speed on that config (much simpler than using any of the *SWAN
programs). I have incorporated the xfrm device setup into a script of
other vrf + ipsec tests. A couple of tests are failing the basic setup.
I have a fix for one of them (as well as the fix for the qdisc on a VRF
device). I did notice trying to add routes with the xfrm device as the
nexthop dev was failing but have not had time to dig into it. I have
busy week but will try to spend some time on this use case this week.
