Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34A0A45D393
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 04:20:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239315AbhKYDXx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 22:23:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:38702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345040AbhKYDWG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 22:22:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D68EC6108B;
        Thu, 25 Nov 2021 03:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637810336;
        bh=jH3ib8LOjypJEX+zrK1zQDOwQlhz18MpvZQCJE0nlew=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hxwqzl3eq0XVdMj/kvDGs8UQPGygRVgK52dxKecb4jIDJWdnC5PoyFHePgCcLi3sr
         c3zzW6uFbgO+xIb/duC1zZ4FgCioX2Nn6IJFvDnjy1g0tNYqrHH4Wh0MwdPrSwfQ7x
         O+g0ZPCSncF/rCqoktCf4VZpR+WmcADahst1sOJZypraMx88dTzL1NTp+nmuX1USnR
         Z1pHDPOf8v0pQ/zzIBr6d/vlGNKLbFxqzJin8Z9ZnRNp9WmGfuR5fK0pzz9OoI82OA
         t6PXxy0XsKacvWfwasx/EYDwl5tb8A80FAaLxratFUYcxuW7YcHi3pymALSn5QpKBM
         pL2Vj2w33ukCQ==
Date:   Wed, 24 Nov 2021 19:18:54 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dylan Hung <dylan_hung@aspeedtech.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Joel Stanley <joel@jms.id.au>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-aspeed <linux-aspeed@lists.ozlabs.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Networking <netdev@vger.kernel.org>,
        Andrew Jeffery <andrew@aj.id.au>,
        "David S . Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        BMC-SW <BMC-SW@aspeedtech.com>
Subject: Re: [PATCH] net:phy: Fix "Link is Down" issue
Message-ID: <20211124191854.4666a185@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <HK0PR06MB283498AF35B397F05CC627A99C629@HK0PR06MB2834.apcprd06.prod.outlook.com>
References: <20211124061057.12555-1-dylan_hung@aspeedtech.com>
        <CACPK8Xc8aD8nY0M442=BdvrpRhYNS1HW7BNQgAQ+ExTfQMsMyQ@mail.gmail.com>
        <YZ5adFBpaJzPwfvc@lunn.ch>
        <HK0PR06MB283498AF35B397F05CC627A99C629@HK0PR06MB2834.apcprd06.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Nov 2021 03:08:22 +0000 Dylan Hung wrote:
> > > We should cc stable too.  
> > 
> > https://www.kernel.org/doc/html/v5.12/networking/netdev-FAQ.html#how-do-
> > i-indicate-which-tree-net-vs-net-next-my-patch-should-be-in
>
> Sorry, I got this mail after I sent v2 out.  Should I prepare patch
> v3 with --subject-prefix='PATCH net'?

That's leave it be now, but please keep this in mind in the future.
