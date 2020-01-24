Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A73A147E86
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 11:13:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388948AbgAXKL2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 05:11:28 -0500
Received: from www62.your-server.de ([213.133.104.62]:52746 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387697AbgAXKL1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 05:11:27 -0500
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iuvvx-0000xF-4G; Fri, 24 Jan 2020 11:11:25 +0100
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=linux-3.fritz.box)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1iuvvw-000UdM-S6; Fri, 24 Jan 2020 11:11:24 +0100
Subject: Re: [PATCH bpf-next] selftests/bpf: initialize duration variable
 before using
To:     Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org,
        John Sperbeck <jsperbeck@google.com>
References: <20200123235144.93610-1-sdf@google.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <d1c43289-e79d-1d89-f9e9-84acfed772d7@iogearbox.net>
Date:   Fri, 24 Jan 2020 11:11:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200123235144.93610-1-sdf@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25704/Thu Jan 23 12:37:43 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/24/20 12:51 AM, Stanislav Fomichev wrote:
> From: John Sperbeck <jsperbeck@google.com>
> 
> The 'duration' variable is referenced in the CHECK() macro, and there are
> some uses of the macro before 'duration' is set.  The clang compiler
> (validly) complains about this.
> 
> Sample error:
> 
> .../selftests/bpf/prog_tests/fexit_test.c:23:6: warning: variable 'duration' is uninitialized when used here [-Wuninitialized]
>          if (CHECK(err, "prog_load sched cls", "err %d errno %d\n", err, errno))
>              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> .../selftests/bpf/test_progs.h:134:25: note: expanded from macro 'CHECK'
>          if (CHECK(err, "prog_load sched cls", "err %d errno %d\n", err, errno))
>              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>          _CHECK(condition, tag, duration, format)
>                                 ^~~~~~~~
> 
> Signed-off-by: John Sperbeck <jsperbeck@google.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>

Applied, thanks!
