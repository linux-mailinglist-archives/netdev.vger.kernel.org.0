Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44F974567A6
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 02:54:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233548AbhKSB5d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 20:57:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:48070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231368AbhKSB5c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 20:57:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 998AE61A09;
        Fri, 19 Nov 2021 01:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637286872;
        bh=vUOT490iA4dcUCpMvxiSBO2FZQMFXqB+K3Nk53F0xkc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qfeTl58R0lNt9GRS0gQhc83RIW/och4Scy3SL9/pFvGbZXizB1PWnq/y6+vPrUheH
         Lph5SkOPzn/YsfW5d7LCLt3nECwFGzg5kkhAWyBbrNeIj0GD+7JSlYfQtoSkF7bKsN
         zdL8MW6fjxc0PJuRU6GJ3hwIUnyVIbCVSW+HBONZpdJQCQzCv6WxerZiabrGkytpca
         gbGDHVrLGQsEd+jNyycbNGHYJ+tq8FbWprDIK5ZzUSbLTtSZUDwLI1r4cGhSOSVe+L
         HLtzbBgNyrtnO+q0xvVhUrd37T1NMRvbnSwQjGA8Klftt7iUfMA9S/MfwmaISatqWA
         TMeUCLK6lvxsw==
Date:   Thu, 18 Nov 2021 17:54:30 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mark Brown <broonie@kernel.org>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: regmap: allow to define reg_update_bits for no bus
 configuration
Message-ID: <20211118175430.226ca5da@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YZWDOidBOssP10yS@sirena.org.uk>
References: <20211117210451.26415-1-ansuelsmth@gmail.com>
        <20211117210451.26415-2-ansuelsmth@gmail.com>
        <YZV/GYJXKTE4RaEj@sirena.org.uk>
        <61958011.1c69fb81.31272.2dd5@mx.google.com>
        <YZWDOidBOssP10yS@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 17 Nov 2021 22:33:30 +0000 Mark Brown wrote:
> On Wed, Nov 17, 2021 at 11:19:39PM +0100, Ansuel Smith wrote:
> > On Wed, Nov 17, 2021 at 10:15:53PM +0000, Mark Brown wrote:  
> 
> > > I've applied this already?  If it's needed by something in another tree
> > > let me know and I'll make a signed tag for it.  
> 
> > Yes, I posted this in this series as net-next still doesn't have this
> > commit. Don't really know how to hanle this kind of corner
> > case. Do you have some hint about that and how to proceed?  
> 
> Ask for a tag like I said in the message you're replying to:
> 
> The following changes since commit fa55b7dcdc43c1aa1ba12bca9d2dd4318c2a0dbf:
> 
>   Linux 5.16-rc1 (2021-11-14 13:56:52 -0800)
> 
> are available in the Git repository at:
> 
>   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git tags/regmap-no-bus-update-bits
> 
> for you to fetch changes up to 02d6fdecb9c38de19065f6bed8d5214556fd061d:
> 
>   regmap: allow to define reg_update_bits for no bus configuration (2021-11-15 13:27:13 +0000)
> 
> ----------------------------------------------------------------
> regmap: Allow regmap_update_bits() to be offloaded with no bus
> 
> Some hardware can do this so let's use that capability.

Pulled into net-next, thanks Mark!

Ansuel, please make sure to post fewer than 15 patches at a time.
