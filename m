Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53F2A20F6BF
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 16:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388515AbgF3OJT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 10:09:19 -0400
Received: from www62.your-server.de ([213.133.104.62]:45906 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731084AbgF3OJT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 10:09:19 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jqGwn-0000ec-7y; Tue, 30 Jun 2020 16:09:17 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jqGwn-000Pku-0t; Tue, 30 Jun 2020 16:09:17 +0200
Subject: Re: [PATCH v2 bpf-next 2/2] selftests/bpf: add byte swapping selftest
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com
References: <20200630060739.1722733-1-andriin@fb.com>
 <20200630060739.1722733-3-andriin@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <cd88906d-2ca7-e37b-9214-6094571d41fc@iogearbox.net>
Date:   Tue, 30 Jun 2020 16:09:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200630060739.1722733-3-andriin@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25858/Mon Jun 29 15:30:49 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/30/20 8:07 AM, Andrii Nakryiko wrote:
> Add simple selftest validating byte swap built-ins and compile-time macros.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>   .../testing/selftests/bpf/prog_tests/endian.c | 53 +++++++++++++++++++
>   .../testing/selftests/bpf/progs/test_endian.c | 37 +++++++++++++
>   2 files changed, 90 insertions(+)
>   create mode 100644 tools/testing/selftests/bpf/prog_tests/endian.c
>   create mode 100644 tools/testing/selftests/bpf/progs/test_endian.c

This fails the build for me with:

[...]
   GEN-SKEL [test_progs] tailcall3.skel.h
   GEN-SKEL [test_progs] test_endian.skel.h
libbpf: invalid relo for 'const16' in special section 0xfff2; forgot to initialize global var?..
Error: failed to open BPF object file: 0
Makefile:372: recipe for target '/root/bpf-next/tools/testing/selftests/bpf/test_endian.skel.h' failed
make: *** [/root/bpf-next/tools/testing/selftests/bpf/test_endian.skel.h] Error 255
make: *** Deleting file '/root/bpf-next/tools/testing/selftests/bpf/test_endian.skel.h'
