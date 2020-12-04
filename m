Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 629F32CF331
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 18:37:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731220AbgLDRgq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 12:36:46 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:39014 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726254AbgLDRgq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 12:36:46 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1klEzz-00AFJi-9k; Fri, 04 Dec 2020 18:36:03 +0100
Date:   Fri, 4 Dec 2020 18:36:03 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexander Dahl <ada@thorsis.com>
Cc:     netdev@vger.kernel.org, Grant Edwards <grant.b.edwards@gmail.com>,
        linux-mtd@lists.infradead.org, linux-arm-kernel@lists.infradead.org
Subject: Re: net: macb: fail when there's no PHY
Message-ID: <20201204173603.GE2400258@lunn.ch>
References: <20201202183531.GJ2324545@lunn.ch>
 <20201203214941.GA2409950@lunn.ch>
 <rqbobm$5qk$1@ciao.gmane.io>
 <3542036.FvJvBFsO4O@ada>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3542036.FvJvBFsO4O@ada>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > 5.10 is LTS. Well, it will be, once it is actually released!
> > 
> > Convincing people to ship an unreleased kernel would be a whole
> > 'nother bucket of worms.
> 
> +1
> 
> Judging just from the release dates of the last LTS kernels, I would have 
> guessed v5.11 will get LTS.  But there has been no announcement yet and I 
> suppose there will be none before release?

It was announced a while ago. e.g:

https://itsfoss.com/kernel-5-10/

	Andrew
