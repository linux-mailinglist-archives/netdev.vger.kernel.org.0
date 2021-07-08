Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF6FC3BF8CB
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 13:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231605AbhGHLUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 07:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231540AbhGHLUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 07:20:21 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8ECCC061574
        for <netdev@vger.kernel.org>; Thu,  8 Jul 2021 04:17:38 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id h2so4487966qtq.13
        for <netdev@vger.kernel.org>; Thu, 08 Jul 2021 04:17:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bKe0/oVmdG1o5nrBuZpRLiU/bmUNU08H+vs34D2hlkw=;
        b=C4Z4OHEUs2oO84uoF0WnGg76Jjf92fdqnYhWmWGWUMsA6EFkdi2XFu7kpPJqn7wo+D
         TIg9Aic6a1nB8dO/jUZLBoAWpDymh71jY/vGAXo4GL5J/XcQFCpPejs/lEosDMU1Xy1C
         qUwnGp39EqtmiAmGaOP7R13k4O+ub9HRzkxahV8FWvbrv69xr9ib9y0Ge9WepmTHhII7
         OK5p8P1HtDKWUnhJ6OPwKaQeFlGKTn/FkWyQdNkkAttX+BJsh33SyDTfjDYs+jGR+IBn
         i9kvaRfoCWCEVwcjCvYuAuo8iDrhV2TcWdqbOrZYsFH77j9qjBo1UQrgshy7vXOjNxN5
         p5CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bKe0/oVmdG1o5nrBuZpRLiU/bmUNU08H+vs34D2hlkw=;
        b=mNOKqGHuUGX3qQE2DrVD4brTJ4qZ26nOaV+R+u9Ka/0Qc+Pt9ATWQangF/PeRe+gTm
         XI5m9w8Ny93kq2SklziwdU1jL8aFzadKtfMYVZUmsn0y5T7+D6V2XXesHG1UQh8ayP62
         WZY92y66LDdEQwFL4zNb+fhynYC/WhFFsZIkGZw+bRARVi9aIQcKoUgxIM98UKONG6u9
         skEZvDgrW+YOQgd8WCQROEy4KUCuPwqqTRA/f34zFc31uA7Xt9r7UK6QVMrT+C7T6xJB
         YuYCZEK67A3ExOclIFWgP/YB1pbjon5rvQmA9ivF8k5Xmz6PX5qtLPlxysbEW2cho5vl
         odyA==
X-Gm-Message-State: AOAM533in/5w2qoA5XZXSXZsqaZhIMy68WDozkKXheRfJAzQ2kAtzpJs
        Ky4binPiF9a4La061QLpT6RHlw==
X-Google-Smtp-Source: ABdhPJzEBmwdYI41QBAITkZ+n229bxvNMEPfS7l6HAHjtt/He5raUeCYvycxdETxcV0nDd4irc4+7g==
X-Received: by 2002:ac8:4e42:: with SMTP id e2mr27460302qtw.311.1625743058062;
        Thu, 08 Jul 2021 04:17:38 -0700 (PDT)
Received: from [192.168.1.171] (bras-base-kntaon1617w-grc-28-184-148-47-47.dsl.bell.ca. [184.148.47.47])
        by smtp.googlemail.com with ESMTPSA id o13sm822249qkg.124.2021.07.08.04.17.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Jul 2021 04:17:37 -0700 (PDT)
Subject: Re: [PATCH net 1/1] tc-testing: Update police test cases
To:     Roi Dayan <roid@nvidia.com>, netdev@vger.kernel.org
Cc:     David Ahern <dsahern@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Paul Blakey <paulb@nvidia.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Roman Mashak <mrv@mojatatu.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Stephen Hemminger <stephen@networkplumber.org>
References: <20210708080006.3687598-1-roid@nvidia.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <54d152b2-1a0b-fbc5-33db-4d70a9ae61e6@mojatatu.com>
Date:   Thu, 8 Jul 2021 07:17:36 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210708080006.3687598-1-roid@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-07-08 4:00 a.m., Roi Dayan wrote:
> Update to match fixed output.
> 
> Signed-off-by: Roi Dayan <roid@nvidia.com>
> ---
> 
> Notes:
>      Hi,
>      
>      This is related to commit that was merged
>      
>      55abdcf20a57 police: Add support for json output
>      
>      and also submitted another small fix commit titled
>      "police: Small corrections for the output"
>      
>      Thanks,
>      Roi
> 
>   .../tc-testing/tc-tests/actions/police.json   | 62 +++++++++----------
>   1 file changed, 31 insertions(+), 31 deletions(-)
> 
> diff --git a/tools/testing/selftests/tc-testing/tc-tests/actions/police.json b/tools/testing/selftests/tc-testing/tc-tests/actions/police.json
> index 8e45792703ed..c9623c7afbd1 100644
> --- a/tools/testing/selftests/tc-testing/tc-tests/actions/police.json
> +++ b/tools/testing/selftests/tc-testing/tc-tests/actions/police.json
> @@ -17,7 +17,7 @@
>           "cmdUnderTest": "$TC actions add action police rate 1kbit burst 10k index 1",
>           "expExitCode": "0",
>           "verifyCmd": "$TC actions ls action police",
> -        "matchPattern": "action order [0-9]*:  police 0x1 rate 1Kbit burst 10Kb",
> +        "matchPattern": "action order [0-9]*: police.*index 1 rate 1Kbit burst 10Kb",
>           "matchCount": "1",
>           "teardown": [
>               "$TC actions flush action police"

Does the old output continue to work here?

cheers,
jamal
