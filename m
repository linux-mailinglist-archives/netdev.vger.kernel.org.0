Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF9E02B0903
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 16:54:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728470AbgKLPyw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 10:54:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728184AbgKLPyw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 10:54:52 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1993FC0613D1
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 07:54:52 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id 23so6495245wrc.8
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 07:54:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lqyK65GNtsPHH3j5sq7yYvEwit0wO+XoiTlJpWKNrYk=;
        b=kIkVL/nkATF5BzYsTh9VdgeN+NiemlMvm5MUn33FQu4scdtlEmGX3vj+5wQjWwSGNd
         Xn6lfWZ+GqhJ/h4rYQQeMrpsZCqCu1yE1LEvWey9P6gsdths7mesoNmotvwUKWTh5ncs
         FIFicFHsLQ8P+FWrihHbrZmaEE/wcVk2lE/tQzF0V46HP+wAmC5VBhzObmq/veEdTalI
         ETvNoa7qYnEH6gR1XUMVh3K/aE4uDpDzOSIWJfDwRRnMqOoyRPz3jRL7Cc4kae+HK0ZP
         TxvZXXwbISmdmKeSl6/t8KCPVT1nWY4NezACI2UMWb7gGnU1RL10yWjPIsxuscnzcKE/
         Dp2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lqyK65GNtsPHH3j5sq7yYvEwit0wO+XoiTlJpWKNrYk=;
        b=jF+cIVAz3jRp6yFPPh0gRbKL/RfImWF3y/MH/ELc95Mv6J9sLSdNL+NlJbgr3vYnRR
         Oad/BI2MVeqwVd47nQ+Ipc1U80A0PdwJMryls8HaVAYwngs95qCxS6Iutt5z4I1HZR1L
         FdMqaG3iFjBxrWeoYbZxMarJ+uoxlDjq8MXUh+4OTejpJKND4h1OkuR9vDkk9t3T0wgA
         Ernkv5OnXOsIcvLvD18BzXnAJ/W3tJxgfSIkzllx7Bje1yxKymhyq1S0jpZtUWU0lZhI
         g4KDwuS+XcdoZWfi1egtm6V1ftYdWFYngyccZ7/rPzvSV9efGzzi72ybYblPQwBMgRkM
         aOyw==
X-Gm-Message-State: AOAM5326mCKERahR56nlWBeqWvD9aF2BMhGxIcB+SaLhCQxWukXHeFEc
        AM4VAozT7adQWuNjhsua4gQ=
X-Google-Smtp-Source: ABdhPJyEiamMBraRqriCndzcLXopi6jfZilBeWLU6Ku7/lKdSmX/pM8FIiM1o0cezUkvcbXowRx4eA==
X-Received: by 2002:a5d:5342:: with SMTP id t2mr154165wrv.243.1605196490888;
        Thu, 12 Nov 2020 07:54:50 -0800 (PST)
Received: from [10.26.72.190] ([195.110.77.193])
        by smtp.gmail.com with ESMTPSA id f11sm7340907wrs.70.2020.11.12.07.54.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Nov 2020 07:54:49 -0800 (PST)
Subject: Re: bug report: WARNING in bonding
To:     Ido Schimmel <idosch@idosch.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Moshe Shemesh <moshe@nvidia.com>,
        Itay Aveksis <itayav@nvidia.com>,
        Ran Rozenstein <ranro@nvidia.com>
References: <fb299ee2-4cf0-31d8-70f4-874da43e0021@gmail.com>
 <20201112154627.GA2138135@shredder>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
Message-ID: <e864f9a3-cda7-e498-91f4-894921527eaf@gmail.com>
Date:   Thu, 12 Nov 2020 17:54:30 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201112154627.GA2138135@shredder>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/12/2020 5:46 PM, Ido Schimmel wrote:
> On Thu, Nov 12, 2020 at 05:38:44PM +0200, Tariq Toukan wrote:
>> Hi all,
>>
>> In the past ~2-3 weeks, we started seeing the following WARNING and traces
>> in our regression testing systems, almost every day.
>>
>> Reproduction is not stable, and not isolated to a specific test, so it's
>> hard to bisect.
>>
>> Any idea what could this be?
>> Or what is the suspected offending patch?
> 
> Do you have commit f8e48a3dca06 ("lockdep: Fix preemption WARN for spurious
> IRQ-enable")? I think it fixed the issue for me
> 

We do have it. Yet issue still exists.
Thanks.
