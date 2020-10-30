Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB38B2A0B17
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 17:29:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726430AbgJ3Q36 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 12:29:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725844AbgJ3Q35 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 12:29:57 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E610C0613CF
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 09:29:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=nMp0O0UxBd2Mv9iIRADZEHHLyuya2BtFbaxYYEgB0kQ=; b=i2eSxiicwE1xL+QxUvI7SjQh0
        gcy+s8nlXEpNVutyp70uXmV6F9HACycPm1XlQUveOheDKy5Vx1YSE43x+hxBjwAIoXqYVi+bgaIQM
        yxY4z4ZeKXcj7GoVvJCgCJMvZ2rAUqnaFoxFwy0pvmJV+hLgdFnBQi5WnwaKc1KpY1toIm5bey+yi
        rNwHt1hiaJ4bSc+YTsdYQid+A3ihlOkIf2hgc0v5mIqQ4BmZsygrCXsOBKZw2FZaR8yLHvsSCv0Rf
        GsmJahnVooj01Wvbp4PCujz5xLlqtgMlXTZ8kfU1oI8TO+P0GOjOSZSWIIw1tTgnZLL+eii1va1Xp
        WSOr12QnQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:52954)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kYXHk-0006M4-Dk; Fri, 30 Oct 2020 16:29:52 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kYXHh-0007Iv-Uj; Fri, 30 Oct 2020 16:29:49 +0000
Date:   Fri, 30 Oct 2020 16:29:49 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next v2 2/5] net: phylink: allow attaching phy for
 SFP modules on 802.3z mode
Message-ID: <20201030162949.GD1551@shell.armlinux.org.uk>
References: <20201029222509.27201-1-kabel@kernel.org>
 <20201029222509.27201-3-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201029222509.27201-3-kabel@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 29, 2020 at 11:25:06PM +0100, Marek Behún wrote:
> Some SFPs may contain an internal PHY which may in some cases want to
> connect with the host interface in 1000base-x/2500base-x mode.
> Do not fail if such PHY is being attached in one of these PHY interface
> modes.
> 
> Signed-off-by: Marek Behún <kabel@kernel.org>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Russell King <rmk+kernel@armlinux.org.uk>

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
