Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31B0A11AB72
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 14:00:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729345AbfLKNAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 08:00:17 -0500
Received: from www62.your-server.de ([213.133.104.62]:53612 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727402AbfLKNAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 08:00:17 -0500
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1if1b9-0002Hf-CV; Wed, 11 Dec 2019 14:00:11 +0100
Date:   Wed, 11 Dec 2019 14:00:10 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Paul Chaignon <paul.chaignon@orange.com>
Cc:     Paul Burton <paulburton@kernel.org>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@gmail.com>,
        Mahshid Khezri <khezri.mahshid@gmail.com>,
        paul.chaignon@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH bpf 0/2] Limit tail calls to 33 in all JIT compilers
Message-ID: <20191211130010.GA23015@linux.fritz.box>
References: <cover.1575916815.git.paul.chaignon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1575916815.git.paul.chaignon@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25660/Wed Dec 11 10:47:07 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 09, 2019 at 07:51:52PM +0100, Paul Chaignon wrote:
> The BPF interpreter and all JIT compilers, except RISC-V's and MIPS',
> enforce a 33-tail calls limit at runtime.  Because of this discrepancy, a
> BPF program can have a different behavior and output depending on whether
> it is interpreted or JIT compiled, or depending on the underlying
> architecture.
> 
> This patchset changes the RISC-V and MIPS JIT compilers to limit tail
> calls to 33 instead of 32.  I have checked other BPF JIT compilers for the
> same discrepancy.
> 
> Paul Chaignon (2):
>   bpf, riscv: limit to 33 tail calls
>   bpf, mips: limit to 33 tail calls
> 
>  arch/mips/net/ebpf_jit.c      | 9 +++++----
>  arch/riscv/net/bpf_jit_comp.c | 4 ++--
>  2 files changed, 7 insertions(+), 6 deletions(-)

Applied, thanks!
