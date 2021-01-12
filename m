Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED612F3DA1
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 01:44:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437157AbhALVhF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 16:37:05 -0500
Received: from www62.your-server.de ([213.133.104.62]:58750 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436901AbhALUWb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 15:22:31 -0500
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1kzQAn-00072e-Gt; Tue, 12 Jan 2021 21:21:49 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kzQAn-0009jQ-8E; Tue, 12 Jan 2021 21:21:49 +0100
Subject: Re: [PATCH bpf 1/2] bpf: support PTR_TO_MEM{,_OR_NULL} register
 spilling
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Gilad Reti <gilad.reti@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20210112091403.10458-1-gilad.reti@gmail.com>
 <CAEf4BzY2ezxxeUbhMy-kw-zRv974JG2NAQ+2g5_rtVSn8EmNcw@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <c532894e-2934-b6ae-103d-ade0ed5b7792@iogearbox.net>
Date:   Tue, 12 Jan 2021 21:21:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAEf4BzY2ezxxeUbhMy-kw-zRv974JG2NAQ+2g5_rtVSn8EmNcw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26047/Tue Jan 12 13:33:56 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/12/21 8:46 PM, Andrii Nakryiko wrote:
> On Tue, Jan 12, 2021 at 1:14 AM Gilad Reti <gilad.reti@gmail.com> wrote:
>>
>> Add support for pointer to mem register spilling, to allow the verifier
>> to track pointer to valid memory addresses. Such pointers are returned
>> for example by a successful call of the bpf_ringbuf_reserve helper.
>>
>> This patch was suggested as a solution by Yonghong Song.
>>
>> The patch was partially contibuted by CyberArk Software, Inc.
>>
>> Fixes: 457f44363a88 ("bpf: Implement BPF ring buffer and verifier
>> support for it")
> 
> Surprised no one mentioned this yet. Fixes tag should always be on a
> single unwrapped line, however long it is, please fix.

Especially for first-time contributors there is usually some luxury that we
would have fixed this up on the fly while applying. ;) But given a v2 is going
to be sent anyway it's good to point it out for future reference, agree.

Thanks,
Daniel
