Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9ED7190DFD
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 13:48:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727681AbgCXMsD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 08:48:03 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54230 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727671AbgCXMsC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Mar 2020 08:48:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=b0iBI1cc2tZNm5/8uDcBP6+/M1WQDfg4ylMZdebmF7w=; b=Oyy3r90z9xt3/YwskzsK2QPyII
        bYHCoCe6nX7gd5WNSJGrLTKKxwI6ZwS23FM/t9lc4mCSi9C9ENDDMn2M5ZYh1S6sMhJO8clPsvmM/
        Cbe7VQE3a/rLZ1Vp/1MwZNGKcNfsuGyodnddelVWX1vQO4oKlULYO8fCTyTI5EtOc7Qk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jGiyJ-0001hK-Lx; Tue, 24 Mar 2020 13:47:55 +0100
Date:   Tue, 24 Mar 2020 13:47:55 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dejin Zheng <zhengdejin5@gmail.com>
Cc:     f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, rjui@broadcom.com, sbranden@broadcom.com,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: phy: mdio-mux-bcm-iproc: use
 readl_poll_timeout() to simplify code
Message-ID: <20200324124755.GV3819@lunn.ch>
References: <20200324112647.27237-1-zhengdejin5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324112647.27237-1-zhengdejin5@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 24, 2020 at 07:26:47PM +0800, Dejin Zheng wrote:
> use readl_poll_timeout() to replace the poll codes for simplify
> iproc_mdio_wait_for_idle() function
> 
> Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
