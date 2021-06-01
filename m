Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 810FD397A94
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 21:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234756AbhFATU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 15:20:27 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39352 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234539AbhFATU0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 15:20:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=9ADwDrG8kpdyR8cCb2SHNl6C1wJeOlNc6NrXVJMv3NI=; b=INMOz52y8HhmZCgS/AkvOOGl4Y
        e0R5a/hapCHuSriCa0DSrRWHS4K5F5HAn5aH/lHd0FDoFcHUZnPFhaaSqLPkg450nIUXbGw8LsMhL
        k0fWKSwRi3Ij7Z9OkVjPpvXaFzSPszZBGOVmvhrDSfJ/WUmiKajeL9uHngAHw06n6Bm4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lo9uM-007Kkb-JP; Tue, 01 Jun 2021 21:18:34 +0200
Date:   Tue, 1 Jun 2021 21:18:34 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Modi, Geet" <geet.modi@ti.com>
Cc:     "Bajjuri, Praneeth" <praneeth@ti.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [EXTERNAL] Re: [EXTERNAL] Re: [PATCH] net: phy: dp83867: perform
 soft reset and retain established link
Message-ID: <YLaICrmU8ND+66mU@lunn.ch>
References: <20210324010006.32576-1-praneeth@ti.com>
 <YFsxaBj/AvPpo13W@lunn.ch>
 <404285EC-BBF0-4482-8454-3289C7AF3084@ti.com>
 <YGSk4W4mW8JQPyPl@lunn.ch>
 <3494dcf6-14ca-be2b-dbf8-dda2e208b70b@ti.com>
 <YLEf128OEADi0Kb1@lunn.ch>
 <5480BEB5-B540-4BB6-AC32-65CB27439270@ti.com>
 <EC713CBF-D669-4A0E-ADF2-093902C03C49@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <EC713CBF-D669-4A0E-ADF2-093902C03C49@ti.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 01, 2021 at 07:01:04PM +0000, Modi, Geet wrote:
> Hello Andrew,
> 
>  
> 
> Please let me know if you have additional questions/clarifications to approve
> below change request.
> 
>  
> 
> Regards,
> Geet
> 
>  
> 
>  
> 
> From: Geet Modi <geet.modi@ti.com>
> Date: Friday, May 28, 2021 at 10:10 AM
> To: Andrew Lunn <andrew@lunn.ch>, "Bajjuri, Praneeth" <praneeth@ti.com>
> Cc: "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
> "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
> "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
> Subject: Re: [EXTERNAL] Re: [EXTERNAL] Re: [PATCH] net: phy: dp83867: perform
> soft reset and retain established link

So this all seems to boil down to, it does not matter if it is
acceptable or not, you are going to do it. So please just remove that
part of the comment. It has no value.

	 Andrew
