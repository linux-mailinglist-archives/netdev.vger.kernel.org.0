Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 865D130E186
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 18:57:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231516AbhBCRzL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 12:55:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231145AbhBCRzK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 12:55:10 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 625DFC061573;
        Wed,  3 Feb 2021 09:54:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=YkBJ95tIOheMu1qT8WUd4dMwBVvw2q3v5lgMfHoq7kk=; b=NoLr8WrKRkeWsZEmixlM19kKb8
        ylLZ3Q4fyuek/8iEEdACx+Bs+ZmUQ1yFrBwv+LzVNy6N315lVq+ieAykNyvh3X35zyHAuTOZhz9Zm
        nQhQKJRJxZlUaZcw4zyQbdb3qDLBKymBp6eo5lJGGsk4yvw6i3s5TPHRYd5ey+DdEHbTKLNQfK+nw
        z+pg3Zk+F8HmVtAhFtD9Ww+BvDFzkD6XBl9vOfOo98j1xQvyYogudj9lVY65HL/1nTjI9M0btzklp
        +cd6omQVMX2J4fXQo9q6tHwK9iBDBsaB8gNf6T4akDkf/sfY4DpRhmjb0bZwPulswriCgeJ+fbgG4
        +r1XvbUg==;
Received: from [2601:1c0:6280:3f0::aec2]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1l7MME-0002YH-NI; Wed, 03 Feb 2021 17:54:27 +0000
Subject: Re: [PATCH] drivers: net: ehternet: i825xx: Fix couple of spellings
 in the file ether1.c
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210203151547.13273-1-unixbhaskar@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <fb09ac34-12a9-f7df-131e-a98497f49d1b@infradead.org>
Date:   Wed, 3 Feb 2021 09:54:22 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20210203151547.13273-1-unixbhaskar@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/3/21 7:15 AM, Bhaskar Chowdhury wrote:
> 
> s/initialsation/initialisation/
> s/specifiing/specifying/
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>

Hi,

$Subject has a typo/spello.

The 2 fixes below look good (as explained in the patch description),
but:
can you explain the 3 changes below that AFAICT do nothing?


> ---
>  drivers/net/ethernet/i825xx/ether1.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/i825xx/ether1.c b/drivers/net/ethernet/i825xx/ether1.c
> index a0bfb509e002..0233fb6e222d 100644
> --- a/drivers/net/ethernet/i825xx/ether1.c
> +++ b/drivers/net/ethernet/i825xx/ether1.c
> @@ -885,7 +885,7 @@ ether1_recv_done (struct net_device *dev)
>  		ether1_writew(dev, 0, priv(dev)->rx_tail, rfd_t, rfd_command, NORMALIRQS);
>  		ether1_writew(dev, 0, priv(dev)->rx_tail, rfd_t, rfd_status, NORMALIRQS);
>  		ether1_writew(dev, 0, priv(dev)->rx_tail, rfd_t, rfd_rbdoffset, NORMALIRQS);
> -
> +
>  		priv(dev)->rx_tail = nexttail;
>  		priv(dev)->rx_head = ether1_readw(dev, priv(dev)->rx_head, rfd_t, rfd_link, NORMALIRQS);
>  	} while (1);
> @@ -1031,7 +1031,7 @@ ether1_probe(struct expansion_card *ec, const struct ecard_id *id)
> 
>  	printk(KERN_INFO "%s: ether1 in slot %d, %pM\n",
>  		dev->name, ec->slot_no, dev->dev_addr);
> -
> +
>  	ecard_set_drvdata(ec, dev);
>  	return 0;
> 
> @@ -1047,7 +1047,7 @@ static void ether1_remove(struct expansion_card *ec)
>  {
>  	struct net_device *dev = ecard_get_drvdata(ec);
> 
> -	ecard_set_drvdata(ec, NULL);
> +	ecard_set_drvdata(ec, NULL);
> 
>  	unregister_netdev(dev);
>  	free_netdev(dev);
> --
> 2.26.2
> 


-- 
~Randy

