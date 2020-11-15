Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 318A82B3186
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 01:08:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbgKOAHX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 19:07:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:36864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726125AbgKOAHX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Nov 2020 19:07:23 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D67B524178;
        Sun, 15 Nov 2020 00:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605398843;
        bh=qvQxhv9XpGRwUHp8bJekmFyvYs/pOIxUinyLe4I8OeY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sUqkkiIJqRgMBczGHFv8s1n5ADQCYlyRCi3Q9K/BFZHOGKEioLZ9C+0fFT6t4+ASN
         mqnSMaIwwAXyQpCdIHKocNT83hQhuCOv90U1sENZa8pEJid8JwpWcDoBDbA5A3CKsk
         MvhG8dMQTuyR4DLDea6XM/26aoDQY7w3aTvSjgTw=
Date:   Sat, 14 Nov 2020 16:07:21 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Oliver Herms <oliver.peter.herms@gmail.com>,
        netdev@vger.kernel.org, davem@davemloft.net, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org
Subject: Re: [PATCH v2] IPv4: RTM_GETROUTE: Add RTA_ENCAP to result
Message-ID: <20201114160721.7516f864@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <44d5ba9e-999d-85c3-38c9-e33e2efbeed9@gmail.com>
References: <20201113085517.GA1307262@tws>
        <44d5ba9e-999d-85c3-38c9-e33e2efbeed9@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Nov 2020 09:44:38 -0700 David Ahern wrote:
> On 11/13/20 1:55 AM, Oliver Herms wrote:
> > This patch adds an IPv4 routes encapsulation attribute
> > to the result of netlink RTM_GETROUTE requests
> > (e.g. ip route get 192.0.2.1).
> > 
> > Signed-off-by: Oliver Herms <oliver.peter.herms@gmail.com>
> 
> Reviewed-by: David Ahern <dsahern@kernel.org>

Applied, thanks!
