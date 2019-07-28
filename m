Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7175781FA
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 00:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726191AbfG1WOU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jul 2019 18:14:20 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42950 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726097AbfG1WOT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Jul 2019 18:14:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=5/H6mwJ6ueqohYnfDld+48SY+48Vagu6j7FHEctaFAQ=; b=eeBZJiNGsQT7R6hK12i3/mN/CD
        89FpcJlP91gShudl7iiYzFma5uaxcArlUYPK7pnDu0eQZSqT0JvbnT7gLgwuqP8zLd4n6NTSXkhEk
        NSWQQ9M5FvZXXgUveNvqrfwOQrOuDNAPK1Oym5fQ+f1ETdV2qWUQH6fiG0LOmzIbVuN8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hrrQi-00068s-DH; Mon, 29 Jul 2019 00:14:12 +0200
Date:   Mon, 29 Jul 2019 00:14:12 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     liuyonglong <liuyonglong@huawei.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@huawei.com,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        shiju.jose@huawei.com
Subject: Re: [PATCH net] net: hns: fix LED configuration for marvell phy
Message-ID: <20190728221412.GB23125@lunn.ch>
References: <1563775152-21369-1-git-send-email-liuyonglong@huawei.com>
 <20190722.181906.2225538844348045066.davem@davemloft.net>
 <72061222-411f-a58c-5873-ad873394cdb5@huawei.com>
 <20190725042829.GB14276@lunn.ch>
 <20190728132412.GC8718@xo-6d-61-c0.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190728132412.GC8718@xo-6d-61-c0.localdomain>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 28, 2019 at 03:24:12PM +0200, Pavel Machek wrote:
> On Thu 2019-07-25 06:28:29, Andrew Lunn wrote:
> > On Thu, Jul 25, 2019 at 11:00:08AM +0800, liuyonglong wrote:
> > > > Revert "net: hns: fix LED configuration for marvell phy"
> > > > This reverts commit f4e5f775db5a4631300dccd0de5eafb50a77c131.
> > > >
> > > > Andrew Lunn says this should be handled another way.
> > > >
> > > > Signed-off-by: David S. Miller <davem@davemloft.net>
> > > 
> > > 
> > > Hi Andrew:
> > > 
> > > I see this patch have been reverted, can you tell me the better way to do this?
> > > Thanks very much!
> > 
> > Please take a look at the work Matthias Kaehlcke is doing. It has not
> > got too far yet, but when it is complete, it should define a generic
> > way to configure PHY LEDs.
> 
> I don't remember PHY LED discussion from LED mailing list. Would you have a pointer?

Hi Pavel 

So far, it has not made it onto the generic LED list. And the current
implementation is unlikely to go as far as using the generic LED
code. But i would like the binding to be compatible with it, so that
some time in the future it could be migrated to being part of the
generic LED code. But that would also require extensions to the
generic LED code to support hardware offload of triggers.

	Andrew
