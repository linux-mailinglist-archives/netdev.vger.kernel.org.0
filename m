Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE92592E8D
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 13:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241327AbiHOL4f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 07:56:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiHOL4d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 07:56:33 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C46A1CB3B
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 04:56:32 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id bu15so298493wrb.7
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 04:56:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=od29IOO6gTbC/HZ6aEdfYqUGdCf1E0vK68LS/4dEixg=;
        b=dAX80bApyf67JCE2DUrctDLbsGity+OOBnYKPNKf8lZNbJr6kDwo+eE1tA4udpKNaz
         gd5TVOjBuJCQ8l8mZi9ZuRsgTLiHcjpY9YuRIPonUCbWoembeuxEwMEqdItA0HXDeMqh
         CMtGbSNHmaRMnYLshZ52NoGk2pl8k0pwypsbg7h3fDFNH0kXn/DiEheTIFjjXCZTSBEt
         D3M9ks7MGOCEzH1A2aMMEAByVQN1h6kdNYoPeqvJSzhfZroQWgiHdOhHxUELgKKgNYU2
         91gAd+bNJRKS6NLSQuAfJkdaLExUp9xfzx1qwgHtXTRDlWMMd341GhcQiwp8h98rmKb+
         FmJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=od29IOO6gTbC/HZ6aEdfYqUGdCf1E0vK68LS/4dEixg=;
        b=VL/Ek6gMjozOG+Byn4PQbx7FepiveQqLjmovjfASagSACHc265wAL5dm6J0RnABQ3Y
         5nmvt0T3Hi3L1UbPt1+Z8e3Fz29e35KRX1lpteKUoe47vX+HIsIcal2bWMCanLZRC9oZ
         tonBncdwtKYexpmv0UC+9fbqDWRB2oRaE2Ufaa6r/8Gg6v6oVGF5hWQilFPr30iI1Y04
         w6pzqRazVLaaXOMfGZQGvW4SNbgUFKTUyjTHHGrId1D8SQaRgbedlUyeeoAoZL1DcwiK
         8pyHujBByPqLN0civaVjEzx+iLquDeS1NSxXksw/Lh26INQjCdm5RQ0NSpNi0qffSVRZ
         RoTg==
X-Gm-Message-State: ACgBeo0mZo/QfvThaSiZUxDjz7fa5frnWqBnmmWnsIo6dffc1Yvj0zeK
        17RkRr70ydrtrjLsuLg4bxzlpA==
X-Google-Smtp-Source: AA6agR49bq7t+WT0onl+f2SU/VXCX07/a4PTztrr5ZOBzp9kZMO+GtM+VNXcCR6lZ2FgpkCrP+Muqw==
X-Received: by 2002:adf:f10d:0:b0:220:7e4f:ceb6 with SMTP id r13-20020adff10d000000b002207e4fceb6mr8655582wro.316.1660564590874;
        Mon, 15 Aug 2022 04:56:30 -0700 (PDT)
Received: from [192.168.2.1] (146725694.box.freepro.com. [130.180.211.218])
        by smtp.googlemail.com with ESMTPSA id m20-20020a05600c3b1400b003a319b67f64sm14804353wms.0.2022.08.15.04.56.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Aug 2022 04:56:30 -0700 (PDT)
Message-ID: <409cd6c3-5ae1-01c6-e774-c60718fa459b@linaro.org>
Date:   Mon, 15 Aug 2022 13:56:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2 1/2] Revert "mlxsw: core: Use different get_trend()
 callbacks for different thermal zones"
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     rafael@kernel.org, vadimp@mellanox.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vadim Pasternak <vadimp@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <20220815091032.1731268-1-daniel.lezcano@linaro.org>
 <YvoybKfgNnHi36dN@shredder>
From:   Daniel Lezcano <daniel.lezcano@linaro.org>
In-Reply-To: <YvoybKfgNnHi36dN@shredder>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Ido,

On 15/08/2022 13:47, Ido Schimmel wrote:
> On Mon, Aug 15, 2022 at 11:10:31AM +0200, Daniel Lezcano wrote:
>> This reverts commit 2dc2f760052da4925482ecdcdc5c94d4a599153c.
>>
>> As discussed in the thread:
>>
>> https://lore.kernel.org/all/f3c62ebe-7d59-c537-a010-bff366c8aeba@linaro.org/
>>
>> the feature provided by commits 2dc2f760052da and 6f73862fabd93 is
>> actually already handled by the thermal framework via the cooling
>> device state aggregation, thus all this code is pointless.
>>
>> No conflict happened when reverting the patch.
>>
>> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
>> Tested-by: Vadim Pasternak <vadimp@nvidia.com>
> 
> Daniel, the intention is to send these patches to mainline as part of
> your 6.1 pull request?

Yes, I told Vadim I prefer the change to go through my tree because it 
is part of a rework of the thermal core internals which impact more drivers.

> I discussed it with Vadim yesterday and we do not expect changes in the
> file during the current cycle so this is OK as far as we are concerned,
> but I believe this will also need an ack from one of the netdev
> maintainers.

Sure.

Dave, Eric,

Is that fine if the changes go through my tree ?



-- 
<http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog
