Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4765D6BB96B
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 17:18:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232223AbjCOQSE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 12:18:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232000AbjCOQRj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 12:17:39 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 405E7A24C
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 09:17:16 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id r29so9801775wra.13
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 09:17:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678897035;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tgwl82S5mdfE2CdDcwGAXad35FkzqQYTV2uOaNJvBYk=;
        b=ozmnm0NQJT2PfGDW0OUFqHh0n1m6Egw5ksk7MaQfQL9OA/s5//svKMpTAju0IVUQk5
         XKX/O+P9jCvKTEt6u2Dmkjy7XMuf0+cf/wAdPaUsCcVXkn+Vzhw8GcHqoDyXpH6i6M/R
         dGIazqblsVlbmnSgIA0v0ZZ02zUO15swmKZ7Ne4i67y1yeKgmMS/RiR7YfUA8RxSOP1J
         IRHfMzE2SqmyxHGNrfY7UaBrFO2TnB0MG4Kciol/ZSx0tx3wW7LOEmreXY53RXpfUIUo
         lVY1nab82TBduXb4grk73TmkyYquorIkKsJTy8m55W+1m/5j3S9MPFDsr1SkMaPTl4Xa
         8oVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678897035;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tgwl82S5mdfE2CdDcwGAXad35FkzqQYTV2uOaNJvBYk=;
        b=H6+kf8kO3KHWMCAtyyOe/JR3nEwpVvTc6zqNhEs1P+vt1AwHfwXj9pmTqAeVzhVrTl
         HNb4a64xvn3GNZuAG+OI+VvfjV3r5eAsMFt8N9Chrx0lfLShUq9Wj7TTGhVGM/sfL4/l
         kL1PVUvLtEG/MGoub/uNrV2EzI8EpbZr9e9amitO7tNlZ1I5wx1MBs44IymuV0rHkssE
         xToD5WGmZknLn0VQ8mfM9AEGXvzGtWQrr4F6DoDQ0GLQG9am1bmGQXr3JfAbdqpdl5MM
         51WkbIQFDxhiVfKQKuvP3/Qs0PDJFue5D9NS/BK/6vWnzau3vw7o+Ty4VhS8IcRFy/mP
         rDsQ==
X-Gm-Message-State: AO0yUKXffCoftRmDpnw5pFO1953+iONEB/BtBpjl04JSuU7E6Aus8F6g
        0SPJ9cZi8vRE0jGuXXKmN24=
X-Google-Smtp-Source: AK7set95ctD6W0JZCBXVFxTsb7mX+iDT3gldHtG+MuzaMSE3jEPR08XV9WeuJ5IIQ8SfrZIKSJSqng==
X-Received: by 2002:adf:fc87:0:b0:2ce:da65:1e1d with SMTP id g7-20020adffc87000000b002ceda651e1dmr2474310wrr.24.1678897034791;
        Wed, 15 Mar 2023 09:17:14 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id p9-20020adfce09000000b002cdbb26bb48sm5262558wrn.33.2023.03.15.09.17.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 09:17:14 -0700 (PDT)
Subject: Re: [PATCH RESEND net-next v4 4/4] sfc: remove expired unicast PTP
 filters
To:     =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>,
        habetsm.xilinx@gmail.com, richardcochran@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        Yalin Li <yalli@redhat.com>
References: <20230314100925.12040-1-ihuguet@redhat.com>
 <20230314100925.12040-5-ihuguet@redhat.com>
 <fcd12738-5e59-3483-540a-b0f6bb639bbd@gmail.com>
 <a2d55af3-df0c-2ed8-fc2c-78c0da6e6390@redhat.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <70906786-d2c3-652f-84a1-2f6dcddf00f3@gmail.com>
Date:   Wed, 15 Mar 2023 16:17:13 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <a2d55af3-df0c-2ed8-fc2c-78c0da6e6390@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/03/2023 08:54, Íñigo Huguet wrote:
>> PTP worker runs on every PTP packet TX or RX, which might be
>>  quite frequent.  It's probably fine but do we need to consider
>>  limiting how much time we spend repeatedly scanning the list?
> 
> PTP traffic is not that frequent, few packets per second, isn't it?
> 
>> Conversely, if all PTP traffic suddenly stops, I think existing
>>  unicast filters will stay indefinitely.  Again probably fine
>>  but just want to check that sounds sane to everyone.
> 
> Yes, it's as you say. However, I thought it didn't worth it to create a new periodic worker only for this, given that I expected a short list, it wouldn't be harmful. However, as I said in the other message, maybe the list can be quite long if we're the PTP master?
> 
> Maybe I should create a dedicated periodic work for this? That would avoid both problems that you are pointing out.

I'm not a PTP expert, hence why my comments above were phrased as
 questions rather than answers ;)
Up to you whether you think a dedicated work is needed; again, my
 Ack stands as it is, I'm happy for this to be done in a followup
 or not at all.
