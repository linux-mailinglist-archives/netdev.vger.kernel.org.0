Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA9E26D589
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 22:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391490AbfGRT7x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 15:59:53 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50932 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727687AbfGRT7x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jul 2019 15:59:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=R7O5LP/5Ym00KWv7HG9gFcq8IIB8ZOQ/FMTwFy1ifdg=; b=M1mdM+DLgSvZed+ZFt8f3/ZFkl
        nuhpiL9qV1pIcRRB5dP2Kc/Gw05xN5FqwBWRLf7AkuCGk70khNSU24swBaggDsftwMx9doClqPF4D
        8sA2aFROBc5IZS3yB52zh02onqmwG+dxfDLUvt0+QgnWf65hgzzKxGGJu3SzNfsxYKzE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hoCZB-00037X-NR; Thu, 18 Jul 2019 21:59:49 +0200
Date:   Thu, 18 Jul 2019 21:59:49 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sven Van Asbroeck <thesven73@gmail.com>
Cc:     Fabio Estevam <festevam@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Fugang Duan <fugang.duan@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: fec: generate warning when using deprecated phy
 reset
Message-ID: <20190718195949.GM25635@lunn.ch>
References: <20190718143428.2392-1-TheSven73@gmail.com>
 <1563468471.2676.36.camel@pengutronix.de>
 <CAOMZO5A_BuWMr1n_fFv4veyaXdcfjxO+9nFAgGfCrmAhNmzV5g@mail.gmail.com>
 <CAGngYiULAjXwwxmUyHxEXhv1WzSeE_wE3idOLSnD5eEaZg3xDw@mail.gmail.com>
 <20190718194131.GK25635@lunn.ch>
 <CAGngYiWESbg6uq4pdtb5--YSzatwAwXiGnRjiAfAQj8nRYPMqw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGngYiWESbg6uq4pdtb5--YSzatwAwXiGnRjiAfAQj8nRYPMqw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> What I keep forgetting in my little arm-imx6 world, is that devicetrees
> aren't in-kernel apis, but that they have out-of-kernel
> dependencies. It makes more sense to to see them as userspace
> apis, albeit directed at firmware/bootloaders, right?

It is an ongoing debate, but generally they should be considered ABI
and follow the ABI rules about not breaking backwards compatibility.

However, there is also an argument that something like a NAS box
running Debian is going to use the DT blob which came with the kernel,
so deprecated DT properties and the code to support them could be
removed after a period of time.

	Andrew
