Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA3B52239E
	for <lists+netdev@lfdr.de>; Sat, 18 May 2019 16:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729485AbfEROUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 May 2019 10:20:15 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38950 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727594AbfEROUO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 May 2019 10:20:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=q/Or2e3m1CSnpWQWrS5RqQhooXZfxL6gF3q5sD6ymVI=; b=s7V1oY+OMAA2Z29dmp8X4Egb1Y
        EADoQ4/ks3lx8LGwhQKnZNZcIQ1Xj9aolG19w0gXB19eb2dVwd2RnLmd/QPOG7O4RNaYBa6k3pbNw
        xRN5372FSpDwy4qCCo9jNFqk1u0wDwKxk2bnhrX3655/qRcoC04/Hu6PspYuMS4LtwiI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hS0C2-0006I1-4e; Sat, 18 May 2019 16:20:10 +0200
Date:   Sat, 18 May 2019 16:20:10 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Schmitz <schmitzmic@gmail.com>
Cc:     netdev@vger.kernel.org, netdev@vger.kernel-org, schmitz@debian.org,
        davem@davemloft.net, sfr@canb.auug.org.au
Subject: Re: [PATCH v2] net: phy: rename Asix Electronics PHY driver
Message-ID: <20190518142010.GL14298@lunn.ch>
References: <20190514105649.512267cd@canb.auug.org.au>
 <1558142095-20307-1-git-send-email-schmitzmic@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1558142095-20307-1-git-send-email-schmitzmic@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 18, 2019 at 01:14:55PM +1200, Michael Schmitz wrote:
> Commit 31dd83b96641 ("net-next: phy: new Asix Electronics PHY driver")
> introduced a new PHY driver drivers/net/phy/asix.c that causes a module
> name conflict with a pre-existiting driver (drivers/net/usb/asix.c).
> 
> The PHY driver is used by the X-Surf 100 ethernet card driver, and loaded
> by that driver via its PHY ID. A rename of the driver looks unproblematic.
> 
> Rename PHY driver to ax88796b.c in order to resolve name conflict.
> 
> Signed-off-by: Michael Schmitz <schmitzmic@gmail.com>
> Fixes: 31dd83b96641 ("net-next: phy: new Asix Electronics PHY driver")
> ---
> 
> Changes from v1:
> 
> - merge into single commit (suggested by Andrew Lunn)

Hi Michael

There is a flag you can pass to git which will make it issue a rename,
rather than delete and then add. That will make the patch much
smaller.

net-next is closed at the moment.

http://vger.kernel.org/~davem/net-next.html

Once it reopens, please send a v3, and it will be merged.

Thanks
	Andrew
