Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE6CF30E7A
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 15:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727114AbfEaNCb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 09:02:31 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44582 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726330AbfEaNCa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 09:02:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=C/iIbFXolCL7AMYPYEBLVId2W+wb3KNv/G2cBSTA9xc=; b=JVDtLGBO85JNnnnXzA/+nYQoQu
        QJJa2HTMTINJoV9hyDFITTGwYahyPGzP+hDIwcHp6cwRk7vvxjx/kD3csSKjmBQtIBVSNH6vnOEEn
        vVbMF4E8T8vPlL9yjWEXWQeWFunygDjQpSv3Jq+CYY5FQzeZEQUKuH/1riadopE4d7VI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hWhAw-0005uH-Lo; Fri, 31 May 2019 15:02:26 +0200
Date:   Fri, 31 May 2019 15:02:26 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net] net: phylink: ensure consistent phy interface mode
Message-ID: <20190531130226.GE18608@lunn.ch>
References: <E1hVYO9-000584-J6@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1hVYO9-000584-J6@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 28, 2019 at 10:27:21AM +0100, Russell King wrote:
> Ensure that we supply the same phy interface mode to mac_link_down() as
> we did for the corresponding mac_link_up() call.  This ensures that MAC
> drivers that use the phy interface mode in these methods can depend on
> mac_link_down() always corresponding to a mac_link_up() call for the
> same interface mode.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
