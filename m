Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85CE21C3F53
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 18:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729425AbgEDQFK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 12:05:10 -0400
Received: from www62.your-server.de ([213.133.104.62]:45066 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726551AbgEDQFJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 12:05:09 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jVdaZ-0004zi-1W; Mon, 04 May 2020 18:05:03 +0200
Received: from [178.195.186.98] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jVdaY-000HF6-Hv; Mon, 04 May 2020 18:05:02 +0200
Subject: Re: [PATCH bpf 0/2] bpf, arm: Small JIT optimizations
To:     Luke Nelson <lukenels@cs.washington.edu>, bpf@vger.kernel.org
Cc:     Luke Nelson <luke.r.nels@gmail.com>,
        Shubham Bansal <illusionist.neo@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20200501020210.32294-1-luke.r.nels@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <c59f4067-6334-2dc4-a37b-b1e953663897@iogearbox.net>
Date:   Mon, 4 May 2020 18:05:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200501020210.32294-1-luke.r.nels@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25802/Mon May  4 14:12:31 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/1/20 4:02 AM, Luke Nelson wrote:
> As Daniel suggested to us, we ran our formal verification tool, Serval,
> over the arm JIT. The bugs we found have been patched and applied to the
> bpf tree [1, 2]. This patch series introduces two small optimizations
> that simplify the JIT and use fewer instructions.
> 
> [1] https://lore.kernel.org/bpf/20200408181229.10909-1-luke.r.nels@gmail.com/
> [2] https://lore.kernel.org/bpf/20200409221752.28448-1-luke.r.nels@gmail.com/
> 
> Luke Nelson (2):
>    bpf, arm: Optimize emit_a32_arsh_r64 using conditional instruction
>    bpf, arm: Optimize ALU ARSH K using asr immediate instruction
> 
>   arch/arm/net/bpf_jit_32.c | 14 +++++++++-----
>   arch/arm/net/bpf_jit_32.h |  2 ++
>   2 files changed, 11 insertions(+), 5 deletions(-)
> 

Applied, thanks!
