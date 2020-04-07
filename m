Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E92641A1878
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 01:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbgDGXHh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 19:07:37 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:58034 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726380AbgDGXHh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 19:07:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=ZvEK24UkGqNzOBqjmwZC2IhscWnqjcxBYAU9aBjfkaU=; b=M/gdZ54ulguO3O9Hvd7KmSfZd2
        NpWGOUb8fizHa+JAZwhjfRCxjORim0d/k/isFCCZPSnKEMgGJuHAH0rK7E9zn5gpvdjgcI3XckCHq
        qb7KpNpPTf9j65rQ1j9MYvl37ZA9g79B3NcoJ29if3u/LgLWOs6zC8SP2WsEWrdrV0A93hE25UhEs
        F8uvLgdlVDmPHYEtpNv6qXu+39DH8MWK7rb/EP4SwLgmuNBUFnApIB+82QhIpXwfc+HJOhHyYrzN7
        pWeQ/zLZCnyD/MpMD00INq88BnJAWRYKWOqoYiXZITJqV8jXeoLwtD1mJsJpWn4EaqXZdo8E48gd7
        YxuZMvgg==;
Received: from [2601:1c0:6280:3f0:897c:6038:c71d:ecac]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jLxJg-00038Z-8y; Tue, 07 Apr 2020 23:07:36 +0000
Subject: Re: [PATCH] Documentation: mdio_bus.c - fix warnings
To:     Lothar Rubusch <l.rubusch@gmail.com>, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org
References: <20200406212920.20229-1-l.rubusch@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <138ef631-15fd-f1d3-18cd-2ebd0529699a@infradead.org>
Date:   Tue, 7 Apr 2020 16:07:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200406212920.20229-1-l.rubusch@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/6/20 2:29 PM, Lothar Rubusch wrote:
> Fix wrong parameter description and related warnings at 'make htmldocs'.
> 
> Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org>

> ---
>  drivers/net/phy/mdio_bus.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
> index 522760c8bca6..7a4eb3f2cb74 100644
> --- a/drivers/net/phy/mdio_bus.c
> +++ b/drivers/net/phy/mdio_bus.c
> @@ -464,7 +464,7 @@ static struct class mdio_bus_class = {
>  
>  /**
>   * mdio_find_bus - Given the name of a mdiobus, find the mii_bus.
> - * @mdio_bus_np: Pointer to the mii_bus.
> + * @mdio_name: The name of a mdiobus.
>   *
>   * Returns a reference to the mii_bus, or NULL if none found.  The
>   * embedded struct device will have its reference count incremented,
> 

thanks.
-- 
~Randy
