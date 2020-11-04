Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 715C42A5C1B
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 02:44:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730383AbgKDBoH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 20:44:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:34874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725769AbgKDBoH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 20:44:07 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5CCFC20870;
        Wed,  4 Nov 2020 01:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604454246;
        bh=KI9LQShmDq+BbAxyoPo9nBH0BUcZngj2x4XBVSVL14w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=0ua95QE7dN8/a8uyJ6TB/dmYe2R82r63Nk28Q2eoBMlXBkxvMNijRhLFW0h0ekJ16
         9oxv+lGEGP/qRi7wM4bmDYwfpCfivLfGA3FcvoreQenaOmt4+HgwUv8Cz9izYqA6s/
         KOighz9KFjh5dBklzmZ5BZ4t/Mp7yycD6ivhLHmc=
Date:   Tue, 3 Nov 2020 17:44:05 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hayes Wang <hayeswang@realtek.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Oliver Neukum <oliver@neukum.org>
Subject: Re: [PATCH net-next v2] net/usb/r8153_ecm: support ECM mode for
 RTL8153
Message-ID: <20201103174405.43a4a3ab@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <db4c6b3b30284206a6f131e922760e1e@realtek.com>
References: <1394712342-15778-387-Taiwan-albertk@realtek.com>
        <1394712342-15778-388-Taiwan-albertk@realtek.com>
        <20201031160838.39586608@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <dc7fd1d4d1c544e8898224c7d9b54bda@realtek.com>
        <20201102114718.0118cc12@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <20201103093241.GA79239@kroah.com>
        <20201103081535.7e92a495@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <db4c6b3b30284206a6f131e922760e1e@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 4 Nov 2020 01:39:52 +0000 Hayes Wang wrote:
> Jakub Kicinski <kuba@kernel.org>
> > Sent: Wednesday, November 4, 2020 12:16 AM  
> [...]
> > > So no, please do not create such a common file, it is not needed or a
> > > good idea.  
> > 
> > I wouldn't go that far, PCI subsystem just doesn't want everyone to add
> > IDs to the shared file unless there is a reason.
> > 
> >  *	Do not add new entries to this file unless the definitions
> >  *	are shared between multiple drivers.
> > 
> > Which seems quite reasonable. But it is most certainly your call :)  
> 
> Do I have to resend this patch?

Yes please, that'd be easiest for me. Also Oliver wasn't CCed on this
posting.
