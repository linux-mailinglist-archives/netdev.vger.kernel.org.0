Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C85404A9C24
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 16:42:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359808AbiBDPmP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 10:42:15 -0500
Received: from www62.your-server.de ([213.133.104.62]:33468 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359802AbiBDPmO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 10:42:14 -0500
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nG0iq-0002u6-Oo; Fri, 04 Feb 2022 16:42:04 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nG0iq-000V8b-BR; Fri, 04 Feb 2022 16:42:04 +0100
Subject: Re: [PATCH bpf-next v3 1/3] bpf, arm64: enable kfunc call
To:     Hou Tao <hotforest@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org, houtao1@huawei.com,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@arm.com>,
        linux-arm-kernel@lists.infradead.org
References: <20220130092917.14544-1-hotforest@gmail.com>
 <20220130092917.14544-2-hotforest@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <1345374f-d47c-81da-e7f3-57b9c22a6328@iogearbox.net>
Date:   Fri, 4 Feb 2022 16:42:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220130092917.14544-2-hotforest@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26443/Fri Feb  4 10:22:38 2022)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/30/22 10:29 AM, Hou Tao wrote:
> From: Hou Tao <houtao1@huawei.com>
> 
> Since commit b2eed9b58811 ("arm64/kernel: kaslr: reduce module
> randomization range to 2 GB"), for arm64 whether KASLR is enabled
> or not, the module is placed within 2GB of the kernel region, so
> s32 in bpf_kfunc_desc is sufficient to represente the offset of
> module function relative to __bpf_call_base. The only thing needed
> is to override bpf_jit_supports_kfunc_call().
> 
> Signed-off-by: Hou Tao <houtao1@huawei.com>

Could you rebase patch 2 & 3 and resend as they don't apply to bpf-next
right now. Meanwhile, applied this one, thanks a lot!
