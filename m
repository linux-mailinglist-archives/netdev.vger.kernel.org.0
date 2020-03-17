Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD466187BFB
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 10:25:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725962AbgCQJZi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 05:25:38 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:34246 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725868AbgCQJZh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 05:25:37 -0400
Received: by mail-wm1-f67.google.com with SMTP id x3so15185643wmj.1
        for <netdev@vger.kernel.org>; Tue, 17 Mar 2020 02:25:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dnT+/2ywN3t7DjrpcWeRO3HK1L7kQfjRXTbsRuGbotI=;
        b=WREWzB/hW4Zo0bJCD7QHal7MSU/MXQ5VdKHhFYYOfkkuhYZhXRiOuRLvmokgldwlSB
         yw1Ppoa71oCs0gLklgotpVUQUmmDKtAJvksMfgN7buqytEqANLj4NKVRrXevGHDQVoph
         OoVN7k5YJs+e90K/ToC2GUwI2ETXh9KJk6lgpKU1Q8V/+sFc8k3MqR0dBEkmTVvFaX8L
         gXSy96qyfpdA88+7q7SV4zr/FkLTT+5til08ZBf4P14aO4m23C2lOZLVGlfLz5pRQsUR
         MhCVk4oKt+XKlnE3lJxmdwHh/DHAxFuj7QVdwgAnekWDSaSudaCZSPpQ7G8F1ujd/scb
         UxNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dnT+/2ywN3t7DjrpcWeRO3HK1L7kQfjRXTbsRuGbotI=;
        b=Es+9ZednPBLNBqgDgbec4iYBIubmsNcAtZ87PwHNH0yjtryiXJZ2BIeHFWXdcYFeDl
         VgPQ2i6IWqAUIFG4FaGtrOOJZIq5gIhkN6tOAKmi4wJPHzImEHJgpYdboalAnZzsfrPw
         gqxXb6NeCOjjclogqnwTXN+ej2Z1B96hg9Eb6VYz9sHo3iOJdFd7uxJs0Zv3TA0ZaZln
         QEj9FS0lWiXo0tCAMmi3IQo74vKANVxOoqpfWCFgNRSyEPCjL097hb7y/+PAuZnJ8n46
         1HWlTFHOILxYtHBi9+2SEG1SuBHtiZGIeyc9qHZsVtySmuoCEkQ7jb2+LZb4AuwakM8B
         qxyg==
X-Gm-Message-State: ANhLgQ1Pww98WT+YufxOyeuw8Hw0jNVPwhlI2ytt2mbAI1crVkBI5Wv5
        VGz1r+9l5Zv4wcRrlLNks5LadzHOf0cX1A==
X-Google-Smtp-Source: ADFU+vsgia+n3CffwxBS/UeKOixscRMnN4nC4k/WfjGmkr8scW8DFr63keFcGb91zXBov3hj/o4Yaw==
X-Received: by 2002:a1c:4d13:: with SMTP id o19mr4318837wmh.186.1584437136062;
        Tue, 17 Mar 2020 02:25:36 -0700 (PDT)
Received: from [192.168.1.10] ([194.35.116.181])
        by smtp.gmail.com with ESMTPSA id f17sm3887956wrj.28.2020.03.17.02.25.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Mar 2020 02:25:35 -0700 (PDT)
Subject: Re: [PATCH bpf-next 4/4] bpftool: Add struct_ops support
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, kernel-team@fb.com,
        netdev@vger.kernel.org
References: <20200316005559.2952646-1-kafai@fb.com>
 <20200316005624.2954179-1-kafai@fb.com>
 <da2d5a6c-3023-bb27-7c45-96224c8f4334@isovalent.com>
 <20200317002452.a4w2pu6vbv4cvsid@kafai-mbp>
 <20200317005721.vhruudlmhr637uto@kafai-mbp>
From:   Quentin Monnet <quentin@isovalent.com>
Message-ID: <8bc91294-dd7a-deb7-5006-4350bbb3b70f@isovalent.com>
Date:   Tue, 17 Mar 2020 09:25:34 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200317005721.vhruudlmhr637uto@kafai-mbp>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2020-03-16 17:57 UTC-0700 ~ Martin KaFai Lau <kafai@fb.com>
> On Mon, Mar 16, 2020 at 05:24:52PM -0700, Martin KaFai Lau wrote:
>> On Mon, Mar 16, 2020 at 11:54:28AM +0000, Quentin Monnet wrote:
>>
>>> [...]
>>>
>>>> +static int do_unregister(int argc, char **argv)
>>>> +{
>>>> +	const char *search_type, *search_term;
>>>> +	struct res res;
>>>> +
>>>> +	if (argc != 2)
>>>> +		usage();
>>>
>>> Or you could reuse the macros in main.h, for more consistency with other
>>> subcommands:
>>>
>>> 	if (!REQ_ARGS(2))
>>> 		return -1;
>> Thanks for the review!
>>
>> I prefer to print out "usage();" whenever possible but then "-j" gave
>> me a 'null' after a json error mesage ...
>>
>> # bpftool -j struct_ops unregister
>> {"error":"'unregister' needs at least 2 arguments, 0 found"},null
>>
>> Then I went without REQ_ARGS(2) which is similar to a few existing
>> cases like do_dump(), do_updaate()...etc in map.c.
>>
>> That was my consideration.  However, I can go back to use REQ_ARGS(2)
>> and return -1 without printing usage.  no strong preference here.
> After another look,  I will keep it as is since REQ_ARGS() is a "<"
> check.  "argc != 2" is the correct check here.  Otherwise,
> allowing 'bpftool struct_ops unregister name cubic dctcp' looks weird.
> 

Ah right, fair enough. I'm good with v2, thanks for the changes!
Quentin
