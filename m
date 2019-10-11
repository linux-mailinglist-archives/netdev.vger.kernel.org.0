Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7151CD3E12
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 13:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727762AbfJKLQK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 07:16:10 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:37702 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726935AbfJKLQK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 07:16:10 -0400
Received: by mail-lj1-f194.google.com with SMTP id l21so9442016lje.4
        for <netdev@vger.kernel.org>; Fri, 11 Oct 2019 04:16:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:organization:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ooy01geSvoqL+GgWiguG5Arr/pkbSR9LEwm6vQ6trlA=;
        b=FJGDUtGWD6dezMdpfiI3yfqw/RLXa3Cf5Y5p0xGMYaiScNsHdq6GDzLNWh5p1En1q0
         eRQtdLRr1/D6U7+Q85XT3rS2ISqQiuliJAmkF/J0fC9tO1mut3EkSl4ckQrODTRDbJdU
         SE36sc3svSCPDdHSMN0uQY3JTiTL9xr8ZTzeE4IQ0z4WYKvesc1H+lJWGNS1B3UvJgJx
         arlORLWtfcvJ3hdtQRMkK1TK2MtcjnIxaexR8VaF/1B+qtq7HkJxYQivLhERG8DBNbBl
         hQfb0LW2/xY1uof3a5oa/f9swp/JrzNMd0ITcgQudf+WS9jFD7yBHeENt5IvXwF77pU0
         to2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Ooy01geSvoqL+GgWiguG5Arr/pkbSR9LEwm6vQ6trlA=;
        b=MYTOWw8zKb2mcjIa2RVoXLrleg0YEg8BPezoUJAp2byzLfKGiRpwGS5oMXpfQ9aZyO
         B7ZH4sDbN6fbRtQcrsA5EoT4xDJMzuKPl76pkLFoulSjKKPd66ygzkpz11IcG3HTQdmi
         v2xCaSGbjQdlzsrAr2EXIlo3xCAEb5sLwJ1eOxNEn4sm8H9o0y53NmyJEivQ+XfIqTuj
         DD0X3vP66LeiZ1fuUfQu8G9El1CbjJRvrA0P0ejPDYKKvmMAuQXJ85cFgW90nZqY8ZHP
         sCqwf0NwJ5mTsDM5YvtEncx3cK9ZDe5i4xix8O1fGO1W9LP23ctmvNjOoYgEVQaUNBNB
         AWww==
X-Gm-Message-State: APjAAAX9o0R/xxGCcsLqWhNsBpkLAhGN1W3TzsS/HjcqqQhqN92BT5hk
        l7M9J6OMXYQe4G2ceel73386SQ==
X-Google-Smtp-Source: APXvYqz+u6eneONfnjvqqaE8Uh0If4lrYaqqjy+4UFFpkLHI7cc3rLwOyRGvWtm0ePCkEkvTKscC4w==
X-Received: by 2002:a2e:569a:: with SMTP id k26mr9075699lje.256.1570792567730;
        Fri, 11 Oct 2019 04:16:07 -0700 (PDT)
Received: from wasted.cogentembedded.com ([2a00:1fa0:4430:5cc6:e6ed:2da1:4d7:1d29])
        by smtp.gmail.com with ESMTPSA id q26sm1857253lfd.53.2019.10.11.04.16.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 11 Oct 2019 04:16:06 -0700 (PDT)
Subject: Re: [PATCH v5 bpf-next 09/15] samples/bpf: use own flags but not
 HOSTCFLAGS
To:     ast@kernel.org, daniel@iogearbox.net, yhs@fb.com,
        davem@davemloft.net, jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        clang-built-linux@googlegroups.com, ilias.apalodimas@linaro.org
References: <20191011002808.28206-1-ivan.khoronzhuk@linaro.org>
 <20191011002808.28206-10-ivan.khoronzhuk@linaro.org>
 <99f76e2f-ed76-77e0-a470-36ae07567111@cogentembedded.com>
 <20191011095715.GB3689@khorivan>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
Message-ID: <3fb88a06-5253-1e48-9bea-2d31a443250b@cogentembedded.com>
Date:   Fri, 11 Oct 2019 14:16:05 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <20191011095715.GB3689@khorivan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-MW
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/11/2019 12:57 PM, Ivan Khoronzhuk wrote:

>>> While compiling natively, the host's cflags and ldflags are equal to
>>> ones used from HOSTCFLAGS and HOSTLDFLAGS. When cross compiling it
>>> should have own, used for target arch. While verification, for arm,
>>
>>   While verifying.
> While verification stage.

   While *in* verification stage, "while" doesn't combine with nouns w/o
a preposition.

>>> arm64 and x86_64 the following flags were used always:
>>>
>>> -Wall -O2
>>> -fomit-frame-pointer
>>> -Wmissing-prototypes
>>> -Wstrict-prototypes
>>>
>>> So, add them as they were verified and used before adding
>>> Makefile.target and lets omit "-fomit-frame-pointer" as were proposed
>>> while review, as no sense in such optimization for samples.
>>>
>>> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
>> [...]

MBR, Sergei
