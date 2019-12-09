Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88D66117879
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 22:27:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbfLIV1e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 16:27:34 -0500
Received: from www62.your-server.de ([213.133.104.62]:52316 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726354AbfLIV1e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 16:27:34 -0500
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1ieQYz-0005UU-5g; Mon, 09 Dec 2019 22:27:29 +0100
Received: from [178.197.249.52] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1ieQYy-000RvL-Qi; Mon, 09 Dec 2019 22:27:28 +0100
Subject: Re: [PATCH bpf-next 2/8] riscv, bpf: add support for far branching
To:     Luke Nelson <lukenels@cs.washington.edu>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Netdev <netdev@vger.kernel.org>, linux-riscv@lists.infradead.org,
        bpf <bpf@vger.kernel.org>, Xi Wang <xi.wang@gmail.com>
References: <20191209173136.29615-1-bjorn.topel@gmail.com>
 <20191209173136.29615-3-bjorn.topel@gmail.com>
 <CADasFoDOyJA0nDVCyA6EY78dHSSxxV+EXS=xUyLDW4_VhJvBkQ@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <2d5d1f2d-d4ab-2449-37c6-e5b319a778d6@iogearbox.net>
Date:   Mon, 9 Dec 2019 22:27:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CADasFoDOyJA0nDVCyA6EY78dHSSxxV+EXS=xUyLDW4_VhJvBkQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25658/Mon Dec  9 10:47:26 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/9/19 10:08 PM, Luke Nelson wrote:
[...]
> We have been developing a formal verification tool for BPF JIT
> compilers, which we have used in the past to find bugs in the RV64
> and x32 BPF JITs:
> 
> https://unsat.cs.washington.edu/projects/serval/
> 
> Recently I added support for verifying the JIT for branch and jump
> instructions, and thought it a good opportunity to verify these
> patches that add support for far jumps and branching.
> 
> I ported these patches to our tool and ran verification, which
> didn't find any bugs according to our specification of BPF and
> RISC-V.
> 
> The tool and code are publicly available, and you can read a more
> detailed writeup of the results here:
> 
> https://github.com/uw-unsat/bpf-jit-verif/tree/far-jump-review
> 
> Currently the tool works on a manually translated version of the
> JIT from C to Rosette, but we are experimenting with ways of making
> this process more automated.

This is awesome work! Did you also check for other architectures aside
from riscv and x86-32, e.g. x86-64 or arm64?

It would be great if we could add such verification tool under tools/bpf/
which would then take the in-tree JIT-code as-is for its analysis and
potentially even trigger a run out of BPF selftests. Any thoughts whether
such path would be feasible wrt serval?

> Reviewed-by: Luke Nelson <lukenels@cs.washington.edu>
> Cc: Xi Wang <xi.wang@gmail.com>

Thanks,
Daniel
