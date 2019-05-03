Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B970613293
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 18:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728545AbfECQyv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 12:54:51 -0400
Received: from mail-wm1-f41.google.com ([209.85.128.41]:52200 "EHLO
        mail-wm1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726444AbfECQyv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 12:54:51 -0400
Received: by mail-wm1-f41.google.com with SMTP id t76so7922664wmt.1
        for <netdev@vger.kernel.org>; Fri, 03 May 2019 09:54:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=to:references:from:openpgp:autocrypt:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PBkCo7H43paaF58OJbFhZqz3qqkLvI0mr2OE6GZuuYs=;
        b=GN6mWva+AUxMSOiu241GRHrFYnAVMooxsf3mzFMoHtTfpHshn0NP9Xz2+VIypYokT9
         MVQwBaksQjPLMQOL3QSRPXneYrCYKAGwZM+d1aBJ7wGze/targIjhJSWkN5x9ejjBo/1
         jFUUe4cOlgCrpF0tkF3dvDgqmK/DwaP71olEt9UavGDUzZHyLVVjkG5EYMoUcHcGdsOr
         T+gsofy3rWnelnANgMnMCQvMyBa5AStj8GFq4gMdhs+Ra0jje2otZuRDhoVWPkaeOzWU
         LKFbT2+QJuPD07NfbMqmdP4+CTfdxTa4vXX+uu/LtKl++YLfQZ0+5yAcdSmJKNwXL9NB
         rErw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:openpgp:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=PBkCo7H43paaF58OJbFhZqz3qqkLvI0mr2OE6GZuuYs=;
        b=NVRDepL7oz2cBHY2eE1XOpTmFBexM4556upspCkCKTQM33/TrKUuozL3vprtlbf9eR
         EsoZO54+Y5wIdSIUODxa4SMkkdeS10OXdZNwq1D0zAW0MoBI+Jb+j1qmFQ6JwvOBrbe1
         xDeZqlJ08UBQUhmNLiZQx7NJvgernTKAODkj9YUYy14luXRhZepDcBkJcFRR70OjwfOu
         Q0VU9yLguKoj1XX2uS1hNw/Iv2WtVnvgxGkV9+0hBiaKAz7Z541QUf8wOqBzFZdo98PC
         qgLh8JfONHEiaLvzsur8p4RfdswqTF+QwaTt6LN6tPSEcxkYEjHIUWWTuA8Kdm4Ei0FW
         XYhg==
X-Gm-Message-State: APjAAAVs6lDF/sYQXAb9VmD12800JYw/HkjhYgUW/W042zfIZm8iEnpX
        Oqwl+gUZWNjZjoGNzwR/W/BCaw==
X-Google-Smtp-Source: APXvYqw5nBScjcDcgSupylbNoYWeIx0Px3OWG+q3+nw8+w/eB/Adv9cEepIRskv5tO2naWLHb0bFhg==
X-Received: by 2002:a1c:304:: with SMTP id 4mr4726704wmd.39.1556902488523;
        Fri, 03 May 2019 09:54:48 -0700 (PDT)
Received: from [172.20.1.104] ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id v9sm3847834wrg.20.2019.05.03.09.54.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 May 2019 09:54:47 -0700 (PDT)
To:     Yonghong Song <yhs@fb.com>, netdev <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>
References: <d84c162f-9ccf-18f5-6d99-d7c88eb61a89@fb.com>
From:   Quentin Monnet <quentin.monnet@netronome.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quentin.monnet@netronome.com; prefer-encrypt=mutual; keydata=
 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
 RHhSHGnKaQ6MfrTge5Q0h5A=
Subject: Re: bpftool doc man page build failure
Message-ID: <1a2c2f20-ede9-61ae-564a-d44843983f73@netronome.com>
Date:   Fri, 3 May 2019 17:54:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <d84c162f-9ccf-18f5-6d99-d7c88eb61a89@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2019-05-03 16:21 UTC+0000 ~ Yonghong Song <yhs@fb.com>
> Quentin,
> 
> I hit the following errors with latest bpf-next.
> 
> -bash-4.4$ make man
>    GEN      bpftool-perf.8
>    GEN      bpftool-map.8
>    GEN      bpftool.8
>    GEN      bpftool-net.8
>    GEN      bpftool-feature.8
>    GEN      bpftool-prog.8
>    GEN      bpftool-cgroup.8
>    GEN      bpftool-btf.8
>    GEN      bpf-helpers.rst
> Parsed description of 111 helper function(s)
> Traceback (most recent call last):
>    File "../../../../scripts/bpf_helpers_doc.py", line 421, in <module>
>      printer.print_all()
>    File "../../../../scripts/bpf_helpers_doc.py", line 187, in print_all
>      self.print_one(helper)
>    File "../../../../scripts/bpf_helpers_doc.py", line 378, in print_one
>      self.print_proto(helper)
>    File "../../../../scripts/bpf_helpers_doc.py", line 356, in print_proto
>      proto = helper.proto_break_down()
>    File "../../../../scripts/bpf_helpers_doc.py", line 56, in 
> proto_break_down
>      'type' : capture.group(1),
> AttributeError: 'NoneType' object has no attribute 'group'
> make: *** [bpf-helpers.rst] Error 1
> -bash-4.4$ pwd
> /home/yhs/work/net-next/tools/bpf/bpftool/Documentation
> -bash-4.4$
> 
> Maybe a format issue in the comments with some recent helpers?
> 
> Thanks,
> 
> Yonghong
> 

Hi Yonghong,

Thanks for the notice! Yes, I observed the same thing not long ago. It
seems that the Python script breaks on the "unsigned long" pointer
argument for strtoul(): the script only accepts "const" or "struct" for
types made of several words, not "unsigned".

I'll fix the script so it can take any word and send a patch next week,
along with some other clean-up fixes for the doc.

Best regards,
Quentin
