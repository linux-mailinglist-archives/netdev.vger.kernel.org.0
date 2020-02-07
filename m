Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70685156104
	for <lists+netdev@lfdr.de>; Fri,  7 Feb 2020 23:05:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727517AbgBGWFC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Feb 2020 17:05:02 -0500
Received: from www62.your-server.de ([213.133.104.62]:52278 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727031AbgBGWFB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Feb 2020 17:05:01 -0500
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1j0Bk3-0007YN-EL; Fri, 07 Feb 2020 23:04:51 +0100
Received: from [85.7.42.192] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1j0Bk3-0008GF-1v; Fri, 07 Feb 2020 23:04:51 +0100
Subject: Re: [PATCH bpf] bpf: Improve bucket_log calculation logic
To:     Martin KaFai Lau <kafai@fb.com>, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>, kernel-team@fb.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux-Sparse <linux-sparse@vger.kernel.org>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        netdev@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>
References: <20200207081810.3918919-1-kafai@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <87b3934a-094f-28c1-c5ce-3792c1fa0356@iogearbox.net>
Date:   Fri, 7 Feb 2020 23:04:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200207081810.3918919-1-kafai@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25717/Fri Feb  7 12:45:15 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/7/20 9:18 AM, Martin KaFai Lau wrote:
> It was reported that the max_t, ilog2, and roundup_pow_of_two macros have
> exponential effects on the number of states in the sparse checker.
> 
> This patch breaks them up by calculating the "nbuckets" first so
> that the "bucket_log" only needs to take ilog2().
> 
> Fixes: 6ac99e8f23d4 ("bpf: Introduce bpf sk local storage")
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Reported-by: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
> Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>

Applied (& improved changelog to clarify it's not just sparse), thanks!
