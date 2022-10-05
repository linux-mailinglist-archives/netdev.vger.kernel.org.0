Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45CB35F51DB
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 11:38:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbiJEJiH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 05:38:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbiJEJiG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 05:38:06 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6287629802;
        Wed,  5 Oct 2022 02:38:05 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id b5so14828605pgb.6;
        Wed, 05 Oct 2022 02:38:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=v/xZ2HYcr1rmIHl2vpbgjTWMh97Ya5kEsSVUiy+v/Nk=;
        b=Dfnr//p1MtXKTVrQPKqS8d2OfMsrcwpUvNKuq2HLKffa77Dhyf3Rs/2dC78oj4d1JP
         qoD2pjv7dMEv888zEUqPAYFPqa2Obqzk1LktCnZTnzXCcrk7GgdTUS5aAyRbH59zXdKC
         OR51yBE42BGv4DLbkTc4Dw5XWMEDia2cwyT1ma7xJ1NAI1gd27B/m2KtTGgvdav7ALQe
         /PN5Qyg8mwNFIUWVqEhThRUO1acUSa8NRmpFNCGYPBLaapxxy8RKNrtQ97x57TLtDOYg
         Tu4GocpNLLbjJSJLErE6bMHq/pDGw/onPuBNxakiyMPQeJ8GT2dwB7jlMjMBbQ5aQLlw
         fMfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=v/xZ2HYcr1rmIHl2vpbgjTWMh97Ya5kEsSVUiy+v/Nk=;
        b=kqUwnEUtk4eii3kFw3p7G1iMUB+EsLTIbTmRyGWvwOfrEi4dz2xk9YbFu2iLutFqTB
         DhJlrNiKkfRbi1Rq0pDYQ6dnbT405aVgXqqna/ZbHxNvdKxkXzhQdaOTDNVBROA36sSm
         tQWJO/H00r41b5U3xzX5er51LKwx2o6CDq676p5r/lRGJ5pGo6O2ymW1OMbA2Mv+K+iT
         bnYmgZB6GYzsQeND55H994BDepTLZ/CDz8c31mSRdHnjuovdqvzV3LXvpLs3QVb6gcbO
         H3yoDn0FErCHe+KZHIWdsKCjSPnmVSgnF0MLnVdOO7XQ1swvX8fAgKsMbSWsl2lRDrYV
         gArA==
X-Gm-Message-State: ACrzQf3W7M6S1v2LzDRSF/S76UwwvSfMzzyjIIdSAT0wPsopZAbAF/C/
        fvKz7SuYUwEvdQLd8lePSA3VLj0ZJDMvAA==
X-Google-Smtp-Source: AMsMyM6MXOJoCZHtthFlf2oyMqt78BUAZVXp8+eSglkif5kFlfovhwUdtUzPQLw8JiH65GHUupzr8Q==
X-Received: by 2002:a05:6a00:1581:b0:546:1c27:6541 with SMTP id u1-20020a056a00158100b005461c276541mr32572797pfk.64.1664962684927;
        Wed, 05 Oct 2022 02:38:04 -0700 (PDT)
Received: from [192.168.43.80] (subs02-180-214-232-92.three.co.id. [180.214.232.92])
        by smtp.gmail.com with ESMTPSA id z10-20020a170902ccca00b00174be817124sm10121108ple.221.2022.10.05.02.38.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Oct 2022 02:38:04 -0700 (PDT)
Message-ID: <30e3cee2-420b-b2bc-9af0-9f7e9c696c57@gmail.com>
Date:   Wed, 5 Oct 2022 16:38:00 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH net-next] docs: networking: phy: add missing space
Content-Language: en-US
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Casper Andersson <casper.casan@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org
References: <20221004073242.304425-1-casper.casan@gmail.com>
 <6645ba3ba389dc6da8d16f063210441337db9249.camel@redhat.com>
 <a495dd76-060a-210a-1a11-55333d67180c@gmail.com>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <a495dd76-060a-210a-1a11-55333d67180c@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/5/22 01:35, Florian Fainelli wrote:
> On 10/4/22 03:30, Paolo Abeni wrote:
>> On Tue, 2022-10-04 at 09:32 +0200, Casper Andersson wrote:
>>> Missing space between "pins'" and "strength"
>>>
>>> Signed-off-by: Casper Andersson <casper.casan@gmail.com>
>>> ---
>>
>> The merge window has now started (after Linus tagged 6.0)
>> and will last until he tags 6.1-rc1 (two weeks from now). During this
>> time we'll not be taking any patches for net-next so
>> please repost in around 2 weeks.
> 
> It is a documentation patch, therefore not functionally touching code, maybe that could count as an exception?

I think jon will pick up this patch, maybe as -rc-worthy fixes.

-- 
An old man doll... just what I always wanted! - Clara
