Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83A9C210E1A
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 16:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731672AbgGAOxy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 10:53:54 -0400
Received: from www62.your-server.de ([213.133.104.62]:49848 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731441AbgGAOxy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 10:53:54 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jqe7T-0007mh-RS; Wed, 01 Jul 2020 16:53:51 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jqe7T-000EbJ-Ko; Wed, 01 Jul 2020 16:53:51 +0200
Subject: Re: [PATCH v3 bpf-next 0/2] Make bpf_endian.h compatible with
 vmlinux.h
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com
References: <20200630152125.3631920-1-andriin@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <2170175d-a97e-6ca5-003c-bc6d6d1b936a@iogearbox.net>
Date:   Wed, 1 Jul 2020 16:53:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200630152125.3631920-1-andriin@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25860/Wed Jul  1 15:40:06 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/30/20 5:21 PM, Andrii Nakryiko wrote:
> Change libbpf's bpf_endian.h header to be compatible when used with system
> headers and when using just vmlinux.h. This is a frequent request for users
> writing BPF CO-RE applications. Do this by re-implementing byte swap
> compile-time macros. Also add simple tests validating correct results both for
> byte-swapping built-ins and macros.
> 
> v2->v3:
> - explicit zero-initialization of global variables (Daniel);
> 
> v1->v2:
> - reimplement byte swapping macros (Alexei).
> 
> Andrii Nakryiko (2):
>    libbpf: make bpf_endian co-exist with vmlinux.h
>    selftests/bpf: add byte swapping selftest
> 
>   tools/lib/bpf/bpf_endian.h                    | 43 ++++++++++++---
>   .../testing/selftests/bpf/prog_tests/endian.c | 53 +++++++++++++++++++
>   .../testing/selftests/bpf/progs/test_endian.c | 37 +++++++++++++
>   3 files changed, 125 insertions(+), 8 deletions(-)
>   create mode 100644 tools/testing/selftests/bpf/prog_tests/endian.c
>   create mode 100644 tools/testing/selftests/bpf/progs/test_endian.c
> 

All good now & applied, thanks!
