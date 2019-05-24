Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA68329AC9
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 17:15:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389947AbfEXPP2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 11:15:28 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36626 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389314AbfEXPP1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 11:15:27 -0400
Received: by mail-wr1-f66.google.com with SMTP id s17so10432910wru.3
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 08:15:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=to:cc:references:from:openpgp:autocrypt:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KSRUhgjwtC0T8Cv+keG98JDBG7eSt1Ox9pHF1Wcdlcc=;
        b=1IEmrwmKbF55Hu1kEEGWyRyPnAwXt2eZZEolcQjRW3ntth1RAitHZFftkNimSIYa07
         zuJl+w2G6kryYG68/W7M/L+sYNbmTPyi+4tNZhYgeNn6Jl9b/B0RtlXWgNv3kEnjPGYg
         CUHcInJ+d9OqXnbh6ynV1o0iMaTjU5Dt4IVQz8UogBeAGiP13zNEuD1jwdnN6wsWQq5w
         T4WP2NIhZiS3LingDto9IFFkr5i/qswXBC3dkfG87rsZ9QMsYapNysAnHz3amOZgcn95
         YGp4meajU3POuDXQdpcXY8e7hozU6XzPYy9FYnIoulcD5bNZYkFfGu5vZ4Z/DWISogFY
         ibgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:openpgp:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=KSRUhgjwtC0T8Cv+keG98JDBG7eSt1Ox9pHF1Wcdlcc=;
        b=fJXRJEtOsn5CrOgiyDyRUlL+K+VI1tJ0wE13J537rn6O+e1YBzAiG4wOn15egpIqaq
         K2TJAkCKJrzd4phX1rA0hAeiWNanOmb+kZHPNpN93BLPAKzi9uwnywqw8s1mSzYX76d9
         SI8s6DMORpoWw021Tq46GouEHjSF1Py6aWJXidB07RDeGbLNZsFD6XJFQCT1GMgEdUJE
         H5rHvVhOrfazsPV337sB7vT3YPwEfRGt31yWctNrqG63KNrcwMfWW4omRfqQHeJ+ug+Y
         94nnP4Uhp9bRmsqgD4ZkOmwvdjpJNRW8M3lgTc9tH7xYnnxiLXdZ0QEVsWkI610DWxHS
         jtCA==
X-Gm-Message-State: APjAAAXHrSkhrWCHHwx11L26AcuC9l2co4bDksXVWNdSytR2NNlDLNFN
        4J6+XiVS7g3eDhEud9qnvpWUeQ==
X-Google-Smtp-Source: APXvYqy5wsUOySULmMEKRPHj4TnoiDtITTFjRyQRYhytJVzdTFqBE7AuFAthy6gYYXw852fZRndmgw==
X-Received: by 2002:adf:f8ce:: with SMTP id f14mr14820676wrq.110.1558710924379;
        Fri, 24 May 2019 08:15:24 -0700 (PDT)
Received: from [172.20.1.104] ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id q14sm1735039wrw.60.2019.05.24.08.15.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 May 2019 08:15:23 -0700 (PDT)
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, oss-drivers@netronome.com,
        Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>
References: <20190524103648.15669-1-quentin.monnet@netronome.com>
 <20190524103648.15669-3-quentin.monnet@netronome.com>
 <20190524132215.4113ff08@carbon>
 <5895821e-0d79-2169-d631-0fa7560135ec@netronome.com>
 <20190524144900.618e8e93@carbon>
From:   Quentin Monnet <quentin.monnet@netronome.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quentin.monnet@netronome.com; prefer-encrypt=mutual; keydata=
 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
 RHhSHGnKaQ6MfrTge5Q0h5A=
Subject: Re: [PATCH bpf-next v3 2/3] libbpf: add bpf_object__load_xattr() API
 function to pass log_level
Message-ID: <0842db21-996b-346c-d572-e7384802eae0@netronome.com>
Date:   Fri, 24 May 2019 16:15:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190524144900.618e8e93@carbon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2019-05-24 14:49 UTC+0200 ~ Jesper Dangaard Brouer <brouer@redhat.com>
> On Fri, 24 May 2019 12:51:14 +0100
> Quentin Monnet <quentin.monnet@netronome.com> wrote:
> 
>> 2019-05-24 13:22 UTC+0200 ~ Jesper Dangaard Brouer <brouer@redhat.com>
>>> On Fri, 24 May 2019 11:36:47 +0100
>>> Quentin Monnet <quentin.monnet@netronome.com> wrote:
>>>   
>>>> libbpf was recently made aware of the log_level attribute for programs,
>>>> used to specify the level of information expected to be dumped by the
>>>> verifier. Function bpf_prog_load_xattr() got support for this log_level
>>>> parameter.
>>>>
>>>> But some applications using libbpf rely on another function to load
>>>> programs, bpf_object__load(), which does accept any parameter for log
>>>> level. Create an API function based on bpf_object__load(), but accepting
>>>> an "attr" object as a parameter. Then add a log_level field to that
>>>> object, so that applications calling the new bpf_object__load_xattr()
>>>> can pick the desired log level.  
>>>
>>> Does this allow us to extend struct bpf_object_load_attr later?  
>>
>> I see no reason why it could not. Having the _xattr() version of the
>> function is precisely a way to have something extensible in the future,
>> without having to create additional API functions each time we want to
>> pass a new parameter. And e.g. struct bpf_prog_load_attr (used with
>> bpf_prog_load_xattr()) has already been extended in the past. So, yeah,
>> we can add to it in the future.
> 
> Great.  I just don't know/understand how user-space handle this. If a
> binary is compiled with libbpf as dynamic loadable lib, then it e.g. saw
> libbpf.so.2 when it was compiled, then can't it choose to use libbpf.so.3
> then? (e.g. when libbpf.so.2 is not on the system). (I would actually
> like to learn/understand this, so links are welcome).

Well I'm no library expert, so don't take my word for it. As far as I
understand, the soname of the library is selected at link time. So if
your app is linked again libbpf.so.2, you will need version 2.* of the
library to be installed on your system, because increasing the version
number usually implies ABI breakage. You can usually check which version
of the libraries is needed with ldd ("ldd bpftool", except that you
won't see libbpf because it's statically linked for bpftool).

This being said, for now the version number for libbpf has not been
incremented and is still at 0, we only had the extraversion increasing.
Since it's not part of the soname ("-Wl,-soname,libbpf.so.$(VERSION)" in
libbpf Makefile), it is not taken into account when searching for the
lib on the system. What I mean is that if the program is linked against
libbpf.so.0, it could pick libbpf.so.0.0.2 or libbpf.so.0.0.3
indifferently depending on what it finds on the system (I assume it
takes the newest?). There should not be any ABI breakage between the
two, so programs compiled against an older patchlevel or extraversion of
the library should still be able to use a newer one.

There is some documentation on libraries here (I should take some time
to finish reading it myself!):

http://tldp.org/HOWTO/Program-Library-HOWTO/

There are also interesting elements in the documentation that was cited
when Andrey introduced the LIBPPF_API macros in libbpf:

https://www.akkadia.org/drepper/dsohowto.pdf

> 
>> Do you have something in mind?
> 
> I was playing with extending bpf_prog_load_attr, but instead I created a
> bpf_prog_load_attr_maps instead and a new function
> bpf_prog_load_xattr_maps(), e.g. see:
> 
> https://github.com/xdp-project/xdp-tutorial/blob/master/common/common_libbpf.h
> https://github.com/xdp-project/xdp-tutorial/blob/master/common/common_libbpf.c
> 
> I guess, I could just extend bpf_prog_load_attr instead, right?
> 

I believe so.

Best,
Quentin
