Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2AA3B9745
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 20:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405534AbfITSe5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 14:34:57 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:33438 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404830AbfITSe4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Sep 2019 14:34:56 -0400
Received: by mail-lj1-f194.google.com with SMTP id a22so8069867ljd.0
        for <netdev@vger.kernel.org>; Fri, 20 Sep 2019 11:34:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=pnD+O0ovrq1F6qN8k3Y2ZgHyJhSBoQdXb5evY3Rg4Cc=;
        b=bqY8uKMYN5NCM6qjXOyTo3GavIiiiafNBzRaCqO4/1LIT9iV6hBLBucLJ/HZJ0OgZD
         thKmQSPWYASptQ6dsQG3Gy+Mdy4QNYH6K4cmbCjPhmxQKKUrInjNLD3TPtvAfPfvqS5K
         q7PX3cVnCzRyAjngm6osaoQej4LjswgsZCxIfa1fBukdORMQe3f9qPTu0BSpFBPONZnR
         6hpPHBSMQoNREbN2MI2EzZSa4MUlvIZ6CpspsjwL0UBJKXK/X3EvVG818MW67iWDk7HD
         sJrgaFZBw7vcxrXUuQ/6n7DmBSZGus02ZPGRZ+eqido3MD4dUxMb9gqBD+RbsTD8Tfaj
         zn9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=pnD+O0ovrq1F6qN8k3Y2ZgHyJhSBoQdXb5evY3Rg4Cc=;
        b=DzmZ4hOOp0YMA8jB343V12zegbxdCofrCVSY2QqQFxzWEMS9ItEMjA/8hcsmnyr6bj
         4zWZgODCQBWWHisIZ1klt+Ln0cGv4ehICzvQpETlnj/LPoGrXOvn5wkl9GuZao51UtIh
         YsU34RSlQ5yT2ckAtwjhZAVUDH86eadsW5N5FqoJ8zMUI211ZFf0FuCzWYylz/+++Zmy
         aXgaMzQCqtJHf4aWEEgo/XSnMcbXuIQic8UZg0vkRkK906c0GrRoXtEliilYfI0SMe2X
         ccJepGvLPR1wUaha+JJbHXZVJzfnxDWVicYbFmkxsJbD47fc2EL6BGB+d0JDv3muHbft
         00gg==
X-Gm-Message-State: APjAAAVh/aN93oyeFrop8Oq3wMuVmXdJSUN77PvUnDXczTrjJp6tQ1ec
        D76eAcrWIVzkQwilKEAwy2f1SQ==
X-Google-Smtp-Source: APXvYqxahYm7w9C/AAIYcYbrY1/vHicqz99sVruFFdLm+qfCxiAg/w2zKMWIq5IhGN7dLvCQN49sNg==
X-Received: by 2002:a2e:a0c5:: with SMTP id f5mr3903494ljm.114.1569004493847;
        Fri, 20 Sep 2019 11:34:53 -0700 (PDT)
Received: from khorivan (168-200-94-178.pool.ukrtel.net. [178.94.200.168])
        by smtp.gmail.com with ESMTPSA id 77sm603953ljj.84.2019.09.20.11.34.52
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 20 Sep 2019 11:34:53 -0700 (PDT)
Date:   Fri, 20 Sep 2019 21:34:51 +0300
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        Yonghong Song <yhs@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH bpf] libbpf: fix version identification on busybox
Message-ID: <20190920183449.GA2760@khorivan>
Mail-Followup-To: Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, Martin Lau <kafai@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20190919160518.25901-1-ivan.khoronzhuk@linaro.org>
 <CAEf4BzbCjCYr5NMPctDkUggwpehnqZPVBSqZOsd9MvSq6WmnZQ@mail.gmail.com>
 <20190920082204.GC8870@khorivan>
 <CAEf4BzaVuaN3HhMu8W_i9z4n-2zfjqxBXyOEOaQHexxZq7b3qg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAEf4BzaVuaN3HhMu8W_i9z4n-2zfjqxBXyOEOaQHexxZq7b3qg@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 20, 2019 at 09:41:54AM -0700, Andrii Nakryiko wrote:
>On Fri, Sep 20, 2019 at 1:22 AM Ivan Khoronzhuk
><ivan.khoronzhuk@linaro.org> wrote:
>>
>> On Thu, Sep 19, 2019 at 01:02:40PM -0700, Andrii Nakryiko wrote:
>> >On Thu, Sep 19, 2019 at 11:22 AM Ivan Khoronzhuk
>> ><ivan.khoronzhuk@linaro.org> wrote:
>> >>
>> >> It's very often for embedded to have stripped version of sort in
>> >> busybox, when no -V option present. It breaks build natively on target
>> >> board causing recursive loop.
>> >>
>> >> BusyBox v1.24.1 (2019-04-06 04:09:16 UTC) multi-call binary. \
>> >> Usage: sort [-nrugMcszbdfimSTokt] [-o FILE] [-k \
>> >> start[.offset][opts][,end[.offset][opts]] [-t CHAR] [FILE]...
>> >>
>> >> Lets modify command a little to avoid -V option.
>> >>
>> >> Fixes: dadb81d0afe732 ("libbpf: make libbpf.map source of truth for libbpf version")
>> >>
>> >> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
>> >> ---
>> >>
>> >> Based on bpf/master
>> >>
>> >>  tools/lib/bpf/Makefile | 2 +-
>> >>  1 file changed, 1 insertion(+), 1 deletion(-)
>> >>
>> >> diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
>> >> index c6f94cffe06e..a12490ad6215 100644
>> >> --- a/tools/lib/bpf/Makefile
>> >> +++ b/tools/lib/bpf/Makefile
>> >> @@ -3,7 +3,7 @@
>> >>
>> >>  LIBBPF_VERSION := $(shell \
>> >>         grep -oE '^LIBBPF_([0-9.]+)' libbpf.map | \
>> >> -       sort -rV | head -n1 | cut -d'_' -f2)
>> >> +       cut -d'_' -f2 | sort -r | head -n1)
>> >
>> >You can't just sort alphabetically, because:
>> >
>> >1.2
>> >1.11
>> >
>> >should be in that order. See discussion on mailing thread for original commit.
>>
>> if X1.X2.X3, where X = {0,1,....99999}
>> Then it can be:
>>
>> -LIBBPF_VERSION := $(shell \
>> -       grep -oE '^LIBBPF_([0-9.]+)' libbpf.map | \
>> -       sort -rV | head -n1 | cut -d'_' -f2)
>> +_LBPFLIST := $(patsubst %;,%,$(patsubst LIBBPF_%,%,$(filter LIBBPF_%, \
>> +           $(shell cat libbpf.map))))
>> +_LBPFLIST2 := $(foreach v,$(_LBPFLIST), \
>> +               $(subst $() $(),,$(foreach n,$(subst .,$() $(),$(v)), \
>> +                       $(shell printf "%05d" $(n)))))
>> +_LBPF_VER := $(word $(words $(sort $(_LBPFLIST2))), $(sort $(_LBPFLIST2)))
>> +LIBBPF_VERSION := $(patsubst %_$(_LBPF_VER),%,$(filter %_$(_LBPF_VER), \
>> +        $(join $(addsuffix _, $(_LBPFLIST)),$(_LBPFLIST2))))
>>
>> It's bigger but avoids invocations of grep/sort/cut/head, only cat/printf
>> , thus -V option also.
>>
>
>No way, this is way too ugly (and still unreliable, if we ever have
>X.Y.Z.W or something). I'd rather go with my original approach of
Yes, forgot to add
X1,X2,X3,...XN, where X = {0,1,....99999} and N = const for all versions.
But frankly, 1.0.0 looks too far.

>fetching the last version in libbpf.map file. See
>https://www.spinics.net/lists/netdev/msg592703.html.
>
>> >
>> >>  LIBBPF_MAJOR_VERSION := $(firstword $(subst ., ,$(LIBBPF_VERSION)))
>> >>
>> >>  MAKEFLAGS += --no-print-directory
>> >> --
>> >> 2.17.1
>> >>
>>
>> --
>> Regards,
>> Ivan Khoronzhuk

-- 
Regards,
Ivan Khoronzhuk
