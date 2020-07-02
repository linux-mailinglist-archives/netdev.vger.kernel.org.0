Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9526212F63
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 00:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726302AbgGBWR2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 18:17:28 -0400
Received: from www62.your-server.de ([213.133.104.62]:56938 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725937AbgGBWR2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 18:17:28 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jr7WI-0001uy-0b; Fri, 03 Jul 2020 00:17:26 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jr7WH-0009fC-PD; Fri, 03 Jul 2020 00:17:25 +0200
Subject: Re: [PATCH v2 bpf-next 0/2] bpf: selftests: A few changes to
 network_helpers and netns-reset
To:     Martin KaFai Lau <kafai@fb.com>, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>, kernel-team@fb.com,
        netdev@vger.kernel.org
References: <20200702004846.2101805-1-kafai@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <92b5e5bc-53bf-aff0-377b-39cafdf8b0f7@iogearbox.net>
Date:   Fri, 3 Jul 2020 00:17:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200702004846.2101805-1-kafai@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25861/Thu Jul  2 15:47:32 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/2/20 2:48 AM, Martin KaFai Lau wrote:
> This set is separated out from the bpf tcp header option series [1] since
> I think it is in general useful for other network related tests.
> e.g. enforce socket-fd related timeout and restore netns after each test.
> 
> [1]: https://lore.kernel.org/netdev/20200626175501.1459961-1-kafai@fb.com/
> 
> v2:
> - Mention non-NULL addr use case in commit message. (Yonghong)
> - Add prefix "__" to variables used in macro. (Yonghong)
> 
> Martin KaFai Lau (2):
>    bpf: selftests: A few improvements to network_helpers.c
>    bpf: selftests: Restore netns after each test
> 
>   tools/testing/selftests/bpf/network_helpers.c | 157 +++++++++++-------
>   tools/testing/selftests/bpf/network_helpers.h |   9 +-
>   .../bpf/prog_tests/cgroup_skb_sk_lookup.c     |  12 +-
>   .../bpf/prog_tests/connect_force_port.c       |  10 +-
>   .../bpf/prog_tests/load_bytes_relative.c      |   4 +-
>   .../selftests/bpf/prog_tests/tcp_rtt.c        |   4 +-
>   tools/testing/selftests/bpf/test_progs.c      |  23 ++-
>   tools/testing/selftests/bpf/test_progs.h      |   2 +
>   8 files changed, 133 insertions(+), 88 deletions(-)
> 

Applied, thanks!
