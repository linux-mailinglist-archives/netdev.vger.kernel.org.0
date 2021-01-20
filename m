Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B6772FC63F
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 02:07:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730908AbhATBGc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 20:06:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:44140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726000AbhATBG2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 20:06:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90FA222C9E;
        Wed, 20 Jan 2021 01:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611104747;
        bh=BqbYp3gaw7FoVTw4sPq+vGJxrrXH5513lrG+pzBmRBg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=F29rP+GkDV2vhWJ/7119l264xXV7tz7W8jiInaSe9czpEs8Y50Am3cKTYDrk233oA
         24JsVffRvq9yB3ysvj6IKPJ21Rn1L9PaU+M6JLiK/mwc9hABXXU86uYnbHGNEKycph
         GGWUH7UZjWXtBlOV3+UMYP6PVuv6euQyxWHWidt9FrV/8yuA4NzM5Qs6rj6vLj7owE
         pOmvuetqUYN/Ni5lU9SUshootpBxYB7unfxCu1BwpOhIEEw3vA/MWay05gVmTJPmtu
         66l2yA1YcBCBxVbwhjdx6h3OrhpnZkRY9UH8h1PoFGMysmzUnXNxMULy0T++WqYdNg
         uIAxk+a3jVRLw==
Date:   Tue, 19 Jan 2021 17:05:46 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Grant Grundler <grundler@chromium.org>
Cc:     Oliver Neukum <oliver@neukum.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] net: usb: cdc_ncm: don't spew notifications
Message-ID: <20210119170546.189e12d1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CANEJEGvoSWDWN19PnYJB9ubKgfyEvX4g=rvi9ezEJ9n+NUevbA@mail.gmail.com>
References: <20210116052623.3196274-1-grundler@chromium.org>
        <20210116052623.3196274-3-grundler@chromium.org>
        <20210119134558.5072a1cc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CANEJEGsd8c1RYnKXsWOhLFDOh89EXAUtLUPMrbWf+2+yin5kHw@mail.gmail.com>
        <CANEJEGvoSWDWN19PnYJB9ubKgfyEvX4g=rvi9ezEJ9n+NUevbA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 Jan 2021 00:59:17 +0000 Grant Grundler wrote:
> > > Thanks for the patch, this looks like an improvement over:
> > >
> > > 59b4a8fa27f5 ("CDC-NCM: remove "connected" log message")
> > >
> > > right? Should we bring the "network connection: connected" message back?  
> >
> > Yes, we can revert Roland's patch. I didn't see that one.
> >  
> > > Do you want all of these patches to be applied to 5.11 and backported?  
> >
> > Yes to 5.11. Only the 3rd one really needs to be applied to stable kernels.  
> 
> Sorry - I was thinking 5.11 was -next (and that's incorrect).
> 
> As you suggested below, only the 3rd one really needs to be applied to
> 5.11 and other stable kernels.

Cool, would you mind reposting just the 3rd patch separately, and
tagged as [PATCH net] so that CI can give it a shaking? We'll go 
from there with the rest.

> >  
> > > Feels to me like the last one is a fix and the rest can go into -next,
> > > WDYT?  
> >
> > Exactly.
