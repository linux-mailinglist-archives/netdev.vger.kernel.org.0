Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FCBB446278
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 12:02:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231959AbhKELEx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 07:04:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231475AbhKELEw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Nov 2021 07:04:52 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FCAFC061203
        for <netdev@vger.kernel.org>; Fri,  5 Nov 2021 04:02:12 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id a20-20020a1c7f14000000b003231d13ee3cso9248927wmd.3
        for <netdev@vger.kernel.org>; Fri, 05 Nov 2021 04:02:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=iF+zxaAHPCZ1aSEwVKQWxuALCDjRYk/u+ocyNXaqMy4=;
        b=xnqGo8p1svLqpLa5r0+asMVZTjzCDuen6wn6ogLQ4nyke59qRd47uLDcaphXHy4lnH
         ow8ZJEmUxylGsyWtZ06rOIG904yTglz1zf/OHvqlxMtPyI0K1H5Abl0O6rUbYHpGqbYi
         GLNoIy7dR2yTSqizurMQIaxqHsh3oSWmtqbgwm5J5mvopQKXRmEaJLH6Vm8pFsAvDZLt
         pAV6b/UZf+WKmS+QTi5QeNrwSXxwP/F4cIKMGnNTOQpr3TGc42+zoS7LC6USCdGIhIXa
         4ib5M2Lwf1QStPrq3vhiAQMbl3vBV56DDxwqfvIENe3YcYDuOkKbr6taYL/oJ4zvdGAM
         SeRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=iF+zxaAHPCZ1aSEwVKQWxuALCDjRYk/u+ocyNXaqMy4=;
        b=paFsP4pMSc+rdSF3wy7Gc4xldCe9lOvS4BI3yqlRxCR5JXv5+9mb/F+dfkvZeUZEbZ
         POubeJvEwntpKOPR1bH2b7iaSvKY7hZPFYnVt6fvNmGE5RjCo4ySu6C1PV1D/aGMtKwn
         IxeitHOhC7wU4EYkTTD+o9pgnv9+3PPoXfyE0ZYBkWYYBKt18hW359S/WrbQi0yn/76t
         w00dgqRwOuYofLVGAB3BmcUKiZV8C8M/+LxIVCv+InVRMlyUo905ZuVX9WHKudz331bk
         iFJsp18aFk7etJ+SRi5mleDTCRHnXPBLxyzCLPVNTsSgXXgO5K1oOBjWNFUAZOtHwfBg
         dCAA==
X-Gm-Message-State: AOAM532LVi2KR6m8AuhT3WIGwyJSewsCiyhORw+Gm7eg9efAN2Qs6n/3
        TP/u2YxyojC6318IiHLCP7KkFw==
X-Google-Smtp-Source: ABdhPJzyHLx0ancDMVHWuEao/JhXkYZjnjykB+oBcP88oPQZV5ekKz4b2rb0jAUBlinPelcjb38gPw==
X-Received: by 2002:a7b:cb55:: with SMTP id v21mr29808116wmj.83.1636110131146;
        Fri, 05 Nov 2021 04:02:11 -0700 (PDT)
Received: from [192.168.1.8] ([149.86.68.127])
        by smtp.gmail.com with ESMTPSA id n1sm5693385wmq.6.2021.11.05.04.02.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Nov 2021 04:02:10 -0700 (PDT)
Message-ID: <6fbd1539-c343-2d03-d153-11d2684effd6@isovalent.com>
Date:   Fri, 5 Nov 2021 11:02:09 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH bpf-next] bpftool: add option to enable libbpf's strict
 mode
Content-Language: en-GB
To:     Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        John Fastabend <john.fastabend@gmail.com>
References: <20211104160311.4028188-1-sdf@google.com>
From:   Quentin Monnet <quentin@isovalent.com>
In-Reply-To: <20211104160311.4028188-1-sdf@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2021-11-04 09:03 UTC-0700 ~ Stanislav Fomichev <sdf@google.com>
> Otherwise, attaching with bpftool doesn't work with strict section names.
> 
> Also:
> 
> - by default, don't append / to the section name; in strict
>   mode it's relevant only for a small subset of prog types
> - print a deprecation warning when requested to pin all programs
> 
> + bpftool prog loadall tools/testing/selftests/bpf/test_probe_user.o /sys/fs/bpf/kprobe type kprobe
> Warning: pinning by section name is deprecated, use --strict to pin by function name.
> See: https://github.com/libbpf/libbpf/wiki/Libbpf:-the-road-to-v1.0#pinning-path-differences
> 
> + bpftool prog loadall tools/testing/selftests/bpf/xdp_dummy.o /sys/fs/bpf/xdp type xdp
> Warning: pinning by section name is deprecated, use --strict to pin by function name.
> See: https://github.com/libbpf/libbpf/wiki/Libbpf:-the-road-to-v1.0#pinning-path-differences
> 
> + bpftool --strict prog loadall tools/testing/selftests/bpf/test_probe_user.o /sys/fs/bpf/kprobe type kprobe
> + bpftool --strict prog loadall tools/testing/selftests/bpf/xdp_dummy.o /sys/fs/bpf/xdp type xdp
> 
> Cc: Quentin Monnet <quentin@isovalent.com>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
Hi and thanks Stanislav! I have some reservations on the current
approach, though.

I see the new option is here to avoid breaking the current behaviour.
However:

- Libbpf has the API break scheduled for v1.0, and at this stage we
won't be able to avoid breakage in bpftool's behaviour. This means that,
eventually, "bpftool prog loadall" will load functions by func name and
not section name, that section names with garbage prefixes
('SEC("xdp_my_prog")') will be rejected, and that maps with extra
attributes in their definitions will be rejected. And save for the
pinning path difference, we won't be able to tell from bpftool when this
happens, because this is all handled by libbpf.

- In that context, I'd rather have the strict behaviour being the
default. We could have an option to restore the legacy behaviour
(disabling strict mode) during the transition, but I'd rather avoid
users starting to use everywhere a "--strict" option which becomes
either mandatory in the future or (more likely) a deprecated no-op when
we switch to libbpf v1.0 and break legacy behaviour anyway.

- If we were to keep the current option, I'm not a fan of the "--strict"
name, because from a user point of view, I don't think it reflects well
the change to pinning by function name, for example. But given that the
option interferes with different aspects of the loading process, I don't
really have a better suggestion :/.

Aside from the discussion on this option, the code looks good. The
optional '/' on program types on the command line works well, thanks for
preserving the behaviour on the CLI. Please find also a few more notes
below.

> ---
>  .../bpftool/Documentation/common_options.rst  |  6 +++
>  tools/bpf/bpftool/main.c                      | 13 +++++-
>  tools/bpf/bpftool/main.h                      |  1 +
>  tools/bpf/bpftool/prog.c                      | 40 +++++++++++--------
>  4 files changed, 43 insertions(+), 17 deletions(-)
> 
> diff --git a/tools/bpf/bpftool/Documentation/common_options.rst b/tools/bpf/bpftool/Documentation/common_options.rst
> index 05d06c74dcaa..28710f9005be 100644
> --- a/tools/bpf/bpftool/Documentation/common_options.rst
> +++ b/tools/bpf/bpftool/Documentation/common_options.rst
> @@ -20,3 +20,9 @@
>  	  Print all logs available, even debug-level information. This includes
>  	  logs from libbpf as well as from the verifier, when attempting to
>  	  load programs.
> +
> +-S, --strict

The option does not affect all commands, and could maybe be moved to the
pages of the relevant commands. I think that "prog" and "map" are affected?

> +	  Use strict (aka v1.0) libbpf mode which has more stringent section
> +	  name requirements.
> +	  See https://github.com/libbpf/libbpf/wiki/Libbpf:-the-road-to-v1.0#pinning-path-differences

There is more than just the pinning difference. The stricter section
name handling and the changes for map declarations (drop of non-BTF and
of unknown attributes) should also affect the way bpftool can load
objects. Even the changes in the ELF section processing might affect the
resulting objects.

> +	  for details.
Note that if we add a command line option, we'd also need to add it to
the interactive help message and bash completion:

https://elixir.bootlin.com/linux/v5.15/source/tools/bpf/bpftool/main.h#L57
https://elixir.bootlin.com/linux/v5.15/source/tools/bpf/bpftool/bash-completion/bpftool#L263

Thanks,
Quentin
