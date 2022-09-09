Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2777F5B3EBF
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 20:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230384AbiIISVx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 14:21:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbiIISVw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 14:21:52 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3529DFF0B9
        for <netdev@vger.kernel.org>; Fri,  9 Sep 2022 11:21:51 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id e20so4171736wri.13
        for <netdev@vger.kernel.org>; Fri, 09 Sep 2022 11:21:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=APQzmEt5NhFdc3UBI3DQ++zJAo3zX616AmktIupeadk=;
        b=IiEBHjUN1IVrpkNhdaX/saFWQ/8xlrtnf1yA/QBkmXAxTuJdCKvdzHEBnxW2MoSmbr
         dTnawqsnmxt0Xi1x6HB+Vh3WERzIzwg+w9moiiUdupHyw0NbB4r2MRKjO/OHLHwaJPWT
         vxhWZsd6TriISVYcbSFUR2+04XZ7qX5jD6iL9z/xP1nWizftpykEBxW476Rv1K2bMa1X
         KSFxUBUCrgqOCDc2aek1s/AIYuRNrYtNL8tKbhqLwmneLfS5nDRctAADhZWvEnWKpyzX
         aLdVZDC88WGumEFswdbLzlfS5VXLeZS/bX1UMXrAOFayuZulNxxnCDKlGT/7adtOQDOQ
         cVBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=APQzmEt5NhFdc3UBI3DQ++zJAo3zX616AmktIupeadk=;
        b=UBpn9w/45A98bx6alhx7z0xjX1zXiInwzQJ0ULHfp7b3M0Wy1Su5ue0XSpVALuXLci
         DU1sUp3vWLVWiHBDDzv0UrIMMkwRSa/mnypqToVC3XTx9/yn56DvYmXhahx/xbZzg7gI
         mgVTOPiUhs8UCBNp6EbVvzqbbslBOdNf2RKeImV3UNGg4voeMxJ6yB8G79VHardM/8Dn
         XUVfDQi+xSqYzcPwZK6moK+SvHURTpsY5CBD78hAz22aVW7mY3ip38z+EzjGmsJbkAO2
         CshE8wkm8b1MYKY0XkFYIyu1HRjn2EjN1YWFwkAz1vfwxtkCG+xh6dj+DwoDUkpqGMjX
         MT4A==
X-Gm-Message-State: ACgBeo39aresy/M4qkGJOdKm2ndy+bypQApnQn1kaxZB098CbcvrOf3K
        D7e+LB3tWPKYuANd3L9B14g=
X-Google-Smtp-Source: AA6agR6UqHnbp7FWjnomBQSSUwkSbFaRVPYQrbI89yXNFDfuA3QjBWgwUCYxcUeHwfETGOgoQXXT5Q==
X-Received: by 2002:a05:6000:1365:b0:22a:2ee9:4363 with SMTP id q5-20020a056000136500b0022a2ee94363mr5414299wrz.393.1662747709642;
        Fri, 09 Sep 2022 11:21:49 -0700 (PDT)
Received: from [192.168.1.10] (2e41ab4c.skybroadband.com. [46.65.171.76])
        by smtp.googlemail.com with ESMTPSA id j13-20020adff54d000000b00229d55994e0sm1018024wrp.59.2022.09.09.11.21.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Sep 2022 11:21:48 -0700 (PDT)
Message-ID: <a3c79b7d-526f-92ce-144a-453ec3c200a5@googlemail.com>
Date:   Fri, 9 Sep 2022 19:21:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: b118509076b3 (probably) breaks my firewall
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        regressions@leemuis.info
References: <e5d757d7-69bc-a92a-9d19-0f7ed0a81743@googlemail.com>
 <20220908191925.GB16543@breakpoint.cc>
 <78611fbd-434e-c948-5677-a0bdb66f31a5@googlemail.com>
 <20220908214859.GD16543@breakpoint.cc> <YxsTMMFoaNSM9gLN@salvia>
Content-Language: en-GB
From:   Chris Clayton <chris2553@googlemail.com>
In-Reply-To: <YxsTMMFoaNSM9gLN@salvia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 09/09/2022 11:19, Pablo Neira Ayuso wrote:
> On Thu, Sep 08, 2022 at 11:48:59PM +0200, Florian Westphal wrote:
>> Chris Clayton <chris2553@googlemail.com> wrote:
>>
>> [ CC Pablo ]
>>
>>> On 08/09/2022 20:19, Florian Westphal wrote:
>>>> Chris Clayton <chris2553@googlemail.com> wrote:
>>>>> Just a heads up and a question...
>>>>>
>>>>> I've pulled the latest and greatest from Linus' tree and built and installed the kernel. git describe gives
>>>>> v6.0-rc4-126-g26b1224903b3.
>>>>>
>>>>> I find that my firewall is broken because /proc/sys/net/netfilter/nf_conntrack_helper no longer exists. It existed on an
>>>>> -rc4 kernel. Are changes like this supposed to be introduced at this stage of the -rc cycle?
>>>>
>>>> The problem is that the default-autoassign (nf_conntrack_helper=1) has
>>>> side effects that most people are not aware of.
>>>>
>>>> The bug that propmpted this toggle from getting axed was that the irc (dcc) helper allowed
>>>> a remote client to create a port forwarding to the local client.
>>>
>>>
>>> Ok, but I still think it's not the sort of change that should be introduced at this stage of the -rc cycle.
>>> The other problem is that the documentation (Documentation/networking/nf_conntrack-sysctl.rst) hasn't been updated. So I
>>> know my firewall is broken but there's nothing I can find that tells me how to fix it.
>>
>> Pablo, I don't think revert+move the 'next' will avoid this kinds of
>> problems, but at least the nf_conntrack-sysctl.rst should be amended to
>> reflect that this was removed.
> 
> I'll post a patch to amend the documentation.
> 
>> I'd keep it though because people that see an error wrt. this might be
>> looking at nf_conntrack-sysctl.rst.
>>
>> Maybe just a link to
>> https://home.regit.org/netfilter-en/secure-use-of-helpers/?
>>
but
I'm afraid that document isn't much use to a "Joe User" like me. It's written by people who know a lot about the subject
matter to be read by other people who know a lot about the subject matter.

>> What do you think?
> 
> I'll update netfilter.org to host a copy of the github sources.
> 
> We have been announcing this going deprecated for 10 years...


That may be the case, it should be broken before -rc1 is released. Breaking it at -rc4+ is, I think, a regression!
Adding Thorsten Leemuis to cc list
