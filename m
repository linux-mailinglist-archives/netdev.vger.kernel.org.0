Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0DDE301235
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 03:15:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbhAWCP3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 21:15:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:34770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726024AbhAWCP1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 21:15:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 64BB523B26;
        Sat, 23 Jan 2021 02:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611368086;
        bh=NladMq7QFe6GyN9y0s7oL87Je19OgCNJZS0X/MI1Uuo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mf6+IF7a/V2Q06BHxc/mLAvPENpqhi5SDnB5I9YjlyqVWNe/jenByRMEeBGDGXmv3
         RzrexoALAWQ2Xn/MqQKjWsjWm/4GuzI+RbXNWcVqKkTHZecaORIDAvdGdTT0dzm1qn
         V9YUoHc3it1jfQzJK/iQzczEoWW0A3NZ94P4zEoR8S1ccT6abeQwk73GN4+mc4wu7h
         lQqCZcZYBu1KRxzjg+LtoxfpQlyg8R5xiW9VxylQwoIvMzxbJy440lTtk2Ad4owaEp
         UioHQzeRRDv2mSGZw+ISKWJfQpilhy/yZbUtJFPhXPphsPz6gjcujoICJkdvHXhitp
         yTvxzzObqfvsQ==
Date:   Fri, 22 Jan 2021 18:14:44 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Richard Cochran <richardcochran@gmail.com>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Brandon Streiff <brandon.streiff@ni.com>,
        Olof Johansson <olof@lixom.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        David Miller <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net 2/4] net: mvpp2: Remove unneeded Kconfig dependency.
Message-ID: <20210122181444.66f9417d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210121150802.GB20321@hoboy.vegasvil.org>
References: <cover.1611198584.git.richardcochran@gmail.com>
        <1069fecd4b7e13485839e1c66696c5a6c70f6144.1611198584.git.richardcochran@gmail.com>
        <20210121102753.GO1551@shell.armlinux.org.uk>
        <20210121150802.GB20321@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 Jan 2021 07:08:02 -0800 Richard Cochran wrote:
> On Thu, Jan 21, 2021 at 10:27:54AM +0000, Russell King - ARM Linux admin wrote:
> > On Wed, Jan 20, 2021 at 08:06:01PM -0800, Richard Cochran wrote:  
> > > The mvpp2 is an Ethernet driver, and it implements MAC style time
> > > stamping of PTP frames.  It has no need of the expensive option to
> > > enable PHY time stamping.  Remove the incorrect dependency.
> > > 
> > > Signed-off-by: Richard Cochran <richardcochran@gmail.com>
> > > Fixes: 91dd71950bd7 ("net: mvpp2: ptp: add TAI support")  
> > 
> > NAK.  
> 
> Can you please explain why mvpp2 requires NETWORK_PHY_TIMESTAMING?

Russell, I think we all agree now this is not the solution to the
problem of which entity should provide the timestamp, but the series
doesn't seem objectionable in itself.

Please LMK if you think otherwise.

(I would put it in net-next tho, given the above this at most a space
optimization.)
