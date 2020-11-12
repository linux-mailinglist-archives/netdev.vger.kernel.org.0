Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E4BF2AFF18
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 06:44:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728242AbgKLFdU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 00:33:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:42114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728785AbgKLEZS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Nov 2020 23:25:18 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E4C621D91;
        Thu, 12 Nov 2020 04:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605155117;
        bh=AGh0gDByaH9qA5uHJbEjywvPJoAQ0wzZd+4gycw26k8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Juto6uQfl2UpeH4e2RZPpDKtnRIcyxemz84D1DvT29DpiV1g8ZQfQa6INXMT6GpwE
         A84yS5ZKrhJsIVHcf64JnabornwQgm6KPc+loUisvqL90aQTpvYMczIwa40Z6p+DnO
         c0KzRIqajztIByaxlO47X8Sc2FYBk1rtr9Khel/c=
Date:   Wed, 11 Nov 2020 20:25:16 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>, davem@davemloft.net,
        vivien.didelot@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: Add helper to get a
 chip's max_vid
Message-ID: <20201111202516.01a9a8a2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201110192332.GI1456319@lunn.ch>
References: <20201110185720.18228-1-tobias@waldekranz.com>
        <20201110192332.GI1456319@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Nov 2020 20:23:32 +0100 Andrew Lunn wrote:
> On Tue, Nov 10, 2020 at 07:57:20PM +0100, Tobias Waldekranz wrote:
> > Most of the other chip info constants have helpers to get at them; add
> > one for max_vid to keep things consistent.
> > 
> > Suggested-by: Andrew Lunn <andrew@lunn.ch>
> > Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>  
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Applied, thanks!
