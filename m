Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA99546CD3
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 01:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbfFNXWw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 19:22:52 -0400
Received: from www62.your-server.de ([213.133.104.62]:41102 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726369AbfFNXWv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 19:22:51 -0400
Received: from [78.46.172.2] (helo=sslproxy05.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hbvWw-0008Hb-Tp; Sat, 15 Jun 2019 01:22:46 +0200
Received: from [178.199.41.31] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hbvWw-000AaQ-M8; Sat, 15 Jun 2019 01:22:46 +0200
Subject: Re: [PATCH v3 bpf-next 0/3] bpf: net: Detach BPF prog from reuseport
 sk
To:     Martin KaFai Lau <kafai@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@fb.com>,
        David Miller <davem@davemloft.net>, kernel-team@fb.com,
        Stanislav Fomichev <sdf@fomichev.me>
References: <20190613215959.3095374-1-kafai@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <82703e8b-4136-65a0-6f7f-72da8977a625@iogearbox.net>
Date:   Sat, 15 Jun 2019 01:22:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190613215959.3095374-1-kafai@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25480/Fri Jun 14 10:12:45 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/13/2019 11:59 PM, Martin KaFai Lau wrote:
> v3:
> - Use rcu_swap_protected (Stanislav Fomichev)
> - Use 0x0047 for SO_DETACH_REUSEPORT_BPF for sparc (kbuild test robot <lkp@intel.com>)
> 
> v2:
> - Copy asm-generic/socket.h to tools/ in the new patch 2 (Stanislav Fomichev)
> 
> This patch adds SO_DETACH_REUSEPORT_BPF to detach BPF prog from
> reuseport sk.
> 
> Martin KaFai Lau (3):
>   bpf: net: Add SO_DETACH_REUSEPORT_BPF
>   bpf: Sync asm-generic/socket.h to tools/
>   bpf: Add test for SO_REUSEPORT_DETACH_BPF
> 
>  arch/alpha/include/uapi/asm/socket.h          |  2 +
>  arch/mips/include/uapi/asm/socket.h           |  2 +
>  arch/parisc/include/uapi/asm/socket.h         |  2 +
>  arch/sparc/include/uapi/asm/socket.h          |  2 +
>  include/net/sock_reuseport.h                  |  2 +
>  include/uapi/asm-generic/socket.h             |  2 +
>  net/core/sock.c                               |  4 ++
>  net/core/sock_reuseport.c                     | 24 +++++++++
>  .../include}/uapi/asm-generic/socket.h        |  2 +
>  .../selftests/bpf/test_select_reuseport.c     | 54 +++++++++++++++++++
>  10 files changed, 96 insertions(+)
>  copy {include => tools/include}/uapi/asm-generic/socket.h (98%)
> 

Applied, thanks!
