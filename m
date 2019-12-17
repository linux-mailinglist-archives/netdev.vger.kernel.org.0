Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82633123ABA
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 00:22:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbfLQXWJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 18:22:09 -0500
Received: from www62.your-server.de ([213.133.104.62]:40902 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726561AbfLQXWJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 18:22:09 -0500
Received: from sslproxy01.your-server.de ([88.198.220.130])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1ihMAE-000697-0j; Wed, 18 Dec 2019 00:22:02 +0100
Received: from [178.197.249.31] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1ihMAD-0005zl-HP; Wed, 18 Dec 2019 00:22:01 +0100
Subject: Re: [PATCH bpf-next] selftests/bpf: more succinct Makefile output
To:     Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>
Cc:     "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
References: <20191217061425.2346359-1-andriin@fb.com>
 <b0e81ae2-9155-e878-1193-3e7ecfab1983@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <a5d8e424-0e23-3211-dc1a-3d556dfe43c2@iogearbox.net>
Date:   Wed, 18 Dec 2019 00:22:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <b0e81ae2-9155-e878-1193-3e7ecfab1983@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25666/Tue Dec 17 10:54:52 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/17/19 10:54 PM, Yonghong Song wrote:
> On 12/16/19 10:14 PM, Andrii Nakryiko wrote:
>> Similarly to bpftool/libbpf output, make selftests/bpf output succinct
>> per-item output line. Output is roughly as follows:
>>
>> $ make
>> ...
>>     CLANG-LLC [test_maps] pyperf600.o
>>     CLANG-LLC [test_maps] strobemeta.o
>>     CLANG-LLC [test_maps] pyperf100.o
>>     EXTRA-OBJ [test_progs] cgroup_helpers.o
>>     EXTRA-OBJ [test_progs] trace_helpers.o
>>        BINARY test_align
>>        BINARY test_verifier_log
>>      GEN-SKEL [test_progs] fexit_bpf2bpf.skel.h
>>      GEN-SKEL [test_progs] test_global_data.skel.h
>>      GEN-SKEL [test_progs] sendmsg6_prog.skel.h
>> ...
>>
>> To see the actual command invocation, verbose mode can be turned on with V=1
>> argument:
>>
>> $ make V=1
>>
>> ... very verbose output ...
>>
>> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> 
> Acked-by: Yonghong Song <yhs@fb.com>

Applied, thanks!
