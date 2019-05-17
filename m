Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B4B521F84
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 23:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbfEQVUK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 17:20:10 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38701 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726731AbfEQVUJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 May 2019 17:20:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=vWNBmZaoo6h8PhQPos96OVGTC8ag0hj9BvGmBslFh5s=; b=YrhFKSN26z9kCYRl0BPeMZnmnI
        pQbSrya21Qri4trQIfDkCeFp5emc2IHSYi8zwrUGvO7R48Q3U6K8MIOBrfsO35NPFK49DuZbJ4mYL
        YDE0vUhX/2IcyVHxhCLIYaPIsLFwsFvf4E6C6J4ctwQI/UyZGeqma/5YJVsu6liEXEVw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hRkGp-0008K9-0I; Fri, 17 May 2019 23:20:03 +0200
Date:   Fri, 17 May 2019 23:20:02 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Schmitz <schmitzmic@gmail.com>
Cc:     netdev@vger.kernel.org, schmitz@debian.org, sfr@canb.auug.org.au,
        davem@davemloft.net
Subject: Re: [PATCH 0/3] resolve module name conflict for asix PHY and USB
 modules
Message-ID: <20190517212002.GA22024@lunn.ch>
References: <20190514105649.512267cd@canb.auug.org.au>
 <1558124718-19209-1-git-send-email-schmitzmic@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1558124718-19209-1-git-send-email-schmitzmic@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 18, 2019 at 08:25:15AM +1200, Michael Schmitz wrote:
> Haven't heard back in a while, so here goes: 
> 
> Commit 31dd83b96641 ("net-next: phy: new Asix Electronics PHY driver")
> introduced a new PHY driver drivers/net/phy/asix.c that causes a module
> name conflict with a pre-existiting driver (drivers/net/usb/asix.c). 
> 
> The PHY driver is used by the X-Surf 100 ethernet card driver, and loaded
> by that driver via its PHY ID. A rename of the driver looks unproblematic.
>  
> Rename PHY driver to ax88796b.c in order to resolve name conflict. 

Hi Michael

Please just use git mv and do it all one patch. It then makes it clear
you have not changed the driver, just renamed it.

Thanks
	Andrew
