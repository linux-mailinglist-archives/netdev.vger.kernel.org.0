Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58E34B97B1
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 21:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726020AbfITTTt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 15:19:49 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:34805 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725820AbfITTTs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Sep 2019 15:19:48 -0400
Received: by mail-lf1-f65.google.com with SMTP id r22so5811879lfm.1
        for <netdev@vger.kernel.org>; Fri, 20 Sep 2019 12:19:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=gAf5/sB7eVKKCWdFTMcwGWL/j6LnoBpK44/vlo0WiMQ=;
        b=NyQh7krmksMSqLjhbOuyr7tfCNP1fZenF74Msk2i++P30Qbuykdt+Q1A71lKdxENKv
         OEc9HIw+zjJ74wmyn6FutxYjkJcMiHKVLyB4VdN+bnrB3FQFrk4So4762SNbwqs7tCHL
         mI2ATbVm4eAB9BtUngciQnhIRe8j3cr1ZHiNYVeSHP37Xl9c/MtEd4EMN0InI0y0WfZt
         XfvqO5frv2lFyPji0FqeJ5HZcshgJ0u+EbRZmqEW93VVLlivJpIQQE1lix26BG+ct0ha
         kra4S+lczs+Vqp9BB49taJWQ3aphd/bsG4dGhR6D0Jti1j5gXWLVXHsRrAXNVohyn535
         MEDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=gAf5/sB7eVKKCWdFTMcwGWL/j6LnoBpK44/vlo0WiMQ=;
        b=q0uUNYGcCtuQnp6a8NGoPP3HnLGqYuhGUChtDf9FvF0CS6rrZWfXSTqeclOF9buh6c
         jEIz8xw9sR42jGU1Hrew0CyMR0w8z413D0p0KUfFJ3eKT1I1e/qWNcROXPkb1KI0pzAR
         gppebFUcOSHsUSA/Pe9HINCZg3izxY9KSHFPDZOezf5+45GGRXSaz8NOx05Fsxv7zlX/
         YL8QHhlA1iqJpfCeAit6tbMnbzDXk85TeF/JINYwoB9idQOHLZv6tX+0yjvv6i7WHE9+
         6M+6sjg4wLj/hThP9ZxfrMcidH+6RxwPAZrDJEfsru0sdQVtEtIc1GAFl6j0CHT4Ze8W
         AAUQ==
X-Gm-Message-State: APjAAAWogDfrMpVJ1onuFsVHU7v+05KEUPkyX8L8o/hUKKAeDL5CnTog
        143QeDC+1TYFhhhY+LYQpskh+Q==
X-Google-Smtp-Source: APXvYqyTX2Yv4Vw1igMUKohBkWPQHWgNronoDQHDya9V4EfROzBLILxLNetkOgRt2M2JAv0Eu7uvQQ==
X-Received: by 2002:a19:48c3:: with SMTP id v186mr9701393lfa.141.1569007185986;
        Fri, 20 Sep 2019 12:19:45 -0700 (PDT)
Received: from khorivan (168-200-94-178.pool.ukrtel.net. [178.94.200.168])
        by smtp.gmail.com with ESMTPSA id v1sm625867lfq.89.2019.09.20.12.19.44
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 20 Sep 2019 12:19:45 -0700 (PDT)
Date:   Fri, 20 Sep 2019 22:19:43 +0300
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        Yonghong Song <yhs@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH bpf] libbpf: fix version identification on busybox
Message-ID: <20190920191941.GB2760@khorivan>
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
 <20190920183449.GA2760@khorivan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190920183449.GA2760@khorivan>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 20, 2019 at 09:34:51PM +0300, Ivan Khoronzhuk wrote:
>On Fri, Sep 20, 2019 at 09:41:54AM -0700, Andrii Nakryiko wrote:
>>On Fri, Sep 20, 2019 at 1:22 AM Ivan Khoronzhuk
>><ivan.khoronzhuk@linaro.org> wrote:
>>>
>>>On Thu, Sep 19, 2019 at 01:02:40PM -0700, Andrii Nakryiko wrote:
>>>>On Thu, Sep 19, 2019 at 11:22 AM Ivan Khoronzhuk
>>>><ivan.khoronzhuk@linaro.org> wrote:
>>>>>
>>>>> It's very often for embedded to have stripped version of sort in
>>>>> busybox, when no -V option present. It breaks build natively on target
>>>>> board causing recursive loop.
>>>>>
>>>>> BusyBox v1.24.1 (2019-04-06 04:09:16 UTC) multi-call binary. \
>>>>> Usage: sort [-nrugMcszbdfimSTokt] [-o FILE] [-k \
>>>>> start[.offset][opts][,end[.offset][opts]] [-t CHAR] [FILE]...
>>>>>
>>>>> Lets modify command a little to avoid -V option.
>>>>>
>>>>> Fixes: dadb81d0afe732 ("libbpf: make libbpf.map source of truth for libbpf version")
>>>>>
>>>>> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
>>>>> ---
>>>>>
>>>>> Based on bpf/master
>>>>>
>>>>>  tools/lib/bpf/Makefile | 2 +-
>>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
>>>>> index c6f94cffe06e..a12490ad6215 100644
>>>>> --- a/tools/lib/bpf/Makefile
>>>>> +++ b/tools/lib/bpf/Makefile
>>>>> @@ -3,7 +3,7 @@
>>>>>
>>>>>  LIBBPF_VERSION := $(shell \
>>>>>         grep -oE '^LIBBPF_([0-9.]+)' libbpf.map | \
>>>>> -       sort -rV | head -n1 | cut -d'_' -f2)
>>>>> +       cut -d'_' -f2 | sort -r | head -n1)
>>>>
>>>>You can't just sort alphabetically, because:
>>>>
>>>>1.2
>>>>1.11
>>>>
>>>>should be in that order. See discussion on mailing thread for original commit.
>>>
>>>if X1.X2.X3, where X = {0,1,....99999}
>>>Then it can be:
>>>
>>>-LIBBPF_VERSION := $(shell \
>>>-       grep -oE '^LIBBPF_([0-9.]+)' libbpf.map | \
>>>-       sort -rV | head -n1 | cut -d'_' -f2)
>>>+_LBPFLIST := $(patsubst %;,%,$(patsubst LIBBPF_%,%,$(filter LIBBPF_%, \
>>>+           $(shell cat libbpf.map))))
>>>+_LBPFLIST2 := $(foreach v,$(_LBPFLIST), \
>>>+               $(subst $() $(),,$(foreach n,$(subst .,$() $(),$(v)), \
>>>+                       $(shell printf "%05d" $(n)))))
>>>+_LBPF_VER := $(word $(words $(sort $(_LBPFLIST2))), $(sort $(_LBPFLIST2)))
>>>+LIBBPF_VERSION := $(patsubst %_$(_LBPF_VER),%,$(filter %_$(_LBPF_VER), \
>>>+        $(join $(addsuffix _, $(_LBPFLIST)),$(_LBPFLIST2))))
>>>
>>>It's bigger but avoids invocations of grep/sort/cut/head, only cat/printf
>>>, thus -V option also.
>>>
>>
>>No way, this is way too ugly (and still unreliable, if we ever have
>>X.Y.Z.W or something). I'd rather go with my original approach of
>Yes, forgot to add
>X1,X2,X3,...XN, where X = {0,1,....99999} and N = const for all versions.
>But frankly, 1.0.0 looks too far.

It actually works for any numbs of X1.X2...X100
but not when you have couple kindof:
X1.X2.X3
and
X1.X2.X3.X4

But, no absolutely any problem to extend this solution to handle all cases,
by just adding leading 0 to every "transformed version", say limit it to 10
possible 'dots' (%5*10d) and it will work as clocks. Advantage - mostly make
functions.

Here can be couple more solutions with sed, not sure it can look less maniac.

>
>>fetching the last version in libbpf.map file. See
>>https://www.spinics.net/lists/netdev/msg592703.html.

Yes it's nice but, no sort, no X1.X2.X3....XN

Main is to solve it for a long time.

>>
>>>>
>>>>>  LIBBPF_MAJOR_VERSION := $(firstword $(subst ., ,$(LIBBPF_VERSION)))
>>>>>
>>>>>  MAKEFLAGS += --no-print-directory
>>>>> --
>>>>> 2.17.1
>>>>>
>>>
>>>--
>>>Regards,
>>>Ivan Khoronzhuk
>
>-- 
>Regards,
>Ivan Khoronzhuk

-- 
Regards,
Ivan Khoronzhuk
