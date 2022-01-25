Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2D5149B0CC
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 11:00:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbiAYJs5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 04:48:57 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:39044 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231608AbiAYJlF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 04:41:05 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id B6D5A1F380;
        Tue, 25 Jan 2022 09:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1643103663; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RRRJ+VWFooL6guMzYsrmYYyVZQxdYiM4bbWKeHDVJOE=;
        b=u6oblSFkK2Uv7SmZhabln1hg0aDUSdPJYFsGVhTK/1Evzn0200jpPwfSCo2NzRj9D1zD4W
        01wKs1JPiF8fsOr7epjPj7H3QdmFEsKtBE2pI/qjx+YZjF8zoZ+FvO15/XSQXIPOhJaGpD
        BzhEtGzrCRTLAto021dksI5xjT/PTUI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1643103663;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RRRJ+VWFooL6guMzYsrmYYyVZQxdYiM4bbWKeHDVJOE=;
        b=/UaU3e7kiLIIGebVO5f+f1/5ABFPkEH2shzQAhbUWXLKOKNOK7HnOgoHc9OmGkEozcnwbC
        /LqMLYeQdfc1Z7Dg==
Received: from localhost (dwarf.suse.cz [10.100.12.32])
        by relay2.suse.de (Postfix) with ESMTP id 12518A3B83;
        Tue, 25 Jan 2022 09:41:02 +0000 (UTC)
Date:   Tue, 25 Jan 2022 10:41:02 +0100
From:   Jiri Bohac <jbohac@suse.cz>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Sabrina Dubroca <sd@queasysnail.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Mike Maloney <maloneykernel@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH] xfrm: fix MTU regression
Message-ID: <20220125094102.ju7bhuplcxnkyv4x@dwarf.suse.cz>
References: <20220114173133.tzmdm2hy4flhblo3@dwarf.suse.cz>
 <20220114174058.rqhtuwpfhq6czldn@dwarf.suse.cz>
 <20220119073519.GJ1223722@gauss3.secunet.de>
 <20220119091233.pzqdlzpcyicjavk5@dwarf.suse.cz>
 <20220124154531.GM1223722@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220124154531.GM1223722@gauss3.secunet.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 24, 2022 at 04:45:31PM +0100, Steffen Klassert wrote:
> > sure; I'll send a v2 with added Fixes: for the original
> > regression (749439bf), which will reappear once b515d263 (which
> > causes the current regression) is reverted. Note this patch needs
> > to be accompanied by the revert!
> > 
> > > Btw. this fixes a xfrm issue, but touches only generic IPv6 code.
> > > To which tree should this patch be applied? I can take it to
> > > the ipsec tee, but would also be ok if it is applied directly
> > > to the net tree.
> > 
> > b515d263 touches xfrm code; but being a regression maybe we want
> > the fastest track possible? 
> 
> The patch is already marked as 'awaiting upstream' in patchwork,
> so I'll take it into the ipsec tree.

OK, thanks! Will you also revert b515d263 in the ipsec tree?

-- 
Jiri Bohac <jbohac@suse.cz>
SUSE Labs, Prague, Czechia

