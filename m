Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26DAA231947
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 08:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726314AbgG2GEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 02:04:05 -0400
Received: from verein.lst.de ([213.95.11.211]:51036 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726047AbgG2GEF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jul 2020 02:04:05 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 72F0968B05; Wed, 29 Jul 2020 08:04:01 +0200 (CEST)
Date:   Wed, 29 Jul 2020 08:04:01 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     David Miller <davem@davemloft.net>
Cc:     hch@lst.de, jengelh@inai.de, idosch@idosch.org, Jason@zx2c4.com,
        David.Laight@ACULAB.COM, netdev@vger.kernel.org
Subject: Re: [PATCH 4/4] net: improve the user pointer check in
 init_user_sockptr
Message-ID: <20200729060401.GD31113@lst.de>
References: <20200728063643.396100-1-hch@lst.de> <20200728063643.396100-5-hch@lst.de> <20200728.130111.2163106097158516623.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200728.130111.2163106097158516623.davem@davemloft.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 28, 2020 at 01:01:11PM -0700, David Miller wrote:
> From: Christoph Hellwig <hch@lst.de>
> Date: Tue, 28 Jul 2020 08:36:43 +0200
> 
> >  	if (get_user(len, optlen))
> >  		return -EFAULT;
>         ^^^^^^^^^^^^^^^^^^^^^^^^^^
> > -	err = init_user_sockptr(&optval, user_optval);
> > +	err = init_user_sockptr(&optval, user_optval, *optlen);
>                                                       ^^^^^^^^
> 
> Hmmm?

A fixed version was already posted yesterday:

https://lore.kernel.org/netdev/20200728163836.562074-1-hch@lst.de/T/#me3e9c7b71e39b4689628ed2e61dec06705344847
