Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37BBD437EB6
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 21:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234230AbhJVTj3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 15:39:29 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53492 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234043AbhJVTjW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 15:39:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=sR6DXOGvr13Avo2THrpUTK4cG7cus+nMaxnZNFmD8kU=; b=vRFGDjIYsP5wIaWI0NFR0A8HVz
        9SDi6MD90mCyJH793K4LMgnozoEeFHUr7FAi4F6wJ/2cjEtcBwWmzvJmXW5D1Ccfs3OkLdiQ+Wdp0
        uLCm8OV9kxST7zL5t9Q/NGoiuNvF05po/9Tu05T1eoY3Ntqvb+2CXm0edbq/o7iUXdQc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1me0Lb-00BQIt-NZ; Fri, 22 Oct 2021 21:36:59 +0200
Date:   Fri, 22 Oct 2021 21:36:59 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Doug Berger <opendmb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:BROADCOM GENET ETHERNET DRIVER" 
        <bcm-kernel-feedback-list@broadcom.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 3/3] net: bcmgenet: Add support for 7712 16nm
 internal EPHY
Message-ID: <YXMS23QSf55r8vBT@lunn.ch>
References: <20211022161703.3360330-1-f.fainelli@gmail.com>
 <20211022161703.3360330-4-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211022161703.3360330-4-f.fainelli@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 22, 2021 at 09:17:03AM -0700, Florian Fainelli wrote:
> The 16nm internal EPHY that is present in 7712 is actually a 16nm
> Gigabit PHY which has been forced to operate in 10/100 mode.

Hi Florian

Will genphy_read_abilities() detect it as a 1G PHY? Does bcmgenet.c
need to call phy_set_max_speed() to stop it advertising 1G?

Andrew
