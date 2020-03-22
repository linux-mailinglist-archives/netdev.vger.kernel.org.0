Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D116C18EBC0
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 20:06:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726797AbgCVTGE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 15:06:04 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50670 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725881AbgCVTGD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Mar 2020 15:06:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=SEiG5DvzF7klvpfRDNwNaEO0lzYKIPH2n0p4wyrcEqE=; b=pSXieA7QEgxvUmEoqhNFw3qJYc
        2ttuurZUSL5+8mvVfArKEYmCjyyXap0WGn3KBNsuc6BIG6imnPlfufr4Pc5LziStZrredTb//K6gL
        Ktd55+BQCD/zdPLuvxtdPxf19yPgzorWRKkL4SUyJcVVVH/yZP4zs/EBAP+0xpIkba70=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jG5uy-0001tO-2d; Sun, 22 Mar 2020 20:05:52 +0100
Date:   Sun, 22 Mar 2020 20:05:52 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dejin Zheng <zhengdejin5@gmail.com>
Cc:     f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, mchehab+samsung@kernel.org, corbet@lwn.net,
        gregkh@linuxfoundation.org, broonie@kernel.org, tglx@linutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v5 08/10] net: phy: use phy_read_poll_timeout()
 to simplify the code
Message-ID: <20200322190552.GD3819@lunn.ch>
References: <20200322174943.26332-1-zhengdejin5@gmail.com>
 <20200322174943.26332-9-zhengdejin5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200322174943.26332-9-zhengdejin5@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 23, 2020 at 01:49:41AM +0800, Dejin Zheng wrote:
> use phy_read_poll_timeout() to replace the poll codes for
> simplify the code in phy_poll_reset() function.
> 
> Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
