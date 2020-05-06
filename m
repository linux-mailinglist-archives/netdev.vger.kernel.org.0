Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F33881C6AE6
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 10:08:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728591AbgEFIId (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 04:08:33 -0400
Received: from www62.your-server.de ([213.133.104.62]:35208 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728345AbgEFIIc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 04:08:32 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jWF6Q-0001an-HW; Wed, 06 May 2020 10:08:26 +0200
Received: from [178.195.186.98] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jWF6P-0005kQ-Vt; Wed, 06 May 2020 10:08:26 +0200
Subject: Re: [PATCH bpf-next 0/4] RV64 BPF JIT Optimizations
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Luke Nelson <lukenels@cs.washington.edu>
Cc:     bpf <bpf@vger.kernel.org>, Luke Nelson <luke.r.nels@gmail.com>,
        Xi Wang <xi.wang@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Netdev <netdev@vger.kernel.org>, linux-riscv@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>
References: <20200506000320.28965-1-luke.r.nels@gmail.com>
 <CAJ+HfNgbuBoMTrU+TM3JCd1stEM1Zi3hG5k=PazT=CxAWa4wBQ@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <76105702-4f84-ead9-6568-48f718cf85c2@iogearbox.net>
Date:   Wed, 6 May 2020 10:08:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAJ+HfNgbuBoMTrU+TM3JCd1stEM1Zi3hG5k=PazT=CxAWa4wBQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25803/Tue May  5 14:19:25 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/6/20 9:08 AM, Björn Töpel wrote:
> On Wed, 6 May 2020 at 02:03, Luke Nelson <lukenels@cs.washington.edu> wrote:
>>
>> This patch series introduces a set of optimizations to the BPF JIT
>> on RV64. The optimizations are related to the verifier zero-extension
>> optimization and BPF_JMP BPF_K.
>>
>> We tested the optimizations on a QEMU riscv64 virt machine, using
>> lib/test_bpf and test_verifier, and formally verified their correctness
>> using Serval.
>>
> 
> Luke and Xi,
> 
> Thanks a lot for working on this! Very nice series!
> 
> For the series:
> Reviewed-by: Björn Töpel <bjorn.topel@gmail.com>
> Acked-by: Björn Töpel <bjorn.topel@gmail.com>
> 
>> Luke Nelson (4):
>>    bpf, riscv: Enable missing verifier_zext optimizations on RV64
>>    bpf, riscv: Optimize FROM_LE using verifier_zext on RV64
>>    bpf, riscv: Optimize BPF_JMP BPF_K when imm == 0 on RV64
>>    bpf, riscv: Optimize BPF_JSET BPF_K using andi on RV64
>>
>>   arch/riscv/net/bpf_jit_comp64.c | 64 ++++++++++++++++++++++-----------
>>   1 file changed, 44 insertions(+), 20 deletions(-)
>>
>> Cc: Xi Wang <xi.wang@gmail.com>

Applied, thanks everyone!
