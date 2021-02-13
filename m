Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 832D831ADCE
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 20:46:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbhBMTqI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 14:46:08 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:39398 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229665AbhBMTqH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 13 Feb 2021 14:46:07 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lB0r7-0065o0-JP; Sat, 13 Feb 2021 20:45:25 +0100
Date:   Sat, 13 Feb 2021 20:45:25 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com,
        gregory.clement@bootlin.com
Subject: Re: [PATCH net-next 2/2] net: mvneta: Implement mqprio support
Message-ID: <YCgsVRuGUSSi2p5M@lunn.ch>
References: <20210212151220.84106-1-maxime.chevallier@bootlin.com>
 <20210212151220.84106-3-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210212151220.84106-3-maxime.chevallier@bootlin.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 12, 2021 at 04:12:20PM +0100, Maxime Chevallier wrote:
> +static void mvneta_setup_rx_prio_map(struct mvneta_port *pp)
> +{
> +	int i;
> +	u32 val = 0;

Hi Maxime

Reverse Chrismtass tree please.

	Andrew
