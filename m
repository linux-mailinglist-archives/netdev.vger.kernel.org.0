Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63D32206419
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 23:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393464AbgFWVQC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 17:16:02 -0400
Received: from www62.your-server.de ([213.133.104.62]:48478 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391205AbgFWVQB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 17:16:01 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jnqGt-00040a-99; Tue, 23 Jun 2020 23:15:59 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jnqGt-000S0y-01; Tue, 23 Jun 2020 23:15:59 +0200
Subject: Re: [PATCH v3 bpf-next 2/3] selftests/bpf: add variable-length data
 concatenation pattern test
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        Kernel Team <kernel-team@fb.com>
References: <20200623032224.4020118-1-andriin@fb.com>
 <20200623032224.4020118-2-andriin@fb.com>
 <7ed6ada5-2539-3090-0db7-0f65b67e4699@iogearbox.net>
 <CAEf4BzbsRyt5Y4-oMaKTUNu_ijnRD09+WW3iA+bfGLZcLpd77w@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <ee6df475-b7d4-b8ed-dc91-560e42d2e7fc@iogearbox.net>
Date:   Tue, 23 Jun 2020 23:15:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAEf4BzbsRyt5Y4-oMaKTUNu_ijnRD09+WW3iA+bfGLZcLpd77w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25852/Tue Jun 23 15:09:58 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/23/20 10:52 PM, Andrii Nakryiko wrote:
> On Tue, Jun 23, 2020 at 1:39 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>> On 6/23/20 5:22 AM, Andrii Nakryiko wrote:
>>> Add selftest that validates variable-length data reading and concatentation
>>> with one big shared data array. This is a common pattern in production use for
>>> monitoring and tracing applications, that potentially can read a lot of data,
>>> but overall read much less. Such pattern allows to determine precisely what
>>> amount of data needs to be sent over perfbuf/ringbuf and maximize efficiency.
>>>
>>> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>>
>> Currently getting the below errors on these tests. My last clang/llvm git build
>> is on 4676cf444ea2 ("[Clang] Skip adding begin source location for PragmaLoopHint'd
>> loop when[...]"):
> 
> Yeah, you need 02553b91da5d ("bpf: bpf_probe_read_kernel_str() has to
> return amount of data read on success") from bpf tree.

Fair point, it's in net- but not yet in net-next tree, so bpf-next sync needs
to wait.

> I'm eagerly awaiting bpf being merged into bpf-next :)

I'll cherry-pick 02553b91da5d locally for testing and if it passes I'll push
these out.

Thanks,
Daniel
