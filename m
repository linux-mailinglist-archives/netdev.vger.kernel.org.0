Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D68EB2D22F6
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 06:18:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725928AbgLHFSd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 00:18:33 -0500
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:48282 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725768AbgLHFSd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 00:18:33 -0500
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 0B85HZYx007069;
        Tue, 8 Dec 2020 06:17:35 +0100
Date:   Tue, 8 Dec 2020 06:17:35 +0100
From:   Willy Tarreau <w@1wt.eu>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Daniel Palmer <daniel@0x0f.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: macb: should we revert 0a4e9ce17ba7 ("macb: support the two tx
 descriptors on at91rm9200") ?
Message-ID: <20201208051735.GA7061@1wt.eu>
References: <20201206092041.GA10646@1wt.eu>
 <20201207154042.46414640@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201207154042.46414640@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
User-Agent: Mutt/1.6.1 (2016-04-27)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 07, 2020 at 03:40:42PM -0800, Jakub Kicinski wrote:
> Thanks for the report, I remember that one. In hindsight maybe we
> should have punted it to 5.11...

Well, not necessarily as it was simple, well documented and *appeared*
to work fine.

> Let's revert ASAP, 5.10 is going to be LTS, people will definitely
> notice.

It could take some time as we're speaking about crazy people running
5.10 on an old 180 MHz MCU :-)

> Would you mind sending a revert patch with the explanation in the
> commit message?

Sure, will do.

Thanks!
Willy
