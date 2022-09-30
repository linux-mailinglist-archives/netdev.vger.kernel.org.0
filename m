Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C28365F1174
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 20:19:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232002AbiI3STq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 14:19:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232196AbiI3STm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 14:19:42 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DF6DE11B4
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 11:19:31 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id a26so10736444ejc.4
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 11:19:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=dNmmnymGTTPLepAvwy4BCZEdwtq1yE9p/7IaHwbiiPs=;
        b=QbOUO3SFiEcnAaKaNCD9UlhuARtZi9d3W2fHdhT8ebWinutEVdxWMuxKLo+CuthJWm
         ChQdphB4sVx9g+QKfSP3pdRd0pOxnzu53vBzJKE0QT0Hey4zvGtdNIBJybpTk8g8VlpN
         N9LmhRlxWBarkyIFBXV3iE7Va3GwY/19uCYPyUustWmcKh90CUh8U+cZzIhsfo9JZKxe
         HzCXjwL5sy4Gss1JOGlONDk47oJVpDN1H5KRmRlH548p+8Y9eeGtDMvfCSM22FHE0zgw
         keyhHg6c19F7CZyIaUPlRZeEpYsF/MuXTN7t26K7Gtq+zMNkRTbWpJeureFumKIEcd3I
         yajQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=dNmmnymGTTPLepAvwy4BCZEdwtq1yE9p/7IaHwbiiPs=;
        b=YgKrzHHFW8NFI2QJBIfAGBaiHQcNCxL0F8SJgaxTq5nS5cl/4CoAC16pmzOfqnMsLh
         mojeurwDCzj7dwv4W1HrB7NxKCVZg4IrP54AELRd+Ms4evl6125KkR+7vuW56mKHHymt
         xyH88Vjinc/lD0nFxG8uvo7m6rg5Yg3Bok+SpiYdjZeo547NMHQC8GjGkPOdacEmNFiA
         mXq52ess9WS7s0xntethYjWp71qMKN0kk/F5TLJq7OHWE9Ne9UJGHYcf4AvaAIKq58Rl
         3/QbWoxGWhRTRMkBZ9F0hvvGyKzWyHrchpOmfouHqxL/QD6cMXt19yEPuLFynjOfdtLz
         K25A==
X-Gm-Message-State: ACrzQf3DSXKCqbAUHRG49f3A3ra9YPyPfgt2RSezmN76pEy1aorCWeBE
        uReYbPmbb8E+40wsjJJCl2aFXQ==
X-Google-Smtp-Source: AMsMyM5rlKnuckNjGR0Syj4uS2Z8vJRLV9vwGN5O8UemryNXKvN39l5pef309QpT4R9o1C07SEKQig==
X-Received: by 2002:a17:907:608d:b0:787:6e75:5111 with SMTP id ht13-20020a170907608d00b007876e755111mr7413202ejc.760.1664561969931;
        Fri, 30 Sep 2022 11:19:29 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id f13-20020a17090660cd00b0077a7c01f263sm1506158ejk.88.2022.09.30.11.19.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Sep 2022 11:19:29 -0700 (PDT)
Message-ID: <8de025b0-01d8-2d28-4c6a-052758f7c737@blackwall.org>
Date:   Fri, 30 Sep 2022 21:19:27 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH net-next] docs: netlink: clarify the historical baggage of
 Netlink flags
Content-Language: en-US
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        Johannes Berg <johannes@sipsolutions.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Guillaume Nault <gnault@redhat.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Hangbin Liu <liuhangbin@gmail.com>
References: <20220927212306.823862-1-kuba@kernel.org>
 <a3dbb76a-5ee8-5445-26f1-c805a81c4b22@blackwall.org>
 <20220928072155.600569db@kernel.org>
 <CAM0EoMmWEme2avjNY88LTPLUSLqvt2L47zB-XnKnSdsarmZf-A@mail.gmail.com>
 <c3033346-100d-3ec6-0e89-c623fc7b742d@blackwall.org>
 <CAM0EoMnpSMydZvQgLXzoqAHTe0=xx6zPEaP1482qHhrTWGH_YQ@mail.gmail.com>
 <4f8b1dec-82c8-b63f-befe-b2179449042d@blackwall.org>
 <CAM0EoMn09qMjpHV5dHEaMDBCuRBVt6qbcTToXCeqCQ-+-7UJeQ@mail.gmail.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <CAM0EoMn09qMjpHV5dHEaMDBCuRBVt6qbcTToXCeqCQ-+-7UJeQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        URI_NO_WWW_INFO_CGI autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30/09/2022 19:36, Jamal Hadi Salim wrote:
> On Fri, Sep 30, 2022 at 10:34 AM Nikolay Aleksandrov
> <razor@blackwall.org> wrote:
>>
>> On 30/09/2022 17:24, Jamal Hadi Salim wrote:
>>> On Fri, Sep 30, 2022 at 7:29 AM Nikolay Aleksandrov <razor@blackwall.org> wrote:
> 
> [..]
> 
>>>
>>> I think what you are looking for is a way to either get or delete
>>> selective objects
>>> (dump and flush dont filter - they mean "everything"); iow, you send a filtering
>>
>> They must be able to flush everything, too. Filter matching all/empty filter, we need
>> it for mdbs and possibly other object types would want that.
> 
> You only have one object type though per netlink request i.e you
> dont have in the same message fdb and mdb objects?
> 

Yep, it is object-type and family- specific, as is the call itself.

>>> expression and a get/del command alongside it. The filtering
>>> expression is very specific
>>> to the object and needs to be specified as such a TLV is appropriate.
>>>
>>
>> Right, and that is what got implemented. The filtering TLVs are bridge and fdb-specific
>> they don't affect any other subsystem. The BULK flag denotes the delete will
>> affect multiple objects.
>>
> 
> Isnt it sufficient to indicate what objects need to be deleted based on presence
> of TLVs or the service header for that object?
> 

That was my initial proposal for the fdbs. :)  When flush attribute was present it would
act on it (and filter based on embedded filters). The only non-intuitive part was that it
happened through SETLINK (changelink), which is a bit strange for a delete op.

>>> Really NLM_F_ROOT and _MATCH are sufficient. The filtering expression is
>>> the challenge.
>>
>> NLM_F_ROOT isn't usable for a DEL expression because its bit is already used by NLM_F_NONREC
>> and it wouldn't be nice to change meaning of the bit based on the subsystem. NLM_F_MATCH's bit
>> actually matches NLM_F_BULK :)
>>
> 
> Ouch. Ok, it got messy over time i guess. We probably should have
> spent more time
> discussing NLM_F_NONREC since it has a single user with very specific
> need and it
> got imposed on all.
> I get your point - i am still not sure if a global flag is the right answer.
> 

Personally, I prefer the complete netlink approach (tlvs describing the operation and filters).
In the end the flag was close enough, I kept all of the family specific code the same just the entry
point was different and other families could use it as a modifier to their del commands.

>>
>> Sometime back I played with a different idea - expressing the filters with the existing TLV objects
>> so whatever can be specified by user-space can also be used as a filter (also for filtering
>> dump requests) with some introspection. The lua idea sounds nice though.
> 
> So what is the content of the TLV in that case?

My first approach, which wasn't using bpf, used the tlv type to define specific filters on the various
types, incl. binary (which at the time was only an exact match, could be improved though). BPF w/ btf
would be the obvious choice these days.

> I think ebpf may work with some acrobatics. We did try classical ebpf and it was
> messy. Note for scaling, this is not just about Delete and Get but
> also for generated
> events, where one can send to the kernel a filter so they dont see a broadcast

Yeah, I remember CL having scaling issues in some user-space software that was snooping
netlink messages and that's the reason I looked into filtering at that time.

> of everything. See for example a use case here:
> https://www.files.netdevconf.info/d/46fd7e152d1d4f6c88ac/files/?p=/LargeScaleTCPAnalytics.pdf
> 
> cheers,
> jamal

