Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6579B5F0D9D
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 16:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbiI3Oey (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 10:34:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbiI3Oex (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 10:34:53 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CB225051A
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 07:34:52 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id lc7so9502706ejb.0
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 07:34:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=/k0tUOCGRoGonmd1+MthpilEN/XKi/4ncYY1WreELNA=;
        b=HBIT2pYQ7RNLt8628eiJWCUQuHj7928uwAd+GjuqyNNBvGrKEUdrvPp8AsobYdHaxJ
         6Hi3rfbgVUMUidzdZsAXjZ174s0N0YPZwQl8ZeFHa4W1jkVCEDPoCp3a5i9dUyIKekp4
         sv6Y9Ja3kEOzu5SDj81Q0BVGxT+OM/gX+3isqtgQJAuHi/Q2AbQTnwt25kXQLf2QrdGk
         6yWlFrbwtNUuK965myc4TaTyz7ec+/ueQhGYjmJBSg3KiijJkZJBz3Cg3gqFKqdzpU10
         +U/6tzectKrlsQ2PY029GD/ws7rEdWCNtbgZx9mtWm+3+1lnjHOFlm9pyXizBtu2KmxQ
         LIrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=/k0tUOCGRoGonmd1+MthpilEN/XKi/4ncYY1WreELNA=;
        b=oHo79swek8UR9F88ZHErog8d/FmEPLPRLX9s4ajYyHKvKlTf9Pp56whfDDovgwWjod
         yGyqWYw9qhx5pf9PMi2AhDoGmr1R5wxKWpvjq8eZOhZQ3zE9GyMpFL7miCv5T42vM9a4
         9u/ssJIOvOCAFSfOazF1lIJHDuBnYo0VzI09X7VR/FhTaRtJl8xeNa3j/48tWKyp5JFt
         4NovBFEkHnCrfZV8X0EBbXxhaK37oxtQd/G1k8SQMl0lIOoq975SU0GPBj2lB2S9jPsu
         iBQhA6q51acEQ5a1AbdkYYZgNk5a6KwKlmH/SAvy5pR1BdQpvOvZOYk7PN7Z37j8g2LS
         VzRA==
X-Gm-Message-State: ACrzQf0NBZ5ejQ7YG094TDrDcFNeFKChG0cr/tCGS5AVtBiGxV0sT4L7
        nzA/P2dBEqM+cRpAGayG+Hi/Og==
X-Google-Smtp-Source: AMsMyM7cD5GgJNKVRJ+vHptIuetw4Hz8RinV6QoDxzLcRXNNXE/vMnaKLTGH3Cd84czeoQkojC5hVg==
X-Received: by 2002:a17:907:6ea4:b0:782:b261:e9ec with SMTP id sh36-20020a1709076ea400b00782b261e9ecmr6749956ejc.287.1664548490288;
        Fri, 30 Sep 2022 07:34:50 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id c5-20020a50d645000000b004580b26e32esm1763678edj.81.2022.09.30.07.34.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Sep 2022 07:34:49 -0700 (PDT)
Message-ID: <4f8b1dec-82c8-b63f-befe-b2179449042d@blackwall.org>
Date:   Fri, 30 Sep 2022 17:34:47 +0300
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
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <CAM0EoMnpSMydZvQgLXzoqAHTe0=xx6zPEaP1482qHhrTWGH_YQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30/09/2022 17:24, Jamal Hadi Salim wrote:
> On Fri, Sep 30, 2022 at 7:29 AM Nikolay Aleksandrov <razor@blackwall.org> wrote:
>>
>> On 30/09/2022 14:07, Jamal Hadi Salim wrote:
>>> On Wed, Sep 28, 2022 at 10:21 AM Jakub Kicinski <kuba@kernel.org> wrote:
>>>>
>>>> On Wed, 28 Sep 2022 10:03:07 +0300 Nikolay Aleksandrov wrote:
>>>>> The part about NLM_F_BULK is correct now, but won't be soon. I have patches to add
>>>>> bulk delete to mdbs as well, and IIRC there were plans for other object types.
>>>>> I can update the doc once they are applied, but IMO it will be more useful to explain
>>>>> why they are used instead of who's using them, i.e. the BULK was added to support
>>>>> flush for FDBs w/ filtering initially and it's a flag so others can re-use it
>>>>> (my first attempt targeted only FDBs[1], but after a discussion it became clear that
>>>>> it will be more beneficial if other object types can re-use it so moved to a flag).
>>>>> The first version of the fdb flush support used only netlink attributes to do the
>>>>> flush via setlink, later moved to a specific RTM command (RTM_FLUSHNEIGH)[2] and
>>>>> finally settled on the flag[3][4] so everyone can use it.
>>>>
>>>> I thought that's all FDB-ish stuff. Not really looking forward to the
>>>> use of flags spreading but within rtnl it may make some sense. We can
>>>> just update the docs tho, no?
>>>>
>>>> BTW how would you define the exact semantics of NLM_F_BULK vs it not
>>>> being set, in abstract terms?
>>>
>>> I missed the discussion.
>>> NLM_F_BULK looks strange. Why pollute the main header? Wouldnt NLM_F_ROOT
>>> have sufficed to trigger the semantic? Or better create your own
>>> "service header"
>>> and put fdb specific into that object header? i.e the idea in netlink
>>> being you specify:
>>> {Main header: Object specific header: Object specific attributes in TLVs}
>>> Main header should only be extended if you really really have to -
>>> i.e requires much
>>> longer review..
>>>
>>
>> I did that initially, my first submission used netlink attributes specifically
>> for fdbs, but then reviews suggested same functionality is needed for other object types
>> e.g. mdbs, vxlan db, neighbor entries and so on. My second attempt added a new RTM_ msg type that
>> deletes multiple objects, and finally all settled on the flag because all families can
>> make use of it, it modifies the delete op to act on multiple objects. For more context please
>> check the discussions bellow [1] is my first submission (all netlink), [2] is RTM_
>> and [3][4] are the flag:
> 
> I think what you are looking for is a way to either get or delete
> selective objects
> (dump and flush dont filter - they mean "everything"); iow, you send a filtering

They must be able to flush everything, too. Filter matching all/empty filter, we need
it for mdbs and possibly other object types would want that.

> expression and a get/del command alongside it. The filtering
> expression is very specific
> to the object and needs to be specified as such a TLV is appropriate.
> 

Right, and that is what got implemented. The filtering TLVs are bridge and fdb-specific
they don't affect any other subsystem. The BULK flag denotes the delete will
affect multiple objects.

> Really NLM_F_ROOT and _MATCH are sufficient. The filtering expression is
> the challenge.

NLM_F_ROOT isn't usable for a DEL expression because its bit is already used by NLM_F_NONREC
and it wouldn't be nice to change meaning of the bit based on the subsystem. NLM_F_MATCH's bit
actually matches NLM_F_BULK :)

> "functionality is needed for other objects" is a true statement; the question is
> whether we keep hacking into the kernel for these filtering expressions.> An idea i toyed with at one point was to send alongside the netlink
> request a lua
> program that will execute your selector. Then you dont have to keep hacking
> and extending netlink TLVs or adding more to the kernel.
> Lua is very appealing because you dont have to compile anything - and the
> whole program goes into the kernel as a string.
> Second best alternative could be to install a bpf program as your selector and
> invoke it from netlink code to select the entries that get deleted or returned.
> You will have to keep transactional state.
> 

Sometime back I played with a different idea - expressing the filters with the existing TLV objects
so whatever can be specified by user-space can also be used as a filter (also for filtering
dump requests) with some introspection. The lua idea sounds nice though.

> cheers,
> jamal

