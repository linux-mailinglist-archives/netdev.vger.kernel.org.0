Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 559712A1017
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 22:21:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727822AbgJ3VVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 17:21:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:35182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727660AbgJ3VVW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 17:21:22 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE0272223F;
        Fri, 30 Oct 2020 21:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604092882;
        bh=LoGzykV26QHCRapsdDjwvazdzFB2lYaEXG67B5MhmT4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WDN4Cd9pcnUATLyAShZ6d/6EPF4t2kDc3VQz+OzqSrWD7+zLjQ9Jw+DSqf//iuEFm
         UqbN1/vjDy6hjp50LAfCd3HOrhv5bc5dhKnTzAHNHeNQvpAGz+PxpRxu9x345pkD3Z
         68qCxt86xWAZ2EI+iCeNx+lMw9FHnBGWDXopQJs0=
Date:   Fri, 30 Oct 2020 14:21:20 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, linux@armlinux.org.uk,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, hkallweit1@gmail.com,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH] drivers: net: phy: Fix spelling in comment defalut to
 default
Message-ID: <20201030142120.2e9fd7cd@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201029130923.GN933237@lunn.ch>
References: <20201029095525.20200-1-unixbhaskar@gmail.com>
        <20201029130923.GN933237@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Oct 2020 14:09:23 +0100 Andrew Lunn wrote:
> On Thu, Oct 29, 2020 at 03:25:25PM +0530, Bhaskar Chowdhury wrote:
> > Fixed spelling in comment like below:
> > 
> > s/defalut/default/p
> > 
> > This is in linux-next.
> > 
> > Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>  
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Applied.
