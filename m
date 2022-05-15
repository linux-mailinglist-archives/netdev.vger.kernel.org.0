Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E97EC527636
	for <lists+netdev@lfdr.de>; Sun, 15 May 2022 09:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235909AbiEOHQz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 May 2022 03:16:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235908AbiEOHQy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 May 2022 03:16:54 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06C7812D04
        for <netdev@vger.kernel.org>; Sun, 15 May 2022 00:16:52 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id w4so16603191wrg.12
        for <netdev@vger.kernel.org>; Sun, 15 May 2022 00:16:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=solid-run-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Gt3/CziA2U5T74PRbPc3Ihm2smim4IbHRf3PjKzYKFI=;
        b=a8ENmtQxA26cb5puth6IGElmry9ak+2SK0FKfmtln62H5zmomnqv2DupJBQxD2+Xi6
         J3TsenEg5Lln/yxYLvlqN708WAVax0Jt9ekOuau47+6ShGmeqkphRyS+P2GPqyTKxq23
         MCF7HmsWCsk912+bxsXDllCxds+1XigoyiUgN/9FM7xpVyLCt3kg0nZwcdSZPnDzbYR5
         k9D/fFG6SkZA26vQPg8BUMShcm4DPTKBP+vYl488j++4KPJw5dRAyq7ziJvCGB7d2J6g
         lDeh9CN/hiIOUzReeu8+eD3yuQZfS3sO0qTDbhAFyZI1BWyIqyJFVEN3Emu6CucVQf3W
         eRrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Gt3/CziA2U5T74PRbPc3Ihm2smim4IbHRf3PjKzYKFI=;
        b=356sI6Qnl/zlinq3/kYQ9VAFViGMAIWmfME5Xbiw57380c8a2RD+T6f8nX+ZqjKPQJ
         p9GVVCWuLd9XzVjaG/2TmIgIs+qkrgXp8z87nJOi/KCmD9mXBWJ1TGsTaT6vEW/0rvat
         QZjrt0lwdj4IpyBleC7VvUCy26sM+f5FB7FtQ5oSSFkrzA3/ZS8rojxaTpNWUAFkoH2e
         +Gm+QTPYYiaGVKEiyIxGSmiFEATsV4JltRIe+6BXeMiKTARLLFDn9ojqU58kI1TQ+GUd
         BPU2ZIKIIrDi2fSHBzHdrBvR+7t9om6c3NSylTf1eJ9XOytmYtBNr8CDClVvoLJs1kUY
         7wKA==
X-Gm-Message-State: AOAM531HaZ31kQCQf9dbrzC2ZgRO2rtupdaE0B0Q9FJmictlJrUt9OWa
        3uGBwsn5JW8y2MJbRJjmEgjJUw==
X-Google-Smtp-Source: ABdhPJyILOQwapkNSyMwNx3FKkAfQloPogxeg9v1kzK9Uh3lN/cz95fwpG1HRZq6yVB9VvgWh1jc+Q==
X-Received: by 2002:a5d:4b89:0:b0:20c:52e3:3073 with SMTP id b9-20020a5d4b89000000b0020c52e33073mr10230104wrt.140.1652599010133;
        Sun, 15 May 2022 00:16:50 -0700 (PDT)
Received: from [192.168.17.225] (bzq-82-81-222-124.cablep.bezeqint.net. [82.81.222.124])
        by smtp.gmail.com with ESMTPSA id p15-20020a7bcdef000000b00394517e7d98sm7013642wmj.25.2022.05.15.00.16.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 May 2022 00:16:49 -0700 (PDT)
Message-ID: <072a773c-2e42-1b82-9fe7-63c9a3dc9c7d@solid-run.com>
Date:   Sun, 15 May 2022 10:16:47 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v4 1/3] dt-bindings: net: adin: document phy clock
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, Michael Walle <michael@walle.cc>
Cc:     alexandru.ardelean@analog.com, alvaro.karsz@solid-run.com,
        davem@davemloft.net, edumazet@google.com,
        krzysztof.kozlowski+dt@linaro.org, michael.hennerich@analog.com,
        netdev@vger.kernel.org, pabeni@redhat.com, robh+dt@kernel.org
References: <20220510133928.6a0710dd@kernel.org>
 <20220511125855.3708961-1-michael@walle.cc>
 <20220511091136.34dade9b@kernel.org>
 <c457047dd2af8fc0db69d815db981d61@walle.cc>
 <20220511124241.7880ef52@kernel.org>
 <bfe71846f940be3c410ae987569ddfbf@walle.cc>
 <20220512154455.31515ead@kernel.org>
From:   Josua Mayer <josua@solid-run.com>
In-Reply-To: <20220512154455.31515ead@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

\o/

I am not sure I can follow your conversation here ...

Am 13.05.22 um 01:44 schrieb Jakub Kicinski:
> On Thu, 12 May 2022 23:20:18 +0200 Michael Walle wrote:
>>> It's pure speculation on my side. I don't even know if PHYs use
>>> the recovered clock to clock its output towards the MAC or that's
>>> a different clock domain.
>>>
>>> My concern is that people will start to use DT to configure SyncE which
>>> is entirely a runtime-controllable thing, and doesn't belong.
Okay.
However phy drivers do not seem to implement runtime control of those 
clock output pins currently, so they are configured once in DT.
>>> Hence
>>> my preference to hide the recovered vs free-running detail if we can
>>> pick one that makes most sense for now.
I am not a fan of hiding information. The clock configuration register 
clearly supports this distinction.

Is this a political stance to say users may not "accidentally" enable 
SyncE by patching DT?
If so we should print a warning message when someone selects it?
>>
>> I see. That makes sense, but then wouldn't it make more sense to pick
>> the (simple) free-running one? As for SyncE you'd need the recovered
>> clock.
> 
> Sounds good.

Yep, it seems recovered clock is only for SyncE - and only if there is a 
master clock on the network. Sadly however documentation is sparse and I 
do not know if the adi phys would fall back to using their internal 
clock, or just refuse to operate at all.
