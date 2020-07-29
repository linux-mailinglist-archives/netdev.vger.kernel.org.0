Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E1FD2316C4
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 02:31:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730733AbgG2AbE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 20:31:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730466AbgG2AbE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 20:31:04 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A016C061794
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 17:31:04 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 680D3128D3F67;
        Tue, 28 Jul 2020 17:14:18 -0700 (PDT)
Date:   Tue, 28 Jul 2020 17:31:03 -0700 (PDT)
Message-Id: <20200728.173103.2245041695854868229.davem@davemloft.net>
To:     gnault@redhat.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, martin.varghese@nokia.com,
        willemb@google.com
Subject: Re: [PATCH v2 net] bareudp: forbid mixing IP and MPLS in
 multiproto mode
From:   David Miller <davem@davemloft.net>
In-Reply-To: <04eafa5bd1f05f7e569a047ecd2d65bc78cd75a1.1595682311.git.gnault@redhat.com>
References: <04eafa5bd1f05f7e569a047ecd2d65bc78cd75a1.1595682311.git.gnault@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 28 Jul 2020 17:14:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guillaume Nault <gnault@redhat.com>
Date: Sat, 25 Jul 2020 15:06:47 +0200

> In multiproto mode, bareudp_xmit() accepts sending multicast MPLS and
> IPv6 packets regardless of the bareudp ethertype. In practice, this
> let an IP tunnel send multicast MPLS packets, or an MPLS tunnel send
> IPv6 packets.
> 
> We need to restrict the test further, so that the multiproto mode only
> enables
>   * IPv6 for IPv4 tunnels,
>   * or multicast MPLS for unicast MPLS tunnels.
> 
> To improve clarity, the protocol validation is moved to its own
> function, where each logical test has its own condition.
> 
> v2: s/ntohs/htons/
> 
> Fixes: 4b5f67232d95 ("net: Special handling for IP & MPLS.")
> Signed-off-by: Guillaume Nault <gnault@redhat.com>

Applied and queued up for -stable, thanks.
