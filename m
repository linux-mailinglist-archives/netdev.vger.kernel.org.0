Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 999581512C1
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 00:11:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727105AbgBCXLh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 18:11:37 -0500
Received: from www62.your-server.de ([213.133.104.62]:40826 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726474AbgBCXLh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 18:11:37 -0500
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iyksR-0002cV-Ay; Tue, 04 Feb 2020 00:11:35 +0100
Received: from [178.197.249.21] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1iyksQ-00008k-0w; Tue, 04 Feb 2020 00:11:34 +0100
Subject: Re: [PATCH bpf] selftests/bpf: fix trampoline_count.c selftest
 compilation warning
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com
References: <20200202065152.2718142-1-andriin@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <b313bfe5-e10a-4732-21f7-c95f0d9394dd@iogearbox.net>
Date:   Tue, 4 Feb 2020 00:11:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200202065152.2718142-1-andriin@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25715/Mon Feb  3 12:37:20 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/2/20 7:51 AM, Andrii Nakryiko wrote:
> Fix missing braces compilation warning in trampoline_count test:
> 
>    .../prog_tests/trampoline_count.c: In function ‘test_trampoline_count’:
>    .../prog_tests/trampoline_count.c:49:9: warning: missing braces around initializer [-Wmissing-braces]
>    struct inst inst[MAX_TRAMP_PROGS] = { 0 };
>           ^
>    .../prog_tests/trampoline_count.c:49:9: warning: (near initialization for ‘inst[0]’) [-Wmissing-braces]
> 
> Fixes: d633d57902a5 ("selftest/bpf: Add test for allowed trampolines count")
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Applied, thanks!
