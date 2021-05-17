Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8550C383BB7
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 19:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236650AbhEQRz2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 13:55:28 -0400
Received: from www62.your-server.de ([213.133.104.62]:45894 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236507AbhEQRz1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 13:55:27 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lihRP-0008yP-Mf; Mon, 17 May 2021 19:54:07 +0200
Received: from [85.7.101.30] (helo=linux.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lihRP-000Nus-DO; Mon, 17 May 2021 19:54:07 +0200
Subject: Re: [PATCH bpf-next v7 0/3] Add TC-BPF API
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Shaun Crampton <shaun@tigera.io>, netdev@vger.kernel.org
References: <20210512103451.989420-1-memxor@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <6e3e344c-1b04-b330-c91b-fda92be02a23@iogearbox.net>
Date:   Mon, 17 May 2021 19:54:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210512103451.989420-1-memxor@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26173/Mon May 17 13:11:33 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/12/21 12:34 PM, Kumar Kartikeya Dwivedi wrote:
> This is the seventh version of the TC-BPF series.
> 
> It adds a simple API that uses netlink to attach the tc filter and its bpf
> classifier program. Currently, a user needs to shell out to the tc command line
> to be able to create filters and attach SCHED_CLS programs as classifiers. With
> the help of this API, it will be possible to use libbpf for doing all parts of
> bpf program setup and attach.
> 
> Changelog contains details of patchset evolution.
> 
> In an effort to keep discussion focused, this series doesn't have the high level
> TC-BPF API. It was clear that there is a need for a bpf_link API in the kernel,
> hence that will be submitted as a separate patchset based on this.
> 
> The individual commit messages contain more details, and also a brief summary of
> the API.
> 
> Changelog:
> ----------
> v6 -> v7
> v6: https://lore.kernel.org/bpf/20210504005023.1240974-1-memxor@gmail.com
> 
>   * Address all comments from Daniel
>     * Rename BPF_NL_* to NL_*
>     * Make bpf_tc_query only support targeted query
>     * Adjust inconsistencies in the commit message
>     * Drop RTM_GETTFILTER NLM_F_DUMP support
>     * Other misc cleanups (also remove bpf_tc_query selftest for dump mode)

Still had to do a major patch cleanup on the first two before pushing out, but I
think it looks nice now and I do like the simple/straight forward API for tc/BPF.

Anyway, applied, thanks!
