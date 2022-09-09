Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EF9D5B3ED5
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 20:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbiIISbh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 14:31:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiIISbg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 14:31:36 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 572C7AE9E5
        for <netdev@vger.kernel.org>; Fri,  9 Sep 2022 11:31:35 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id bd26-20020a05600c1f1a00b003a5e82a6474so2006877wmb.4
        for <netdev@vger.kernel.org>; Fri, 09 Sep 2022 11:31:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=VtS7PbDmPvc8AiYt35hlNpvuYkClVGKCtod6MiUG9ts=;
        b=RkU1DBYgwRsITqk09LgwXa0wxjqaQhNzXihljRMOjLyVixFo4bMVPse+nUzkQtwo3L
         etH7VeR93TL2GHro5WHS20IKYYapGGRzjvpZaVG0bES1gJqes1fqn6BUTAGkhM3Nxzd2
         uVzKmI2toN35lSqslJLisR6ag8ZDES2b77rMF2WYese3SBTOQ4nq9GAca+wAiBtbGGrA
         Z3kq1hOl9yGPGgvFbcQH16FCEgTYj5xaG8H4izPb46TEyJpi2Bnq65vvm0SfUyJhLt9R
         bRnxZ5KbF0FS3XC8Hv+z0Yza5TZvzfwxrSLdqwAc1DuL9A4Ro9WCJ8+27HEpl79XZH38
         D+Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=VtS7PbDmPvc8AiYt35hlNpvuYkClVGKCtod6MiUG9ts=;
        b=zMlfLXqcsrtXBeCToGv1ETZcxSI/wFz5tiI14gd8gixKPht9eLbOeowSjzs3VqofhJ
         qvLzS/F0gi6zN12Dbf24JNoF/CcGwpNJgxDkJxaHIHd38Qi1aa7ubCielszM1TCk15fq
         +8VXB74AeScy7C4fW0yF+kYyTPPS49PKt+Wy7/A4MuWZFgSseSpL/EtQpu2BhZIhKRcj
         TFwn0kkCNsXIxHZQ/fzZthXVH7W1XvFH4/XKEQcg15Me9XdK1QPSlihlBr4chhRyXHwb
         VFcK2T2tpQ8oen8QMpBlF38kLNSKl5KUgT+q0c4BGg/1JnB9kA7u2xzca+aqKEpeFCLl
         baig==
X-Gm-Message-State: ACgBeo0tAcqpl9Vr2BdG9zwgSAvr1BuQtV0gTKiLSM2CaPjEgsT87GsX
        58DJMe2zpSUV8VZPNkbeGXM=
X-Google-Smtp-Source: AA6agR6qziD+ro1TyiWVCZJsQCu7whSP7P50JQO9E2aKW3fQr7sNTXW/rA5ux2t4CqXmt5zGxdTFJA==
X-Received: by 2002:a7b:ce97:0:b0:3b3:4136:59fe with SMTP id q23-20020a7bce97000000b003b3413659femr3862997wmj.24.1662748293800;
        Fri, 09 Sep 2022 11:31:33 -0700 (PDT)
Received: from [192.168.1.10] (2e41ab4c.skybroadband.com. [46.65.171.76])
        by smtp.googlemail.com with ESMTPSA id n18-20020a05600c501200b003a846a014c1sm1433947wmr.23.2022.09.09.11.31.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Sep 2022 11:31:33 -0700 (PDT)
Message-ID: <702fb195-93a9-10f8-7890-2cb6c3cefea3@googlemail.com>
Date:   Fri, 9 Sep 2022 19:31:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: b118509076b3 (probably) breaks my firewall
Content-Language: en-GB
From:   Chris Clayton <chris2553@googlemail.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        regressions@lists.linux.dev
References: <e5d757d7-69bc-a92a-9d19-0f7ed0a81743@googlemail.com>
 <20220908191925.GB16543@breakpoint.cc>
 <78611fbd-434e-c948-5677-a0bdb66f31a5@googlemail.com>
 <20220908214859.GD16543@breakpoint.cc> <YxsTMMFoaNSM9gLN@salvia>
 <a3c79b7d-526f-92ce-144a-453ec3c200a5@googlemail.com>
In-Reply-To: <a3c79b7d-526f-92ce-144a-453ec3c200a5@googlemail.com>
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

[the address I used for regressions was bounced. Using the right one...]

On 09/09/2022 19:21, Chris Clayton wrote:
> 
> 
> On 09/09/2022 11:19, Pablo Neira Ayuso wrote:
>> On Thu, Sep 08, 2022 at 11:48:59PM +0200, Florian Westphal wrote:
>>> Chris Clayton <chris2553@googlemail.com> wrote:
>>>
>>> [ CC Pablo ]
>>>
>>>> On 08/09/2022 20:19, Florian Westphal wrote:
>>>>> Chris Clayton <chris2553@googlemail.com> wrote:
>>>>>> Just a heads up and a question...
>>>>>>
>>>>>> I've pulled the latest and greatest from Linus' tree and built and installed the kernel. git describe gives
>>>>>> v6.0-rc4-126-g26b1224903b3.
>>>>>>
>>>>>> I find that my firewall is broken because /proc/sys/net/netfilter/nf_conntrack_helper no longer exists. It existed on an
>>>>>> -rc4 kernel. Are changes like this supposed to be introduced at this stage of the -rc cycle?
>>>>>
>>>>> The problem is that the default-autoassign (nf_conntrack_helper=1) has
>>>>> side effects that most people are not aware of.
>>>>>
>>>>> The bug that propmpted this toggle from getting axed was that the irc (dcc) helper allowed
>>>>> a remote client to create a port forwarding to the local client.
>>>>
>>>>
>>>> Ok, but I still think it's not the sort of change that should be introduced at this stage of the -rc cycle.
>>>> The other problem is that the documentation (Documentation/networking/nf_conntrack-sysctl.rst) hasn't been updated. So I
>>>> know my firewall is broken but there's nothing I can find that tells me how to fix it.
>>>
>>> Pablo, I don't think revert+move the 'next' will avoid this kinds of
>>> problems, but at least the nf_conntrack-sysctl.rst should be amended to
>>> reflect that this was removed.
>>
>> I'll post a patch to amend the documentation.
>>
>>> I'd keep it though because people that see an error wrt. this might be
>>> looking at nf_conntrack-sysctl.rst.
>>>
>>> Maybe just a link to
>>> https://home.regit.org/netfilter-en/secure-use-of-helpers/?
>>>
> but
> I'm afraid that document isn't much use to a "Joe User" like me. It's written by people who know a lot about the subject
> matter to be read by other people who know a lot about the subject matter.
> 
>>> What do you think?
>>
>> I'll update netfilter.org to host a copy of the github sources.
>>
>> We have been announcing this going deprecated for 10 years...
> 
> 
> That may be the case, it should be broken before -rc1 is released. Breaking it at -rc4+ is, I think, a regression!
> Adding Thorsten Leemuis to cc list
