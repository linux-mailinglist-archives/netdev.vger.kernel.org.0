Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70E264A4795
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 13:54:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376989AbiAaMy3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 07:54:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239602AbiAaMy0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 07:54:26 -0500
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB04FC061714
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 04:54:25 -0800 (PST)
Received: by mail-qt1-x82d.google.com with SMTP id k25so6292376qtp.4
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 04:54:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=rv/l0iR88alaV0E0PKHjXHkAUudNqhKjqbuycOIch9Q=;
        b=iHVT48IqlNbeuYIjWPJb6ynAwg4idbdp8oC0oAHm8/oFmqMyrvZS04InIuqaUqc58O
         apNEJeljxcfaGC9CUMlBr19wZRvqto/dKwDzUnxAE0rDXpREBomxA742ZXBehNRMw0mr
         bvJppg/hnybdp3MN+ZzrTF9/FCA3EUPUjNQCD0Kn/gv+l+N9gqQ9DuB7E71SttJ/zJrp
         /TJ07dEAyWlKOpFTqN3k/rP08QtLc+6C3OGhwHvWx44sGn4t5kgglqeDOW4oQN9RkvXn
         z/JJfkayWGaCIWL9Vp2D0MwtoBaVwW4vkGH1zKFQyV7WtvCICFDfxLgZ7lZuOy5c3YqG
         V8EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=rv/l0iR88alaV0E0PKHjXHkAUudNqhKjqbuycOIch9Q=;
        b=WGHY+uWnf8xe4ZZtir67SV+L2qSIje942qikVuDk5hsHbQLnmUH5dcp3IbjxC8+qPJ
         37hL6tmcL1CIZEzaFVhZJ7AFvgKgwCq2XSpLLzufYJdyfAitRP37horMU78zUDFkfjTU
         qMVHVh+ie0qIBrmfvDMfBUNGeLeBPqDL98t8Do/vuoOuuH+Yx9GfngV4fuJbKMdor9BX
         HEuH4zwHOEJFmV0YmNTSOY5coqRpZgC5SyGvqHQH9MAp8JebNfVmX4GbtSpeJZtHksu9
         EWbsk3TP5X6UDD04HHiZN5mGiq7YBOQusoCFRqDVG9R33MFvlWD/urP7Cxn5tAGGAu42
         +ARQ==
X-Gm-Message-State: AOAM530/2xw0xJ2fELlFQEp+sUtrgMtamXpz/cziyeQNZVbvrEmQAfjA
        OPDn+XudPNhOZke7hIK3EN1Qeg==
X-Google-Smtp-Source: ABdhPJwW8RLPBsuSTx2b9dAlYGrWKDVcSMMdZea0z0pFihmnEt/Y/Xc1fV2T/DlMQcjE5Jv3XYel7A==
X-Received: by 2002:a05:622a:215:: with SMTP id b21mr14539181qtx.199.1643633664983;
        Mon, 31 Jan 2022 04:54:24 -0800 (PST)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-28-184-148-47-74.dsl.bell.ca. [184.148.47.74])
        by smtp.googlemail.com with ESMTPSA id k20sm8354187qtx.64.2022.01.31.04.54.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Jan 2022 04:54:24 -0800 (PST)
Message-ID: <78ac271a-7d00-7526-54b5-2aabb5b3a3ba@mojatatu.com>
Date:   Mon, 31 Jan 2022 07:54:23 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH iproute2 v3 1/2] tc: u32: add support for json output
Content-Language: en-US
To:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Andrea Claudi <aclaudi@redhat.com>
Cc:     netdev@vger.kernel.org, Wen Liang <wenliang@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Victor Nogueira <victor@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Davide Caratti <dcaratti@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Vlad Buslov <vladbu@nvidia.com>
References: <cover.1641493556.git.liangwen12year@gmail.com>
 <0670d2ea02d2cbd6d1bc755a814eb8bca52ccfba.1641493556.git.liangwen12year@gmail.com>
 <20220106143013.63e5a910@hermes.local> <Ye7vAmKjAQVEDhyQ@tc2>
 <20220124105016.66e3558c@hermes.local> <Ye8abWbX5TZngvIS@tc2>
 <20220124164354.7be21b1c@hermes.local>
 <848d9baa-76d1-0a60-c9e4-7d59efbc5cbc@mojatatu.com>
 <a7ec49d5-8969-7999-43c4-12247decae9e@gmail.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
In-Reply-To: <a7ec49d5-8969-7999-43c4-12247decae9e@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-01-26 10:50, David Ahern wrote:
> On 1/26/22 6:52 AM, Jamal Hadi Salim wrote:
>>
>> Makes sense in particular if we have formal output format like json.
>> If this breaks tdc it would be worth to fix tdc (and not be backward
>> compatible)
>>
>> So: Since none of the tc maintainers was Cced in this thread, can we
>> please impose a rule where any changes to tc subdir needs to have tdc
>> tests run (and hopefully whoever is making the change will be gracious
>> to contribute an additional testcase)?
> 
> I can try to remember to run tdc tests for tc patches. I looked into it
> a few days ago and seems straightforward to run tdc.sh.

Note tdc.sh is meant for the bot. It skips a lot things per Davide's
comment that he was worried the robot will end up spending too many
cycles. Good source at the moment is the README.

> The output of
> those tests could be simplified - when all is good you get the one line
> summary of the test name with PASS/FAIL with an option to run in verbose
> mode to get the details of failures. As it is, the person running the
> tests has to wade through a lot of output.
> 

We are going to put some cycles improving things. Your input is useful.

>> Do you need a patch for that in some documentation?
>>
> 
> How about adding some comments to README.devel?


Sure - but it wont be sufficient IMO.
Best course of action is for the maintainers to remind people to run
tests.

BTW: We found out that Stephen's patches still break the latest -next.

cheers,
jamal
