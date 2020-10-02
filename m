Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEC3C281103
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 13:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387757AbgJBLKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 07:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725953AbgJBLJ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 07:09:28 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3902AC0613D0
        for <netdev@vger.kernel.org>; Fri,  2 Oct 2020 04:09:26 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id j2so1217731eds.9
        for <netdev@vger.kernel.org>; Fri, 02 Oct 2020 04:09:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DbdnNyMO9+3ZK95D4doiWs/xTPBLJFhjIBpvvKny9hk=;
        b=anFfWMx/NHN+NFEq6XK7nAGhLyBV0Y/w2LnDB8dws4s83IeZASTWAuYWVuQkpWXPt9
         z+tCrKz0SJiOXxLsO/JCNVT4l0XcnN10veNOrajTHPbGh8VcN3X+YkxdG41N2DfBgt8w
         9NdN5j1lXQC3JBZq41TDB0LDrOhHylkXjlHFzcwhBUbr8R2065EOUFs5zNKdCE0KEXyK
         lUZQ4f6H8C4bgKL9lieIolpsTJAQPSCtrwV8u40axByUgRpfoyV/XZWWm4x8gz05tvje
         /mM+elEptmOqI+w1wZQbMhS0sYL8MVhcDtDLBS/j7/aPGO4PXdhzibHrbqvgsVPYPOth
         chJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DbdnNyMO9+3ZK95D4doiWs/xTPBLJFhjIBpvvKny9hk=;
        b=AKhqay32RzngPQmbSgDfhqjSxpMpB8SqZKliItmqLklRd50sSGF0jSc1ROcD0uqawy
         /I20iU3ZglKlA3+RksvyApS+Ly36abK4MOfXe5Rm/1oa9zmaUqODjmuVi9+MxZOqELRF
         UCuOlyStM+oAYioeIuAD5EZt3YOv6pxOgEJAOYOMNty54yHXB0hXsCK5FvRaaXhhEQZ/
         CNTaTd04vvCTD/YQrR2iw/jxo5Kv63xw3Mf8eqdc8sHxcb/pVn5N6PyFeLVSJDWr6z/P
         PlJMYh2RqAhJ/PeYN6h5R73P/C2kKEvWdorqZ/9Cw/hYy1JKCFj6H4fgVwBdHGaNGB76
         1ewA==
X-Gm-Message-State: AOAM531agALw4H3BwkZqoHiD74c4Kyfyb1sBkByclYKGolYpI5A2w2mc
        glDH9hXuDshk7WivUtSOOk821z5wS+s=
X-Google-Smtp-Source: ABdhPJw6n+hs9vXuTPx4w9OjqnY3Z195EFNj6932eNvrilGduvyDSMYHQKbrQEjZ+MOFG3TFc6MdKA==
X-Received: by 2002:a05:6402:155a:: with SMTP id p26mr1757577edx.178.1601636964615;
        Fri, 02 Oct 2020 04:09:24 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f00:6a00:750d:3901:86f:91ce? (p200300ea8f006a00750d3901086f91ce.dip0.t-ipconnect.de. [2003:ea:8f00:6a00:750d:3901:86f:91ce])
        by smtp.googlemail.com with ESMTPSA id ao17sm923858ejc.18.2020.10.02.04.09.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Oct 2020 04:09:24 -0700 (PDT)
Subject: Re: [Bug 209423] WARN_ON_ONCE() at rtl8169_tso_csum_v2()
To:     Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <bug-209423-201211-atteo0d1ZY@https.bugzilla.kernel.org/>
 <80adc922-f667-a1ab-35a6-02bf1acfd5a1@gmail.com>
 <CANn89i+ZC5y_n_kQTm4WCWZsYaph4E2vtC9k_caE6dkuQrXdPQ@mail.gmail.com>
 <733a6e54-f03c-0076-1bdc-9b0d4ec1038c@gmail.com>
 <CANn89iJ2zqH=_fvJQ8dhG4nBVnKNB7SjHnHDLv+0iR7UwgxTsw@mail.gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <b6ff841a-320c-5592-1c2b-650e18dfe3e0@gmail.com>
Date:   Fri, 2 Oct 2020 13:09:18 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <CANn89iJ2zqH=_fvJQ8dhG4nBVnKNB7SjHnHDLv+0iR7UwgxTsw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02.10.2020 10:46, Eric Dumazet wrote:
> On Fri, Oct 2, 2020 at 10:32 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>>
>>
>>
>> On 10/2/20 10:26 AM, Eric Dumazet wrote:
>>> On Thu, Oct 1, 2020 at 10:34 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>>>>
>>>> I have a problem with the following code in ndo_start_xmit() of
>>>> the r8169 driver. A user reported the WARN being triggered due
>>>> to gso_size > 0 and gso_type = 0. The chip supports TSO(6).
>>>> The driver is widely used, therefore I'd expect much more such
>>>> reports if it should be a common problem. Not sure what's special.
>>>> My primary question: Is it a valid use case that gso_size is
>>>> greater than 0, and no SKB_GSO_ flag is set?
>>>> Any hint would be appreciated.
>>>>
>>>>
>>>
>>> Maybe this is not a TCP packet ? But in this case GSO should have taken place.
>>>
>>> You might add a
>>> pr_err_once("gso_type=%x\n", shinfo->gso_type);
>>>
> 
>>
>> Ah, sorry I see you already printed gso_type
>>
>> Must then be a bug somewhere :/
> 
> 
> napi_reuse_skb() does :
> 
> skb_shinfo(skb)->gso_type = 0;
> 
> It does _not_ clear gso_size.
> 
> I wonder if in some cases we could reuse an skb while gso_size is not zero.
> 
> Normally, we set it only from dev_gro_receive() when the skb is queued
> into GRO engine (status being GRO_HELD)
> 
Thanks Eric. I'm no expert that deep in the network stack and just wonder
why napi_reuse_skb() re-initializes less fields in shinfo than __alloc_skb().
The latter one does a
memset(shinfo, 0, offsetof(struct skb_shared_info, dataref));

What I can do is letting the affected user test the following.

diff --git a/net/core/dev.c b/net/core/dev.c
index 62b06523b..8e75399cc 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6088,6 +6088,7 @@ static void napi_reuse_skb(struct napi_struct *napi, struct sk_buff *skb)
 
 	skb->encapsulation = 0;
 	skb_shinfo(skb)->gso_type = 0;
+	skb_shinfo(skb)->gso_size = 0;
 	skb->truesize = SKB_TRUESIZE(skb_end_offset(skb));
 	skb_ext_reset(skb);
 
-- 
2.28.0


