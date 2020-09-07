Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DACA225FDA5
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 17:54:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730241AbgIGPyJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 11:54:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730016AbgIGOu5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 10:50:57 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49668C061756
        for <netdev@vger.kernel.org>; Mon,  7 Sep 2020 07:50:56 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id x14so16048228wrl.12
        for <netdev@vger.kernel.org>; Mon, 07 Sep 2020 07:50:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0efjPxCDKomGI0/nUwwa7TQGZtId6W3ZUv6w3XZV+hE=;
        b=xsdev9nbMkRlmNr/eeDnTiPl/v7JZcHFgv47jTNSAmo8Hz8hfc9Wqh/JgLe0MF7BId
         rtEcyoviBrODTlbSsLX0LZDKg82AB2Wz+CP+MLtbEji1lsulsVe6FtW2ZltxGs1Hc0hJ
         QdyNVazdLRKbmV4OYlHyEbA3FSlLmEuU+6JoOTcFGcjZ1MZAfU/YNhWbrIterRh/igXS
         NyBbpVxbL3ciMa5/+t3q9mJNcYE8LdJsukNMna9jZT1DAS6CRNU9i4yO+Yb/2Wp77TQz
         goH3h0vpNjdqqgEftU4GVVtiy8LVK+wYrNOj+OlcwJopZzqUHLB2bha337FjDO6Zmaoh
         tLqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0efjPxCDKomGI0/nUwwa7TQGZtId6W3ZUv6w3XZV+hE=;
        b=RX4yn7TUAj37BtimU3rQBCqSXqFxQeAatc1m18G7CWnFmYr0gRq2AqZoaxEdh44FyM
         3KSS/j/+Bg2/aGyQCJJjAzE6F4AOJdh2pauO0cOLKEuDVUjqPeOYzIm4Kb41UBY58gyF
         vzRCQow14fLk8+inXlJS2VSKWD461qpvUaKTRgyUi7bSSFoBocXR5KIZpe7Mz65QqwxU
         zfXk3C5nM9uK5ZUQiR6HrE7MQMKfY5ESs0YqOOY9tRhwP72dxy9ofSiTDsD5tRVUkXAb
         HQmUNEUEXjC3Ge4z+jBqZxBLL2AXDeHt/DoHfxzcnBXFjYdAQatJAIj76BDGXo6OnLBp
         PnGg==
X-Gm-Message-State: AOAM531U1by5+eh0U7yU7KxRZTk+pD6wK4fnakaQ7qLBgFN2jhPC8G0u
        b8m5f0HW/wRPv5bBdB+X8aGSz4f4WgeXLEr8
X-Google-Smtp-Source: ABdhPJwLb6o8fjUsxJqWJoTBQd59XIeABb8CkMwR3OcTxT9ikPrgctFH/VIDidsmYJdlc4ABBTR6QA==
X-Received: by 2002:adf:9f10:: with SMTP id l16mr23581731wrf.77.1599490254717;
        Mon, 07 Sep 2020 07:50:54 -0700 (PDT)
Received: from [192.168.1.12] ([194.35.119.8])
        by smtp.gmail.com with ESMTPSA id h17sm24040166wro.27.2020.09.07.07.50.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Sep 2020 07:50:54 -0700 (PDT)
Subject: Re: [PATCH bpf-next 3/3] tools: bpftool: automate generation for "SEE
 ALSO" sections in man pages
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>
References: <20200904205657.27922-1-quentin@isovalent.com>
 <20200904205657.27922-4-quentin@isovalent.com>
 <CAEf4BzYFDi2w5mbu1Dgb6aTR2HsAXDs0=QbfUc-hwCHngKsaCg@mail.gmail.com>
From:   Quentin Monnet <quentin@isovalent.com>
Message-ID: <ca595fd6-e807-ac8e-f15f-68bfc7b7dbc4@isovalent.com>
Date:   Mon, 7 Sep 2020 15:50:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <CAEf4BzYFDi2w5mbu1Dgb6aTR2HsAXDs0=QbfUc-hwCHngKsaCg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/09/2020 22:51, Andrii Nakryiko wrote:
> On Fri, Sep 4, 2020 at 1:58 PM Quentin Monnet <quentin@isovalent.com> wrote:
>>
>> The "SEE ALSO" sections of bpftool's manual pages refer to bpf(2),
>> bpf-helpers(7), then all existing bpftool man pages (save the current
>> one).
>>
>> This leads to nearly-identical lists being duplicated in all manual
>> pages. Ideally, when a new page is created, all lists should be updated
>> accordingly, but this has led to omissions and inconsistencies multiple
>> times in the past.
>>
>> Let's take it out of the RST files and generate the "SEE ALSO" sections
>> automatically in the Makefile when generating the man pages. The lists
>> are not really useful in the RST anyway because all other pages are
>> available in the same directory.
>>
>> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
>> ---
> 
> Acked-by: Andrii Nakryiko <andriin@fb.com>
> 
> but see note about printf and format string below

Thanks!

>> diff --git a/tools/bpf/bpftool/Documentation/Makefile b/tools/bpf/bpftool/Documentation/Makefile
>> index becbb8c52257..86233619215c 100644
>> --- a/tools/bpf/bpftool/Documentation/Makefile
>> +++ b/tools/bpf/bpftool/Documentation/Makefile
>> @@ -29,11 +29,21 @@ man8: $(DOC_MAN8)
>>
>>  RST2MAN_DEP := $(shell command -v rst2man 2>/dev/null)
>>
>> +list_pages = $(sort $(basename $(filter-out $(1),$(MAN8_RST))))
>> +see_also = $(subst " ",, \
>> +       "\n" \
>> +       "SEE ALSO\n" \
>> +       "========\n" \
>> +       "\t**bpf**\ (2),\n" \
>> +       "\t**bpf-helpers**\\ (7)" \
>> +       $(foreach page,$(call list_pages,$(1)),",\n\t**$(page)**\\ (8)") \
>> +       "\n")
>> +
>>  $(OUTPUT)%.8: %.rst
>>  ifndef RST2MAN_DEP
>>         $(error "rst2man not found, but required to generate man pages")
>>  endif
>> -       $(QUIET_GEN)rst2man $< > $@
>> +       $(QUIET_GEN)( cat $< ; printf $(call see_also,$<) ) | rst2man > $@
> 
> a bit dangerous to pass string directly as a format string due to %
> interpretation. Did you try echo -e "...\n..." ?

I believe printf is supposed to be more portable, this is why I used it.
It seems unlikely we end up with a percent sign in a bpftool man page
name, but I can switch to "echo -e" for v2.

Quentin
