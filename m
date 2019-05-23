Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B697528007
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 16:43:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730846AbfEWOnE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 10:43:04 -0400
Received: from www62.your-server.de ([213.133.104.62]:60348 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730719AbfEWOnE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 10:43:04 -0400
Received: from [78.46.172.2] (helo=sslproxy05.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hTovp-0007x8-Mv; Thu, 23 May 2019 16:42:57 +0200
Received: from [178.197.249.12] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hTovp-000HEs-HW; Thu, 23 May 2019 16:42:57 +0200
Subject: Re: [PATCH v2 bpf-next 0/3] bpf: increase jmp sequence limit
To:     Alexei Starovoitov <ast@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
References: <20190522031421.2825174-1-ast@kernel.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <6c85c980-52da-c012-4879-8cc10bfca13c@iogearbox.net>
Date:   Thu, 23 May 2019 16:42:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190522031421.2825174-1-ast@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25458/Thu May 23 09:58:32 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/22/2019 05:14 AM, Alexei Starovoitov wrote:
> Patch 1 - jmp sequence limit
> Patch 2 - improve existing tests
> Patch 3 - add pyperf-based realistic bpf program that takes advantage
> of higher limit and use it as a stress test
> 
> v1->v2: fixed nit in patch 3. added Andrii's acks
> 
> Alexei Starovoitov (3):
>   bpf: bump jmp sequence limit
>   selftests/bpf: adjust verifier scale test
>   selftests/bpf: add pyperf scale test
> 
>  kernel/bpf/verifier.c                         |   7 +-
>  .../bpf/prog_tests/bpf_verif_scale.c          |  31 +-
>  tools/testing/selftests/bpf/progs/pyperf.h    | 268 ++++++++++++++++++
>  tools/testing/selftests/bpf/progs/pyperf100.c |   4 +
>  tools/testing/selftests/bpf/progs/pyperf180.c |   4 +
>  tools/testing/selftests/bpf/progs/pyperf50.c  |   4 +
>  tools/testing/selftests/bpf/test_verifier.c   |  31 +-
>  7 files changed, 319 insertions(+), 30 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/progs/pyperf.h
>  create mode 100644 tools/testing/selftests/bpf/progs/pyperf100.c
>  create mode 100644 tools/testing/selftests/bpf/progs/pyperf180.c
>  create mode 100644 tools/testing/selftests/bpf/progs/pyperf50.c
> 

Looks good, applied, thanks!
