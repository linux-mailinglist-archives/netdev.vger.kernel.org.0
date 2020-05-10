Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCB451CCCDF
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 20:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728926AbgEJSVn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 May 2020 14:21:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:55102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728381AbgEJSVn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 May 2020 14:21:43 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71C1520801;
        Sun, 10 May 2020 18:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589134902;
        bh=c3BcTIC6SXMFE4zC+I8LcvNAaL7wSIvsn8x+Ob9psn0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LPva1NKCjJ4OXpgh+4/WW5Q/hhkMFLAgBAmxWHOJ9C7T+xecxTYjgN+eD8qadlwaD
         7QrXfzrNKls6yMsVV6xsY5oVGmjuSoDCmc3MLGDtuso773Hwerfuit4QCLWQwaip87
         2nCEIIx1+Ut8f1qJxpT8Tnp1MFfsb06JpN3zImrg=
Date:   Sun, 10 May 2020 11:21:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Walle <michael@walle.cc>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next 0/4] net: phy: broadcom: cable tester support
Message-ID: <20200510112140.0203889e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200509223714.30855-1-michael@walle.cc>
References: <20200509223714.30855-1-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 10 May 2020 00:37:10 +0200 Michael Walle wrote:
> Add cable tester support for the Broadcom PHYs. Support for it was
> developed on a BCM54140 Quad PHY which RDB register access.
> 
> If there is a link partner the results are not as good as with an open
> cable. I guess we could retry if the measurement until all pairs had at
> least one valid result.
> 
> Please note that this patch depends on Andrew's latest cable testing
> series:
> https://lore.kernel.org/netdev/20200509162851.362346-1-andrew@lunn.ch/

Thanks for posting the patches early Michael, it's definitely useful,
but I'd advise to post as RFC before the dependency is in the tree.
CI bots won't understand English well enough to take care of this
dependency, so we're loosing whatever test coverage they provide..

Please repost once Andrew's patches get merged, I'm marking these as
RFC in patchwork for now.
