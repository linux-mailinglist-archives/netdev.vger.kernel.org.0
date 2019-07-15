Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 055C569EE0
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 00:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733061AbfGOWST (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 18:18:19 -0400
Received: from www62.your-server.de ([213.133.104.62]:33794 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727862AbfGOWSS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 18:18:18 -0400
Received: from [78.46.172.3] (helo=sslproxy06.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hn9IW-0001m5-TG; Tue, 16 Jul 2019 00:18:16 +0200
Received: from [99.0.85.34] (helo=localhost.localdomain)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hn9IW-000BPj-Gu; Tue, 16 Jul 2019 00:18:16 +0200
Subject: Re: [PATCH v3 bpf 0/3] fix BTF verification size resolution
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, yhs@fb.com
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com
References: <20190712172557.4039121-1-andriin@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <499d90ef-a008-a9f4-e663-12d5f20796c1@iogearbox.net>
Date:   Tue, 16 Jul 2019 00:18:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190712172557.4039121-1-andriin@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25511/Mon Jul 15 10:10:35 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/12/19 7:25 PM, Andrii Nakryiko wrote:
> BTF size resolution logic isn't always resolving type size correctly, leading
> to erroneous map creation failures due to value size mismatch.
> 
> This patch set:
> 1. fixes the issue (patch #1);
> 2. adds tests for trickier cases (patch #2);
> 3. and converts few test cases utilizing BTF-defined maps, that previously
>    couldn't use typedef'ed arrays due to kernel bug (patch #3).
> 
> Andrii Nakryiko (3):
>   bpf: fix BTF verifier size resolution logic
>   selftests/bpf: add trickier size resolution tests
>   selftests/bpf: use typedef'ed arrays as map values
> 
>  kernel/bpf/btf.c                              | 19 ++--
>  .../bpf/progs/test_get_stack_rawtp.c          |  3 +-
>  .../bpf/progs/test_stacktrace_build_id.c      |  3 +-
>  .../selftests/bpf/progs/test_stacktrace_map.c |  2 +-
>  tools/testing/selftests/bpf/test_btf.c        | 88 +++++++++++++++++++
>  5 files changed, 104 insertions(+), 11 deletions(-)
> 

Applied, thanks!
