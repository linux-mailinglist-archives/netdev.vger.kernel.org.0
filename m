Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 303494FDED8
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 13:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234838AbiDLMBC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 08:01:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343682AbiDLL7e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 07:59:34 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACB3D17ABD
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 03:54:46 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id z6so21888849iot.0
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 03:54:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=cuESGRG4BO2nfFa0+8ZvF7UTLJiHecUweEg/G/1YzP4=;
        b=RBNRVZnLuno/ijORPN7PMrhrXQnHqSuqrgFmiyaCDw9HX9EBSf9gRcw3sZ352ZNM3a
         WE7pII686okLJe5x7ynHyv1AjQ4pOWzpSgB7QtIPV2icJIqxsRaW15vZm3a3WdWTozjM
         3UI2oF0DmWtbX/rdomuATivKYnq5JA2MddjulIywznb7MK/eyNxtcM8MEiwiMxi2wc4F
         4tr5MQt71fCNhSlaeCCroHnUjBSzC6Bg4iFcsJFIjUDZjMsU+1FEXJdbGrBLOFcKglvF
         42m9ZeTBcyWoXSNbDvpzzodSVN43nmrg/+XJxR1tCNJvdjK1EBc47wcCMCQvgcsYOY7o
         ZlAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=cuESGRG4BO2nfFa0+8ZvF7UTLJiHecUweEg/G/1YzP4=;
        b=c8Bm5Gxqdey2L4tB4ajQJqlUhhCtYRNV14tBv0zCvNZ+n/YpDehrM8Ks5yiXlv3XDo
         SLEdmas3l82zhvur13AJ6SEF8NHicP2wRqyaku7/RXSz1iXgO8jFG+1evI7wfdrfyWiY
         LLlBjPP838tNrlltGO3x9h/B8IIwqUIixDPVcRpHmo5/Sv+FWhtc/X8VTkFr0FXueiFe
         7ejY/zVgfFZH3EJsJiocu/e0fywr5u3EA0c9aRMyRYl9+1jN3FD0D0ezk2FLRXpDAoBQ
         l+O/MfdMGZfaMZoQPiuE3VTh2LdadEz6ARWgnL+h86OJewALJNGRBYG4Km1gzQLPOA7m
         owuw==
X-Gm-Message-State: AOAM530HON5JZ8FYyTFK/U6WCiboyx16rTbEzUWkEZAErgNsFSzUmQGZ
        HF242NRKKD5QT7HAaaZZOaQs6Q==
X-Google-Smtp-Source: ABdhPJzAN0UJBfDQleFGHIZyDdJzSZ7ORifnJ/e55f8MYc2HriiteStUi8EcdkrjVAJiibF+nrGT2g==
X-Received: by 2002:a02:8797:0:b0:326:30dd:85 with SMTP id t23-20020a028797000000b0032630dd0085mr4383794jai.44.1649760885846;
        Tue, 12 Apr 2022 03:54:45 -0700 (PDT)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-25-174-95-97-66.dsl.bell.ca. [174.95.97.66])
        by smtp.googlemail.com with ESMTPSA id o15-20020a6bcf0f000000b00649c4056879sm21487346ioa.50.2022.04.12.03.54.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Apr 2022 03:54:44 -0700 (PDT)
Message-ID: <24581ebb-e952-d1d8-8d64-a51c94e29bc8@mojatatu.com>
Date:   Tue, 12 Apr 2022 06:54:43 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH net-next 0/5] flower: match on the number of vlan tags
Content-Language: en-US
To:     Boris Sukholitko <boris.sukholitko@broadcom.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Eric Dumazet <edumazet@google.com>,
        zhang kai <zhangkaiheb@126.com>,
        Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        Ilya Lifshits <ilya.lifshits@broadcom.com>
References: <20220411133100.18126-1-boris.sukholitko@broadcom.com>
 <1b1b82a9-3e1b-d20a-f62c-f35fe1f155b8@mojatatu.com>
 <20220411145647.GA23636@noodle>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
In-Reply-To: <20220411145647.GA23636@noodle>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-04-11 10:56, Boris Sukholitko wrote:
> On Mon, Apr 11, 2022 at 10:07:14AM -0400, Jamal Hadi Salim wrote:
>> On 2022-04-11 09:30, Boris Sukholitko wrote:
>>> Hi,

[..]

>> Can you please provide more elaborate example of more than 1 vlan?
> 
> Perusing our logs, we have redirect rules such as:
> 
> tc filter add dev $GPON ingress flower num_of_vlans $N \
>     action mirred egress redirect dev $DEV
>

Please add in the commit logs.

> where N can range from 0 to 3 and $DEV is the function of $N.
> 

Also in the commit log, very specific to GPON. I have seen upto
4 in some telco environment.

> Also there are rules setting skb mark based on the number of vlans:
> 
> tc filter add dev $GPON ingress flower num_of_vlans $N vlan_prio \
>     $P action skbedit mark $M
>

Yep makes sense.


>> Where would the line be drawn:
>> Is it max of two vlans?
> 
> We have seen the maximum of 3 vlans.
> 
>> Is there potential of <=X, meaning matching of upto X Vlans?
>>
> 
> We've managed to get by without such feature somehow :)

If needed should be extensible. You already have ability to count, so
adding inequality check should not be hard to add when needed.

cheers,
jamal
