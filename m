Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E7AF28D8ED
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 05:13:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728846AbgJNDNJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 23:13:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:45528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726049AbgJNDNJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Oct 2020 23:13:09 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C38EB21775;
        Wed, 14 Oct 2020 03:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602645189;
        bh=NwgTOsmhFDsoNXrdTKUpOlGw6YR1p9x8rc49/ddJF4Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hUrmXEUPKZ4HvdJZPImI+zsjF2aKpGo4Im12o0RcaI3dq6e69/KO1DkAlH8YeOa7F
         u8LVyw/pNWFRNERWTv6CdsGmCnnYlr1y5bIHy1i8v3bqGtUeO6BqCHkgKzHJW1utCq
         sGTWqWOnsfjrG/zMi7E7lqszf697RK07AfJ3mvIM=
Date:   Tue, 13 Oct 2020 20:13:07 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Willy Tarreau <w@1wt.eu>
Cc:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        netdev@vger.kernel.org, David Miller <davem@davemloft.net>
Subject: Re: [PATCH net-next 0/3] macb: support the 2-deep Tx queue on at91
Message-ID: <20201013201307.48976984@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201014030630.GA12531@1wt.eu>
References: <20201011090944.10607-1-w@1wt.eu>
        <20201013170358.1a4d282a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201014030630.GA12531@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 14 Oct 2020 05:06:30 +0200 Willy Tarreau wrote:
> > LGTM. There's always a chance that this will make other 
> > designs explode, but short of someone from Cadence giving 
> > us a timely review we have only one way to find that out.. :)  
> 
> Not that much in fact, given that the at91ether_* functions are only
> used by AT91RM9200 (whose datasheet I used to do this) and Mstar which
> I used for the tests. I initially wanted to get my old SAM9G20 board
> to boot until I noticed that it doesn't even use the same set of
> functions, so the potential victims are extremely limited :-)

GTK :)
