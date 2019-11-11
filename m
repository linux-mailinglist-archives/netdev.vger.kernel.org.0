Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE31F75C6
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 14:58:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbfKKN6k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 08:58:40 -0500
Received: from www62.your-server.de ([213.133.104.62]:34832 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726811AbfKKN6j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 08:58:39 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iUADA-00081Y-Gr; Mon, 11 Nov 2019 14:58:32 +0100
Received: from [2a02:1205:507e:bf80:bef8:7f66:49c8:72e5] (helo=pc-11.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1iUADA-000Jlu-57; Mon, 11 Nov 2019 14:58:32 +0100
Subject: Re: [PATCH] samples: bpf: fix outdated README build command
To:     "Daniel T. Lee" <danieltimlee@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
References: <20191110081901.20851-1-danieltimlee@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <3db9a7b0-c218-693c-98c5-a45b69429b8a@iogearbox.net>
Date:   Mon, 11 Nov 2019 14:58:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20191110081901.20851-1-danieltimlee@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25630/Mon Nov 11 10:59:49 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/10/19 9:19 AM, Daniel T. Lee wrote:
> Currently, building the bpf samples under samples/bpf directory isn't
> working. Running make from the directory 'samples/bpf' will just shows
> following result without compiling any samples.
> 
>   $ make
>   make -C ../../ /git/linux/samples/bpf/ BPF_SAMPLES_PATH=/git/linux/samples/bpf
>   make[1]: Entering directory '/git/linux'
>     CALL    scripts/checksyscalls.sh
>     CALL    scripts/atomic/check-atomics.sh
>     DESCEND  objtool
>   make[1]: Leaving directory '/git/linux'
> 
> Due to commit 394053f4a4b3 ("kbuild: make single targets work more
> correctly"), building samples/bpf without support of samples/Makefile
> is unavailable. Instead, building the samples with 'make M=samples/bpf'
> from the root source directory will solve this issue.[1]
> 
> This commit fixes the outdated README build command with samples/bpf.
> 
> [0]: https://patchwork.kernel.org/patch/11168393/
> 
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>

Thanks for the patch, Daniel! Looks like it's not rebased to the latest bpf-next
tree and therefore doesn't apply cleanly.

Meanwhile, https://patchwork.ozlabs.org/patch/1192639/ was sent which addresses
the same issue.

Best,
Daniel
