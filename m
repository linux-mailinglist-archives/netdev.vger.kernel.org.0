Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7312B6B0195
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 09:34:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbjCHIed (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 03:34:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230309AbjCHIdw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 03:33:52 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A12F59E5D
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 00:33:19 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id cw28so62524743edb.5
        for <netdev@vger.kernel.org>; Wed, 08 Mar 2023 00:33:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678264395;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=08co5VKvgYPVtTox29HjyrCSQb3Vy/mGVljoghktoV4=;
        b=RktQsrV345O0oMV35TGSBz9LtBaRLOQqcgQNAnjJogA8PhBr2vovnutWCXX59JsCPx
         At9Aya/G4O17uIz/6l/3G0Qj9fFeTAUVAwRyL2igjTU8zrAA2Uc1D5OcxZ/gjCONRcnz
         22IhU0NO9ZZRAkYc5IMRTKCHfNSV4cynVj2BCXMQhEccdPs0cbHVEOVOG8rikpoq3Xw7
         +gbCrhgYXzpZgNyUbC4KlbXwbfcHBb8a64sJg3u0WpwKh1DQFdO2fnLAGg6RZGS/OeuL
         AHYyxl/cQOYr9tXH2IpeKhlpAEpWtobil5DqHkfPrYeYI9jRWC5hRKd6qz0qA73X19Zz
         NSIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678264395;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=08co5VKvgYPVtTox29HjyrCSQb3Vy/mGVljoghktoV4=;
        b=DvZrB654YCQEOANIyQHnX3wmIwO6EWKmC/AjHLvnpXDmszF0PC5gN8siysGtFbwe+P
         TZxiw5q1q6YJf7aqbEE0Ft3TlEJ9SkFt2p5nQWJBDeRtcWSoL30Uh9PZibKAGgt5x6Ya
         A0Kie36+YhkivPt4jMY42wY41TikirkAM1ln1Qon74GrbnhZ1QxE6aVk1p4MJy6RRCP6
         o76nqLHqI2dpABZDKV0HWJLokJUNnsKgBtccq0i07euDTlOqCsFwKV3d2nEEXOB2kEa+
         LW5o8z/xpfMjQUpPRyb8mpLBRsRUQLILf35J39EDhn7kNeGz7B/YvIAQ95AiJ33OkvZw
         JNlw==
X-Gm-Message-State: AO0yUKUs2WDQciczGWrZ7Pdg2MF4gYwIrdWfmG2puLe58h/9eopzmki0
        eKnqF9csckFuEELhOXwotYM=
X-Google-Smtp-Source: AK7set++b4o7dLGBwtef5mMRLYNmum8RZJaLgm/4V6PfMcA0ADz0EXUZHCnwLd9nkw9zAREA0amj/g==
X-Received: by 2002:a17:907:948e:b0:878:7f6e:38a7 with SMTP id dm14-20020a170907948e00b008787f6e38a7mr23083901ejc.44.1678264395054;
        Wed, 08 Mar 2023 00:33:15 -0800 (PST)
Received: from [192.168.0.106] ([77.126.33.94])
        by smtp.gmail.com with ESMTPSA id f27-20020a50a6db000000b004acc61206cfsm7832880edc.33.2023.03.08.00.33.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Mar 2023 00:33:14 -0800 (PST)
Message-ID: <e0d6760b-c571-cb1e-f47e-89a6b6376b86@gmail.com>
Date:   Wed, 8 Mar 2023 10:33:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net] ynl: re-license uniformly under GPL-2.0 OR
 BSD-3-Clause
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Tariq Toukan <tariqt@nvidia.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
References: <20230306200457.3903854-1-kuba@kernel.org>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <20230306200457.3903854-1-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 06/03/2023 22:04, Jakub Kicinski wrote:
> I was intending to make all the Netlink Spec code BSD-3-Clause
> to ease the adoption but it appears that:
>   - I fumbled the uAPI and used "GPL WITH uAPI note" there
>   - it gives people pause as they expect GPL in the kernel
> As suggested by Chuck re-license under dual. This gives us benefit
> of full BSD freedom while fulfilling the broad "kernel is under GPL"
> expectations.
> 
> Link: https://lore.kernel.org/all/20230304120108.05dd44c5@kernel.org/
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> --
> CC: Tariq Toukan <tariqt@nvidia.com>
> CC: Lorenzo Bianconi <lorenzo@kernel.org>
> 
> Tariq, Lorenzo, can I have your acks?
> ---

Acked-by: Tariq Toukan <tariqt@nvidia.com> # re-license my contributions
