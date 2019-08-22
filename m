Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E13D299130
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 12:46:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387755AbfHVKoA convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 22 Aug 2019 06:44:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56168 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387710AbfHVKoA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 06:44:00 -0400
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7E572C08EC15
        for <netdev@vger.kernel.org>; Thu, 22 Aug 2019 10:43:59 +0000 (UTC)
Received: by mail-ed1-f71.google.com with SMTP id b5so3109929eds.22
        for <netdev@vger.kernel.org>; Thu, 22 Aug 2019 03:43:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=0JLhxmTFC0T1JpcoAWZpSF/J/8Lj2ncl3gvrc6r31y8=;
        b=JIZE5mPrp6PjqLq5WAuwjMdJB0H1AmGKTiFQ8v+N+IbikxZ3wZzp66Kz/86FqaiSzY
         dfQs9HpfhxAfUf0gApWPN3p9o4xtaRqratmOKRQJVlMdQSU+n7HFVm4b0C20Jxora6yc
         PRR3/O0Ol+BdZTMs4dZ3z1pRpbh0C5Zz3UPgHynp7m69qQlzlooP189VAS+l2PaH0vGE
         QjsDzrtI8dkDYY4mrTh4JUI+HvndjAszYO2W5G4FOyi9EelBQcNBvIYOI+8EgLCK3jtG
         qZEJ6v+fXja2o8tzri5/CqTzM8l9q6MMudL6l6YTcDE2LwJxGUL1tTeng0k94JNY4+tA
         wVUw==
X-Gm-Message-State: APjAAAXtGL0m+kq2BHJV5ZnLfrLJxwwJMK+psz/+/2BXM1AjT/U+6K4d
        VM0hBfeNnhX31+5Wju1I8g2HtMvmZo4dK3YyE5ON7qObvBZk9ZWnoSyvFDKYr/cF7iyjo2E6lY2
        p+98yD3VqglMNMdcN
X-Received: by 2002:aa7:c1da:: with SMTP id d26mr33293428edp.208.1566470638300;
        Thu, 22 Aug 2019 03:43:58 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxOjMDvOoZysLMKijezQgJaN4SLJPc0vvw5kDtOhrb+8j1+sGoOgyxVqC8kx6rmFoerYpNKrg==
X-Received: by 2002:aa7:c1da:: with SMTP id d26mr33293414edp.208.1566470638147;
        Thu, 22 Aug 2019 03:43:58 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id o88sm3928028edb.28.2019.08.22.03.43.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Aug 2019 03:43:57 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id BCFEB181CEF; Thu, 22 Aug 2019 12:43:56 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        andrii.nakryiko@gmail.com
Subject: Re: [RFC bpf-next 4/5] iproute2: Allow compiling against libbpf
In-Reply-To: <9de36bbf-b70d-9320-c686-3033d0408276@iogearbox.net>
References: <20190820114706.18546-1-toke@redhat.com> <20190820114706.18546-5-toke@redhat.com> <9de36bbf-b70d-9320-c686-3033d0408276@iogearbox.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 22 Aug 2019 12:43:56 +0200
Message-ID: <87imqppjir.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann <daniel@iogearbox.net> writes:

> On 8/20/19 1:47 PM, Toke Høiland-Jørgensen wrote:
>> This adds a configure check for libbpf and renames functions to allow
>> lib/bpf.c to be compiled with it present. This makes it possible to
>> port functionality piecemeal to use libbpf.
>> 
>> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
>> ---
>>   configure          | 16 ++++++++++++++++
>>   include/bpf_util.h |  6 +++---
>>   ip/ipvrf.c         |  4 ++--
>>   lib/bpf.c          | 33 +++++++++++++++++++--------------
>>   4 files changed, 40 insertions(+), 19 deletions(-)
>> 
>> diff --git a/configure b/configure
>> index 45fcffb6..5a89ee9f 100755
>> --- a/configure
>> +++ b/configure
>> @@ -238,6 +238,19 @@ check_elf()
>>       fi
>>   }
>>   
>> +check_libbpf()
>> +{
>> +    if ${PKG_CONFIG} libbpf --exists; then
>> +	echo "HAVE_LIBBPF:=y" >>$CONFIG
>> +	echo "yes"
>> +
>> +	echo 'CFLAGS += -DHAVE_LIBBPF' `${PKG_CONFIG} libbpf --cflags` >> $CONFIG
>> +	echo 'LDLIBS += ' `${PKG_CONFIG} libbpf --libs` >>$CONFIG
>> +    else
>> +	echo "no"
>> +    fi
>> +}
>> +
>>   check_selinux()
>
> More of an implementation detail at this point in time, but want to
> make sure this doesn't get missed along the way: as discussed at
> bpfconf [0] best for iproute2 to handle libbpf support would be the
> same way of integration as pahole does, that is, to integrate it via
> submodule [1] to allow kernel and libbpf features to be in sync with
> iproute2 releases and therefore easily consume extensions we're adding
> to libbpf to aide iproute2 integration.

I can sorta see the point wrt keeping in sync with kernel features. But
how will this work with distros that package libbpf as a regular
library? Have you guys given up on regular library symbol versioning for
libbpf?

>    [0] http://vger.kernel.org/bpfconf2019.html#session-4

Thanks for that link! Didn't manage to find any of the previous
discussions on iproute2 compatibility.

-Toke
