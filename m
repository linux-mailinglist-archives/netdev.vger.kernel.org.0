Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 608FB5E75D
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 17:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbfGCPFc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 11:05:32 -0400
Received: from www62.your-server.de ([213.133.104.62]:53904 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726675AbfGCPFa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 11:05:30 -0400
Received: from [78.46.172.2] (helo=sslproxy05.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1higon-0001dI-N1; Wed, 03 Jul 2019 17:05:09 +0200
Received: from [178.193.45.231] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1higon-0007PN-GI; Wed, 03 Jul 2019 17:05:09 +0200
Subject: Re: [PATCH bpf v6 0/2] xdp: fix hang while unregistering device bound
 to xdp socket
To:     Ilya Maximets <i.maximets@samsung.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        xdp-newbies@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
References: <CGME20190628080413eucas1p13f3400f657b4827414737af42f02a57b@eucas1p1.samsung.com>
 <20190628080407.30354-1-i.maximets@samsung.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <ae128ab7-0983-921e-7e56-7f42cb419113@iogearbox.net>
Date:   Wed, 3 Jul 2019 17:05:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190628080407.30354-1-i.maximets@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25499/Wed Jul  3 10:03:10 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/28/2019 10:04 AM, Ilya Maximets wrote:
> Version 6:
> 
>     * Better names for socket state.
> 
> Version 5:
> 
>     * Fixed incorrect handling of rtnl_lock.
> 
> Version 4:
> 
>     * 'xdp_umem_clear_dev' exposed to be used while unregistering.
>     * Added XDP socket state to track if resources already unbinded.
>     * Splitted in two fixes.
> 
> Version 3:
> 
>     * Declaration lines ordered from longest to shortest.
>     * Checking of event type moved to the top to avoid unnecessary
>       locking.
> 
> Version 2:
> 
>     * Completely re-implemented using netdev event handler.
> 
> Ilya Maximets (2):
>   xdp: hold device for umem regardless of zero-copy mode
>   xdp: fix hang while unregistering device bound to xdp socket
> 
>  include/net/xdp_sock.h |  5 +++
>  net/xdp/xdp_umem.c     | 21 +++++-----
>  net/xdp/xdp_umem.h     |  1 +
>  net/xdp/xsk.c          | 87 ++++++++++++++++++++++++++++++++++++------
>  4 files changed, 93 insertions(+), 21 deletions(-)
> 

Applied, thanks!
