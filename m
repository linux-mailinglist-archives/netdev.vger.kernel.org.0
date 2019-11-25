Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52CAF10893D
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 08:35:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725940AbfKYHfd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 02:35:33 -0500
Received: from www62.your-server.de ([213.133.104.62]:53054 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbfKYHfd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 02:35:33 -0500
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iZ8ty-0004Im-3J; Mon, 25 Nov 2019 08:35:18 +0100
Received: from [178.197.248.11] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1iZ8tx-0004nu-Mq; Mon, 25 Nov 2019 08:35:17 +0100
Subject: Re: linux-next: Signed-off-by missing for commits in the net-next
 tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>
References: <20191125182834.5c97443e@canb.auug.org.au>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <41e3a554-453c-12c0-4686-a571faa05efa@iogearbox.net>
Date:   Mon, 25 Nov 2019 08:35:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20191125182834.5c97443e@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25643/Sun Nov 24 10:57:45 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/25/19 8:28 AM, Stephen Rothwell wrote:
> Hi Dave,
> 
> Commits
> 
>    5940c5bf6504 ("selftests, bpftool: Skip the build test if not in tree")
>    31f8b8295bb8 ("selftests, bpftool: Set EXIT trap after usage function")
>    a89b2cbf71d6 ("tools, bpf: Fix build for 'make -s tools/bpf O=<dir>'")
>    a0f17cc6665c ("tools, bpftool: Fix warning on ignored return value for 'read'")
>    5d946c5abbaf ("xsk: Fix xsk_poll()'s return type")
> 
> are missing a Signed-off-by from their committers.
> 
> Presumably because the bpf-next tree has been rebased before asking you
> to merge it.  :-(

Yep, the tree has been rebased onto net-next in order to avoid an ugly merge
conflict. My maintainer SOB is still there fwiw, but I guess in this situation
would probably have been good add both of ours. Sorry for the trouble.

Thanks,
Daniel
