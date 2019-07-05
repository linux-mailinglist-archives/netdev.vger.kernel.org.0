Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C02D260D90
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 00:01:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728104AbfGEWBT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 18:01:19 -0400
Received: from www62.your-server.de ([213.133.104.62]:53296 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbfGEWBT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 18:01:19 -0400
Received: from [88.198.220.130] (helo=sslproxy01.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hjWGZ-0003Tn-0E; Sat, 06 Jul 2019 00:01:15 +0200
Received: from [178.193.45.231] (helo=linux.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hjWGY-0004Kx-MV; Sat, 06 Jul 2019 00:01:14 +0200
Subject: Re: [PATCH bpf-next] Enable zext optimization for more RV64G ALU ops
To:     Luke Nelson <lukenels@cs.washington.edu>,
        linux-kernel@vger.kernel.org
Cc:     Luke Nelson <luke.r.nels@gmail.com>,
        Song Liu <liu.song.a23@gmail.com>,
        Jiong Wang <jiong.wang@netronome.com>,
        Xi Wang <xi.wang@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        netdev@vger.kernel.org, linux-riscv@lists.infradead.org,
        bpf@vger.kernel.org
References: <20190705001803.30094-1-luke.r.nels@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <fbd0a41a-2d45-7b25-b417-f325d31c0074@iogearbox.net>
Date:   Sat, 6 Jul 2019 00:01:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190705001803.30094-1-luke.r.nels@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25501/Fri Jul  5 10:01:52 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/05/2019 02:18 AM, Luke Nelson wrote:
> commit 66d0d5a854a6 ("riscv: bpf: eliminate zero extension code-gen")
> added the new zero-extension optimization for some BPF ALU operations.
> 
> Since then, bugs in the JIT that have been fixed in the bpf tree require
> this optimization to be added to other operations: commit 1e692f09e091
> ("bpf, riscv: clear high 32 bits for ALU32 add/sub/neg/lsh/rsh/arsh"),
> and commit fe121ee531d1 ("bpf, riscv: clear target register high 32-bits
> for and/or/xor on ALU32")
> 
> Now that these have been merged to bpf-next, the zext optimization can
> be enabled for the fixed operations.
> 
> Cc: Song Liu <liu.song.a23@gmail.com>
> Cc: Jiong Wang <jiong.wang@netronome.com>
> Cc: Xi Wang <xi.wang@gmail.com>
> Signed-off-by: Luke Nelson <luke.r.nels@gmail.com>

Applied, thanks!
