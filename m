Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C91E777F98
	for <lists+netdev@lfdr.de>; Sun, 28 Jul 2019 15:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726134AbfG1NYZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jul 2019 09:24:25 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58916 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726032AbfG1NYZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jul 2019 09:24:25 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id 33D9E80239; Sun, 28 Jul 2019 15:24:11 +0200 (CEST)
Date:   Sun, 28 Jul 2019 15:24:12 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     liuyonglong <liuyonglong@huawei.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@huawei.com,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        shiju.jose@huawei.com
Subject: Re: [PATCH net] net: hns: fix LED configuration for marvell phy
Message-ID: <20190728132412.GC8718@xo-6d-61-c0.localdomain>
References: <1563775152-21369-1-git-send-email-liuyonglong@huawei.com>
 <20190722.181906.2225538844348045066.davem@davemloft.net>
 <72061222-411f-a58c-5873-ad873394cdb5@huawei.com>
 <20190725042829.GB14276@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190725042829.GB14276@lunn.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu 2019-07-25 06:28:29, Andrew Lunn wrote:
> On Thu, Jul 25, 2019 at 11:00:08AM +0800, liuyonglong wrote:
> > > Revert "net: hns: fix LED configuration for marvell phy"
> > > This reverts commit f4e5f775db5a4631300dccd0de5eafb50a77c131.
> > >
> > > Andrew Lunn says this should be handled another way.
> > >
> > > Signed-off-by: David S. Miller <davem@davemloft.net>
> > 
> > 
> > Hi Andrew:
> > 
> > I see this patch have been reverted, can you tell me the better way to do this?
> > Thanks very much!
> 
> Please take a look at the work Matthias Kaehlcke is doing. It has not
> got too far yet, but when it is complete, it should define a generic
> way to configure PHY LEDs.

I don't remember PHY LED discussion from LED mailing list. Would you have a pointer?
Would it make sense to coordinate with LED subsystem?

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
