Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99BFE1D3224
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 16:07:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727788AbgENOH1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 10:07:27 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60298 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726087AbgENOH0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 May 2020 10:07:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=wwRhkKn0eHdoukuepMwhCHkQwW3Cuk8zKvhH1DL4z7w=; b=BXi9swYQFOrPgF2aJ5s3juPkrR
        E/NWZfeq+i3Rlpid+K9n896iPxO8QPw1PLuIUwsPWVTm4anahEXPrf80nZakmaWRsfkC3Bk1BFOn4
        6FAgqXb31bhasJDtlAzxc9+amMkZCSN6u87B7nqW4LzSHO7vyoqP4vO57Odcjx2Ud+ok=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jZEWA-002I7L-IZ; Thu, 14 May 2020 16:07:22 +0200
Date:   Thu, 14 May 2020 16:07:22 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: Re: [PATCH V5 18/19] net: ks8851: Implement Parallel bus operations
Message-ID: <20200514140722.GQ499265@lunn.ch>
References: <20200514000747.159320-1-marex@denx.de>
 <20200514000747.159320-19-marex@denx.de>
 <20200514015753.GL527401@lunn.ch>
 <5dbab44d-de45-f8e2-b4e4-4be15408657e@denx.de>
 <20200514131527.GN527401@lunn.ch>
 <16f60604-f3e9-1391-ff47-37c40ab9c6f7@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16f60604-f3e9-1391-ff47-37c40ab9c6f7@denx.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> All right
> 
> btw is jiffies-based timeout OK? Like this:

If you can, make use of include/linux/iopoll.h

   Andrew
