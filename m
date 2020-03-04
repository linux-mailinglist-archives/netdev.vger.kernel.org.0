Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E578A1798BA
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 20:14:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728614AbgCDTN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 14:13:59 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55031 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726561AbgCDTN7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 14:13:59 -0500
Received: by mail-wm1-f65.google.com with SMTP id i9so3449300wml.4
        for <netdev@vger.kernel.org>; Wed, 04 Mar 2020 11:13:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZpiDh26r+Ch8iWHGrJTS8rzPFoZXjwfWAgWenFu6J9w=;
        b=L8ThUlaDZX0jF8LO2oqF3/Jjs2InRUkoll3W3RPXyrUYZVLn1hemJbU8GLDacnB1Xk
         qwq9KMsxUzw1xBNB0ktv/M7tpzc/FTdtD7ypwLkR006dfhZPvdJ+FXq2W29cmG3ZjkQX
         LQ1WeDuQFXzqM2TJENBSMipbS8QYfdNLeAb700huHHuHFHsgF6PyZO/44/jS6SVNwD/9
         dXzw9/IBNOsGSI8KugZl1CvcZz8Jw1C4zUtxCvM6P9au46opo7kCziJvR8BrFgQe99kF
         Ublf0Gwsxe4cvfXOX2SsnRnLls8BH2UW1zumBw4Fdmz4B7GqHMMKi/WeCxFwdFzuKrGQ
         R5xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZpiDh26r+Ch8iWHGrJTS8rzPFoZXjwfWAgWenFu6J9w=;
        b=kbn9gFkNhTIn9fhNznki6jpku/wYI5Slp4gUA/PJaMSvDJGLUy6p8GxLK6Dkw71pvy
         CEh7jDaqJy/WxzN2tctcI7dJGRo0ZKGnOM58FRU2SKgelqoBtGzpIOHrdG+9W6kdsfnM
         TeZte7dQrMwRLeBamnsdi14U9dITfb4UuUpbrle4Cj03KWxtDopPcuJpJvm8MkgH4m12
         +QvSzc7bpU+lTn6YhlAtOWbdv6KiQxmfbEaxJudkjQWFQANmNtrhDt8swrzA4Zznl7PW
         yj+klSCTsjUmg7fjy4CdyknwJOcN2lJevr1l1oxWEFwQKa3Eg+AqntjS5KlgsqliyOc1
         gbug==
X-Gm-Message-State: ANhLgQ0Z4BH1MEa/dUFKK0kD7sMTii7HrkHNKCgrBiIJ50v44t32srBK
        pJ6yr01ChxIOnH8U1v3NbQp5Lg==
X-Google-Smtp-Source: ADFU+vs2uLVlKgGfAPldPd8Z2YwCYW1lZpvNQUXbPqqWtqZZ9Mho67phCSI/fQ5wDpmw5hIc1gRjkg==
X-Received: by 2002:a7b:cd11:: with SMTP id f17mr5104788wmj.6.1583349236118;
        Wed, 04 Mar 2020 11:13:56 -0800 (PST)
Received: from [192.168.1.10] ([194.35.118.106])
        by smtp.gmail.com with ESMTPSA id t3sm40813652wrx.38.2020.03.04.11.13.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Mar 2020 11:13:55 -0800 (PST)
Subject: Re: [PATCH v4 bpf-next 0/4] bpftool: introduce prog profile
To:     Song Liu <songliubraving@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     kernel-team@fb.com, ast@kernel.org, daniel@iogearbox.net,
        arnaldo.melo@gmail.com, jolsa@kernel.org
References: <20200304180710.2677695-1-songliubraving@fb.com>
From:   Quentin Monnet <quentin@isovalent.com>
Message-ID: <6d824118-7223-12eb-a58b-46368c33b782@isovalent.com>
Date:   Wed, 4 Mar 2020 19:13:54 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200304180710.2677695-1-songliubraving@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2020-03-04 10:07 UTC-0800 ~ Song Liu <songliubraving@fb.com>
> This set introduces bpftool prog profile command, which uses hardware
> counters to profile BPF programs.
> 
> This command attaches fentry/fexit programs to a target program. These two
> programs read hardware counters before and after the target program and
> calculate the difference.
> 
> Changes v3 => v4:
> 1. Simplify err handling in profile_open_perf_events() (Quentin);
> 2. Remove redundant p_err() (Quentin);
> 3. Replace tab with space in bash-completion; (Quentin);
> 4. Fix typo _bpftool_get_map_names => _bpftool_get_prog_names (Quentin).
> 
> Changes v2 => v3:
> 1. Change order of arguments (Quentin), as:
>      bpftool prog profile PROG [duration DURATION] METRICs
> 2. Add bash-completion for bpftool prog profile (Quentin);
> 3. Fix build of selftests (Yonghong);
> 4. Better handling of bpf_map_lookup_elem() returns (Yonghong);
> 5. Improve clean up logic of do_profile() (Yonghong);
> 6. Other smaller fixes/cleanups.
> 
> Changes RFC => v2:
> 1. Use new bpf_program__set_attach_target() API;
> 2. Update output format to be perf-stat like (Alexei);
> 3. Incorporate skeleton generation into Makefile;
> 4. Make DURATION optional and Allow Ctrl-C (Alexei);
> 5. Add calcated values "insn per cycle" and "LLC misses per million isns".
> 
> Song Liu (4):
>   bpftool: introduce "prog profile" command
>   bpftool: Documentation for bpftool prog profile
>   bpftool: bash completion for "bpftool prog profile"
>   bpftool: fix typo in bash-completion
> 
>  .../bpftool/Documentation/bpftool-prog.rst    |  19 +
>  tools/bpf/bpftool/Makefile                    |  18 +
>  tools/bpf/bpftool/bash-completion/bpftool     |  47 +-
>  tools/bpf/bpftool/prog.c                      | 425 +++++++++++++++++-
>  tools/bpf/bpftool/skeleton/profiler.bpf.c     | 171 +++++++
>  tools/bpf/bpftool/skeleton/profiler.h         |  47 ++
>  tools/scripts/Makefile.include                |   1 +
>  7 files changed, 725 insertions(+), 3 deletions(-)
>  create mode 100644 tools/bpf/bpftool/skeleton/profiler.bpf.c
>  create mode 100644 tools/bpf/bpftool/skeleton/profiler.h
> 
> --

Thanks again! This version looks good to me, although I've not tested
the patchset, so there's still the error met by Jiri to figure out. For
the rest of the series:

Reviewed-by: Quentin Monnet <quentin@isovalent.com>
