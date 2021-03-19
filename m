Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6396D341A64
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 11:49:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbhCSKtC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 06:49:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:51628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229648AbhCSKsr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Mar 2021 06:48:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD8DD64DDA;
        Fri, 19 Mar 2021 10:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616150927;
        bh=jxXXsWLmNgSKyex1sIRe54fbKbfd0erKWr8OR0LmtkQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=a81CTAcVyNDwFr8Pzgb89foiQFaWgRbEqo1DHippvg6XnVBeMq2Xkh3yZ/6if1gOV
         1bSgocOGUCit5fOv8gO0Rfs4VnGFVyeVud3uYMkuWVDT2YsPskA7YNGyw3yH9cQt02
         Evv87PBv9svdebhW7YCSj+iv7n3c9wiOJG+1ZSLk=
Date:   Fri, 19 Mar 2021 11:48:45 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, sashal@kernel.org
Subject: Re: [PATCH stable 0/6] net: dsa: b53: Correct learning for
 standalone ports
Message-ID: <YFSBjd8N98xcFHYc@kroah.com>
References: <20210317003549.3964522-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210317003549.3964522-1-f.fainelli@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 16, 2021 at 05:35:43PM -0700, Florian Fainelli wrote:
> Hi Greg, Sasha, Jaakub and David,
> 
> This patch series contains backports for a change that recently made it
> upstream as f9b3827ee66cfcf297d0acd6ecf33653a5f297ef ("net: dsa: b53:
> Support setting learning on port") however that commit depends on
> infrastructure that landed in v5.12-rc1.
> 
> The way this was fixed in the netdev group's net tree is slightly
> different from how it should be backported to stable trees which is why
> you will find a patch for each branch in the thread started by this
> cover letter. The commit used as a Fixes: base dates back from when the
> driver was first introduced into the tree since this should have been
> fixed from day one ideally.
> 
> Let me know if this does not apply for some reason. The changes from 4.9
> through 4.19 are nearly identical and then from 5.4 through 5.11 are
> about the same.

All now applied, thanks!

greg k-h
