Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C03C3F0E89
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 01:09:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234669AbhHRXJy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 19:09:54 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57488 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231976AbhHRXJx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 19:09:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Z9zqNyUAY3h7FBFaj48JDOfsa94h/BOigE88Ofvxnzs=; b=3q+Mfm56cRsz+4xCDsOq5nEDo2
        dGN6GWOGaRxIdWIDNwFhEocz4PurDN3LWCjHkgewCsQ495gBEylrQqJXwHgk7/dEj1kYKyqQS6Qij
        zxJ5RSFr/57PawSi+O+CnubV/ziTBcrT68M+leXy/DyhF8VXuUeI/Pm/TzoAqZvGHtZQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mGUgN-000s2Q-NB; Thu, 19 Aug 2021 01:09:15 +0200
Date:   Thu, 19 Aug 2021 01:09:15 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Stephen Suryaputra <ssuryaextr@gmail.com>
Cc:     Nikolay Aleksandrov <nikolay@nvidia.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] ipmr: ip6mr: Add ability to display non default
 caches and vifs
Message-ID: <YR2TG2uodH4wHM1/@lunn.ch>
References: <20210818200951.7621-1-ssuryaextr@gmail.com>
 <912ed426-68c3-6a44-daec-484b45fdebde@nvidia.com>
 <20210818225022.GA31396@ICIPI.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210818225022.GA31396@ICIPI.localdomain>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 18, 2021 at 06:50:22PM -0400, Stephen Suryaputra wrote:
> On Thu, Aug 19, 2021 at 01:37:21AM +0300, Nikolay Aleksandrov wrote:
> > 
> > Sorry, but I don't see any point to this. We don't have it for any of the other
> > non-default cases, and I don't see a point of having it for ipmr either.
> > If you'd like to display the non-default tables then you query for them, you
> > don't change a sysctl to see them in /proc.
> > It sounds like a workaround for an issue that is not solved properly, and
> > generally it shouldn't be using /proc. If netlink interfaces are not sufficient
> > please improve them.
> 
> We found that the ability to dump the tables from kernel point of view
> is valuable for debugging the applications. Sometimes during the
> development, bugs in the use of the netlink interfaces can be solved
> quickly if the tables in the kernel can be viewed easily.
>
> If you agree on the reasoning above, what do you recommend then? Again,
> this is to easily view what's in the kernel.

Does iproute2 allow you to dump the tables?

First work on a simple CLI tool to dump the tables. Make it bug free
and contribute it. Then work on your buggy multicast routing daemon.

    Andrew


