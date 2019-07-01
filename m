Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E64F35C45A
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 22:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbfGAUge (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 16:36:34 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:53316 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726620AbfGAUgd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 16:36:33 -0400
Received: by mail-wm1-f68.google.com with SMTP id x15so792727wmj.3
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 13:36:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HStAZ93zuMp9Y5p6BG37ZsU7GChkZ4Ezge1atW7zg3w=;
        b=tLS1oEHjF/865fCt2hwQVg6o3qWIkG+CmBQYEFmgUkXjg5M7+Sf8q1FYqzQTeUwe32
         CC7iFOD8d3g+ssNJepMwMUnsgOQH1QGP60g7zlDdsmjuwMJQr6P+T8EQ8wVFArhUFqMY
         M6ceLWDkEnvcevOX/xtoauxsI2tuI75qE7R++S/tR8klNBYeG1PiticKLHc0C7utRJV1
         4CsYuPxOssPtnQ5EsV61EHE/PyAZzxfL1wfHLn8mjMOxPazowXje1JfPFYN0EIpH4NVQ
         A9g7yu0Dx14SK+tytqFD1QX5167RzVyzXxH23Bta1fxj8moKsKmcursD4RcvZctuABzr
         tIqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HStAZ93zuMp9Y5p6BG37ZsU7GChkZ4Ezge1atW7zg3w=;
        b=DCP4rVQIAGzMHYqwJigFIBaLwV2MGO8/ac8SYbbmkhUyqtWC9zJe/T2KCpw2fs6GgX
         rHl8q1rNl6SuaeFX+5u8E8DmAVfqSc1vFJ2UM0jGV4R75oO+/2OsxBVfKlGjB9CTMeN2
         S6TP4dEbqiGcdazzs/K305McRNzbYbT60N5zYiC/3zNL5WucJBg6ENzEVFhYEEVQhpHp
         LqXRDozXTh15rGxUOh/wVZsXa7RriDKVcQ/JU8zLkYVWpfHlL4SOFK60e8P2R20fFW2C
         scMqG6QNgxBKOEJhVQBpb+SaObRbWYNn5nPq6+SLWX4O2yAcoDYPVcPZDyBQZWwcQOZU
         v/MA==
X-Gm-Message-State: APjAAAU6GnzLBaxyiTMCkBifsIuy7krWHQQAo+tJMBdLDwcAjqoc6DWu
        FXLxy2Z3vMxnLknokVtItUDzqY8l
X-Google-Smtp-Source: APXvYqyZ6HqeligeTK/eJ5gLUIlbFZPHAcQnNTygdhGW4k0Phtp6M1GBAxScVRKLPJpB1EpVwC5DUQ==
X-Received: by 2002:a1c:107:: with SMTP id 7mr631038wmb.84.1562013391306;
        Mon, 01 Jul 2019 13:36:31 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bd6:c00:8dac:9ad2:a34c:33bc? (p200300EA8BD60C008DAC9AD2A34C33BC.dip0.t-ipconnect.de. [2003:ea:8bd6:c00:8dac:9ad2:a34c:33bc])
        by smtp.googlemail.com with ESMTPSA id y6sm957025wmd.16.2019.07.01.13.36.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Jul 2019 13:36:30 -0700 (PDT)
Subject: Re: [PATCH net-next] r8169: fix ntohs/htons sparse warnings
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <1d1f9dba-1ade-7782-6cc0-3151a7086a4b@gmail.com>
 <20190701195621.GC17978@ZenIV.linux.org.uk>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <81c45b3c-bbaa-c619-981c-8b8f4b73d5c5@gmail.com>
Date:   Mon, 1 Jul 2019 22:36:26 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190701195621.GC17978@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01.07.2019 21:56, Al Viro wrote:
> On Mon, Jul 01, 2019 at 09:35:28PM +0200, Heiner Kallweit wrote:
>> Sparse complains about casting to/from restricted __be16. Fix this.
> 
> Fix what, exactly?  Force-cast is not a fix - it's "STFU, I know
> better, it's really correct" to sparse.  Which may or may not
> match the reality, but it definitely requires more in way of
> commit message than "sparse says it's wrong; shut it up".
> 
>>  static void rtl8169_rx_vlan_tag(struct RxDesc *desc, struct sk_buff *skb)
>> @@ -1537,7 +1537,7 @@ static void rtl8169_rx_vlan_tag(struct RxDesc *desc, struct sk_buff *skb)
>>  
>>  	if (opts2 & RxVlanTag)
>>  		__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q),
>> -				       ntohs(opts2 & 0xffff));
>> +				       ntohs((__force __be16)(opts2 & 0xffff)));
>>  }
> 
> Should that be ntohs at all?  What behaviour is correct on big-endian host?
> 
> AFAICS, in that code opts2 comes from little-endian 32bit.  It's converted to
> host-endian, lower 16 bits (i.e. the first two octets in memory) are then
> fed to ntohs.  Suppose we had in-core value stored as A0, A1, A2, A3.
> On little-endian that code will yield A0 * 256 + A1, treated as host-endian.
> On big-endian the same will yield A1 * 256 + A0.  Is that actually correct?
> 
I think you're right and the original patch should be reverted.

> The code dealing with the value passed to __vlan_hwaccel_put_tag() as the
> third argument treats it as a host-endian integer.  So... Has anyone
> tested that code on b-e host?  Should that ntohs() actually be swab16(),
> yielding (on any host) the same value we currently get for l-e hosts only?
> 
I haven't seen any b-e host with a Realtek network chip yet.
