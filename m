Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7048E28A207
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 00:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388363AbgJJWxu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 18:53:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:48088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730408AbgJJSwY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 10 Oct 2020 14:52:24 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D9009224F9;
        Sat, 10 Oct 2020 18:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602355374;
        bh=nrrtVk1+7qXKAq8BqG+5dihLoDwn0kILgdMjJ+ABvS0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=V1rmBkdKM8Y4KHWH3oL/gfGExmS36lSKY3HsAADVNaYAUY1SASHjtaEX4UcRr2Buj
         NA17pVc3cK9dJY6xdrBQY+okvZhcZ88yj/F4qhrpRu8sPpeYZyKTnRamUBlVW6jklz
         WO9IswUp00ypLqsZSxa66cgyh1c1QrgRVBvXV68c=
Date:   Sat, 10 Oct 2020 11:42:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Tobias Brunner <tobias@strongswan.org>
Subject: Re: [PATCH net] ipv4: Restore flowi4_oif update before call to
 xfrm_lookup_route
Message-ID: <20201010114252.05b0e0ae@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201009180101.5092-1-dsahern@kernel.org>
References: <20201009180101.5092-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  9 Oct 2020 11:01:01 -0700 David Ahern wrote:
> Tobias reported regressions in IPsec tests following the patch
> referenced by the Fixes tag below. The root cause is dropping the
> reset of the flowi4_oif after the fib_lookup. Apparently it is
> needed for xfrm cases, so restore the oif update to ip_route_output_flow
> right before the call to xfrm_lookup_route.
> 
> Fixes: 2fbc6e89b2f1 ("ipv4: Update exception handling for multipath routes via same device")
> Reported-by: Tobias Brunner <tobias@strongswan.org>
> Signed-off-by: David Ahern <dsahern@kernel.org>

Applied and queued for stable, thank you!
