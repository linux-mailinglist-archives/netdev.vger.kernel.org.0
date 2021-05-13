Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84EF137F8D8
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 15:34:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234059AbhEMNfw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 09:35:52 -0400
Received: from mail.aperture-lab.de ([116.203.183.178]:56756 "EHLO
        mail.aperture-lab.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233997AbhEMNfj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 09:35:39 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 464743E8F5;
        Thu, 13 May 2021 15:34:26 +0200 (CEST)
Date:   Thu, 13 May 2021 15:34:24 +0200
From:   Linus =?utf-8?Q?L=C3=BCssing?= <linus.luessing@c0d3.blue>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
Cc:     netdev@vger.kernel.org, Roopa Prabhu <roopa@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 00/11] net: bridge: split IPv4/v6 mc router
 state and export for batman-adv
Message-ID: <20210513133423.GB2222@otheros>
References: <20210512231941.19211-1-linus.luessing@c0d3.blue>
 <c5634f19-f9f3-5966-a5b3-a0a64ca4534b@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <c5634f19-f9f3-5966-a5b3-a0a64ca4534b@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Last-TLS-Session-Version: TLSv1.2
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 13, 2021 at 03:02:13PM +0300, Nikolay Aleksandrov wrote:
> Nice work overall, thank you. I hope it was tested well. :)
> It'd be great if later you could add some selftests.
> 
> Cheers,
>  Nik

Hi Nikolay,

I think I found a way now to better deal with the protocol
specific hlist_for_each_entry(), by using hlist_for_each()
and a helper function, to reduce the duplicate code
with br_{ip4,ip6}_multicast_get_rport_slot() as you suggested
(and also removing duplicate code with 
br_{ip4,ip6}_multicast_mark_router()) and reworked patches 7
and 9 a bit for that...

Sorry for the inconvience and my bad timing with your reviews. But
thanks a lot for all your valuable feedback!

Also netdevbpf patchwork had a few more remarks, they should
hopefully be fixed now, too.

Regards, Linus
