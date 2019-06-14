Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A666D46C9E
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 01:07:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726392AbfFNXHa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 19:07:30 -0400
Received: from www62.your-server.de ([213.133.104.62]:38128 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725993AbfFNXHa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 19:07:30 -0400
Received: from [88.198.220.132] (helo=sslproxy03.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hbvHw-0006Kr-16; Sat, 15 Jun 2019 01:07:16 +0200
Received: from [178.199.41.31] (helo=linux.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hbvHv-0001wk-NH; Sat, 15 Jun 2019 01:07:15 +0200
Subject: Re: [PATCH bpf 1/3] devmap: Fix premature entry free on destroying
 map
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     netdev@vger.kernel.org, xdp-newbies@vger.kernel.org,
        bpf@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        David Ahern <dsahern@gmail.com>
References: <20190614082015.23336-1-toshiaki.makita1@gmail.com>
 <20190614082015.23336-2-toshiaki.makita1@gmail.com> <877e9octre.fsf@toke.dk>
 <87sgscbc5d.fsf@toke.dk> <fb895684-c863-e580-f36a-30722c480b41@gmail.com>
 <87muikb9ev.fsf@toke.dk>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <5f6efec8-87f8-4ac5-46ee-47788dbf1d44@iogearbox.net>
Date:   Sat, 15 Jun 2019 01:07:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <87muikb9ev.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25480/Fri Jun 14 10:12:45 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/14/2019 03:09 PM, Toke Høiland-Jørgensen wrote:
> Toshiaki Makita <toshiaki.makita1@gmail.com> writes:
[...]
>>> Alternatively, since this entire series should probably go to stable, I
>>> can respin mine on top of it?
>>
>> Indeed conflict will happen, as this is for 'bpf' not 'bpf-next'.
>> Sorry for disturbing your work.
> 
> Oh, no worries!
> 
>> I'm also not sure how to proceed in this case.
> 
> I guess we'll leave that up to the maintainers :)

So all three look good to me, I've applied them to bpf tree. Fixes to bpf do
have precedence over patches to bpf-next given they need to land in the current
release. I'll get bpf out later tonight and ask David to merge net into net-next
after that since rebase is also needed for Stanislav's cgroup series. We'll then
flush out bpf-next so we can fast-fwd to net-next to pull in all the dependencies.

Thanks a lot,
Daniel
