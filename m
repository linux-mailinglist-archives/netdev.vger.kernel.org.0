Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABB085B287D
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 23:22:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbiIHVWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 17:22:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230032AbiIHVWo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 17:22:44 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA33911C144
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 14:22:42 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id n17-20020a05600c501100b003a84bf9b68bso2869199wmr.3
        for <netdev@vger.kernel.org>; Thu, 08 Sep 2022 14:22:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=11KDZ7OyFz9GIjzzg4Hc59awopnZX5NJFMeEL1T+mCI=;
        b=DCT+MvXTDfvinynGYpwGHuz+Wa+Z08pwrO+rYUyngUgquxHPfBOm1g0XFZoz7Spux9
         kZENFvGIgJguhRhKM0pdocJ30XWa6owHoWhDzytUtZSrA2LocNEK8SokGJGVz/RYc2z3
         8KFN8VBaUd1UV/QFETVlIezgoBDQoP8H0Bfd+C1GVRBITmzz0qfcs9ZgIIZf7emWWyog
         7WR52YkX9WKTMDGvz5EAGG8SNLxx4vs1BTKIcp5+c2pvGSfevopdptAJCUKmDI+hxhLd
         9akwwuLBN9UGvdv51//ngHFM398vaCzcM3ml+wHHItiK4QAOqu+3DMyBHfowT9UixhcS
         +2CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=11KDZ7OyFz9GIjzzg4Hc59awopnZX5NJFMeEL1T+mCI=;
        b=2Q/pGiRdmzFMISTjNWSOPwK6TOhmDswvxHhAmkhasEiroGTrToKMy7iZuI2LUJ1nsK
         FR2IJjvLjGFHCKZ8FofCuOflDP8x4WE4ktpWoti20pWdADv/pPE7RP/GKJlw+4WD1Kwr
         4nRX8CWpQgR5/pS1Bet2Qy8Ei837RxvB4mgg0wwPiLc90g+WyOh0wTAWaIE2aqjivcv/
         Yf3vLtbfF+QiDmrrl35UjwWw1+BJ0XinP6HE+PMnDLQ9r7mNB8xe3+tIGu4VTcnobD56
         GQZcy84wwetEmxyTVstQTaWuF8iEBdStn7OVzyRjvsyvNeyMcbhKrqZUccA1gY3sIWXD
         U+jA==
X-Gm-Message-State: ACgBeo3wLICQ/kiiuDdYr5qit00t/O4Sw2pnbNmgo7ICIPzJO+9RKU7E
        PElXjbFaCLdnfZiS9fm+gbIptLOjGIY=
X-Google-Smtp-Source: AA6agR62Ke/KlBbdzH+g08GZzdX1pMZT5OMt9CZfsYoe3j9DLXuV6zOXhtyowYuP0dYjyG5wYMtJfQ==
X-Received: by 2002:a1c:440b:0:b0:3b3:330d:88d8 with SMTP id r11-20020a1c440b000000b003b3330d88d8mr2780272wma.31.1662672161315;
        Thu, 08 Sep 2022 14:22:41 -0700 (PDT)
Received: from [192.168.1.10] (2e41ab4c.skybroadband.com. [46.65.171.76])
        by smtp.googlemail.com with ESMTPSA id n20-20020a05600c3b9400b003a5c1e916c8sm11235449wms.1.2022.09.08.14.22.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Sep 2022 14:22:40 -0700 (PDT)
Message-ID: <78611fbd-434e-c948-5677-a0bdb66f31a5@googlemail.com>
Date:   Thu, 8 Sep 2022 22:22:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: b118509076b3 (probably) breaks my firewall
To:     Florian Westphal <fw@strlen.de>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <e5d757d7-69bc-a92a-9d19-0f7ed0a81743@googlemail.com>
 <20220908191925.GB16543@breakpoint.cc>
Content-Language: en-GB
From:   Chris Clayton <chris2553@googlemail.com>
In-Reply-To: <20220908191925.GB16543@breakpoint.cc>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 08/09/2022 20:19, Florian Westphal wrote:
> Chris Clayton <chris2553@googlemail.com> wrote:
>> Just a heads up and a question...
>>
>> I've pulled the latest and greatest from Linus' tree and built and installed the kernel. git describe gives
>> v6.0-rc4-126-g26b1224903b3.
>>
>> I find that my firewall is broken because /proc/sys/net/netfilter/nf_conntrack_helper no longer exists. It existed on an
>> -rc4 kernel. Are changes like this supposed to be introduced at this stage of the -rc cycle?
> 
> The problem is that the default-autoassign (nf_conntrack_helper=1) has
> side effects that most people are not aware of.
> 
> The bug that propmpted this toggle from getting axed was that the irc (dcc) helper allowed
> a remote client to create a port forwarding to the local client.


Ok, but I still think it's not the sort of change that should be introduced at this stage of the -rc cycle.

The other problem is that the documentation (Documentation/networking/nf_conntrack-sysctl.rst) hasn't been updated. So I
know my firewall is broken but there's nothing I can find that tells me how to fix it.
