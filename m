Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C163E2FE31C
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 07:42:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbhAUGmJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 01:42:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:48800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726381AbhATXmq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Jan 2021 18:42:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC3E2221FE;
        Wed, 20 Jan 2021 23:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611186120;
        bh=q8VZVDy9MD1pO4xzShCfdin0tvooH1Dty8IlAcZthbQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=u4L9X1fWkAq9lQ5exqpX6BPXJhSdroFZ6MxSQQHX+p250bqSMdawJbS9phqlql+8b
         2oesWMQTgIx0zbg4Clt0F2AyzycfBlRL5MHvP6JnFkzT/ItHVsQsIw54TqLf3/RPca
         nvGXK1UwMgmBWyut6F6fR0e/l0r6ywgyh0iqbN+adhZsqFRbI6VnHl+zNg54dLWVjx
         za1QMl6E6NKj2UZsofNG2XtQkeVZVv5JnX7kuj7XwR3qf8IISL1x3pc4R13mPNgyVs
         2ZtmL3Wqj14avTojJUxVE8+dFKxT/lasK2+I3Kxz9oMBruSg8q+PH8pEgQXbCkvmse
         nDZXo5E+uD4Cg==
Date:   Wed, 20 Jan 2021 15:41:58 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        davem@davemloft.net, jacob.e.keller@intel.com, roopa@nvidia.com,
        mlxsw@nvidia.com
Subject: Re: [patch net-next RFC 00/10] introduce line card support for
 modular switch
Message-ID: <20210120154158.206b8752@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YAg2ngUQIty8U36l@lunn.ch>
References: <20210113121222.733517-1-jiri@resnulli.us>
        <X/+nVtRrC2lconET@lunn.ch>
        <20210119115610.GZ3565223@nanopsycho.orion>
        <YAbyBbEE7lbhpFkw@lunn.ch>
        <20210120083605.GB3565223@nanopsycho.orion>
        <YAg2ngUQIty8U36l@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 Jan 2021 14:56:46 +0100 Andrew Lunn wrote:
> > No, the FW does not know. The ASIC is not physically able to get the
> > linecard type. Yes, it is odd, I agree. The linecard type is known to
> > the driver which operates on i2c. This driver takes care of power
> > management of the linecard, among other tasks.  
> 
> So what does activated actually mean for your hardware? It seems to
> mean something like: Some random card has been plugged in, we have no
> idea what, but it has power, and we have enabled the MACs as
> provisioned, which if you are lucky might match the hardware?
> 
> The foundations of this feature seems dubious.

But Jiri also says "The linecard type is known to the driver which
operates on i2c." which sounds like there is some i2c driver (in user
space?) which talks to the card and _does_ have the info? Maybe I'm
misreading it. What's the i2c driver?
