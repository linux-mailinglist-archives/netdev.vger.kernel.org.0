Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0C3A16C476
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 15:54:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730926AbgBYOyt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 09:54:49 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42353 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730905AbgBYOyr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 09:54:47 -0500
Received: by mail-wr1-f66.google.com with SMTP id p18so11426767wre.9
        for <netdev@vger.kernel.org>; Tue, 25 Feb 2020 06:54:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=y++kI/5dCtw5fZaeSgXh8lWKMSaGQmRYxWkHHDDsYEE=;
        b=jGWepyEIkZ1p0tED+rauWwmW4k3RG+6zN0X4+Bky/2ByebPFpB9k5sL2WKPs6Odb+c
         E5MFAI285mX4zdtjqORrRKQDBBJwXm1myO7nslK+AtFUxk5GUzxOs1R8v73pHgKaV2X0
         7R/bLi/0hyOhShc0bz1uYhtozSNWxm0TGVRbDAkkvl0P/UQ1ljuyPwdVM1Nj0jSzRkLz
         hmkndN0H37fZzshO4I7DzEGHOxlvrPfvsAt9p7Naj81CWN4vKqrl+nuY6mZlh+N4Rj07
         7gnDQ/sDjdKgaWRUy/RfRO+i8ZglHkuBPTxsb18n4eB0SPCdfQsiuh1wa857P0BP4fUo
         TgIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=y++kI/5dCtw5fZaeSgXh8lWKMSaGQmRYxWkHHDDsYEE=;
        b=a6Ssb9kXziCx2lSjYZm0M+OUmKA1WRaaTRJ3pgmTdn18YlDr6EfHl7BiUdzAJoM7tj
         q5jpNd0nvcACea8rfVexQdTHHvhFIkHUfNP4HhGffvClEVNE4JmMcJpZ50pbeSvJtJpR
         5qC38w1woQYDO2UAnjbmtfe6pBzFb1jawfNc1Oj/T+mp9NyIrkzfRy0l5vQo1GehiGIZ
         o01UNZszfJH2LJivHoRJaEKDxgmF1eI9eddPYT4mAOLq/qZ/nZYbDfolex0WvIi/deIk
         hGUmKofDX47lBPte7m2VzRxrFOaLo8u3TWA/PatNnKqerGXmBJXEdPyLm4gb1aG5KZ8T
         PMUA==
X-Gm-Message-State: APjAAAW/EuZjnFiwH7KiQTZvotsHV64Gof7CzUF6UK3CJjPulJE7uMA0
        gW+kRNznLK9FgTJRMaUECZjIgw==
X-Google-Smtp-Source: APXvYqwfSaJ8pCA6BhtoWHv0t8xFZnZrK/CzrI1X29nZWXWlh6LSoOIjxsxgH2SsHYgerYZIkRUP+w==
X-Received: by 2002:adf:f244:: with SMTP id b4mr20457380wrp.413.1582642485266;
        Tue, 25 Feb 2020 06:54:45 -0800 (PST)
Received: from [192.168.1.10] ([194.35.116.65])
        by smtp.gmail.com with ESMTPSA id v131sm4674454wme.23.2020.02.25.06.54.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2020 06:54:44 -0800 (PST)
Subject: Re: [PATCH bpf-next v2 5/5] selftests/bpf: Add test for "bpftool
 feature" command
To:     Michal Rostecki <mrostecki@opensuse.org>, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
References: <20200221031702.25292-1-mrostecki@opensuse.org>
 <20200221031702.25292-6-mrostecki@opensuse.org>
 <d178dc6c-7696-8e58-9df9-887152104a1c@isovalent.com>
 <c24d2b7a-889b-9294-cd30-6938f00b645a@opensuse.org>
From:   Quentin Monnet <quentin@isovalent.com>
Message-ID: <424b3804-a6ec-750c-bc90-753bbdf512ce@isovalent.com>
Date:   Tue, 25 Feb 2020 14:54:43 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <c24d2b7a-889b-9294-cd30-6938f00b645a@opensuse.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2020-02-25 14:55 UTC+0100 ~ Michal Rostecki <mrostecki@opensuse.org>
> On 2/21/20 12:28 PM, Quentin Monnet wrote:
>>> +    @default_iface
>>> +    def test_feature_dev(self, iface):
>>> +        expected_patterns = [
>>> +            SECTION_SYSCALL_CONFIG_PATTERN,
>>> +            SECTION_PROGRAM_TYPES_PATTERN,
>>> +            SECTION_MAP_TYPES_PATTERN,
>>> +            SECTION_HELPERS_PATTERN,
>>> +            SECTION_MISC_PATTERN,
>>> +        ]
>>
>> Mixed feeling on the tests with plain output, as we keep telling people
>> that plain output should not be parsed (not reliable, may change). But
>> if you want to run one or two tests with it, why not, I guess.
> 
> I thought about that and yes, testing the plain output is probably
> redundant and makes those tests less readable. However, the only plain
> output test which I would like to keep there is test_feature_macros -
> because I guess that we are not planning to change names or patterns of
> generated macros (or if so, we should test that change).
> 

I did not mentally include the header/macros output in “plain output”, 
but yeah I guess I was not explicit on this one. So: Agreed, with 
“macros” it should not change and it is welcome in the tests, feel free 
to keep it :)

Quentin
