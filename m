Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87FC1D5295
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 23:26:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729762AbfJLV0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 17:26:50 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:38665 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729671AbfJLV0u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Oct 2019 17:26:50 -0400
Received: by mail-lj1-f193.google.com with SMTP id b20so13048062ljj.5
        for <netdev@vger.kernel.org>; Sat, 12 Oct 2019 14:26:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=l+nirvmkHLEBqBl6bw7lxrZbBMmPpPDkXnfegt2ERs0=;
        b=bOOQ6fpaQHN/FWWatME7AFTtNCrf5dgO1ZU8WA/fBDgO7AEY8yXMZklcpRl4XNkq5T
         eecBMUbKu/rM+OyMkdQIzmQ2S5VYs8FlfeeBmgWWu0eDBy43EWsj8uX0iYJKIb8MOC5z
         msROfXVDW89+AcnvuStR3HUCuGucUvwGwo6zA3n9Q6fROANyForjuXNIn/t/f/GpG/o+
         mOYoJ9C/2Zm01ycIU62BeDDkv5FRvUkOPXYtrApoCWqeg6wcwF3N+TK1QRjHkegswSBv
         VvvKqBTKJJ5n2JLYN+WoeHgk7qOBooUw05QbaV05lYRP/+8ZCRDs9y+4Bw7uJGCGl7Z/
         yGmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=l+nirvmkHLEBqBl6bw7lxrZbBMmPpPDkXnfegt2ERs0=;
        b=pnD5bTv/cULsWa88JloG2IOYkMZLsDOSEnL01rq6my4hhyvWz1SScI4RD0qeezZCJo
         zcdDm90s+htEik8gR/Wx9EtBzpl0OHkA3PGCFBAQZ2wtRAI8yYFipzUsXNNS0XHVY35Y
         0/h5LaBPkm8woA+1LCNQheMdeI6EqAuTzq/s4lgXW2g7IN4cakq/lbYjIw+K94SUKNfj
         N+sOruxufE6lwyfg2Y5l0dCtXDFhwBGw1T0D1HxlP1Njv8k/Dh2O1dXsv5qKIpyTHGmZ
         OFYsIYisPYZxLuwG7Pg0fHLi0OLxVQ1RudyAxO5QQs1Q6Ec9v07i89cXGQQqnDEpPNge
         Bqwg==
X-Gm-Message-State: APjAAAVM7Knztk4Uqu47BB3fiIK+unOXqywPSemMpuw2rJPY17XCk31T
        drdCIDXwXb4ErOUudbvaQ7MMkQ==
X-Google-Smtp-Source: APXvYqx/zpvokyTYRRQY1lgFNCEeQnhx9hVn6IE+ZWV4Trp0oLV6Oz0w6zjygCjzS9E+uhEs2zkbfA==
X-Received: by 2002:a2e:8315:: with SMTP id a21mr13301291ljh.73.1570915608214;
        Sat, 12 Oct 2019 14:26:48 -0700 (PDT)
Received: from khorivan (88-201-94-178.pool.ukrtel.net. [178.94.201.88])
        by smtp.gmail.com with ESMTPSA id x30sm2931384ljd.39.2019.10.12.14.26.46
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 12 Oct 2019 14:26:47 -0700 (PDT)
Date:   Sun, 13 Oct 2019 00:26:45 +0300
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, yhs@fb.com,
        davem@davemloft.net, jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        clang-built-linux@googlegroups.com, ilias.apalodimas@linaro.org
Subject: Re: [PATCH v5 bpf-next 09/15] samples/bpf: use own flags but not
 HOSTCFLAGS
Message-ID: <20191012212643.GC3689@khorivan>
Mail-Followup-To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        ast@kernel.org, daniel@iogearbox.net, yhs@fb.com,
        davem@davemloft.net, jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        clang-built-linux@googlegroups.com, ilias.apalodimas@linaro.org
References: <20191011002808.28206-1-ivan.khoronzhuk@linaro.org>
 <20191011002808.28206-10-ivan.khoronzhuk@linaro.org>
 <99f76e2f-ed76-77e0-a470-36ae07567111@cogentembedded.com>
 <20191011095715.GB3689@khorivan>
 <3fb88a06-5253-1e48-9bea-2d31a443250b@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <3fb88a06-5253-1e48-9bea-2d31a443250b@cogentembedded.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 11, 2019 at 02:16:05PM +0300, Sergei Shtylyov wrote:
>On 10/11/2019 12:57 PM, Ivan Khoronzhuk wrote:
>
>>>> While compiling natively, the host's cflags and ldflags are equal to
>>>> ones used from HOSTCFLAGS and HOSTLDFLAGS. When cross compiling it
>>>> should have own, used for target arch. While verification, for arm,
>>>
>>>   While verifying.
>> While verification stage.
>
>   While *in* verification stage, "while" doesn't combine with nouns w/o
>a preposition.


Sergei, better add me in cc list when msg is to me I can miss it.

Regarding the language lesson, thanks, I will keep it in mind next
time, but the issue is not rude, if it's an issue at all, so I better
leave it as is, as not reasons to correct it w/o code changes and
everyone is able to understand it.

>
>>>> arm64 and x86_64 the following flags were used always:
>>>>
>>>> -Wall -O2
>>>> -fomit-frame-pointer
>>>> -Wmissing-prototypes
>>>> -Wstrict-prototypes
>>>>
>>>> So, add them as they were verified and used before adding
>>>> Makefile.target and lets omit "-fomit-frame-pointer" as were proposed
>>>> while review, as no sense in such optimization for samples.
>>>>
>>>> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
>>> [...]
>
>MBR, Sergei

-- 
Regards,
Ivan Khoronzhuk
