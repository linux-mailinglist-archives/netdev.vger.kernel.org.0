Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD453B8974
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 22:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233951AbhF3UFv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 16:05:51 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35330 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233693AbhF3UFu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Jun 2021 16:05:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=YKMhRboh+lKze4+WuoZJxqXVfSKTDuhGeZI4lldCD3I=; b=B2
        g5ekKiuufadZ7g9B/g7TPSdKWdoYs0+gegQ31z2Y0P+qvA/kaf6Umg+Odmno39uka24QsHIlIhgpw
        SZMVYUxSQ1qV1cZ44/RYFiHuR98n2dJ9psm7y7E36WImIQ2FzUYYD0r+m1R3tIM3tup9NjFwQDxKp
        PgQZB9s9ugNKsuw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lygQa-00Bh5e-Fs; Wed, 30 Jun 2021 22:03:20 +0200
Date:   Wed, 30 Jun 2021 22:03:20 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net 2/6] net: dsa: mv88e6xxx: use correct
 .stats_set_histogram() on Topaz
Message-ID: <YNzOCIXXyw7jKhyZ@lunn.ch>
References: <20210630174308.31831-1-kabel@kernel.org>
 <20210630174308.31831-3-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210630174308.31831-3-kabel@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 30, 2021 at 07:43:04PM +0200, Marek Behún wrote:
> Commit 40cff8fca9e3 ("net: dsa: mv88e6xxx: Fix stats histogram mode")
> introduced wrong .stats_set_histogram() method for Topaz family.
> 
> The Peridot method should be used instead.
> 
> Signed-off-by: Marek Behún <kabel@kernel.org>
> Fixes: 40cff8fca9e3 ("net: dsa: mv88e6xxx: Fix stats histogram mode")

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
