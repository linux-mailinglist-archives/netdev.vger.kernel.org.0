Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54EA930E3EB
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 21:15:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231775AbhBCUOf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 15:14:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:48600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231301AbhBCUOe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 15:14:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4330D64F74;
        Wed,  3 Feb 2021 20:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612383234;
        bh=naNYzzp/Pabw0t7/SkNVodAlMDX6j6FT3sxuxohzUh8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WSKkSV5DfTxMJnhGRZ6nntyDNi/AStZe4iWWJplcpwQ69JJgQDZQLOv7/0pRsi/c9
         ffB6ofGRaZcwvf062v2e+AuMsN4mwXJw+QlDgYOalkJy6Tzsvs1mTVGQdtQwriI5Id
         w1tzciPi/rPlZDqiwgqTBrbbNDEaGW3JPBjtdbEPUu/vewVZ22XoXMqWODcf8WoTEt
         z+PB0JMns46MVwDo7NicMcnrUsUetANiejIyf6wmosYTFfs8mW27n8J+W2lgv2OVJY
         Yq/kBOI0CbPASfGy3tgJPtenk9hKCoRc2QXxGH8ocSi8zBNJIdCu3eRRzPxU4Bh6AU
         uZXpU0y4pfogw==
Date:   Wed, 3 Feb 2021 12:13:52 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, linux@armlinux.org.uk,
        davem@davemloft.net, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: net: ehternet: i825xx: Fix couple of spellings
 in the file ether1.c
Message-ID: <20210203121352.41b4733d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <fb09ac34-12a9-f7df-131e-a98497f49d1b@infradead.org>
References: <20210203151547.13273-1-unixbhaskar@gmail.com>
        <fb09ac34-12a9-f7df-131e-a98497f49d1b@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 3 Feb 2021 09:54:22 -0800 Randy Dunlap wrote:
> On 2/3/21 7:15 AM, Bhaskar Chowdhury wrote:
> > 
> > s/initialsation/initialisation/
> > s/specifiing/specifying/
> > 
> > Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>  
> 
> Hi,
> 
> $Subject has a typo/spello.

This happens more than you'd think with spell fixies. Always makes me
chuckle. FWIW "net: i825xx:" is enough of a prefix, no need to
transcribe the entire directory path.

> The 2 fixes below look good (as explained in the patch description),
> but:
> can you explain the 3 changes below that AFAICT do nothing?

I think we can jump to the conclusion that Bhaskar's editor cleanup up
trailing white space.

Bhaskar please make sure that the patch does not make unrelated white 
space changes.

> >  drivers/net/ethernet/i825xx/ether1.c | 10 +++++-----
> >  1 file changed, 5 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/i825xx/ether1.c b/drivers/net/ethernet/i825xx/ether1.c
> > index a0bfb509e002..0233fb6e222d 100644
> > --- a/drivers/net/ethernet/i825xx/ether1.c
> > +++ b/drivers/net/ethernet/i825xx/ether1.c
> > @@ -885,7 +885,7 @@ ether1_recv_done (struct net_device *dev)
> >  		ether1_writew(dev, 0, priv(dev)->rx_tail, rfd_t, rfd_command, NORMALIRQS);
> >  		ether1_writew(dev, 0, priv(dev)->rx_tail, rfd_t, rfd_status, NORMALIRQS);
> >  		ether1_writew(dev, 0, priv(dev)->rx_tail, rfd_t, rfd_rbdoffset, NORMALIRQS);
> > -
> > +
> >  		priv(dev)->rx_tail = nexttail;
> >  		priv(dev)->rx_head = ether1_readw(dev, priv(dev)->rx_head, rfd_t, rfd_link, NORMALIRQS);
> >  	} while (1);
> > @@ -1031,7 +1031,7 @@ ether1_probe(struct expansion_card *ec, const struct ecard_id *id)
> > 
> >  	printk(KERN_INFO "%s: ether1 in slot %d, %pM\n",
> >  		dev->name, ec->slot_no, dev->dev_addr);
> > -
> > +
> >  	ecard_set_drvdata(ec, dev);
> >  	return 0;
> > 
> > @@ -1047,7 +1047,7 @@ static void ether1_remove(struct expansion_card *ec)
> >  {
> >  	struct net_device *dev = ecard_get_drvdata(ec);
> > 
> > -	ecard_set_drvdata(ec, NULL);
> > +	ecard_set_drvdata(ec, NULL);
> > 
> >  	unregister_netdev(dev);
> >  	free_netdev(dev);
> > --
> > 2.26.2
> >   
> 
> 

