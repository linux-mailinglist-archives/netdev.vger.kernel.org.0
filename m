Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 066235F345C
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 19:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbiJCRVK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 13:21:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbiJCRVH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 13:21:07 -0400
Received: from novek.ru (unknown [213.148.174.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79679233A1;
        Mon,  3 Oct 2022 10:21:01 -0700 (PDT)
Received: from [192.168.0.18] (unknown [37.228.234.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 59A7F504DDD;
        Mon,  3 Oct 2022 20:17:07 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 59A7F504DDD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1664817429; bh=lm4Wb7jLqcErrIgbXs/DukXIBa4faqBjfyZytSxlIdY=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=wUPmnsVnoQCKGwi1891Fgssyn1UW5tgeLYmU2EDWwCzR/+IAwWUHbEwpE2Y5x+Z4M
         bnnm6cHs4bjXP9Sr/9K03L9dy/nZDYHbkmz8FP/vHdtpu0clf9jpIYL9a3Ys07Riq0
         7zz381jEuqRvILKZQ+R2j8b1sJM2P7FUPieq0mcU=
Message-ID: <2bb59b66-ffb2-0bfe-83d5-a6ff606ca98e@novek.ru>
Date:   Mon, 3 Oct 2022 18:20:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [RFC PATCH v2 0/3] Create common DPLL/clock configuration API
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        Vadim Fedorenko <vadfed@fb.com>
Cc:     Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Aya Levin <ayal@nvidia.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org,
        Gal Pressman <gal@nvidia.com>
References: <20220626192444.29321-1-vfedorenko@novek.ru>
 <YzWESUXPwcCo67LP@nanopsycho> <6b80b6c8-29fd-4c2a-e963-1f273d866f12@novek.ru>
 <Yzap9cfSXvSLA+5y@nanopsycho> <20220930073312.23685d5d@kernel.org>
 <YzfUbKtWlxuq+FzI@nanopsycho> <20221001071827.202fe4c1@kernel.org>
 <Yzmhm4jSn/5EtG2l@nanopsycho> <20221003072831.3b6fb150@kernel.org>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
In-Reply-To: <20221003072831.3b6fb150@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03.10.2022 15:28, Jakub Kicinski wrote:
> On Sun, 2 Oct 2022 16:35:07 +0200 Jiri Pirko wrote:
>>>> What I'm trying to say
>>>> is, perhaps sysfs is a better API for this purpose. The API looks very
>>>> neat and there is no probabilito of huge grow.
>>>
>>> "this API is nice and small" said everyone about every new API ever,
>>> APIs grow.
>>
>> Sure, what what are the odds.
> 
> The pins were made into full objects now, and we also model muxes.
> 
> Vadim, could you share the link to the GH repo?

I've already shared the link to Jiri.
> 
> What's your feeling on posting the latest patches upstream as RFC,
> whatever state things are in right now?
> 
I'll post RFC v3 once we agree on locking mechanics for pins. Right now there is 
no good solution AFAIU, discussions are in progress.

> My preference would be to move the development to the list at this
> stage, FWIW.

I got this point and I will follow it once we will have something ready.
