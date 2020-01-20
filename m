Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 325021433CF
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 23:19:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbgATWTY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 17:19:24 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:47388 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726752AbgATWTY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jan 2020 17:19:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Xu+XNGpc25wEw4d1IWRPuU0/6caDdUIr3ZUKAJ3cpRM=; b=NG0TxKiKWn7+tvl6+Qp6q0krws
        xsIreLBoqy9q9B6lBtuDNP4dXHA6UIJvAV86xzGk4zFGLTDGWZLjvGOW41fkNmphu5u1gXwqZs8xu
        RpX8Dd1p1OYM+P687BZCU6/D954x1MAXKLuyrdFkfNgaaX2biNWjkMrcfOb4eKrGqBck=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1itfOD-0001ea-Dj; Mon, 20 Jan 2020 23:19:21 +0100
Date:   Mon, 20 Jan 2020 23:19:21 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        Mark Einon <mark.einon@gmail.com>,
        Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 3/3] net: convert suitable network drivers to
 use phy_do_ioctl
Message-ID: <20200120221921.GF1466@lunn.ch>
References: <a7a6dc1f-b4d4-e36f-7408-31e4715d947f@gmail.com>
 <793a9ff0-3fa1-c811-fdd3-4a704d680371@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <793a9ff0-3fa1-c811-fdd3-4a704d680371@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 20, 2020 at 10:18:37PM +0100, Heiner Kallweit wrote:
> Convert suitable network drivers to use phy_do_ioctl.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

