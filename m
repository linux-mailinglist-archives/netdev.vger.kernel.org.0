Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9D1AD9A7C
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 21:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436723AbfJPTyL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 15:54:11 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:33965 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436685AbfJPTyL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 15:54:11 -0400
Received: by mail-pg1-f194.google.com with SMTP id k20so7560821pgi.1
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 12:54:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Xdoq2nThOqFLhikj0qU5Mih2TvMdL6CVco57qi6Xi7s=;
        b=mMr6mO5xJ1PDyXFaBqXG86x2ag/v4sQQQik7mPswDOPv/MuD/ft4DFA3WWrKZTWByq
         05Ba5f3bUG3IIVeqPZwi2FbA8JSV0o7ApvY20kvm6L63yddlYw+G0e52nq20u3oS4T32
         9FkcYEHoUXIZkxH9FbB3UYAYKxdgBWvk5yaaswGyXrxLXg/pL5/WpBR0JiMedkvXWIrk
         1R1Dq/NPM0vdv60ClcbF1Tk5Rt1v4LzWggJgCy/tW3fNtImWizvyTTI6j3OpuMs8hqh7
         qTemlK7tWK6XRCSH+ef7V1YZERnral1PXpa4j6OCOXkoqYEQS03ocNtvLtRqNvoifRfv
         O8NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Xdoq2nThOqFLhikj0qU5Mih2TvMdL6CVco57qi6Xi7s=;
        b=OR3v6uQpADmYBApVQSrh9pItWJg1BgR60IDfZH8+hnCoVewBlZzP23tlCChq0xJVhv
         3ulr1NZPs3WcDLTzaSrap/d98DxxZ/gOINQSiHUmo5KHT2boi8WdI0DSCuFi9uNAheiv
         Ik1adpvcDvjG7fN3C0j4DFLm3G7Y2yWPkb778VONXb+gLEUqsnvQlncY+g96pvcrZEJc
         Bq70YYto8g7CdSqVxulzMQrUdgJ4BxioFss6xD2IDvwH2sgw27cyOGNf+gYmCIvf7N2N
         49KTCHwnZWex42/FTssr7BBe00xg2IJ4LABkcEd9xc+xCnLADEwndTPguqN5NrivASq/
         Hqdg==
X-Gm-Message-State: APjAAAXB0aPx9o7SW/+Cvn7tjqCliof4waUQLfmAnoiwjqFrj/TMgDDV
        jZV2FO2+GPzAPnUsGnZLyTLDpUzj
X-Google-Smtp-Source: APXvYqyebT3BeVXYoL6k69dAuoMqLqKTj+HTxCng+vrdgeXwN5ndThrmx0F6WtiNGwlsT+80QXAF4A==
X-Received: by 2002:a63:5b63:: with SMTP id l35mr28181405pgm.307.1571255649846;
        Wed, 16 Oct 2019 12:54:09 -0700 (PDT)
Received: from ?IPv6:2620:0:1000:3510:9c1d:f62a:9434:e03f? ([2620:0:1000:3510:9c1d:f62a:9434:e03f])
        by smtp.gmail.com with ESMTPSA id t125sm31294384pfc.80.2019.10.16.12.54.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Oct 2019 12:54:06 -0700 (PDT)
Subject: Re: AW: big ICMP requests get disrupted on IPSec tunnel activation
To:     "Bartschies, Thomas" <Thomas.Bartschies@cvk.de>,
        'David Ahern' <dsahern@gmail.com>,
        "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>
References: <EB8510AA7A943D43916A72C9B8F4181F62A096BF@cvk038.intra.cvk.de>
 <24354e08-fa07-9383-e8ba-7350b40d3171@gmail.com>
 <df90f3cf-69d6-dae6-a394-b92a3fc379bb@gmail.com>
 <EB8510AA7A943D43916A72C9B8F4181F62A0981D@cvk038.intra.cvk.de>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <df6f5b96-0a5b-fdfb-100c-3dbd5581ccb0@gmail.com>
Date:   Wed, 16 Oct 2019 12:54:03 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <EB8510AA7A943D43916A72C9B8F4181F62A0981D@cvk038.intra.cvk.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/16/19 11:54 AM, Bartschies, Thomas wrote:
> Hello,
> 
> I had to adapt the second half to my test kernel. Just had to make some guesses, tested. and it works.
> Your conclusions are correct. I also suspected something like that, but with no knowledge of the inner
> workings of the ip stack I had very little chances to find the right fix by myself.
> 
> Thank you very much. Will retest know for a secondary forwarding problem that's much harder to reproduce.
> 

Sorry for the delay.

The patch backported to 5.2.18 would be something like :

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 8c2ec35b6512f1486cf2ea01f4a19444c7422642..96c02146be0af1e66230627b401c35757f9dc702 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -626,6 +626,7 @@ int ip_do_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
        if (skb_has_frag_list(skb)) {
                struct sk_buff *frag, *frag2;
                unsigned int first_len = skb_pagelen(skb);
+               ktime_t tstamp = skb->tstamp;
 
                if (first_len - hlen > mtu ||
                    ((first_len - hlen) & 7) ||
@@ -687,6 +688,7 @@ int ip_do_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
                                ip_send_check(iph);
                        }
 
+                       skb->tstamp = tstamp;
                        err = output(net, sk, skb);
 
                        if (!err)



> Regards,
> --
> Thomas Bartschies
> CVK IT-Systeme
> 
> -----Ursprüngliche Nachricht-----
> Von: Eric Dumazet [mailto:eric.dumazet@gmail.com] 
> Gesendet: Mittwoch, 16. Oktober 2019 17:41
> An: Bartschies, Thomas <Thomas.Bartschies@cvk.de>; 'David Ahern' <dsahern@gmail.com>; 'netdev@vger.kernel.org' <netdev@vger.kernel.org>
> Betreff: Re: big ICMP requests get disrupted on IPSec tunnel activation
> 
> On 10/16/19 8:31 AM, Eric Dumazet wrote:
>>
>>
>> On 10/16/19 5:57 AM, Bartschies, Thomas wrote:
>>> Hello,
>>>
>>> did another test. This time I've changed the order. First triggered the IPSec policy and then tried to ping in parallel with a big packet size.
>>> Could also reproduce the issue, but the trace was completely different. May be this time I've got the trace for the problematic connection?
>>>
>>
>> This one was probably a false positive.
>>
>> The other one, I finally understood what was going on.
>>
>> You told us you removed netfilter, but it seems you still have the ip defrag modules there.
>>
>> (For a pure fowarding node, no reassembly-defrag should be needed)
>>
>> When ip_forward() is used, it correctly clears skb->tstamp
>>
>> But later, ip_do_fragment() might re-use the skbs found attached to 
>> the master skb and we do not init properly their skb->tstamp
>>
>> The master skb->tstamp should be copied to the children.
>>
>> I will send a patch asap.
>>
>> Thanks.
>>
> 
> Can you try :
> 
> diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c index 28fca408812c5576fc4ea957c1c4dec97ec8faf3..c880229a01712ba5a9ed413f8aab2b56dfe93c82 100644
> --- a/net/ipv4/ip_output.c
> +++ b/net/ipv4/ip_output.c
> @@ -808,6 +808,7 @@ int ip_do_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
>         if (skb_has_frag_list(skb)) {
>                 struct sk_buff *frag, *frag2;
>                 unsigned int first_len = skb_pagelen(skb);
> +               ktime_t tstamp = skb->tstamp;
>  
>                 if (first_len - hlen > mtu ||
>                     ((first_len - hlen) & 7) || @@ -846,6 +847,7 @@ int ip_do_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
>                                 ip_fraglist_prepare(skb, &iter);
>                         }
>  
> +                       skb->tstamp = tstamp;
>                         err = output(net, sk, skb);
>  
>                         if (!err)
> 
