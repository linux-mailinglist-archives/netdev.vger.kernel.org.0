Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24872483F13
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 10:21:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbiADJVd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 04:21:33 -0500
Received: from www62.your-server.de ([213.133.104.62]:57138 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiADJVd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 04:21:33 -0500
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1n4g0V-0007Gq-6k; Tue, 04 Jan 2022 10:21:27 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1n4g0U-000Dvu-Tq; Tue, 04 Jan 2022 10:21:26 +0100
Subject: Re: [PATCH net] bpf: Add missing map_get_next_key method to bloom
 filter map
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>, bpf <bpf@vger.kernel.org>,
        syzbot <syzkaller@googlegroups.com>, Yonghong Song <yhs@fb.com>,
        joannekoong@fb.com
References: <20220104090130.3121751-1-eric.dumazet@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <d5776f5d-3416-4e3b-8751-8a5a9e6a0d4d@iogearbox.net>
Date:   Tue, 4 Jan 2022 10:21:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220104090130.3121751-1-eric.dumazet@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26411/Mon Jan  3 10:24:00 2022)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric, [ +Joanne, ]

On 1/4/22 10:01 AM, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> It appears map_get_next_key() method is mandatory,
> as syzbot is able to trigger a NULL deref in map_get_next_key().
> 
> Fixes: 9330986c0300 ("bpf: Add bloom filter map implementation")
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Yonghong Song <yhs@fb.com>

Thanks for your patch, this has recently been fixed:

   https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=3ccdcee28415c4226de05438b4d89eb5514edf73

I'm not quite sure why it was applied to bpf-next instead of bpf (maybe assumption was
that there would be no rc8 anymore), but I'd expect it to land in Linus' tree once merge
window opens up on 9th Jan. In that case stable team would have to pick it up for 5.16.

Thanks,
Daniel
