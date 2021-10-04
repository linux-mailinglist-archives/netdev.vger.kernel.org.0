Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E39C420700
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 10:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230484AbhJDIIG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 04:08:06 -0400
Received: from www62.your-server.de ([213.133.104.62]:39104 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230408AbhJDIIB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Oct 2021 04:08:01 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mXIz0-000CRs-N6; Mon, 04 Oct 2021 10:05:58 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mXIz0-000BaL-Cv; Mon, 04 Oct 2021 10:05:58 +0200
Subject: Re: [PATCH v4 0/8] bpf powerpc: Add BPF_PROBE_MEM support in powerpc
 JIT compiler
To:     Michael Ellerman <mpe@ellerman.id.au>,
        Hari Bathini <hbathini@linux.ibm.com>,
        naveen.n.rao@linux.ibm.com, christophe.leroy@csgroup.eu,
        ast@kernel.org
Cc:     paulus@samba.org, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
References: <20210929111855.50254-1-hbathini@linux.ibm.com>
 <88b59272-e3f7-30ba-dda0-c4a6b42c0029@iogearbox.net>
 <87o885raev.fsf@mpe.ellerman.id.au>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <768469ec-a596-9e0c-541c-aca5693d69e7@iogearbox.net>
Date:   Mon, 4 Oct 2021 10:05:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <87o885raev.fsf@mpe.ellerman.id.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26311/Sun Oct  3 11:08:49 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/4/21 12:49 AM, Michael Ellerman wrote:
> Daniel Borkmann <daniel@iogearbox.net> writes:
>> On 9/29/21 1:18 PM, Hari Bathini wrote:
>>> Patch #1 & #2 are simple cleanup patches. Patch #3 refactors JIT
>>> compiler code with the aim to simplify adding BPF_PROBE_MEM support.
>>> Patch #4 introduces PPC_RAW_BRANCH() macro instead of open coding
>>> branch instruction. Patch #5 & #7 add BPF_PROBE_MEM support for PPC64
>>> & PPC32 JIT compilers respectively. Patch #6 & #8 handle bad userspace
>>> pointers for PPC64 & PPC32 cases respectively.
>>
>> Michael, are you planning to pick up the series or shall we route via bpf-next?
> 
> Yeah I'll plan to take it, unless you think there is a strong reason it
> needs to go via the bpf tree (doesn't look like it from the diffstat).

Sounds good to me, in that case, please also route the recent JIT fixes from
Naveen through your tree.

Thanks,
Daniel
