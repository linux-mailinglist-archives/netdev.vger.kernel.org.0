Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79CAE5190B8
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 23:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242204AbiECVsF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 17:48:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238169AbiECVsE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 17:48:04 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE03E2DD49
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 14:44:30 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id a22so11736484qkl.5
        for <netdev@vger.kernel.org>; Tue, 03 May 2022 14:44:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ggM6Tr17bza2NldnnZ+b75hkn7TB+UqlGcKv2f0eQfM=;
        b=i9dIr15VbbnLcQiaqCqcrTuBIStlh0xsWDP3RqI+hrNmCgfMxL5BOgkBj/LfqfAoCl
         Qh4McT/tWOM+7MIUmga0Sjxx5QBsc3IU5LUKj2PALbvnbaTab/Se8Ibovg9Tjw/1P+qJ
         itpckWffDpx59OCAa0Z8t7lUECYpdY56COEXytyfgAoC5S5k6hc0187gdsrqml0zY6v5
         eHHIvjxQSU9sTwZ5F/wyjoJgfAeaJ7ee2yYVNwpGEOjVRDr1OHgEGFqCRketq0g6uuzd
         3aMAHfGc4ZXAkVB90jSiFrgo2lvLhfhVsh0EdVfHHulqcrjIj863L2X5oFNHBrrWb97P
         wZOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ggM6Tr17bza2NldnnZ+b75hkn7TB+UqlGcKv2f0eQfM=;
        b=U9o5AJ4XZ0SGgtmuXPyVet3wjMPJxdrGM/tLDi+QLDrNgGjUZXvKAfVHGXHbSVmoqD
         gxCkCO1YpHKTQbwCDSxLwUXTw5FcD8eWQoFgoiZMkgEbRpivBzlVZy7ODsrlgdZ1sVa4
         /ZqpdNYTCA7SX8IYJVFkB4LXxV+7bEWdbVQBTyc/Y2+VCr5DzDUCPAjwqvcWPGppMhoH
         9n7K0IDvWZ5B/SBks546Iq6nkaSDAg1qoQy/IDj1qiZSONnWTNw3xyTzAJzlAUIW6Qj+
         UKKpJZqsyx4PyYigLJHBpQMxer/JVFlgkuvANjUyuWyMIaO3+/RYBAv5hrEuO7x4tHTR
         Gtkg==
X-Gm-Message-State: AOAM531X3CcBY+BkL41W8NJkxEvACKGX3XbZ/Jjp7RF1jSAIgy2vphdC
        wOAouN8xX0i6El9KOA/xMs/T3Q==
X-Google-Smtp-Source: ABdhPJyzrQYwg5JlR6N7u6Q3xhZsMO9/NIkhfl4wFxDpZPB9lhU1Elp9kc25Wegt7pNGR3UVY4JMFA==
X-Received: by 2002:a05:620a:294d:b0:69f:d37e:dca5 with SMTP id n13-20020a05620a294d00b0069fd37edca5mr9899323qkp.321.1651614269949;
        Tue, 03 May 2022 14:44:29 -0700 (PDT)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-27-184-148-44-6.dsl.bell.ca. [184.148.44.6])
        by smtp.googlemail.com with ESMTPSA id 18-20020a370a12000000b0069fc13ce1f7sm6705584qkk.40.2022.05.03.14.44.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 May 2022 14:44:29 -0700 (PDT)
Message-ID: <e4488ef0-82f7-a5b0-4537-ef5b3dfb503b@mojatatu.com>
Date:   Tue, 3 May 2022 17:44:28 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net-next 01/11] ice: Add support for classid based queue
 selection
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "Nambiar, Amritha" <amritha.nambiar@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Mogilappagari, Sudheer" <sudheer.mogilappagari@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        "Sreenivas, Bharathi" <bharathi.sreenivas@intel.com>
References: <20220428172430.1004528-1-anthony.l.nguyen@intel.com>
 <20220428172430.1004528-2-anthony.l.nguyen@intel.com>
 <20220428160414.28990a0c@kernel.org>
 <MWHPR11MB1293C17C30E689270E0C39AAF1FC9@MWHPR11MB1293.namprd11.prod.outlook.com>
 <20220429171717.5b0b2a81@kernel.org>
 <MWHPR11MB129308C755FAB7B4EA1F8DDCF1FF9@MWHPR11MB1293.namprd11.prod.outlook.com>
 <20220429194207.3f17bf96@kernel.org>
 <d3935370-b12c-e9db-1e59-52c8cceacf9a@mojatatu.com>
 <20220503084732.363b89cc@kernel.org>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
In-Reply-To: <20220503084732.363b89cc@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-05-03 11:47, Jakub Kicinski wrote:
> On Tue, 3 May 2022 06:32:01 -0400 Jamal Hadi Salim wrote:
>> I am on the fence of "six of one, half a dozen of the other" ;->
>>
>> TC classids have *always been used to identify queues* (or hierarchy of
>> but always leading to a single queue). Essentially a classid identity
>> is equivalent to a built-in action which says which queue to pick.
>> The data structure is very much engrained in the tc psyche.
>>
>> When TX side HW queues(IIRC, mqprio) showed up there was ambiguity to
>> distinguish between a s/w queue vs a h/w queue hence queue_mapping
>> which allows us to override the *HW TX queue* selection - or at least
>> that was the intended goal.
>> Note: There are other ways to tell the h/w what queues to use on TX
>> (eg skb->priority) i.e there's no monopoly by queue_mapping.
>>
>> Given lack of s/w queues on RX (hence lack of ambiguity) it seemed
>> natural that the classid could be used to describe the RX queue
>> identity for offload, it's just there.
>> I thought it was brilliant when Amritha first posted.
> 
> Is it just me or is TC generally considered highly confusing?

Hopefully we can discuss what is confusing (otherwise this becomes the
internet troll discussion of "tc sucks").
The fact that folks find ways to use s/w in an unintended ways is
not unique to tc. The architecture is clean.

> IMO using a qdisc cls construct in clsact is only going to add
> to that.
> 
> Assigning classid can still be meaningful on ingress in case
> of a switch where there are actual qdiscs offloaded.
> 
>> I think we should pick the simpler of "half-dozen or six".
>> The posted patch seems driver-only change i.e no core code
>> changes required (which other vendors could follow).
>> But i am not sure if that defines "simpler".
> 
> No core changes is not an argument we should take seriously upstream.
>

I am afraid, that sounds like a blanket statement though.
It should be taken seriously if it helps maintainability
but like i said i wasnt sure having not seen the alternative.

>> BTW:
>> Didnt follow the skb_record_rx_queue() thought - isnt that
>> always set by the driver based on which h/w queue the packet
>> arrived at? Whereas the semantics of this is to tell the h/w
>> what queue to use.
> 
> Overriding the queue mapping in the SW could still be useful
> if TC wants to override the actual queue ID assigned by the NIC.
> 
> This way whether the action gets offloaded or not the resulting
> skb will have the same metadata (in case of offload because it
> came on the right queue and the driver set the mapping, in case
> of sw because we overwrote the mapping).

IIUC, you are suggesting that using the same semantics for ingress and
egress is more intuitive - and that is a fair arguement.
Hope you understand my view when I said it was half a dozen or six
given we have multiple approaches today on egress that signal the
hardware what queue to use (and classid's intent is/was to
select a queue).

cheers,
jamal
