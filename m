Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A30867677A
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 15:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727197AbfGZN3X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 09:29:23 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40056 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726001AbfGZN3X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jul 2019 09:29:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=sMK0QAS0zARc10vqNqRj3GhsyMUWELzN4DHKP2wQCJk=; b=aehCqycIp+sy9GNe7jVtvPbF9x
        Myz3V4bf1I8muG/rzCv9qe/d0pbeg67rRYgfQJqVrq/ZJ0vbsb+P5tBKRgAAlU3uIyfBG+a1V2MbF
        hDtoay/oyUvJvPLEN9l7wxB4XdJuwgA8QiBmKfTE8FwT681lZbemLxxUEeaqSDubAmf8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hr0Hf-00051S-Ug; Fri, 26 Jul 2019 15:29:19 +0200
Date:   Fri, 26 Jul 2019 15:29:19 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     xiaofeis@codeaurora.org
Cc:     vkoul@kernel.org, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH v2] net: dsa: qca8k: enable port flow control
Message-ID: <20190726132919.GB18223@lunn.ch>
References: <1563944576-62844-1-git-send-email-xiaofeis@codeaurora.org>
 <20190724175031.GA28488@lunn.ch>
 <351b5292d597e47d69d0dcfd5af6a188@codeaurora.org>
 <20190725130135.GA21952@lunn.ch>
 <e2c51913e0e38450b09ef8f06bf259c0@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e2c51913e0e38450b09ef8f06bf259c0@codeaurora.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I didn't compile it on this tree, same code is just compiled and tested on
> kernel v4.14.

For kernel development work, v4.14 is dead. It died 12th November
2017. It gets backports of bug fixes, but kernel developers otherwise
don't touch it.

> We are working on one google project, all the change is
> required to upstream by Google.
> But if I do the change based on the new type for kernel 5.3, then the commit
> can't be used directly for Google's project.

So you will need to backport the change. In this case, you will have a
very different patch in v4.14 than in mainline, due to changes like
this. That is part of the pain in using such an old kernel.

You should use the function 

void phy_support_asym_pause(struct phy_device *phydev);

to indicate the MAC supports asym pause.

   Andrew
