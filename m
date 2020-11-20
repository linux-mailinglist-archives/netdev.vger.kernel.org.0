Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 946362BA218
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 06:58:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726123AbgKTF5Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 00:57:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:59786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725777AbgKTF5Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 00:57:16 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 27D9722256;
        Fri, 20 Nov 2020 05:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605851835;
        bh=CdGhgNyYd+DOvco1QwH8g7tLVLuvG4n1ofKjRJWIe38=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jsSKaoPtp3u8ZFlwgrAkiJTNIjDx9a1ALtrN/TvAwD58B7C+FEcLW6TTvBhZLDkyy
         YP9TSVCw4WrkqLKvZ1z63SmAXmiU8M9Sc33VsQc2EwkEYL8I9h+gv/rCAkkxJ9Em6D
         AtVfo5Nepdq2He1316nL03FJwxAK2RLaMLxQnnWg=
Date:   Thu, 19 Nov 2020 21:57:14 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Oliver Herms <oliver.peter.herms@gmail.com>,
        netdev@vger.kernel.org, davem@davemloft.net, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org
Subject: Re: [PATCH v4] IPv6: RTM_GETROUTE: Add RTA_ENCAP to result
Message-ID: <20201119215714.1fd0e316@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <c5c7d312-0366-83a4-b285-013c74abeccc@gmail.com>
References: <20201118230651.GA8861@tws>
        <c5c7d312-0366-83a4-b285-013c74abeccc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Nov 2020 17:29:52 -0700 David Ahern wrote:
> On 11/18/20 4:06 PM, Oliver Herms wrote:
> > This patch adds an IPv6 routes encapsulation attribute
> > to the result of netlink RTM_GETROUTE requests
> > (i.e. ip route get 2001:db8::).
> > 
> > Signed-off-by: Oliver Herms <oliver.peter.herms@gmail.com>
> > ---
> >  net/ipv6/route.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> >   
> 
> Reviewed-by: David Ahern <dsahern@kernel.org>

Applied, thanks!
