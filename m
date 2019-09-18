Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC49B6156
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 12:23:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729471AbfIRKXI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 06:23:08 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:33096 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727687AbfIRKXI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 06:23:08 -0400
Received: by mail-lf1-f66.google.com with SMTP id y127so5318610lfc.0
        for <netdev@vger.kernel.org>; Wed, 18 Sep 2019 03:23:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=fVR7WsKZT5heVux6OOhTNN5qN9Wk5lAWV1vo95u5Gr0=;
        b=Y5GBajLiMRbH/tuOHEBJvgYOb5SWPminhxoMUY69MsCfGM5r0xIm6Ikqje9sxOendn
         tdPVPYzb9qFisuw1tsor9oEfooOu33xZjMzzTjqw5xlPejP8lTovz/Y9QgvDAGiXbD5g
         LUamOcDj0jAoSLteYIE+uEzSJPyUazE+b8FlFAjwivlQFnBzUf3h6/sM2MEMZiqj5in6
         lKTphQZcEWAnzjawl6Aj9zY4GZUT5YQaYGSWT+quiiskZS/xx4dbZgRw4uDeN1kpJwfE
         WD1C1bCk+z/2QU5cWDBUTNLovP0E0/w/HlsZwYjfRLedw80G+Ue9YebLZxOTQ3hvmeiA
         Vcpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=fVR7WsKZT5heVux6OOhTNN5qN9Wk5lAWV1vo95u5Gr0=;
        b=ITyualCIN+jPYIPes7DpMVRqRb0MmK1sAg72xxmEKjqM6Pjx230H5rTZEMBHtGXcqi
         iv8/bg69xyC0dnO+POId6FL4GnGz8Z7dunkIPWv8ADKhkhzVfqBotMfTR2Sal65Z/A8m
         qOT4pRsL/BoXWfUxQajrQPCvhwUOd2nCJbrccXLJxv8g4AkEe1pIvzcIg0w8vTH/0888
         0z6xdmXsO0lkpp4zaC1eEhzNF4KGdhdCFoA59B7yXe1PKJIm2TRNlMiA/c/k8S6j1aiP
         Wf+i8F2JdqO27YxwhZWq8JqMSCDMfzWyQV4zkkwS098hhozAwfL3c2p8Nj6q2+Dhuz5C
         2o6Q==
X-Gm-Message-State: APjAAAUJigKSXIr0kRFQv20MWtZG0qgGfzs35tDwRMC6nmzUAHkIkSkr
        dksqGeTB/xI+clIsrfdt6GDAdA==
X-Google-Smtp-Source: APXvYqz4gDimKURT0PWwEBQXLEtgkrosCtJcqwr5kRYavpJm1msXefaCnraptiyROoAqurD5dtoidA==
X-Received: by 2002:a19:7d55:: with SMTP id y82mr1737621lfc.106.1568802186400;
        Wed, 18 Sep 2019 03:23:06 -0700 (PDT)
Received: from khorivan (168-200-94-178.pool.ukrtel.net. [178.94.200.168])
        by smtp.gmail.com with ESMTPSA id y22sm936629lfb.75.2019.09.18.03.23.04
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 18 Sep 2019 03:23:05 -0700 (PDT)
Date:   Wed, 18 Sep 2019 13:23:03 +0300
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        clang-built-linux@googlegroups.com,
        sergei.shtylyov@cogentembedded.com
Subject: Re: [PATCH v3 bpf-next 08/14] samples: bpf: makefile: base target
 programs rules on Makefile.target
Message-ID: <20190918102301.GB2908@khorivan>
Mail-Followup-To: Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        clang-built-linux@googlegroups.com,
        sergei.shtylyov@cogentembedded.com
References: <20190916105433.11404-1-ivan.khoronzhuk@linaro.org>
 <20190916105433.11404-9-ivan.khoronzhuk@linaro.org>
 <CAEf4BzYFoJJk+WM51YT7NwCxQpy117DAMmgiJ1YbqaW9UUWpEg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAEf4BzYFoJJk+WM51YT7NwCxQpy117DAMmgiJ1YbqaW9UUWpEg@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 17, 2019 at 04:28:01PM -0700, Andrii Nakryiko wrote:
>On Mon, Sep 16, 2019 at 3:58 AM Ivan Khoronzhuk
><ivan.khoronzhuk@linaro.org> wrote:
>>
>
>Please don't prepend "samples: bpf: makefile:" to patches,
>"samples/bpf: " is a typical we've used for BPF samples changes.
Ok.

>
>
>> The main reason for that - HOSTCC and CC have different aims.
>> HOSTCC is used to build programs running on host, that can
>> cross-comple target programs with CC. It was tested for arm and arm64
>> cross compilation, based on linaro toolchain, but should work for
>> others.
>>
>> So, in order to split cross compilation (CC) with host build (HOSTCC),
>> lets base samples on Makefile.target. It allows to cross-compile
>> samples/bpf programs with CC while auxialry tools running on host
>> built with HOSTCC.
>>
>> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
>> ---
>>  samples/bpf/Makefile | 135 ++++++++++++++++++++++---------------------
>>  1 file changed, 69 insertions(+), 66 deletions(-)
>>
>> diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
>> index 9d923546e087..1579cc16a1c2 100644
>> --- a/samples/bpf/Makefile
>> +++ b/samples/bpf/Makefile
>> @@ -4,55 +4,53 @@ BPF_SAMPLES_PATH ?= $(abspath $(srctree)/$(src))
>>  TOOLS_PATH := $(BPF_SAMPLES_PATH)/../../tools
>>
>>  # List of programs to build
>> -hostprogs-y := test_lru_dist
[...]
>> -KBUILD_HOSTCFLAGS := $(ARM_ARCH_SELECTOR)
>> +TPROGS_CFLAGS += $(ARM_ARCH_SELECTOR)
>>  endif
>>
>> +TPROGS_LDLIBS := $(KBUILD_HOSTLDLIBS)
>
>Please group TPROGS_LDLIBS definition together with the one below,
>there doesn't seem to be a reason to split them this way.
No. It's used in Makefile.target and should be here, following hostprog logic.

>
>But also, it's kind of weird to use host libraries as cross-compiled
>libraries as well. Is that intentional?
No cross-compile split yet. This patch replace only KBUILD on TPROGS.
It's done in following patches.

>
>> +TPROGS_CFLAGS += $(KBUILD_HOSTCFLAGS) $(HOST_EXTRACFLAGS)
>
>Same here, is it right to use HOSTCFLAGS and HOST_EXTRACFLAGS as a
>base for cross-compiled cflags?
same

[...]

-- 
Regards,
Ivan Khoronzhuk
