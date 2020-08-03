Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45AF623AFD9
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 23:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727091AbgHCVzh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 17:55:37 -0400
Received: from www62.your-server.de ([213.133.104.62]:60012 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726239AbgHCVzg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 17:55:36 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1k2iQg-0001sR-Pa; Mon, 03 Aug 2020 23:55:34 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1k2iQg-000PXH-Jb; Mon, 03 Aug 2020 23:55:34 +0200
Subject: Re: [PATCH bpf-next v6 0/2] bpf: cgroup skb improvements for
 bpf_prog_test_run
To:     Dmitry Yakunin <zeil@yandex-team.ru>, alexei.starovoitov@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     eric.dumazet@gmail.com, sdf@google.com
References: <20200803090545.82046-1-zeil@yandex-team.ru>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <a980acba-03cf-b3c3-7f49-20740bcdeb08@iogearbox.net>
Date:   Mon, 3 Aug 2020 23:55:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200803090545.82046-1-zeil@yandex-team.ru>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25893/Mon Aug  3 17:01:47 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/3/20 11:05 AM, Dmitry Yakunin wrote:
> This patchset contains some improvements for testing cgroup/skb programs
> through BPF_PROG_TEST_RUN command.
> 
> v2:
>    - fix build without CONFIG_CGROUP_BPF (kernel test robot <lkp@intel.com>)
> 
> v3:
>    - fix build without CONFIG_IPV6 (kernel test robot <lkp@intel.com>)
> 
> v4:
>    - remove cgroup storage related commits for future rework (Daniel Borkmann)
> 
> v5:
>    - check skb length before access to inet headers (Eric Dumazet)
> 
> v6:
>    - do not use pskb_may_pull() in skb length checking (Alexei Starovoitov)
> 
> Dmitry Yakunin (2):
>    bpf: setup socket family and addresses in bpf_prog_test_run_skb
>    bpf: allow to specify ifindex for skb in bpf_prog_test_run_skb
> 
>   net/bpf/test_run.c                               | 39 ++++++++++++++++++++++--
>   tools/testing/selftests/bpf/prog_tests/skb_ctx.c |  5 +++
>   2 files changed, 42 insertions(+), 2 deletions(-)
> 

Looks good, applied, thanks!
