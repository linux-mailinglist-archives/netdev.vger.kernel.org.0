Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C8015A97D
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 09:46:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbfF2Hp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 03:45:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:56032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726796AbfF2Hp5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 Jun 2019 03:45:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D84F5214AF;
        Sat, 29 Jun 2019 07:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561794356;
        bh=sLLH/3nMbbtUX5/jPH3tYQ4Sy81gT2DLouUp2Zn3m8A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=j/nxeZFsvzDkJ/wYt5bmYrfTbc3x7nC8oSrcvC+W6aAoi6x0mFz0biupnIuytzAWs
         3buw+GwJWcWQh2jpJvO2nCkvQ2eGBVkIAAKri9iDtbi1Vpy3dGveJNI0pmozy6xiiU
         pfSRqaUcQ47qKW0WmhI/5vt/tEDxa000mcolBCa8=
Date:   Sat, 29 Jun 2019 09:45:53 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Josh Elsasser <jelsasser@appneta.com>
Cc:     Sasha Levin <sashal@kernel.org>, Matteo Croce <mcroce@redhat.com>,
        stable@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Subject: Re: net: check before dereferencing netdev_ops during busy poll
Message-ID: <20190629074553.GA28708@kroah.com>
References: <CAGnkfhxxw9keiNj_Qm=2GBYpY38HAq28cOROMRqXfbqq8wNbWQ@mail.gmail.com>
 <20190628225533.GJ11506@sasha-vm>
 <1560226F-F2C0-440D-9C58-D664DE3C7322@appneta.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1560226F-F2C0-440D-9C58-D664DE3C7322@appneta.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 28, 2019 at 07:03:01PM -0700, Josh Elsasser wrote:
> On Jun 28, 2019, at 3:55 PM, Sasha Levin <sashal@kernel.org> wrote:
> 
> > What's the upstream commit id?
> 
> The commit wasn't needed upstream, as I only sent the original patch after
> 79e7fff47b7b ("net: remove support for per driver ndo_busy_poll()") had
> made the fix unnecessary in Linus' tree.
> 
> May've gotten lost in the shuffle due to my poor Fixes tags. The patch in
> question applied only on top of the 4.9 stable release at the time, but the
> actual NPE had been around in some form since 3.11 / 0602129286705 ("net: add
> low latency socket poll").

Ok, can people then resend this and be very explicit as to why this is
needed only in a stable kernel tree and get reviews from people agreeing
that this really is the correct fix?

thanks,

greg k-h
