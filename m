Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7DA7B7B2C
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 15:55:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390354AbfISNyo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 09:54:44 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55262 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403799AbfISNwp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Sep 2019 09:52:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=uHqAZszAl3o6WeCOPg4z0LfW+cCmWq3xrdVjUD6u4cc=; b=m9hhE2xoRKR2YYB7uf0VifEQnX
        aOZ0+fdp520LdgMzOTKjsIrHpbX0evpx6kfQuWT22DK/3rghtJNe64JnjP8nhoJ/XbyXznacocWFv
        YLb/dZdilLMACdcvabHVVRHVu5iokUFqOcyB2N8WUNJeACxQTC/BINx6ur5ejiNCfYek=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1iAwrT-0006Js-9C; Thu, 19 Sep 2019 15:52:43 +0200
Date:   Thu, 19 Sep 2019 15:52:43 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Peter Mamonov <pmamonov@gmail.com>
Cc:     f.fainelli@gmail.com, hkallweit1@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH RFC] net/phy: fix Marvell PHYs probe failure when HWMON
 and THERMAL_OF are enabled
Message-ID: <20190919135243.GB22556@lunn.ch>
References: <20190918213837.24585-1-pmamonov@gmail.com>
 <20190919025016.GA12785@lunn.ch>
 <20190919081055.GD9025@chr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190919081055.GD9025@chr>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 19, 2019 at 11:10:56AM +0300, Peter Mamonov wrote:
> Hi, Andrew,
> 
> On Thu, Sep 19, 2019 at 04:50:16AM +0200, Andrew Lunn wrote:
> > On Thu, Sep 19, 2019 at 12:38:37AM +0300, Peter Mamonov wrote:
> > > Hello,
> > > 
> > > Some time ago I've discovered that probe functions of certain Marvell PHYs 
> > > fail if both HWMON and THERMAL_OF config options are enabled.
> > 
> > Hi Peter
> > 
> > It probably affects more then Marvell PHYs.
> > 
> > > The root 
> > > cause of this problem is a lack of an OF node for a PHY's built-in 
> > > temperature sensor.  However I consider adding this OF node to be a bit 
> > > excessive solution. Am I wrong? Below you will find a one line patch which 
> > > fixes the problem.
> > 
> > Your patch look sensible to me.
> > 
> > > I've sent it to the releveant maintainers three weeks 
> > > ago without any feedback yet.
> > 
> > Could you point me at the relevant mailing list archive?
> 
> Here it is: https://marc.info/?l=linux-pm&m=156691695616377&w=2

Hi Peter

O.K. Thanks.

We should not take this patch via netdev, since it is outside of
netdev, even if it does break netdev. So lets polish the patch a bit,
and then repost it to linux-pm and its maintainers.

Please could you add a Fixes: tag. Can you figure out which commit
broke it, or has it always been broken?

Add a stable: tag, indicating it needs to be back ported. For netdev,
you would not do this, but for linux-pm, i guess it is needed.

Change the subject a little. thermal: Fix broken registration if sensor OF node missing.

Add

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

When you post it, please Cc: me, netdev, davem, but make the To: the
three thermal maintainers.

Thanks
      Andrew
