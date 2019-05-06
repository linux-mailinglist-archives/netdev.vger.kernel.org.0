Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0886B14E70
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 17:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727804AbfEFPBJ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 6 May 2019 11:01:09 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:43035 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726532AbfEFOli (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 10:41:38 -0400
X-Originating-IP: 90.88.149.145
Received: from bootlin.com (aaubervilliers-681-1-29-145.w90-88.abo.wanadoo.fr [90.88.149.145])
        (Authenticated sender: maxime.chevallier@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 8ADAF6000B;
        Mon,  6 May 2019 14:41:33 +0000 (UTC)
Date:   Mon, 6 May 2019 16:41:32 +0200
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     Petr =?UTF-8?B?xaB0ZXRpYXI=?= <ynezz@true.cz>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, matthias.bgg@gmail.com, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, frowand.list@gmail.com,
        srinivas.kandagatla@linaro.org, maxime.ripard@bootlin.com,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH v4 00/10] of_net: Add NVMEM support to
 of_get_mac_address
Message-ID: <20190506164132.10342ef6@bootlin.com>
In-Reply-To: <20190506083207.GG81826@meh.true.cz>
References: <1556893635-18549-1-git-send-email-ynezz@true.cz>
        <20190505.214727.1839442238121977055.davem@davemloft.net>
        <20190506083207.GG81826@meh.true.cz>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Petr,

On Mon, 6 May 2019 10:32:07 +0200
Petr Štetiar <ynezz@true.cz> wrote:

>David Miller <davem@davemloft.net> [2019-05-05 21:47:27]:
>
>Hi David,
>
>> Series applied, thank you.  
>
>I did probably something terribly wrong, but patch "[PATCH v4 05/10] net:
>ethernet: support of_get_mac_address new ERR_PTR error" has not reached the
>patchwork, but I'm sure, that it was sent out as Hauke Mehrtens (maintainer
>for ethernet/lantiq_xrx200.c) has confirmed to me on IRC, that he has received
>it.

It seems indeed that the 5th patch hasn't beed applied, which effectively
breaks mvneta on net-next, and I guess a lot of other drivers that rely
on handling the new return values.

I saw you sent a followup series fixing that, but only patch 2/3
shows-up on netdev, so you might be facing a similar issue here.

Maxime
