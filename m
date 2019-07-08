Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFEA36270F
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 19:28:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389055AbfGHR2P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 13:28:15 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:32772 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728744AbfGHR2P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jul 2019 13:28:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=M3zgtKURWFQr5PaK8JSTuxRaIlcnl298Ex2ZMAz+ZMw=; b=RRubzNit/N+zEgZgi6HuTpIJVd
        InOvszBgF1/Wi8L3WDfWk3f3+uaJbfHmaBLjyHuNabq/Zfvc1Mg0MBZHF8EVWH0kM8NhA4mM8fhpQ
        OexX5T83NCVS/RlRRqNsDKiGz3wqT6NoxTJVIrWnyXP+UKNvJg92ysjxbsseEYBoYyos=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hkXQu-0003io-M8; Mon, 08 Jul 2019 19:28:08 +0200
Date:   Mon, 8 Jul 2019 19:28:08 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, paweldembicki@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: vsc73xx: Fix Kconfig warning and
 build errors
Message-ID: <20190708172808.GG9027@lunn.ch>
References: <20190708144224.33376-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190708144224.33376-1-yuehaibing@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 08, 2019 at 10:42:24PM +0800, YueHaibing wrote:
> Fix Kconfig dependency warning and subsequent build errors
> caused by OF is not set:
> 
> WARNING: unmet direct dependencies detected for NET_DSA_VITESSE_VSC73XX
>   Depends on [n]: NETDEVICES [=y] && HAVE_NET_DSA [=y] && OF [=n] && NET_DSA [=m]
>   Selected by [m]:
>   - NET_DSA_VITESSE_VSC73XX_PLATFORM [=m] && NETDEVICES [=y] && HAVE_NET_DSA [=y] && HAS_IOMEM [=y]
> 
> Move OF and NET_DSA dependencies to NET_DSA_VITESSE_VSC73XX/
> NET_DSA_VITESSE_VSC73XX_PLATFORM to fix this.

Hi YueHaibing

I might be better to make NET_DSA_VITESSE_VSC73XX_SPI and NET_DSA_VITESSE_VSC73XX_PLATFORM
depend on NET_DSA_VITESSE_VSC73XX rather than select it.

       Andrew
