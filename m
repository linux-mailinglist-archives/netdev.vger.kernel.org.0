Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91FA03254BA
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 18:50:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231274AbhBYRto (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 12:49:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:47148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229522AbhBYRtm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Feb 2021 12:49:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE58364F24;
        Thu, 25 Feb 2021 17:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614275342;
        bh=hjKk6M+dmIawgZS3JaWfTQ04sRlB/jwqry70VBDUv2c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kKBqYhk7tB58K6eAY0Uvka+n15r3Wibw7Dc4n1qucOZgvV7emIFjOVYlVbQXgYMUS
         AQOMoWyzeFUvGFug840WpwDXVBvNcNw+Bv5J67XSccxImVU/wy5Da+Fx8jlX7ROJSP
         kDqixs3MJYVLiOfndpuxvXh/TrtoQnf5CXxRpMFCwbM68xQ/45GUDpkYtoUS/VQXRK
         eSxp1goinV7GT3A67shGbz4haYvA5YV+bO0XIoYrn2CPIUWW8V3tkf5VJhFrJ831xq
         9rSuUznTd2FnjY0NhuJtbCA/aH+HjiUlaCNoknHsqIOV2N7eT6L3TA//j0njEnQUVq
         CptYVGeIiDk/w==
Date:   Thu, 25 Feb 2021 09:49:00 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Marco Wenzel <marco.wenzel@a-eberle.de>,
        george.mccollister@gmail.com
Cc:     "David S. Miller" <davem@davemloft.net>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Andreas Oetken <andreas.oetken@siemens.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Arvid Brodin <Arvid.Brodin@xdin.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: hsr: add support for EntryForgetTime
Message-ID: <20210225094900.10ba8346@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YDZaxXkP25RjN02G@lunn.ch>
References: <CAFSKS=PnV-aLnGeNqjqrsT4nfFby18uYQpScCCurz6dZ39AynQ@mail.gmail.com>
        <20210224094653.1440-1-marco.wenzel@a-eberle.de>
        <YDZaxXkP25RjN02G@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 24 Feb 2021 14:55:17 +0100 Andrew Lunn wrote:
> On Wed, Feb 24, 2021 at 10:46:49AM +0100, Marco Wenzel wrote:
> > In IEC 62439-3 EntryForgetTime is defined with a value of 400 ms. When a
> > node does not send any frame within this time, the sequence number check
> > for can be ignored. This solves communication issues with Cisco IE 2000
> > in Redbox mode.
> > 
> > Fixes: f421436a591d ("net/hsr: Add support for the High-availability Seamless Redundancy protocol (HSRv0)")
> > Signed-off-by: Marco Wenzel <marco.wenzel@a-eberle.de>
> > Reviewed-by: George McCollister <george.mccollister@gmail.com>
> > Tested-by: George McCollister <george.mccollister@gmail.com>  
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Applied, thanks!
