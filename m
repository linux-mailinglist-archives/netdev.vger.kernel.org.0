Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 234124936EC
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 10:12:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352908AbiASJMg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 04:12:36 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:54710 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352899AbiASJMf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 04:12:35 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id C4E731F37E;
        Wed, 19 Jan 2022 09:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1642583554; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OFkzn3ldKf+98WP73bB5aGqbJy3Nn7YQv7/tekP7T10=;
        b=QMTzKbsa53vBKHOvoqTHCdf81ZqojNXiYyOnhweuvqv5N58FKiZ4n8dlmE2qHnh8VcWoMh
        0UQ+J06pSnYo+as8EBsFwZTJ/ZvIUi6Q6CPRE0UZOMM1ml52tmpztf7Kc+va7zKKuIEvCK
        baTOzcG9r79NctnsAZhU6cBPbiLk/8c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1642583554;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OFkzn3ldKf+98WP73bB5aGqbJy3Nn7YQv7/tekP7T10=;
        b=TceXs+0NliswCeA+UMMXCoDUJIPd4LIkk/0G9RlfINeajtkoQDPE25wWYCokxZ4cy+/wVF
        5driIvPsMibFzCDg==
Received: from localhost (dwarf.suse.cz [10.100.12.32])
        by relay2.suse.de (Postfix) with ESMTP id 095ACA3B84;
        Wed, 19 Jan 2022 09:12:34 +0000 (UTC)
Date:   Wed, 19 Jan 2022 10:12:33 +0100
From:   Jiri Bohac <jbohac@suse.cz>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Sabrina Dubroca <sd@queasysnail.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Mike Maloney <maloneykernel@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH] xfrm: fix MTU regression
Message-ID: <20220119091233.pzqdlzpcyicjavk5@dwarf.suse.cz>
References: <20220114173133.tzmdm2hy4flhblo3@dwarf.suse.cz>
 <20220114174058.rqhtuwpfhq6czldn@dwarf.suse.cz>
 <20220119073519.GJ1223722@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220119073519.GJ1223722@gauss3.secunet.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 19, 2022 at 08:35:19AM +0100, Steffen Klassert wrote:
> Can you please add a 'Fixes:' tag so that it can be backported
> to the stable trees?

sure; I'll send a v2 with added Fixes: for the original
regression (749439bf), which will reappear once b515d263 (which
causes the current regression) is reverted. Note this patch needs
to be accompanied by the revert!

> Btw. this fixes a xfrm issue, but touches only generic IPv6 code.
> To which tree should this patch be applied? I can take it to
> the ipsec tee, but would also be ok if it is applied directly
> to the net tree.

b515d263 touches xfrm code; but being a regression maybe we want
the fastest track possible? 

Thanks,


-- 
Jiri Bohac <jbohac@suse.cz>
SUSE Labs, Prague, Czechia

