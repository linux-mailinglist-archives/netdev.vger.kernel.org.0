Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00A091CDFEB
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 18:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730610AbgEKQFv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 12:05:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729556AbgEKQFt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 12:05:49 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B562C061A0E
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 09:05:49 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id m12so13711605wmc.0
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 09:05:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XSBbYEPUjFSpzCt6ADMl+351ottRgxXUnYo0HFyHqs8=;
        b=ZWQ/89RHr7imqniXVaiAI1SrBs7ZJyPBxOFfRyS9gzNS16Fs2zefbmpcIIOtBTW38F
         g6AQx1E4SHw9Kx9tNOJsMPf8e2gBvAViW6qf1zoMdRkgHM+x7Bqw3H2NsVJMd5eofHMa
         OUR4EuJ6GIJ1ecfdIuRvmiOo2Q3TX0STOiBWKKnyiyDElrenLdlAHRIvd15p/Zz9jCxa
         JotUuycV5l+kMR6A/yzrMIXgQc3BOFHnmdx5hjPdVtswuoB88MrTr3uQ1JHEifMiNQxZ
         L3uidtGJnn6R1iyHqK6wyf65Ube5sWPBbgJPy/9A7uGnhZGQQsIku/4lXo9mwuhicPNz
         o9VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XSBbYEPUjFSpzCt6ADMl+351ottRgxXUnYo0HFyHqs8=;
        b=Zz/SOzYSWmchC/yN7B9U6TrFA0jhV6G69eVZiY2l3IQeWhA+0246D3/zaYHr+XeRfX
         Jxs7az+HOR71Xv91u6R2VJA5iEJgCvPW9pqGO79KqaFNUM6aUQLBcealOQzIpyqo3tKr
         fgTvNPd22+0SfXoC7TzgYtgexfJty7HTG7CYk1WGVRt9PWXkAwlSClT5pAeagP2CHs8y
         ZH3UnI3vSmHkxxfiUU/QPG3SHp8L9DtUsM6iVOvqgGmvOaDgW/f7jXbse0xURMq81yaG
         Py6s9H1kquWh3Pxqvin4AHZkUeIwQpe8y5zLZ5jjbpbGuCASdfvVQZAMZcyeoop5E7oO
         m27A==
X-Gm-Message-State: AGi0Pua6wmddN9USmBTST8b8DautC646xLfswmbCIju5Bi0o2J9LKI1h
        tiQ/IwK1TwiTwRE/X9aQSzR1ys1Y6Tew3Q==
X-Google-Smtp-Source: APiQypLF+9XK9xmOIjpKvJvyhyJdNgGLYDamRjMI8S5rn+mdACJIPXY1q9xNRlVTBzZlD32no3IvMw==
X-Received: by 2002:a1c:6402:: with SMTP id y2mr32938638wmb.116.1589213147735;
        Mon, 11 May 2020 09:05:47 -0700 (PDT)
Received: from [192.168.1.10] ([194.53.185.84])
        by smtp.gmail.com with ESMTPSA id b14sm15284020wmb.18.2020.05.11.09.05.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 May 2020 09:05:47 -0700 (PDT)
Subject: Re: [PATCH bpf-next 2/4] tools: bpftool: minor fixes for
 documentation
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
References: <20200511133807.26495-1-quentin@isovalent.com>
 <20200511133807.26495-3-quentin@isovalent.com>
 <673bcb25-1949-f0d8-c690-4f0a75819a80@iogearbox.net>
From:   Quentin Monnet <quentin@isovalent.com>
Message-ID: <6671c199-713d-fb5f-b6d1-11187301e6e4@isovalent.com>
Date:   Mon, 11 May 2020 17:05:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <673bcb25-1949-f0d8-c690-4f0a75819a80@iogearbox.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2020-05-11 17:25 UTC+0200 ~ Daniel Borkmann <daniel@iogearbox.net>
> On 5/11/20 3:38 PM, Quentin Monnet wrote:
>> Bring minor improvements to bpftool documentation. Fix or harmonise
>> formatting, update map types (including in interactive help), improve
>> description for "map create", fix a build warning due to a missing line
>> after the double-colon for the "bpftool prog profile" example,
>> complete/harmonise/sort the list of related bpftool man pages in
>> footers.
>>
>> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> [...]
>> @@ -116,24 +123,24 @@ DESCRIPTION
>>             receiving events if it installed its rings earlier.
>>         **bpftool map peek**  *MAP*
>> -          Peek next **value** in the queue or stack.
>> +          Peek next value in the queue or stack.
> 
> Looks great overall. Was about to push, but noticed above inconsistency.
> Should this
> be `*VALUE*` as well?

Hm I don't think so, there is no "VALUE" passed on the command line in
that case.

But then I should probably have removed mark-up on "value" for "bpftool
map pop|dequeue", instead of changing it, as those commands do not use
any value on the command line either. Thanks for the review, I'll send a
v2 with that change.

> 
>>       **bpftool map push**  *MAP* **value** *VALUE*
>> -          Push **value** onto the stack.
>> +          Push *VALUE* onto the stack.
>>         **bpftool map pop**  *MAP*
>> -          Pop and print **value** from the stack.
>> +          Pop and print *VALUE* from the stack.
>>         **bpftool map enqueue**  *MAP* **value** *VALUE*
>> -          Enqueue **value** into the queue.
>> +          Enqueue *VALUE* into the queue.
>>         **bpftool map dequeue**  *MAP*
>> -          Dequeue and print **value** from the queue.
>> +          Dequeue and print *VALUE* from the queue.
