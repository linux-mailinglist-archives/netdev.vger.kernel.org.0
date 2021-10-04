Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDE30420785
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 10:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbhJDIpi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 04:45:38 -0400
Received: from gandalf.ozlabs.org ([150.107.74.76]:48021 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbhJDIph (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Oct 2021 04:45:37 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4HNDlR0VHPz4xb7;
        Mon,  4 Oct 2021 19:43:47 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1633337027;
        bh=lGiN5YFpQQ1dHQyebaZ+eHrMLRHhQ/tolfu0dgF5gdc=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=i76Zi2TSGeV/SugFPxQ1z4T2iU1ASdx//IkawvUKouym9vTGxNS/l44JjRpp/bKMh
         ycR5XDmgaXz9dy6S7vSzUfIZv3ZnxtgBsM7JtFy0VAT23ry4u5akHXi5yPg3mGm1Cq
         432dQTzCNawvET02o1vnkxzZBrlzTX9L6OktpqwbD43j1UigtcxhY+BF7fMni1088k
         yDdSZnkf6LxzVOwaOtFOfHBHCnQWvctEvcHkzUkzNEPC1RZ7f/39PILfKZl/mjbFJQ
         0DxCYPOk2N3wsyNdEZooAysOtkASbhdXLyNQXVfPW9tdeuraegK/06qP+hCdbq7xl0
         rmtbbwBbg6rHg==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Hari Bathini <hbathini@linux.ibm.com>,
        naveen.n.rao@linux.ibm.com, christophe.leroy@csgroup.eu,
        ast@kernel.org
Cc:     paulus@samba.org, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v4 0/8] bpf powerpc: Add BPF_PROBE_MEM support in
 powerpc JIT compiler
In-Reply-To: <768469ec-a596-9e0c-541c-aca5693d69e7@iogearbox.net>
References: <20210929111855.50254-1-hbathini@linux.ibm.com>
 <88b59272-e3f7-30ba-dda0-c4a6b42c0029@iogearbox.net>
 <87o885raev.fsf@mpe.ellerman.id.au>
 <768469ec-a596-9e0c-541c-aca5693d69e7@iogearbox.net>
Date:   Mon, 04 Oct 2021 19:43:45 +1100
Message-ID: <87lf39qiwu.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann <daniel@iogearbox.net> writes:
> On 10/4/21 12:49 AM, Michael Ellerman wrote:
>> Daniel Borkmann <daniel@iogearbox.net> writes:
>>> On 9/29/21 1:18 PM, Hari Bathini wrote:
>>>> Patch #1 & #2 are simple cleanup patches. Patch #3 refactors JIT
>>>> compiler code with the aim to simplify adding BPF_PROBE_MEM support.
>>>> Patch #4 introduces PPC_RAW_BRANCH() macro instead of open coding
>>>> branch instruction. Patch #5 & #7 add BPF_PROBE_MEM support for PPC64
>>>> & PPC32 JIT compilers respectively. Patch #6 & #8 handle bad userspace
>>>> pointers for PPC64 & PPC32 cases respectively.
>>>
>>> Michael, are you planning to pick up the series or shall we route via bpf-next?
>> 
>> Yeah I'll plan to take it, unless you think there is a strong reason it
>> needs to go via the bpf tree (doesn't look like it from the diffstat).
>
> Sounds good to me, in that case, please also route the recent JIT fixes from
> Naveen through your tree.

Will do.

cheers
