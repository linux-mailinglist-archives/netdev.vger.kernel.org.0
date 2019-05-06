Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 879E8145AE
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 10:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726016AbfEFIAe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 04:00:34 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:46451 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725830AbfEFIAe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 04:00:34 -0400
X-Originating-IP: 90.88.149.145
Received: from bootlin.com (aaubervilliers-681-1-29-145.w90-88.abo.wanadoo.fr [90.88.149.145])
        (Authenticated sender: maxime.chevallier@bootlin.com)
        by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id 19B771C0019;
        Mon,  6 May 2019 08:00:27 +0000 (UTC)
Date:   Mon, 6 May 2019 10:00:26 +0200
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        thomas.petazzoni@bootlin.com, gregory.clement@bootlin.com,
        miquel.raynal@bootlin.com, nadavh@marvell.com, stefanc@marvell.com,
        mw@semihalf.com, Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: Re: [PATCH net-next 0/4] net: mvpp2: cls: Add classification
Message-ID: <20190506100026.7d0094fc@bootlin.com>
In-Reply-To: <20190504025353.74acbb6d@cakuba.netronome.com>
References: <20190430131429.19361-1-maxime.chevallier@bootlin.com>
        <20190504025353.74acbb6d@cakuba.netronome.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jakub,

On Sat, 4 May 2019 02:53:53 -0400
Jakub Kicinski <jakub.kicinski@netronome.com> wrote:

>On Tue, 30 Apr 2019 15:14:25 +0200, Maxime Chevallier wrote:
>> Compared to the first submissions, the NETIF_F_NTUPLE flag was also
>> removed, following Saeed's comment.  
>
>You should probably add it back, even though the stack only uses
>NETIF_F_NTUPLE for aRFS the ethtool APIs historically depend on the
>drivers doing a lot of the validation.

OK my bad, reading your previous comments again, I should indeed have
left it.

I'll re-add the flag, do you think this should go through -net or wait
until net-next reopens ?

Thanks,

Maxime
