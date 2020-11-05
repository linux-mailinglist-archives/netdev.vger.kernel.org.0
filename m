Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C9E22A8226
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 16:25:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731008AbgKEPZQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 10:25:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730721AbgKEPZQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 10:25:16 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C6E8C0613CF;
        Thu,  5 Nov 2020 07:25:15 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id r9so2179413ioo.7;
        Thu, 05 Nov 2020 07:25:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fYavb5trObhAZPZIPglmd9BvENDlMnE/9++hUv1/9ac=;
        b=fauSHxDPuxFa3mR9spZXxGmskcC2M0B1MtHI44ogSAF3GwqMTuIoFwMa7Nn06sMq/r
         SCklE7Klxb3+hHUhl1l4y6AOVZlPE8sgZ/kFGLpOOpSZiw3q1IZhi8h3bSO/B8wJn2zG
         0X8ZuRY8kyqt7bkmsHNCKKBVgcc6k2AeVPLWKdLDG4fMo47t1KaWJQ1Dvt9deuWWgstD
         KY12PenH69CzRKkeGjdgEPgSFl2uWN/mVWki30HPAGpy7yvOOeL2fDgU6FR1pajGPpQ1
         LYGI7b/htGwFHs9Q+JUPSkcSszRsRcW4drw9ZFUBCUT3L18XKXtLwbqTwyAX/W7lXRDz
         h5kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fYavb5trObhAZPZIPglmd9BvENDlMnE/9++hUv1/9ac=;
        b=TA4BFuGHGVQA2ef2yQD54OigIX+X1fo4BlwHJph481ZZuperAc2AsMbv66DWFrpv7c
         KMvCq7XEVQRlT7bARNeNsBLM7lnbaILJ2+FYoqiIs9hchUa4RIa8mBs7Vy5AsOOptL1c
         zV8OuNi8UL2EfabSTCV6Tj2zoJOjWe54LKhScIbh6N6QcHbE9q6eLj8M4JwWxVV4CptY
         HyNqqOuuk/Az2BdAyIyBhhA59MJ90aO4gfGF9hP1dLHdQEcgPgTw8nDzJ2nBE4crdWns
         6FxEloK4T82hmRonbERoHAU+3QKqsJyv4nzfzje3+IRnaB6ytg826YmCOQNgk7Mz4Naa
         Vhzw==
X-Gm-Message-State: AOAM530okS2ZsVuS9p9TvwRlXZU0L5vD9xk7aGf/xAie1OYwCr8DTEy9
        YY0EoKyXWRJGbN15tiC9W9w9R/8nuNA=
X-Google-Smtp-Source: ABdhPJzn7DUPgiNnR8flZSQblZpiL33g12D0+ddegq4SNmdFSVkTEeWkMwxNRSuMDfFV2PDG1ZUirg==
X-Received: by 2002:a05:6638:206:: with SMTP id e6mr2521378jaq.64.1604589914872;
        Thu, 05 Nov 2020 07:25:14 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:291c:9506:5e60:11ce])
        by smtp.googlemail.com with ESMTPSA id t17sm1272849ilm.8.2020.11.05.07.25.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2020 07:25:14 -0800 (PST)
Subject: Re: [PATCHv3 iproute2-next 3/5] lib: add libbpf support
To:     Hangbin Liu <haliu@redhat.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
References: <20201028132529.3763875-1-haliu@redhat.com>
 <20201029151146.3810859-1-haliu@redhat.com>
 <20201029151146.3810859-4-haliu@redhat.com>
 <db14a227-1d5e-ed3a-9ada-ecf99b526bf6@gmail.com>
 <20201104082203.GP2408@dhcp-12-153.nay.redhat.com>
 <61a678ce-e4bc-021b-ab4e-feb90e76a66c@gmail.com>
 <20201105075121.GV2408@dhcp-12-153.nay.redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <3c3f892a-6137-d176-0006-e5ddaeeed2b5@gmail.com>
Date:   Thu, 5 Nov 2020 08:25:12 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201105075121.GV2408@dhcp-12-153.nay.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/5/20 12:51 AM, Hangbin Liu wrote:
> On Wed, Nov 04, 2020 at 07:33:40PM -0700, David Ahern wrote:
>> On 11/4/20 1:22 AM, Hangbin Liu wrote:
>>> If we move this #ifdef HAVE_LIBBPF to bpf_legacy.c, we need to rename
>>> them all. With current patch, we limit all the legacy functions in bpf_legacy
>>> and doesn't mix them with libbpf.h. What do you think?
>>
>> Let's rename conflicts with a prefix -- like legacy. In fact, those
>> iproute2_ functions names could use the legacy_ prefix as well.
>>
> 
> Sorry, when trying to rename the functions. I just found another issue.
> Even we fix the conflicts right now. What if libbpf add new functions
> and we got another conflict in future? There are too much bpf functions
> in bpf_legacy.c which would have more risks for naming conflicts..
> 
> With bpf_libbpf.c, there are less functions and has less risk for naming
> conflicts. So I think it maybe better to not include libbpf.h in bpf_legacy.c.
> What do you think?
> 
>

Is there a way to sort the code such that bpf_legacy.c is not used when
libbpf is enabled and bpf_libbpf.c is not compiled when libbpf is disabled.
