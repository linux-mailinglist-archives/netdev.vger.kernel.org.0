Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE33887EFB
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 18:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437021AbfHIQI5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 12:08:57 -0400
Received: from www62.your-server.de ([213.133.104.62]:58552 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436626AbfHIQI5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 12:08:57 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <borkmann@iogearbox.net>)
        id 1hw7Ri-0002hE-PG; Fri, 09 Aug 2019 18:08:50 +0200
Received: from [178.193.45.231] (helo=pc-63.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <borkmann@iogearbox.net>)
        id 1hw7Ri-00071g-K6; Fri, 09 Aug 2019 18:08:50 +0200
Subject: Re: [bpf-next v3 PATCH 0/3] bpf: improvements to xdp_fwd sample
To:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     a.s.protopopov@gmail.com, dsahern@gmail.com,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
        ys114321@gmail.com
References: <156528102557.22124.261409336813472418.stgit@firesoul>
From:   Daniel Borkmann <borkmann@iogearbox.net>
Message-ID: <6ed374ad-1b3d-81cc-b482-bd3acbea82f5@iogearbox.net>
Date:   Fri, 9 Aug 2019 18:08:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <156528102557.22124.261409336813472418.stgit@firesoul>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: borkmann@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25536/Fri Aug  9 10:22:54 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/8/19 6:17 PM, Jesper Dangaard Brouer wrote:
> V3: Hopefully fixed all issues point out by Yonghong Song
> 
> V2: Addressed issues point out by Yonghong Song
>   - Please ACK patch 2/3 again
>   - Added ACKs and reviewed-by to other patches
> 
> This patchset is focused on improvements for XDP forwarding sample
> named xdp_fwd, which leverage the existing FIB routing tables as
> described in LPC2018[1] talk by David Ahern.
> 
> The primary motivation is to illustrate how Toke's recent work
> improves usability of XDP_REDIRECT via lookups in devmap. The other
> patches are to help users understand the sample.
> 
> I have more improvements to xdp_fwd, but those might requires changes
> to libbpf.  Thus, sending these patches first as they are isolated.
> 
> [1] http://vger.kernel.org/lpc-networking2018.html#session-1
> 
> ---
> 
> Jesper Dangaard Brouer (3):
>        samples/bpf: xdp_fwd rename devmap name to be xdp_tx_ports
>        samples/bpf: make xdp_fwd more practically usable via devmap lookup
>        samples/bpf: xdp_fwd explain bpf_fib_lookup return codes
> 
> 
>   samples/bpf/xdp_fwd_kern.c |   39 ++++++++++++++++++++++++++++++---------
>   samples/bpf/xdp_fwd_user.c |   35 +++++++++++++++++++++++------------
>   2 files changed, 53 insertions(+), 21 deletions(-)
> 
> --
> 

Applied, thanks!
