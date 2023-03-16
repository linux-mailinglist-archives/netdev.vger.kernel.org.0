Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D76BC6BDCC9
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 00:18:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230284AbjCPXSU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 19:18:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbjCPXSQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 19:18:16 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A0938615E;
        Thu, 16 Mar 2023 16:18:15 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id h19so3668103qtn.1;
        Thu, 16 Mar 2023 16:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679008694;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hizf1rKt9yqJi/dPDTO6w3mkjCS9486AALEnSxm1ai4=;
        b=IMOuEpxDsSBgvV8mrJdwgxOaUK9UYcOo4fAkHn5O/PUvR2GcJBXTQiUVA5JBrKxTDg
         SN4f7GEnuLJ7GL4unBLHdWzCrKLaySs00RXkX0dFKMYjOFmKf6Txg95SwCEacZeUNOwc
         rHYT54FhG1RTaGDpmTAo61UN4TafoiENmw9WNn9O2JlWIPIMnLlOIMjtFEBExqQYQl/t
         FtfVOIz5mG6lz8s89uCmp2RedrsiiPVppQTs9T5Dp4bQ+USHQSFAhAwvyx0GDcuNoaC3
         GgsgsatfDn3EEwqvIcQHlZ51KSo/az7KH+kXuJ8IdtdCuhsnK99gdVx76S5F9Eu6dfrM
         r1fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679008694;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hizf1rKt9yqJi/dPDTO6w3mkjCS9486AALEnSxm1ai4=;
        b=Ta82Kono8Goh9Ujnh9pBhMo9wvB6Ng8Wq8Dv1FUDGiGiH2vc+A67zp4YETUQaROuvl
         82TmGMyJi/HoMQWEKL0kIiuyEBSmd9c03HNW2g2x+byfGl+QAJJLhVuSOn5eUL7n2qne
         fqNsaQ5a/zE9I7hBBnbAJk8o0yC2Bd492cuL58oC9FJjiaCNCBLvhPaqwzXqOBYHJM/e
         8cqg4jPJA48EK44VpeKPOmg73r6biYxCQ1TnrHZ+Ctyy+IS0K+ZObgC8dP8TDqzGv0iN
         o5bCvO39EB35oJ0RjG00gapmX0/mvoI1KO2trRGb7EQVJwsACDqj4YpXPWnDEwUpteP1
         Oqew==
X-Gm-Message-State: AO0yUKXqoGQppPBMLlqeaKWQ7EUE/6qiQNr0vmuYhhW0WyzYyEV2BLhm
        sm7hkJqxwUamM3IZq2RuxuY=
X-Google-Smtp-Source: AK7set/sS4Fb9KPNSK/wEhFU3sxhZEekJKHlG2yB63AmLevYMFDErYt3Kr4B5PISzdiEw3ZDsRC0Qw==
X-Received: by 2002:a05:622a:170c:b0:3b9:bc8c:c212 with SMTP id h12-20020a05622a170c00b003b9bc8cc212mr2080410qtk.29.1679008694696;
        Thu, 16 Mar 2023 16:18:14 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 13-20020a37080d000000b007456efa7f73sm472676qki.85.2023.03.16.16.18.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Mar 2023 16:18:14 -0700 (PDT)
Message-ID: <c123bda1-650d-0982-9e38-368de51664fa@gmail.com>
Date:   Thu, 16 Mar 2023 16:18:08 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next] docs: networking: document NAPI
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, corbet@lwn.net,
        linux-doc@vger.kernel.org
References: <20230315223044.471002-1-kuba@kernel.org>
 <20230315155202.2bba7e20@hermes.local> <20230315161142.48de9d98@kernel.org>
 <7ddfa9e1-c7a2-7a62-a2ba-eb2c93a3a2fa@gmail.com>
 <20230316160757.52ea01b0@kernel.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230316160757.52ea01b0@kernel.org>
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

On 3/16/23 16:07, Jakub Kicinski wrote:
> On Thu, 16 Mar 2023 15:59:49 -0700 Florian Fainelli wrote:
>> True, though I would put a word in or two about level vs. edge triggered
>> anyway, if nothing else, explain essentially what Stephen just provided
>> ought to be a good starting point for driver writers to consider the
>> possible issue.
> 
> It's not a blocker for something close to the current document
> going in, tho, right? More of a future extension (possibly done
> by someone else...) ?

Works for me, Stephen should have plenty of time to come up with an 
addendum ;)
-- 
Florian

