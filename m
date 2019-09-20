Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70D5DB98A3
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 22:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387534AbfITUse (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 16:48:34 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:43477 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387479AbfITUsd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Sep 2019 16:48:33 -0400
Received: by mail-lj1-f193.google.com with SMTP id n14so3282587ljj.10
        for <netdev@vger.kernel.org>; Fri, 20 Sep 2019 13:48:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=T8An8FHblE+kDgtVFHSjYWnPaCBxTzDv21Ur6auB05g=;
        b=qG1PAZcUe75GcJB6L6hYulpGLwTWOINwYP/XeLJ2PZIWPE6tjn1V6g7SGVJ9mA7BWp
         fSIPDrfKR8KVHg/ApCo7JRdi8DMZrx+ieKnZWjvqiSC3rJIRq4u5end22mYU5trW1kX1
         Av+5sj+GOgzHMDlET8a33+HOP1glQl3smTYMOdQH4K6GdEo6aoUB1mAownQ2PUlGaWIo
         t2bO+/4d4AKV0AH2vKbT+aZ6qHkz7ZDdgiYmGh3XpzevEHUbvy8aGAxF4Bu1/H1xBuDX
         K4+mzsERfl1RWb06AOCtL+IsN4bXKUDlUUAV/SJOIKdF/tnITfxBKXgfZauS4xC6qQ3R
         5OQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=T8An8FHblE+kDgtVFHSjYWnPaCBxTzDv21Ur6auB05g=;
        b=uf9jhSFkHhsaTnEvlZWzI2P68/I2LdOIS8TBbmy7oqJ8nKYlOp0CwAkVbUm5GUKb8D
         PAPCVIPgaRwtS0DdDRq5pe97IpgsyF8ZnyhNqZ7grg4uvHRzKfXVlLdXsrMAW7a3uBSV
         95aBDXJ4qBDUg8JmpOPubsadK4Yt5cwi8Mq4UpurMALT+km997rC3meltK0TWcoY86Pq
         OwwClHit13dwH6z62ofqpI8eFu7WrhWD754j75PkQlbAWpoCtaDNekzmrCBfJD1o2pVj
         zUZ+gP1yKY9SryQiDLfTKrnaEsv5mCXOQED1imamO35yDCeCNyHlH5M5K/sJC4TzQKBQ
         GRxQ==
X-Gm-Message-State: APjAAAVIwOx4CEKjMvp6bay/iXPaNo3XrlWncPsykmmmN3eQUJIrbV53
        CJab5QhOBxcoOlUvw75sOYoB9g==
X-Google-Smtp-Source: APXvYqy8VIN09R+o3Z1mR5K3A3l3pyiz4qCgKb3vi3Nj3ujVAVqCg6y44oj3hY0kLJtMZK7tP2l7nA==
X-Received: by 2002:a2e:9081:: with SMTP id l1mr10283633ljg.33.1569012508896;
        Fri, 20 Sep 2019 13:48:28 -0700 (PDT)
Received: from khorivan (168-200-94-178.pool.ukrtel.net. [178.94.200.168])
        by smtp.gmail.com with ESMTPSA id e21sm714873lfj.10.2019.09.20.13.48.27
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 20 Sep 2019 13:48:28 -0700 (PDT)
Date:   Fri, 20 Sep 2019 23:48:26 +0300
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        Yonghong Song <yhs@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH bpf] libbpf: fix version identification on busybox
Message-ID: <20190920204824.GC2760@khorivan>
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
 <20190920191941.GB2760@khorivan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190920191941.GB2760@khorivan>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 20, 2019 at 10:19:43PM +0300, Ivan Khoronzhuk wrote:
>On Fri, Sep 20, 2019 at 09:34:51PM +0300, Ivan Khoronzhuk wrote:
>>On Fri, Sep 20, 2019 at 09:41:54AM -0700, Andrii Nakryiko wrote:
>>>On Fri, Sep 20, 2019 at 1:22 AM Ivan Khoronzhuk
>>><ivan.khoronzhuk@linaro.org> wrote:
>>>>
>>>>On Thu, Sep 19, 2019 at 01:02:40PM -0700, Andrii Nakryiko wrote:
>>>>>On Thu, Sep 19, 2019 at 11:22 AM Ivan Khoronzhuk
>>>>><ivan.khoronzhuk@linaro.org> wrote:
>>>>>>
>>>>>>It's very often for embedded to have stripped version of sort in
>>>>>>busybox, when no -V option present. It breaks build natively on target
>>>>>>board causing recursive loop.
>>>>>>
>>>>>>BusyBox v1.24.1 (2019-04-06 04:09:16 UTC) multi-call binary. \
>>>>>>Usage: sort [-nrugMcszbdfimSTokt] [-o FILE] [-k \
>>>>>>start[.offset][opts][,end[.offset][opts]] [-t CHAR] [FILE]...
>>>>>>
>>>>>>Lets modify command a little to avoid -V option.
>>>>>>
>>>>>>Fixes: dadb81d0afe732 ("libbpf: make libbpf.map source of truth for libbpf version")
>>>>>>
>>>>>>Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
>>>>>>---
>>>>>>
>>>>>>Based on bpf/master
>>>>>>
>>>>>> tools/lib/bpf/Makefile | 2 +-
>>>>>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>>
>>>>>>diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
>>>>>>index c6f94cffe06e..a12490ad6215 100644
>>>>>>--- a/tools/lib/bpf/Makefile
>>>>>>+++ b/tools/lib/bpf/Makefile
>>>>>>@@ -3,7 +3,7 @@
>>>>>>
>>>>>> LIBBPF_VERSION := $(shell \
>>>>>>        grep -oE '^LIBBPF_([0-9.]+)' libbpf.map | \
>>>>>>-       sort -rV | head -n1 | cut -d'_' -f2)
>>>>>>+       cut -d'_' -f2 | sort -r | head -n1)
>>>>>
>>>>>You can't just sort alphabetically, because:
>>>>>
>>>>>1.2
>>>>>1.11
>>>>>
>>>>>should be in that order. See discussion on mailing thread for original commit.
>>>>
>>>>if X1.X2.X3, where X = {0,1,....99999}
>>>>Then it can be:
>>>>
>>>>-LIBBPF_VERSION := $(shell \
>>>>-       grep -oE '^LIBBPF_([0-9.]+)' libbpf.map | \
>>>>-       sort -rV | head -n1 | cut -d'_' -f2)
>>>>+_LBPFLIST := $(patsubst %;,%,$(patsubst LIBBPF_%,%,$(filter LIBBPF_%, \
>>>>+           $(shell cat libbpf.map))))
>>>>+_LBPFLIST2 := $(foreach v,$(_LBPFLIST), \
>>>>+               $(subst $() $(),,$(foreach n,$(subst .,$() $(),$(v)), \
>>>>+                       $(shell printf "%05d" $(n)))))
>>>>+_LBPF_VER := $(word $(words $(sort $(_LBPFLIST2))), $(sort $(_LBPFLIST2)))
>>>>+LIBBPF_VERSION := $(patsubst %_$(_LBPF_VER),%,$(filter %_$(_LBPF_VER), \
>>>>+        $(join $(addsuffix _, $(_LBPFLIST)),$(_LBPFLIST2))))
>>>>
>>>>It's bigger but avoids invocations of grep/sort/cut/head, only cat/printf
>>>>, thus -V option also.
>>>>
>>>
>>>No way, this is way too ugly (and still unreliable, if we ever have
>>>X.Y.Z.W or something). I'd rather go with my original approach of
>>Yes, forgot to add
>>X1,X2,X3,...XN, where X = {0,1,....99999} and N = const for all versions.
>>But frankly, 1.0.0 looks too far.
>
>It actually works for any numbs of X1.X2...X100
>but not when you have couple kindof:
>X1.X2.X3
>and
>X1.X2.X3.X4
>
>But, no absolutely any problem to extend this solution to handle all cases,
>by just adding leading 0 to every "transformed version", say limit it to 10
>possible 'dots' (%5*10d) and it will work as clocks. Advantage - mostly make
>functions.

_LBPFLIST := $(subst ;,,$(patsubst LIBBPF_%,%,$(filter LIBBPF_%, \
	     $(shell cat libbpf.map))))
_LBPF2 := $(foreach v,$(_LBPFLIST), \
	  $(subst $() $(),,$(foreach n,$(subst ., ,$(v)), \
			$(shell printf "%05d" $(n)))))
_LBPF2 := $(foreach v,$(_LBPF2), $(shell printf "%050s" $(v)))
_LBPF_VER := $(word $(words $(sort $(_LBPF2))), $(sort $(_LBPF2)))
LIBBPF_VERSION := $(patsubst %_$(_LBPF_VER),%,$(filter %_$(_LBPF_VER), \
	 	  $(join $(addsuffix _, $(_LBPFLIST)),$(_LBPF2))))
>
>Here can be couple more solutions with sed, not sure it can look less maniac.
>
>>
>>>fetching the last version in libbpf.map file. See
>>>https://www.spinics.net/lists/netdev/msg592703.html.
>
>Yes it's nice but, no sort, no X1.X2.X3....XN
>
>Main is to solve it for a long time.
>
>>>
>>>>>
>>>>>> LIBBPF_MAJOR_VERSION := $(firstword $(subst ., ,$(LIBBPF_VERSION)))
>>>>>>
>>>>>> MAKEFLAGS += --no-print-directory
>>>>>>--
>>>>>>2.17.1
>>>>>>
>>>>
>>>>--
>>>>Regards,
>>>>Ivan Khoronzhuk
>>
>>-- 
>>Regards,
>>Ivan Khoronzhuk
>
>-- 
>Regards,
>Ivan Khoronzhuk

-- 
Regards,
Ivan Khoronzhuk
