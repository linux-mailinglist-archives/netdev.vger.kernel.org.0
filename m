Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9028041897D
	for <lists+netdev@lfdr.de>; Sun, 26 Sep 2021 16:35:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231880AbhIZOgs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Sep 2021 10:36:48 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60914 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231876AbhIZOgr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Sep 2021 10:36:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Kb0PYJpLBzmebaR2WWpkR2c9qQSqhrZZ1IR0APR+94I=; b=KIOBxe9Mf2KDsBx5SM51Tp+gdH
        qkbTL74pvnu0Rxyo1pw6bMkEfYkLa7t/M0m3xCYb75Tf29ShOibtSxZEEQWR23rPhNH8upXLv48Ps
        zF5PGcNAN6k5t8gC6DmXh4o3cZe41CCBVR3O8NrzxMNSFwyhVpTZGt5i3XDwgHToMjf4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mUVFF-008K9B-C7; Sun, 26 Sep 2021 16:35:09 +0200
Date:   Sun, 26 Sep 2021 16:35:09 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Christian Lamparter <chunkeey@gmail.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next v1] net: ethernet: emac: utilize of_net's
 of_get_mac_address()
Message-ID: <YVCFHT7F2e6OOThM@lunn.ch>
References: <20210926095648.244445-1-chunkeey@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210926095648.244445-1-chunkeey@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +	err = of_get_mac_address(np, dev->ndev->dev_addr);
> +	if (err) {
> +		if (err != -EPROBE_DEFER)
> +			dev_err(&dev->ofdev->dev, "Can't get valid [local-]mac-address from OF !\n");
> +		return err;

I think there is a helper which does the if (err != -EPRODE_DEFER)
then print, but i cannot remember its name. Probably the script kids
will come along and convert it for you.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
