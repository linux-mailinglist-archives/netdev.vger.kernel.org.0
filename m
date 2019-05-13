Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7051B660
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 14:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729946AbfEMMuJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 08:50:09 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33718 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728943AbfEMMuJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 May 2019 08:50:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=pv45FV0SS8BEAUpDVaxiRJs217OXc9ARoRbuV0Fvm4M=; b=a8mUiJqkoKnPfssjVdTW193/ay
        xDouV5CxbocUpAszWL5LLdiSbycwkqQPd7tqhn/KF1tUB/2isj6CKJ2102u6Bo3nME24hp/VKgqnF
        b0fJCGtMem0Xh/CzCE9ODwSWaHbngCOLgzOJSPs2DNbMt9tyD14wYiKwbZiTw8DlgbSU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hQAP4-0008BI-Ec; Mon, 13 May 2019 14:50:02 +0200
Date:   Mon, 13 May 2019 14:50:02 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: phy: realtek: Replace phy functions with
 non-locked version in rtl8211e_config_init()
Message-ID: <20190513125002.GB28969@lunn.ch>
References: <1557729705-6443-1-git-send-email-hayashi.kunihiko@socionext.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1557729705-6443-1-git-send-email-hayashi.kunihiko@socionext.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 13, 2019 at 03:41:45PM +0900, Kunihiko Hayashi wrote:
> After calling phy_select_page() and until calling phy_restore_page(),
> the mutex 'mdio_lock' is already locked, so the driver should use
> non-locked version of phy functions. Or there will be a deadlock with
> 'mdio_lock'.
> 
> This replaces phy functions called from rtl8211e_config_init() to avoid
> the deadlock issue.
> 
> Fixes: f81dadbcf7fd ("net: phy: realtek: Add rtl8211e rx/tx delays config")
> Signed-off-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
