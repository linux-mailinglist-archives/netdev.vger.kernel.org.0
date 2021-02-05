Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E18F3110FC
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 20:21:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233509AbhBERhy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 12:37:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233055AbhBEP5j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 10:57:39 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18AACC0613D6;
        Fri,  5 Feb 2021 09:39:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=K9RAcQUU8wl+QmrBr2wtAwlL0UcIu0I2afA4jOYwzNw=; b=1qmVu5Mv3ZaHZyVBwQY1aUmjNx
        zSB3NH20gVNyuBC+1FCnETTO1ot3gEVpbEFIUUyjXAB9IX83ysqQpvt1yAlfVegNfdA1MituRl0H/
        V4yF9EVDPL2CZgGrlGtXWRM3NQPIWzFx66ZW1svN6imAL6biwrbKG6r8Z9FBTBA+FCyPvjaxY2j+6
        lnnaP89tHFFOtQrQ7yru/uYBmOsQfGpOBBzKjjq7n6LqSBM71MH4Tu3EqxCo/drb94e08JZyRUxJv
        ZRH7WafNyuxdE+Myo1yZUAR7kJYJum8R9rLbgSZnjqvC/LQMZ2ZR4AWcJae2gMfVgRPJRWCOHZNeX
        gKZgw4Yw==;
Received: from [2601:1c0:6280:3f0::aec2]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1l854e-0006xb-O6; Fri, 05 Feb 2021 17:39:17 +0000
Subject: Re: [PATCH bpf] selftests/bpf: use bash instead of sh in
 test_xdp_redirect.sh
To:     William Tu <u9012063@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
References: <20210205170950.145042-1-bjorn.topel@gmail.com>
 <CALDO+SZhgSr5haWT=c1b-+WMpeaPGkDYoxCoWtTaX2+L85WEJA@mail.gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <b186bc7e-2b0b-58b8-065e-c77255b6aecb@infradead.org>
Date:   Fri, 5 Feb 2021 09:39:12 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <CALDO+SZhgSr5haWT=c1b-+WMpeaPGkDYoxCoWtTaX2+L85WEJA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/5/21 9:30 AM, William Tu wrote:
> On Fri, Feb 5, 2021 at 9:09 AM Björn Töpel <bjorn.topel@gmail.com> wrote:
>>
>> From: Björn Töpel <bjorn.topel@intel.com>
>>
>> The test_xdp_redirect.sh script uses some bash-features, such as
>> '&>'. On systems that use dash as the sh implementation this will not
>> work as intended. Change the shebang to use bash instead.

Hi,
In general we (kernel, maybe not bpf) try to move away from bash to a more
"standard" sh shell, so things like "&>" would be converted to ">file 2>&1"
or whatever is needed.

>> Also remove the 'set -e' since the script actually relies on that the
>> return value can be used to determine pass/fail of the test.
>>
>> Fixes: 996139e801fd ("selftests: bpf: add a test for XDP redirect")
>> Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
>> ---
> LGTM, thanks.
> Acked-by: William Tu <u9012063@gmail.com>
> 


-- 
~Randy

