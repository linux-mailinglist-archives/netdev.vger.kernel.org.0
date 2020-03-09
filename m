Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 612C317EC6A
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 00:06:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727407AbgCIXGU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 19:06:20 -0400
Received: from www62.your-server.de ([213.133.104.62]:55266 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726536AbgCIXGU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 19:06:20 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jBRTV-0005D7-SN; Tue, 10 Mar 2020 00:06:17 +0100
Received: from [85.7.42.192] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jBRTV-000VpB-Im; Tue, 10 Mar 2020 00:06:17 +0100
Subject: Re: [PATCH v6 bpf-next 0/4] bpftool: introduce prog profile
To:     Song Liu <songliubraving@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     quentin@isovalent.com, kernel-team@fb.com, ast@kernel.org,
        arnaldo.melo@gmail.com, jolsa@kernel.org
References: <20200309173218.2739965-1-songliubraving@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <56e69208-17d8-d4f1-cd3a-77fc881aa80e@iogearbox.net>
Date:   Tue, 10 Mar 2020 00:06:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200309173218.2739965-1-songliubraving@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25746/Mon Mar  9 12:13:05 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/9/20 6:32 PM, Song Liu wrote:
> This set introduces bpftool prog profile command, which uses hardware
> counters to profile BPF programs.
> 
> This command attaches fentry/fexit programs to a target program. These two
> programs read hardware counters before and after the target program and
> calculate the difference.
> 
> Changes v5 => v6:
> 1. Use new header bpf_tracing.h (Yonghong).
> 
> Changes v4 => v5:
> 1. Adjust perf_event_attr for the events (Jiri).
> 
> Changes v3 => v4:
> 1. Simplify err handling in profile_open_perf_events() (Quentin);
> 2. Remove redundant p_err() (Quentin);
> 3. Replace tab with space in bash-completion; (Quentin);
> 4. Fix typo _bpftool_get_map_names => _bpftool_get_prog_names (Quentin).
> 
> Changes v2 => v3:
> 1. Change order of arguments (Quentin), as:
>       bpftool prog profile PROG [duration DURATION] METRICs
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
>    bpftool: introduce "prog profile" command
>    bpftool: Documentation for bpftool prog profile
>    ybpftool: bash completion for "bpftool prog profile"

Applied and fixed subject typo above, thanks.

Please follow-up with a feature probe to support older clang/llvm versions.

>    bpftool: fix typo in bash-completion
