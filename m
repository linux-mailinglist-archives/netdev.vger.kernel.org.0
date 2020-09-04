Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD7525E3A8
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 00:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728116AbgIDWYd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 18:24:33 -0400
Received: from www62.your-server.de ([213.133.104.62]:57684 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727057AbgIDWYd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 18:24:33 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kEK8F-0000pm-K0; Sat, 05 Sep 2020 00:24:31 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kEK8F-00053M-EK; Sat, 05 Sep 2020 00:24:31 +0200
Subject: Re: [PATCH bpf-next 1/2] samples: bpf: Replace bpf_program__title()
 with bpf_program__section_name()
To:     "Daniel T. Lee" <danieltimlee@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
References: <20200904063434.24963-1-danieltimlee@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <b24c21f4-23dc-b704-4d46-9edcd3bbecad@iogearbox.net>
Date:   Sat, 5 Sep 2020 00:24:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200904063434.24963-1-danieltimlee@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25920/Fri Sep  4 15:46:46 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/4/20 8:34 AM, Daniel T. Lee wrote:
>  From commit 521095842027 ("libbpf: Deprecate notion of BPF program
> "title" in favor of "section name""), the term title has been replaced
> with section name in libbpf.
> 
> Since the bpf_program__title() has been deprecated, this commit
> switches this function to bpf_program__section_name(). Due to
> this commit, the compilation warning issue has also been resolved.
> 
> Fixes: 521095842027 ("libbpf: Deprecate notion of BPF program "title" in favor of "section name"")
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>

Both applied, thanks!
