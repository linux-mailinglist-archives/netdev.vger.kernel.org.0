Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B1AD44E24
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 23:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729897AbfFMVLi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 17:11:38 -0400
Received: from www62.your-server.de ([213.133.104.62]:36644 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbfFMVLi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 17:11:38 -0400
Received: from [78.46.172.2] (helo=sslproxy05.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hbX0S-0004am-6r; Thu, 13 Jun 2019 23:11:36 +0200
Received: from [178.199.41.31] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hbX0S-000WZf-1i; Thu, 13 Jun 2019 23:11:36 +0200
Subject: Re: [PATCH 0/2] powerpc/bpf: DIV64 instruction fix
To:     "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
References: <cover.1560364574.git.naveen.n.rao@linux.vnet.ibm.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <a6fe940f-94bb-1b8f-ecd2-5e8e003a3f57@iogearbox.net>
Date:   Thu, 13 Jun 2019 23:11:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <cover.1560364574.git.naveen.n.rao@linux.vnet.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25479/Thu Jun 13 10:12:53 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/12/2019 08:51 PM, Naveen N. Rao wrote:
> The first patch updates DIV64 overflow tests to properly detect error 
> conditions. The second patch fixes powerpc64 JIT to generate the proper 
> unsigned division instruction for BPF_ALU64.
> 
> - Naveen
> 
> Naveen N. Rao (2):
>   bpf: fix div64 overflow tests to properly detect errors
>   powerpc/bpf: use unsigned division instruction for 64-bit operations
> 
>  arch/powerpc/include/asm/ppc-opcode.h              |  1 +
>  arch/powerpc/net/bpf_jit.h                         |  2 +-
>  arch/powerpc/net/bpf_jit_comp64.c                  |  8 ++++----
>  .../testing/selftests/bpf/verifier/div_overflow.c  | 14 ++++++++++----
>  4 files changed, 16 insertions(+), 9 deletions(-)
> 

LGTM, applied to bpf, thanks!
