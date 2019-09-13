Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29685B2889
	for <lists+netdev@lfdr.de>; Sat, 14 Sep 2019 00:37:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404145AbfIMWgu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 18:36:50 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:39216 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404136AbfIMWgt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 18:36:49 -0400
Received: by mail-lj1-f194.google.com with SMTP id j16so28569422ljg.6
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 15:36:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=sfVAv/G3SBA3hh8aRouxiJvEsUEGrIoANWZewhhUKls=;
        b=FQ8lqumewVJJLLoIRzb4SA4o96HlDROwFkRGtgVHua5RS/MK5DpYJr00VqfhPh6TOf
         n5SLEArHZ1ROJSNVTVvnalcmOJEnMqVTs9GltJ0c6ptleHrINEMuFXthzCJEdmxzHII+
         Z7vAIrDlnxCHnaJY4m4dYap1Yr4h9jQDump0hM+7NEFEW1R3ot4T7MFye3msGIX2YwZ9
         RzB7ob3kAbMvetVCIG42gD0e+UvbFT8peiWoADClBsFWHPOK0GdPZbrjup1ajrpBwPRD
         VsBRsXRPDMT1jK68FtBAeQb8wq3XikY429TzBmL5qlK5tY6gKVXXi7KBJwu7wrkICxCr
         s5HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=sfVAv/G3SBA3hh8aRouxiJvEsUEGrIoANWZewhhUKls=;
        b=g39Swsoz6GEXlO9XJIFv8BYSBuDwWWl6nrolZTGSP95E6iXfHR+WclblyhMLpqpkeC
         Do6rRa2biz63X6zmM7ciFmhvcmoHu8cbdq483PFzoITumcRHw2GKiDD8ha7vTheXcc9F
         kbHQ+ncPYdNjXhI0LvkNGgzgdhg35rVVRRPyWdeqlq1iGC96zVTTYwPy6BJsApwn1rf+
         wtAr09It1moyh2+/FePirlCM9BHpiLJEm5WKC+BbGjijqX1h+LNfZrSNz+wbry1upARA
         L8drSK1XgXY2O/24H+ncazFNgL1yH98k/fi6wjWiI9BE1yZyc0f27FPA4NMFEiczdSVG
         8QTw==
X-Gm-Message-State: APjAAAUG/CxQIYTQf18MjqJQCbuZaAKEJkF8KMwICH1AkNe5zb17XJKp
        UsXRR9RTEjDLtJT54fPf2k/F5Q==
X-Google-Smtp-Source: APXvYqwjlDzQxVv+WSKyHAC63FoEdn9FGOKDWAq3hjINghZA/hdEqL0Y2fOu/7VUIRcnkCROURpIaA==
X-Received: by 2002:a2e:9081:: with SMTP id l1mr12064327ljg.33.1568414205743;
        Fri, 13 Sep 2019 15:36:45 -0700 (PDT)
Received: from khorivan (168-200-94-178.pool.ukrtel.net. [178.94.200.168])
        by smtp.gmail.com with ESMTPSA id h25sm8508971lfj.81.2019.09.13.15.36.44
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 13 Sep 2019 15:36:45 -0700 (PDT)
Date:   Sat, 14 Sep 2019 01:36:43 +0300
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     Yonghong Song <yhs@fb.com>
Cc:     "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "clang-built-linux@googlegroups.com" 
        <clang-built-linux@googlegroups.com>
Subject: Re: [PATCH bpf-next 11/11] samples: bpf: makefile: add sysroot
 support
Message-ID: <20190913223642.GG26724@khorivan>
Mail-Followup-To: Yonghong Song <yhs@fb.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "clang-built-linux@googlegroups.com" <clang-built-linux@googlegroups.com>
References: <20190910103830.20794-1-ivan.khoronzhuk@linaro.org>
 <20190910103830.20794-12-ivan.khoronzhuk@linaro.org>
 <e967744b-0286-d92f-9fc8-70f5759cc4a1@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <e967744b-0286-d92f-9fc8-70f5759cc4a1@fb.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 13, 2019 at 09:45:31PM +0000, Yonghong Song wrote:
>
>
>On 9/10/19 11:38 AM, Ivan Khoronzhuk wrote:
>> Basically it only enables that was added by previous couple fixes.
>> For sure, just make tools/include to be included after sysroot
>> headers.
>>
>> export ARCH=arm
>> export CROSS_COMPILE=arm-linux-gnueabihf-
>> make samples/bpf/ SYSROOT="path/to/sysroot"
>>
>> Sysroot contains correct libs installed and its headers ofc.
>> Useful when working with NFC or virtual machine.
>>
>> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
>> ---
>>   samples/bpf/Makefile   |  5 +++++
>>   samples/bpf/README.rst | 10 ++++++++++
>>   2 files changed, 15 insertions(+)
>>
>> diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
>> index 4edc5232cfc1..68ba78d1dbbe 100644
>> --- a/samples/bpf/Makefile
>> +++ b/samples/bpf/Makefile
>> @@ -177,6 +177,11 @@ ifeq ($(ARCH), arm)
>>   CLANG_EXTRA_CFLAGS := $(D_OPTIONS)
>>   endif
>>
>> +ifdef SYSROOT
>> +ccflags-y += --sysroot=${SYSROOT}
>> +PROGS_LDFLAGS := -L${SYSROOT}/usr/lib
>> +endif
>> +
>>   ccflags-y += -I$(objtree)/usr/include
>>   ccflags-y += -I$(srctree)/tools/lib/bpf/
>>   ccflags-y += -I$(srctree)/tools/testing/selftests/bpf/
>> diff --git a/samples/bpf/README.rst b/samples/bpf/README.rst
>> index 5f27e4faca50..786d0ab98e8a 100644
>> --- a/samples/bpf/README.rst
>> +++ b/samples/bpf/README.rst
>> @@ -74,3 +74,13 @@ samples for the cross target.
>>   export ARCH=arm64
>>   export CROSS_COMPILE="aarch64-linux-gnu-"
>>   make samples/bpf/ LLC=~/git/llvm/build/bin/llc CLANG=~/git/llvm/build/bin/clang
>> +
>> +If need to use environment of target board (headers and libs), the SYSROOT
>> +also can be set, pointing on FS of target board:
>> +
>> +export ARCH=arm64
>> +export CROSS_COMPILE="aarch64-linux-gnu-"
>> +make samples/bpf/ SYSROOT=~/some_sdk/linux-devkit/sysroots/aarch64-linux-gnu
>> +
>> +Setting LLC and CLANG is not necessarily if it's installed on HOST and have
>> +in its targets appropriate arch triple (usually it has several arches).
>
>You have very good description about how to build and test in cover
>letter. Could you include those instructions here as well? This will
>help keep a record so later people can try/test if needed.

I will try.
Thanks!!!

-- 
Regards,
Ivan Khoronzhuk
