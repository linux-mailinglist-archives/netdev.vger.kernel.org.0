Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D51BB2E00AC
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 20:09:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726207AbgLUTIK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 14:08:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:55546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725780AbgLUTIK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Dec 2020 14:08:10 -0500
Date:   Mon, 21 Dec 2020 11:07:28 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608577649;
        bh=mVMpxRgVbjqNwdwri6h6wUuxC8sIdUi3TgWil6YcDxo=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=KSqQNDmWh4BBGkZfDc/8l6sN7aRCvvjpnBOe6DRzWQo/7kvd4zZHpo8ue99bdeafO
         gDpsGlO/fDWJaq2chzxcI3ARaRL50VNLbK+1b/94BvKn0LHg5Ydgj8itYD6bglG+Xj
         5fW/2mUbrKKTnGyNkgUcjUU4JvogIfH/1uVBziQeQUPYkFodlQjayZl1F0stmUpQuZ
         kXisE1q8NqykH+sTlg5cMMePQm//k1yvieW6vJjP4u8Kc6TNsDyHwr5/2cND8SUHpF
         h0RgYzwB2KDfarbTq7Iy18dvFrlwoNmblr3nDhFiXHytnfEgEvZl1EF5sye9MMfJgZ
         qrN9/pXbgRytg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stefan Chulski <stefanc@marvell.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "rmk+kernel@armlinux.org.uk" <rmk+kernel@armlinux.org.uk>,
        Liron Himi <lironh@marvell.com>
Subject: Re: [EXT] Re: [PATCH net-next] net: mvpp2: prs: improve ipv4 parse
 flow
Message-ID: <20201221110728.22e91152@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CO6PR18MB3873C6157D3F89092964B14FB0C10@CO6PR18MB3873.namprd18.prod.outlook.com>
References: <1608221278-15043-1-git-send-email-stefanc@marvell.com>
        <20201219100345.22d86122@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CO6PR18MB3873C6157D3F89092964B14FB0C10@CO6PR18MB3873.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 20 Dec 2020 11:11:35 +0000 Stefan Chulski wrote:
> > RFC patches sent for review only are obviously welcome at any time.  
> 
> If I post RFC patches for review only, should I add some prefix or tag for this?

Include RFC in the tag: [RFC net-next] or [PATCH RFC net-next],
this way patchwork will automatically mark it as RFC and we'll
know you're not expecting us to apply the patch.

> And if all reviewers OK with change(or no comments at all), should I
> repost this patch again after net-next opened?

Sure, if there are no comments or you're confident the change is
correct there is no need for an RFC posting. I'm guessing that was 
your question? If you're asking if you _have_ to repost even if there 
are not comments the answer is yes, we don't queue patches "to be
applied later", fresh posting will be needed.
