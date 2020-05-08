Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2FF71CBB52
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 01:41:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728240AbgEHXlG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 19:41:06 -0400
Received: from www62.your-server.de ([213.133.104.62]:40562 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727778AbgEHXlF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 19:41:05 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jXCc3-0001XZ-LG; Sat, 09 May 2020 01:41:03 +0200
Received: from [178.195.186.98] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jXCc3-000RNt-C4; Sat, 09 May 2020 01:41:03 +0200
Subject: Re: [PATCH bpf-next v5 0/4] bpf: allow any port in bpf_bind helper
To:     Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, Andrey Ignatov <rdna@fb.com>,
        Martin KaFai Lau <kafai@fb.com>
References: <20200508174611.228805-1-sdf@google.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <1791ff9a-becb-58a0-1bc4-590b3aec644c@iogearbox.net>
Date:   Sat, 9 May 2020 01:41:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200508174611.228805-1-sdf@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25806/Fri May  8 14:16:19 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/8/20 7:46 PM, Stanislav Fomichev wrote:
> We want to have a tighter control on what ports we bind to in
> the BPF_CGROUP_INET{4,6}_CONNECT hooks even if it means
> connect() becomes slightly more expensive.
> 
> The series goes like this:
> 1. selftests: move existing helpers that make it easy to create
>     listener threads into common test_progs part
> 2. selftests: move some common functionality into network_helpers
> 3. do small refactoring of __inet{,6}_bind() flags to make it easy
>     to extend them with the additional flags
> 4. remove the restriction on port being zero in bpf_bind() helper;
>     add new bind flag to prevent POST_BIND hook from being called
> 
> Acked-by: Andrey Ignatov <rdna@fb.com>
> Acked-by: Martin KaFai Lau <kafai@fb.com>
> 
> Stanislav Fomichev (4):
>    selftests/bpf: generalize helpers to control background listener
>    selftests/bpf: move existing common networking parts into
>      network_helpers
>    net: refactor arguments of inet{,6}_bind
>    bpf: allow any port in bpf_bind helper
> 

Applied, thanks!
