Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1120C29510
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 11:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390098AbfEXJq7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 05:46:59 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53004 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389582AbfEXJq7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 05:46:59 -0400
Received: by mail-wm1-f66.google.com with SMTP id y3so8694865wmm.2
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 02:46:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mkCiLlrSzhAV2CD8PHBGktrJShCBHx4vJYh2M4ZW7p0=;
        b=cAo+rRhTZq9z2qCSV3cQYDh9UM2ZnNYvDfhK0Kemyke+xwh4upPOy7Gi2YbHvgRG2A
         1E8cx1fBBr0UJLmRLJ2Xvb3pIJeNgPwBDR9oWko192PapCUgWMVeADq1JRe4QfdT25mR
         prJxVgI/9mEw2NVr3Hwzw/FoS1WYbB7TeyiBmZxJLqyTnFu+HX9gyvgWdxUsHL2JJm6R
         S6Z/VWMfUAgBKn23chrdO4JLXbJgxMY3xzDpORETxigyn4qcjoEdHKhYAHOCv7Rj44sZ
         9O3eRRVqRIcAVm2NCahQTUqYck/RCh4zPMgYvEp99se7kst8CLNwnZwmLx6r3bpXvkBQ
         2bfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mkCiLlrSzhAV2CD8PHBGktrJShCBHx4vJYh2M4ZW7p0=;
        b=HEQ5Qxp0xr9W7CFPOzui3aegcCibPJd8nPanfeQVoYYlu1QKWIVGuF9SWk21JH+MeS
         Vq8rQhQEtvLcX+TFnWKzhWL5L6tD1VwW9yHWnjIiSD2yRBNVKvRM76dlaRkr525q60ki
         Pb5iGxNnvBartwHP3jXQObR+t1UuRYIE/ti2QLMgYFSBvkENIHQJDu+ky1Kx1ZOl7ow/
         nxGl3OWqmFNzSxo7HEr/D/2sV5cBctnQbOqepVi33TAvcZ41J4nZTeXxNdmjgfH8wAf3
         IHiP0UTS9T6mbu7AE0oGvAlvBA1G1xH/KxnaNdBJlNeMCQ/taqz6ALgR6JfvsQqZtHs5
         s6Bw==
X-Gm-Message-State: APjAAAWhxL/KzbAVIjGBUUrPew+6d8JOC0fqpndcynMqdWwh6bt+ncEu
        iZjEwhjdpHWAVgbc9RbVaSl+NA==
X-Google-Smtp-Source: APXvYqyOmcBpTlo/qkNaZeMYvIEjLQYgMp7eWOOzsanh0QRKYrYyzJRsPOwbF0mcezuMOUMX0NS3HA==
X-Received: by 2002:a05:600c:23d2:: with SMTP id p18mr15045739wmb.66.1558691216664;
        Fri, 24 May 2019 02:46:56 -0700 (PDT)
Received: from [192.168.1.2] ([194.53.186.20])
        by smtp.gmail.com with ESMTPSA id i17sm1916346wrr.46.2019.05.24.02.46.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 May 2019 02:46:56 -0700 (PDT)
Subject: Re: [PATCH bpf-next v2 1/3] tools: bpftool: add -d option to get
 debug output from libbpf
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org,
        Networking <netdev@vger.kernel.org>, oss-drivers@netronome.com,
        Yonghong Song <yhs@fb.com>
References: <20190523105426.3938-1-quentin.monnet@netronome.com>
 <20190523105426.3938-2-quentin.monnet@netronome.com>
 <CAEf4BzZt75Wm29MQKx1g_u8cH2QYRF3HGYgnOpa3yF9NOMXysw@mail.gmail.com>
 <20190523134421.38a0da0c@cakuba.netronome.com>
 <CAEf4BzbyE8w1wLN33OfUgu8qGqRbxE5LbXFniucyqW4mH7mQFw@mail.gmail.com>
From:   Quentin Monnet <quentin.monnet@netronome.com>
Message-ID: <c720f3ce-059b-b47a-a0de-5e360b590a30@netronome.com>
Date:   Fri, 24 May 2019 10:46:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CAEf4BzbyE8w1wLN33OfUgu8qGqRbxE5LbXFniucyqW4mH7mQFw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2019-05-23 13:57 UTC-0700 ~ Andrii Nakryiko <andrii.nakryiko@gmail.com>
> On Thu, May 23, 2019 at 1:44 PM Jakub Kicinski
> <jakub.kicinski@netronome.com> wrote:
>>
>> On Thu, 23 May 2019 09:20:52 -0700, Andrii Nakryiko wrote:
>>> On Thu, May 23, 2019 at 3:54 AM Quentin Monnet wrote:
>>>>
>>>> libbpf has three levels of priority for output messages: warn, info,
>>>> debug. By default, debug output is not printed to the console.
>>>>
>>>> Add a new "--debug" (short name: "-d") option to bpftool to print libbpf
>>>> logs for all three levels.
>>>>
>>>> Internally, we simply use the function provided by libbpf to replace the
>>>> default printing function by one that prints logs regardless of their
>>>> level.
>>>>
>>>> v2:
>>>> - Remove the possibility to select the log-levels to use (v1 offered a
>>>>   combination of "warn", "info" and "debug").
>>>> - Rename option and offer a short name: -d|--debug.
>>>
>>> Such and option in CLI tools is usually called -v|--verbose, I'm
>>> wondering if it might be a better name choice?
>>>
>>> Btw, some tools also use -v, -vv and -vvv to define different levels
>>> of verbosity, which is something we can consider in the future, as
>>> it's backwards compatible.
>>
>> That was my weak suggestion.  Sometimes -v is used for version, e.g.
>> GCC.  -d is sometimes used for debug, e.g. man, iproute2 uses it as
>> short for "detailed".  If the consensus is that -v is better I don't
>> really mind.
> 
> It's minor, so I'm not insisting at all, just wasn't sure it was
> brought up. bpftool is sufficiently different in its conventions from
> other modern CLIs anyways.
> 
> As for -v for version. It seems like the trend is to use -V|--version
> for version, and -v|--verbose for verbosity. I've also seen some tools
> option for `cli version` (subcommand) for version. Anyway, no strong
> preferences from me either.
> 

For the record, bpftool has both "bpftool -V" and "bpftool version" to
dump the version number.

This leaves us with "-v" free to do something like "--verbose", but just
as Jakub said we wanted to limit the risks of confusion... I don't mind
changing, but since nobody has expressed a strong opinion on the matter,
I'll stick to "-d|--debug" for now.

Thanks Andrii for the review!
Quentin
