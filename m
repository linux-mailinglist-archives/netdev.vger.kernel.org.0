Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D944183D13
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 00:11:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbgCLXLo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 19:11:44 -0400
Received: from www62.your-server.de ([213.133.104.62]:39600 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726710AbgCLXLn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 19:11:43 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jCWzO-0007Fr-5x; Fri, 13 Mar 2020 00:11:42 +0100
Received: from [85.7.42.192] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jCWzN-000NsL-RV; Fri, 13 Mar 2020 00:11:41 +0100
Subject: Re: [PATCH v3 bpf-next 0/3] Fixes for bpftool-prog-profile
To:     Song Liu <songliubraving@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     john.fastabend@gmail.com, quentin@isovalent.com,
        kernel-team@fb.com, ast@kernel.org, arnaldo.melo@gmail.com,
        jolsa@kernel.org
References: <20200312182332.3953408-1-songliubraving@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <9a91e2a9-1668-99fc-927a-39b2f1188477@iogearbox.net>
Date:   Fri, 13 Mar 2020 00:11:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200312182332.3953408-1-songliubraving@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25749/Thu Mar 12 14:09:06 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/12/20 7:23 PM, Song Liu wrote:
> 1. Fix build for older clang;
> 2. Fix skeleton's dependency on libbpf;
> 3. Add files to .gitignore.
> 
> Changes v2 => v3:
> 1. Add -I$(LIBBPF_PATH) to Makefile (Quentin);
> 2. Use p_err() for error message (Quentin).
> 
> Changes v1 => v2:
> 1. Rewrite patch 1 with real feature detection (Quentin, Alexei).
> 2. Add files to .gitignore (Andrii).
> 
> Song Liu (3):
>    bpftool: only build bpftool-prog-profile if supported by clang
>    bpftool: skeleton should depend on libbpf
>    bpftool: add _bpftool and profiler.skel.h to .gitignore
> 
>   tools/bpf/bpftool/.gitignore                  |  2 ++
>   tools/bpf/bpftool/Makefile                    | 20 +++++++++++++------
>   tools/bpf/bpftool/prog.c                      |  1 +
>   tools/build/feature/Makefile                  |  9 ++++++++-
>   .../build/feature/test-clang-bpf-global-var.c |  4 ++++
>   5 files changed, 29 insertions(+), 7 deletions(-)
>   create mode 100644 tools/build/feature/test-clang-bpf-global-var.c

Tested with clang-7 and clang-11; looks good, applied, thanks!
