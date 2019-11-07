Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1E8CF34B1
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 17:36:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730074AbfKGQgE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 11:36:04 -0500
Received: from www62.your-server.de ([213.133.104.62]:53518 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729775AbfKGQgD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 11:36:03 -0500
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iSklO-0000Xg-6H; Thu, 07 Nov 2019 17:36:02 +0100
Received: from [178.197.249.41] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1iSklN-000VIt-ML; Thu, 07 Nov 2019 17:36:01 +0100
Subject: Re: [PATCH bpf-next 0/5] Fix bugs and issues found by static analysis
 in libbpf
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com
References: <20191107020855.3834758-1-andriin@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <34069e64-e39c-f095-ad94-9f67f88e0c64@iogearbox.net>
Date:   Thu, 7 Nov 2019 17:35:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20191107020855.3834758-1-andriin@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25626/Thu Nov  7 10:50:48 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/7/19 3:08 AM, Andrii Nakryiko wrote:
> Github's mirror of libbpf got LGTM and Coverity statis analysis running
> against it and spotted few real bugs and few potential issues. This patch
> series fixes found issues.
> 
> Andrii Nakryiko (5):
>    libbpf: fix memory leak/double free issue
>    libbpf: fix potential overflow issue
>    libbpf: fix another potential overflow issue in bpf_prog_linfo
>    libbpf: make btf__resolve_size logic always check size error condition
>    libbpf: improve handling of corrupted ELF during map initialization
> 
>   tools/lib/bpf/bpf.c            |  2 +-
>   tools/lib/bpf/bpf_prog_linfo.c | 14 +++++++-------
>   tools/lib/bpf/btf.c            |  3 +--
>   tools/lib/bpf/libbpf.c         |  6 +++---
>   4 files changed, 12 insertions(+), 13 deletions(-)
> 

All look good, applied, thanks!
