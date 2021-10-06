Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08C5D42406E
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 16:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231776AbhJFOvc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 10:51:32 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52356 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239165AbhJFOva (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 10:51:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=GxcApIX4fCkYDec6Jrkf/UxGR+hVz6J82NegHKwILBI=; b=FYPDpKwDg+sYnPxuqX16PIuOVA
        SwipTKuhTfdk5TorBroEgWlhrPrHKpIGRWX/LeNF90/JGLcjFfLucs/4qZjrwidTZlqhz2mlL1UTe
        a/ZI7c0IPKDI2a3FJOtMuxHtjL7+ViBGOiTXW68tDk6HkCQAz2hqHxFS1o+rc3GRaR2M=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mY8Ei-009qb5-8d; Wed, 06 Oct 2021 16:49:36 +0200
Date:   Wed, 6 Oct 2021 16:49:36 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, gregkh@linuxfoundation.org,
        rafael@kernel.org, saravanak@google.com, mw@semihalf.com,
        jeremy.linton@arm.com
Subject: Re: [RFC] fwnode: change the return type of mac address helpers
Message-ID: <YV23gINkk3b9m6tb@lunn.ch>
References: <20211006022444.3155482-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211006022444.3155482-1-kuba@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> --- a/drivers/net/ethernet/apm/xgene-v2/main.c
> +++ b/drivers/net/ethernet/apm/xgene-v2/main.c
> @@ -36,7 +36,7 @@ static int xge_get_resources(struct xge_pdata *pdata)
>  		return -ENOMEM;
>  	}
>  
> -	if (!device_get_ethdev_addr(dev, ndev))
> +	if (device_get_ethdev_addr(dev, ndev))
>  		eth_hw_addr_random(ndev);

That is going to be interesting for out of tree drivers.

Otherwise, this looks O.K.

	   Andrew
