Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB6FB19892F
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 02:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729562AbgCaA5s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 20:57:48 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:46327 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729019AbgCaA5s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 20:57:48 -0400
Received: by mail-qt1-f194.google.com with SMTP id g7so16912440qtj.13;
        Mon, 30 Mar 2020 17:57:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/Lg/VsxW3ycT8/vfwIgWP6DV77CzhCdyUBOJK9ynUD8=;
        b=W04eZUoD1OTQOZSPCV2+0J+zWwin/T+2Sv56YxmkDh8XTPw/YJiymm/sHzo4w58Jys
         Z7xfgSyyz8xo4dVPrtvUeRoCKWFY7bxdhSrAQWFqWq+J4pWq+why8rxaeoNN2it8WdVw
         cz3YXjAJaxyRxdtoLVV2CI/cfWekrDOiDgtDkK1HSwruIvDYY2LwRQFkYvMG0iqzPH+c
         3s20gZ/5iRDQ9FhymGareAYVLyqq83Vt4GAIx6SQDIcWxlSdI3fKSNvWLMn8ULJCmXTa
         zOIH6FHAySoyCPLhuskUCfHF9ruxvv+gurBMDYJRrqFzpR1GagQSg/B5QpWhepZpx/FB
         REGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/Lg/VsxW3ycT8/vfwIgWP6DV77CzhCdyUBOJK9ynUD8=;
        b=QLDscP67aEgxo6OUrJCrELd5t6q6b5R58ynmXFtsKp7xI7q70J8TMDerLhlQO53rzN
         CQYLALv4utZUcUdni4hUIyCY8vjLtRJjl3oFweqFWYCq9Ix/GJ9sfMdn4dI4qfnvr6NP
         kKoRk8wOGpx11qhSYB4x86aSpHYzxoQAkfLNAioTwFZSYO4VX5pTmmg8h/x+9AeBCrhz
         mUYCqch4cW4D8VBywe2Fdm/Nz1kab3qmxGqnzKfCdbNiBHP+gm1qXFuUR1yd4LUVgo3J
         vCusqmFLjsq0cSiSXrSFLuXHWHivzw0Ut1tmIrw3qIeEj4ij3Z4MFZzwyC1StjxbpZin
         hfHw==
X-Gm-Message-State: ANhLgQ2OYCCthhn9mDK5aLEhbSukZ0XzCMbRv6CBMRBqgufTxA7NZCP3
        MLyYubB7LXg9uTkJR1s6Qzc=
X-Google-Smtp-Source: ADFU+vvLTmvY9gWZASJn/q7tJaCOx///SnC+5Kc4QMOOB/BaOgkTsqgnA+dK8IxFuCt9t20XV7ibYg==
X-Received: by 2002:ac8:32f2:: with SMTP id a47mr2920988qtb.62.1585616267477;
        Mon, 30 Mar 2020 17:57:47 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:38c4:c806:40d0:dc8a? ([2601:282:803:7700:38c4:c806:40d0:dc8a])
        by smtp.googlemail.com with ESMTPSA id q34sm12801650qtb.41.2020.03.30.17.57.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Mar 2020 17:57:46 -0700 (PDT)
Subject: Re: [PATCH v3 bpf-next 0/4] Add support for cgroup bpf_link
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrey Ignatov <rdna@fb.com>, Kernel Team <kernel-team@fb.com>
References: <20200330030001.2312810-1-andriin@fb.com>
 <c9f52288-5ea8-a117-8a67-84ba48374d3a@gmail.com>
 <CAEf4BzZpCOCi1QfL0peBRjAOkXRwGEi_DAW4z34Mf3Tv_sbRFw@mail.gmail.com>
 <662788f9-0a53-72d4-2675-daec893b5b81@gmail.com>
 <CAADnVQK8oMZehQVt34=5zgN12VBc2940AWJJK2Ft0cbOi1jDhQ@mail.gmail.com>
 <cdd576be-8075-13a7-98ee-9bc9355a2437@gmail.com>
 <20200331003222.gdc2qb5rmopphdxl@ast-mbp>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <58cea4c7-e832-2632-7f69-5502b06310b2@gmail.com>
Date:   Mon, 30 Mar 2020 18:57:44 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200331003222.gdc2qb5rmopphdxl@ast-mbp>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/30/20 6:32 PM, Alexei Starovoitov wrote:
>>
>> This is not a large feature, and there is no reason for CREATE/UPDATE -
>> a mere 4 patch set - to go in without something as essential as the
>> QUERY for observability.
> 
> As I said 'bpftool cgroup' covers it. Observability is not reduced in any way.

You want a feature where a process can prevent another from installing a
program on a cgroup. How do I learn which process is holding the
bpf_link reference and preventing me from installing a program? Unless I
have missed some recent change that is not currently covered by bpftool
cgroup, and there is no way reading kernel code will tell me.

###
To quote Lorenz from an earlier response:

"However, this behaviour concerns me. It's like Windows not
letting you delete a file while an application has it opened, which just
leads to randomly killing programs until you find the right one. It's
frustrating and counter productive.

You're taking power away from the operator. In your deployment scenario
this might make sense, but I think it's a really bad model in general.
If I am privileged I need to be able to exercise that privilege."
###

That is my point. You are restricting what root can do and people will
not want to resort to killing random processes trying to find the one
holding a reference. This is an essential missing piece and should go in
at the same time as this set.
