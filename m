Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE0BB31BBEE
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 16:12:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbhBOPKf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 10:10:35 -0500
Received: from relay10.mail.gandi.net ([217.70.178.230]:39181 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230391AbhBOPJN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 10:09:13 -0500
Received: from bootlin.com (apoitiers-259-1-26-122.w90-55.abo.wanadoo.fr [90.55.97.122])
        (Authenticated sender: maxime.chevallier@bootlin.com)
        by relay10.mail.gandi.net (Postfix) with ESMTPSA id E3CA8240003;
        Mon, 15 Feb 2021 15:08:17 +0000 (UTC)
Date:   Mon, 15 Feb 2021 16:08:16 +0100
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com,
        gregory.clement@bootlin.com
Subject: Re: [PATCH net-next 2/2] net: mvneta: Implement mqprio support
Message-ID: <20210215160816.5f8e5255@bootlin.com>
In-Reply-To: <YCgsVRuGUSSi2p5M@lunn.ch>
References: <20210212151220.84106-1-maxime.chevallier@bootlin.com>
        <20210212151220.84106-3-maxime.chevallier@bootlin.com>
        <YCgsVRuGUSSi2p5M@lunn.ch>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Sat, 13 Feb 2021 20:45:25 +0100
Andrew Lunn <andrew@lunn.ch> wrote:

>On Fri, Feb 12, 2021 at 04:12:20PM +0100, Maxime Chevallier wrote:
>> +static void mvneta_setup_rx_prio_map(struct mvneta_port *pp)
>> +{
>> +	int i;
>> +	u32 val = 0;  
>
>Hi Maxime
>
>Reverse Chrismtass tree please.

Ah yes sorry, I'll fix that in V2.

Thanks for the review,

Maxime

-- 
Maxime Chevallier, Bootlin
Embedded Linux and kernel engineering
https://bootlin.com
