Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE24EC27B
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 13:10:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727487AbfKAMKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 08:10:20 -0400
Received: from www62.your-server.de ([213.133.104.62]:34942 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726783AbfKAMKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 08:10:20 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iQVks-00044S-Ce; Fri, 01 Nov 2019 13:10:14 +0100
Received: from [178.197.249.38] (helo=pc-63.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1iQVks-000Cts-2z; Fri, 01 Nov 2019 13:10:14 +0100
Subject: Re: [PATCH net 0/3] fix BPF offload related bugs
To:     Jakub Kicinski <jakub.kicinski@netronome.com>, davem@davemloft.net
Cc:     alexei.starovoitov@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, oss-drivers@netronome.com
References: <20191101030700.13080-1-jakub.kicinski@netronome.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <fe57af03-c42d-0f87-b712-30c5048764ad@iogearbox.net>
Date:   Fri, 1 Nov 2019 13:10:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20191101030700.13080-1-jakub.kicinski@netronome.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25620/Fri Nov  1 10:04:15 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/1/19 4:06 AM, Jakub Kicinski wrote:
> Hi!
> 
> test_offload.py catches some recently added bugs.
> 
> First of a bug in test_offload.py itself after recent changes
> to netdevsim is fixed.
> 
> Second patch fixes a bug in cls_bpf, and last one addresses
> a problem with the recently added XDP installation optimization.
> 
> Jakub Kicinski (3):
>    selftests: bpf: Skip write only files in debugfs
>    net: cls_bpf: fix NULL deref on offload filter removal
>    net: fix installing orphaned programs
> 
>   net/core/dev.c                              | 3 ++-
>   net/sched/cls_bpf.c                         | 8 ++++++--
>   tools/testing/selftests/bpf/test_offload.py | 5 +++++
>   3 files changed, 13 insertions(+), 3 deletions(-)

Should this go via -bpf or -net? Either way is fine, but asking
given it's BPF related fixes; planning to do a PR in the evening,
set looks good to me in any case.

Thanks,
Daniel
