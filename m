Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF55C54ED8
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 14:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731312AbfFYM3N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 08:29:13 -0400
Received: from www62.your-server.de ([213.133.104.62]:58856 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727485AbfFYM3N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 08:29:13 -0400
Received: from [78.46.172.3] (helo=sslproxy06.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hfkZO-0005rK-Fn; Tue, 25 Jun 2019 14:29:06 +0200
Received: from [178.199.41.31] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hfkZO-000RXE-7h; Tue, 25 Jun 2019 14:29:06 +0200
Subject: Re: [PATCH v3 bpf-next 0/2] veth: Bulk XDP_TX
To:     Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     netdev@vger.kernel.org, xdp-newbies@vger.kernel.org,
        bpf@vger.kernel.org,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Jason Wang <jasowang@redhat.com>
References: <20190613093959.2796-1-toshiaki.makita1@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <2ee794bc-403b-84c5-da8f-3cbabf52dff7@iogearbox.net>
Date:   Tue, 25 Jun 2019 14:29:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190613093959.2796-1-toshiaki.makita1@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25491/Tue Jun 25 10:02:48 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/13/2019 11:39 AM, Toshiaki Makita wrote:
> This introduces bulk XDP_TX in veth.
> Improves XDP_TX performance by approximately 9%. The detailed
> explanation and performance numbers are shown in patch 2.
> 
> v2:
> - Use stack for bulk queue instead of a global variable.
> 
> v3:
> - Add act field to xdp_bulk_tx tracepoint to be in line with other XDP
>   tracepoints.
> 
> Signed-off-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
> 
> Toshiaki Makita (2):
>   xdp: Add tracepoint for bulk XDP_TX
>   veth: Support bulk XDP_TX
> 
>  drivers/net/veth.c         | 60 ++++++++++++++++++++++++++++++++++++----------
>  include/trace/events/xdp.h | 29 ++++++++++++++++++++++
>  kernel/bpf/core.c          |  1 +
>  3 files changed, 78 insertions(+), 12 deletions(-)
> 

Applied, thanks!
