Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC6A7291EB4
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 21:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388245AbgJRTyc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 15:54:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:43532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388229AbgJRTy1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Oct 2020 15:54:27 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2DFB22263;
        Sun, 18 Oct 2020 19:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603050867;
        bh=lYYbu+LHVs/lI42o9GlVg5xf4fVuj6IuC281Ogm3UKg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eH87+V9t24jrCyts1XE4BPOlv/zkzt1xVw5KzK9qWvsLfSDe9MQuPqGunvGiubzgP
         dwOBj7YgdFy7GWJ6uAk/TBKbT4RxRfbIux+UZ7Xy1A3SIPCx5NQValsuU0XRPmOBqK
         Ngku01mhuYSPoejY2vD0Wc17FLgZ5JWoL6MgAXnM=
Date:   Sun, 18 Oct 2020 12:54:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Greg KH <greg@kroah.com>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Anant Thazhemadam <anant.thazhemadam@gmail.com>,
        petkan@nucleusys.com, davem@davemloft.net,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-next@vger.kernel.org
Subject: Re: [PATCH v2] net: usb: rtl8150: don't incorrectly assign random
 MAC addresses
Message-ID: <20201018125425.05ef059d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201015153700.1e97b354@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201010064459.6563-1-anant.thazhemadam@gmail.com>
        <20201011173030.141582-1-anant.thazhemadam@gmail.com>
        <20201012091428.103fc2be@canb.auug.org.au>
        <20201016085922.4a2b90d1@canb.auug.org.au>
        <20201015152451.125895b1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201015153700.1e97b354@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 15 Oct 2020 15:37:00 -0700 Jakub Kicinski wrote:
> On Thu, 15 Oct 2020 15:24:51 -0700 Jakub Kicinski wrote:
> > On Fri, 16 Oct 2020 08:59:22 +1100 Stephen Rothwell wrote:  
> > > > I will apply the above patch to the merge of the usb tree today to fix
> > > > up a semantic conflict between the usb tree and Linus' tree.      
> > > 
> > > It looks like you forgot to mention this one to Linus :-(
> > > 
> > > It should probably say:
> > > 
> > > Fixes: b2a0f274e3f7 ("net: rtl8150: Use the new usb control message API.")    
> > 
> > Umpf. I think Greg sent his changes first, so this is on me.
> > 
> > The networking PR is still outstanding, can we reply to the PR with
> > the merge guidance. Or is it too late?  
> 
> I take that back, this came through net, not net-next so our current
> PR is irrelevant :)

Looks like the best thing to do right now is to put this fix in net,
so let me do just that (with the Fixes tag from Stephen).

Thanks Anant!
