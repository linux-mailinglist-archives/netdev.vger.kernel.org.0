Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B3C04D9EB
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 21:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726405AbfFTTBs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 15:01:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57770 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725905AbfFTTBs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jun 2019 15:01:48 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 47FD83086209;
        Thu, 20 Jun 2019 19:01:43 +0000 (UTC)
Received: from localhost (unknown [10.36.112.13])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DD72B608D0;
        Thu, 20 Jun 2019 19:01:39 +0000 (UTC)
Date:   Thu, 20 Jun 2019 21:01:35 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     David Miller <davem@davemloft.net>, Jianlin Shi <jishi@redhat.com>,
        Wei Wang <weiwan@google.com>, Martin KaFai Lau <kafai@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v6 06/11] ipv6/route: Don't match on fc_nh_id
 if not set in ip6_route_del()
Message-ID: <20190620210135.46bee931@redhat.com>
In-Reply-To: <402be9f4-262c-b185-46a9-d5d4bb531cf1@gmail.com>
References: <cover.1560987611.git.sbrivio@redhat.com>
        <18a49a3a5d0274df90f059f37d3601abd0bac879.1560987611.git.sbrivio@redhat.com>
        <402be9f4-262c-b185-46a9-d5d4bb531cf1@gmail.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Thu, 20 Jun 2019 19:01:48 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Jun 2019 08:16:28 -0600
David Ahern <dsahern@gmail.com> wrote:

> On 6/19/19 5:59 PM, Stefano Brivio wrote:
> > If fc_nh_id isn't set, we shouldn't try to match against it. This
> > actually matters just for the RTF_CACHE case below (where this is
> > already handled): if iproute2 gets a route exception and tries to
> > delete it, it won't reference its fc_nh_id, even if a nexthop
> > object might be associated to the originating route.
> > 
> > Fixes: 5b98324ebe29 ("ipv6: Allow routes to use nexthop objects")
> > Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
> > ---
> > v6: New patch
> > 
> >  net/ipv6/route.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >   
> 
> Thanks for catching that.

Your recent addition to pmtu.sh did it :)

-- 
Stefano
