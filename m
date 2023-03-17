Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D08B76BF01A
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 18:47:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230403AbjCQRr3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 13:47:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230399AbjCQRr0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 13:47:26 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77583C7965
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 10:47:24 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id hf2so2317907qtb.3
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 10:47:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679075243;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UkpnQ8pjRqI+McI410V8kcv0tcTp5sXulpV3DbQRNsI=;
        b=fNL8tRSCHssQd/8QA5Z42BAkK6bbnVSbHT0oHbmSGFFuAFI1YDLLBDJyChAp2DHCtU
         9clE420dHbGEb5crxhaiMs+2AksnYEr/l8peOj8QqgIEgvRQudrzhkWDyMAbPq4xS1aV
         bG3ENhQ7trynAs3ic2evha+J4a1RZEj+GT9wtEEPIY1OH9PR4kGCtUPSvsqEqhQZFMrJ
         EGXt2a9cwlI8VEIyymOO+j0QNyBwXGKzkcwA4+RgJHQTy6/oRiX2m0R/ONJWc9irG35Q
         S3l1j+OBlYEiEOa5D06QlUUQuUlq3dDaBQHoN/ci9pjHcfMYIGtkI94TNchkBCvFg80q
         1BJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679075243;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UkpnQ8pjRqI+McI410V8kcv0tcTp5sXulpV3DbQRNsI=;
        b=zDhz2Dwc++KoBEgTtUzEj3QkLiEg/Tlftmq6/rsiQDC3JbzBZrwQnPPF87Z5p0CkSK
         CT7uPyPYw7J3FvPFNfJTZQKcwvUfW53iW3Vz32yNzpkPXYrEs21ltTDdsrLSMhZM/KJu
         Hcs4zxqQMU5jlxYCYIVSCPFFAsfBm2DbUg3Ow7SNgGMHiqjMEsUM9KH7k4D86TAqftTk
         HfEHjXMYcVPDKplhu1Zhg6yw6IRO0YN9e+YVyB6AlbXC9U45BT8dFFtJ2R9hpu0rRvHl
         4CYIN4lOZECuLqIOthEvogk6kDHqaBz0cZVopxUC9q6T1hsAeTeCIvixuGW6UTFYrU6M
         PNyA==
X-Gm-Message-State: AO0yUKXqsxhB2WCgaeytlcEye7ax4KP+++1NGkA/8graQ9WB2uEIUoK+
        AIwMnSgbfS4MUv+EfvCUae0=
X-Google-Smtp-Source: AK7set/IxjvxjVkJ2Zar1BFwcYo42229feu5dmIbHrAaNNVxrE4sG4PviIBMDXIMvFr+LUX3kpgM6g==
X-Received: by 2002:a05:622a:144c:b0:3b8:68ef:d538 with SMTP id v12-20020a05622a144c00b003b868efd538mr11032069qtx.52.1679075243636;
        Fri, 17 Mar 2023 10:47:23 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id j68-20020a37b947000000b0074577e835f2sm2078168qkf.48.2023.03.17.10.47.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Mar 2023 10:47:23 -0700 (PDT)
Message-ID: <8985802d-1faa-abd3-0188-49d73fed7a09@gmail.com>
Date:   Fri, 17 Mar 2023 10:47:14 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 1/1] net: stmmac: start PHY early in __stmmac_open
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Shenwei Wang <shenwei.wang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, imx@lists.linux.dev
References: <20230316205449.1659395-1-shenwei.wang@nxp.com>
 <ZBOQecR6q5Xgr75F@shell.armlinux.org.uk>
 <f348ece4-90ef-4368-893a-73de37410fd2@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <f348ece4-90ef-4368-893a-73de37410fd2@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
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

On 3/17/23 10:34, Andrew Lunn wrote:
>> NAK. A patch similar to this has already been sent.
>>
>> The problem with just moving this is that phylink can call the
>> mac_link_up() method *before* phylink_start() has returned - and as
>> this driver has not completed the setup, it doesn't expect the link
>> to come up at that point.
>>
>> There are several issues with this driver wanting the PHY clock early,
>> and there have been two people working on addressing this previously,
>> proposing two different changes to phylink.
>>
>> I sent them away to talk to each other and come back with a unified
>> solution. Shock horror, they never came back.
>>
>> Now we seem to be starting again from the beginning.
>>
>> stmmac folk really need to get a handle on this so reviewers are not
>> having to NAK similar patches time and time again, resulting in the
>> problem not being solved.
> 
> And just adding to that, Developers should also get into the habit of
> searching to see if somebody has already tried and failed to solve the
> problem.
> 
> “Those Who Do Not Learn History Are Doomed To Repeat It.”
> 
> Try avoiding wasting everybody's times by learning a bit of history.

This is a tough problem to solve though, we have had similar issues in 
the past with the GENET driver whereby we need the PHY clock in order to 
clock certain parts of the MAC's receive path to ensure it completes its 
reset. This is a terrible design that unfortunately a lot of designers 
get wrong.

Eventually we found that we had this "auto-configure" feature which 
could kick in when the PHY is up and running which solved it:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=88f6c8bf1aaed5039923fb4c701cab4d42176275

though it took a few attempts to get there:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=612eb1c3b9e504de24136c947ed7c07bc342f3aa

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=3a55402c93877d291b0a612d25edb03d1b4b93ac

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=28c2d1a7a0bf

Does something similar exit on stmmac? Can you somehow utilize the MAC's 
TX clock and loop it back to the RX clock to satisfy any clocking 
requirements?
-- 
Florian

