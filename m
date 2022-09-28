Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B20F55ED8C1
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 11:22:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233631AbiI1JWF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 05:22:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233543AbiI1JWE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 05:22:04 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 270CE5F9A3
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 02:22:01 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id a13so1325005edj.0
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 02:22:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=FaaOgDtK9TyS0PoRrl8QZ7NwsI6ddEBCIDU/7HAk3aM=;
        b=zsgx/kJsmIDXu6++WpqIJO74LDVjtUusm8cN25QFWv2kSciJlpepE27BJBMTwFHCPB
         r0arArW9e570sNNgRqcVgflL/OjYOam2y1TfRsnNlQbhaLS3ZkO+ntxRRGZdu9x2wUua
         PiqWoXeLMKeBZiHbPMSpNpyhGATjFUJ6iuXoTbWCP7mJoDOfITi1KE/yAP1T0X+Ay89z
         It1znFuNqx2YhjGcx9Q7AdzhvxowdlQOvtpJ+bXoT3NLCcU6lMXmL37aqUHu2a5DFM0V
         way/sOq+/K9lpFzFXM2W5S1vkD++ZhYt/Pjowo06qzXdZI9D4az+eo9mhPL3K4McMqNB
         FqrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=FaaOgDtK9TyS0PoRrl8QZ7NwsI6ddEBCIDU/7HAk3aM=;
        b=1JopZvYfjuV1p9qKHlIiz0aGhI0L0/yNkSibKj6rRPbZK3b+bh5/F/tNRuXhhoJkWW
         WKDZemyF1eD3t0cyOF3t9QpIgx9jjzcKGucHxuAyfQHbVTC7p1I0++P2G22gjWsc/owJ
         fFzonMLrzw9/BtKBsMxIz8yQx54W9RgCiQtDbIt+quGUsiY9yqIR+PQzEWbeltYOXuUL
         l6vSbXBOmSN5B9H+b1gCx6ImNOkO1UOdNJ8TMmYQ1jYuaTdDVFY4wV2nfPgk92eckjvK
         TLp5axxmdC8+CPw++SIlruLZ63iL4XSUbspk6PjiqYkRnokTDmBLGZa6uGuO/9vs1NIi
         PKAg==
X-Gm-Message-State: ACrzQf0sNc8OHe5ShcGvCqubCd133+l0lwudhegtoiOOz2Y2e0gPuMGD
        CYGFtfw7r1gpseXfDXLokTe08Q==
X-Google-Smtp-Source: AMsMyM5v/YQV1SftdRhGHhSf2rrVrDzDcuLd1V1Y4YRZiKiYMMRMldeqzindC70eUewgNuJk938HiA==
X-Received: by 2002:aa7:d28a:0:b0:457:caea:9585 with SMTP id w10-20020aa7d28a000000b00457caea9585mr5760396edq.400.1664356919573;
        Wed, 28 Sep 2022 02:21:59 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id ku18-20020a170907789200b0073100dfa7b0sm2104337ejc.8.2022.09.28.02.21.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Sep 2022 02:21:59 -0700 (PDT)
Message-ID: <e4db8d52-5bbb-8667-86a6-c7a2154598d1@blackwall.org>
Date:   Wed, 28 Sep 2022 12:21:57 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH net-next] docs: netlink: clarify the historical baggage of
 Netlink flags
Content-Language: en-US
To:     nicolas.dichtel@6wind.com,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Guillaume Nault <gnault@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
References: <20220927212306.823862-1-kuba@kernel.org>
 <a93cea13-21e9-f714-270c-559d51f68716@wifirst.fr>
 <d93ee260-9199-b760-40fe-f3d61a0af701@6wind.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <d93ee260-9199-b760-40fe-f3d61a0af701@6wind.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/09/2022 11:55, Nicolas Dichtel wrote:
> 
> Hello,
> 
> Le 28/09/2022 à 10:04, Florent Fourcot a écrit :
>> Hello,
>>
>> About NLM_F_EXCL, I'm not sure that my comment is relevant for your intro.rst
>> document, but it has another usage in ipset submodule. For IPSET_CMD_DEL,
>> setting NLM_F_EXCL means "raise an error if entry does not exist before the
>> delete".
> So NLM_F_EXCL could be used with DEL command for netfilter netlink but cannot be
> used (it overlaps with NLM_F_BULK, see [1]) with DEL command for rtnetlink.
> Sigh :(
> 
> [1] https://lore.kernel.org/netdev/0198618f-7b52-3023-5e9f-b38c49af1677@6wind.com/
> 
> 
> Regards,
> Nicolas

One could argue that's abuse of the api, but since it's part of a different family
I guess it's ok. NLM_F_EXCL is a modifier of NEW cmd as the comment above it says
and has never had rtnetlink DEL users.


