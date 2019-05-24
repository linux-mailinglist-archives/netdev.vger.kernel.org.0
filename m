Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0ECAA29F52
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 21:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391712AbfEXTqk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 15:46:40 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56994 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391181AbfEXTqk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 May 2019 15:46:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=npdTHUhEtUEHQ08Cj3LyglYIMvauLPD/ArqXgRmDhxc=; b=gjis12TqBU1Vj2YTkxwl495ZWn
        KhopAjZMv0HuHQBcE3xlfjfS6MyJd6JDMuWts4D1OcBNZjfc+1xMeX/YtrsFZaLXwfrm+/xha1t4P
        n9PCuSUS21Lq8vhSB9JL4kwA8JDC7GvI4lbP6bJZvkou7YnCJXfOWkn1Vb+341hcsEcI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hUG9E-0004BB-I8; Fri, 24 May 2019 21:46:36 +0200
Date:   Fri, 24 May 2019 21:46:36 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Krzysztof Halasa <khalasa@piap.pl>
Subject: Re: [PATCH 1/8] net: ethernet: ixp4xx: Standard module init
Message-ID: <20190524194636.GN21208@lunn.ch>
References: <20190524162023.9115-1-linus.walleij@linaro.org>
 <20190524162023.9115-2-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190524162023.9115-2-linus.walleij@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 24, 2019 at 06:20:16PM +0200, Linus Walleij wrote:
> The IXP4xx driver was initializing the MDIO bus before even
> probing, in the callbacks supposed to be used for setting up
> the module itself, and with the side effect of trying to
> register the MDIO bus as soon as this module was loaded or
> compiled into the kernel whether the device was discovered
> or not.

Hi Linus

What is the address space like? Could the mdio driver be pull out into
a standalone driver?

  Andrew
