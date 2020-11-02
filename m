Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C36062A2B9B
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 14:34:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725916AbgKBNeQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 08:34:16 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:58518 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725791AbgKBNeP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 08:34:15 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kZZyK-004ou3-Hj; Mon, 02 Nov 2020 14:34:08 +0100
Date:   Mon, 2 Nov 2020 14:34:08 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Pavana Sharma <pavana.sharma@digi.com>
Cc:     marek.behun@nic.cz, ashkan.boldaji@digi.com, davem@davemloft.net,
        f.fainelli@gmail.com, gregkh@linuxfoundation.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        vivien.didelot@gmail.com
Subject: Re: [PATCH v7 3/4] net: dsa: mv88e6xxx: Change serdes lane parameter
  from u8 type to int
Message-ID: <20201102133408.GG1109407@lunn.ch>
References: <cover.1604298276.git.pavana.sharma@digi.com>
 <205569de82d73e543625583e55e808981a7c9ee8.1604298276.git.pavana.sharma@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <205569de82d73e543625583e55e808981a7c9ee8.1604298276.git.pavana.sharma@digi.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -985,12 +985,12 @@ int mv88e6390_serdes_get_regs_len(struct mv88e6xxx_chip *chip, int port)
>  void mv88e6390_serdes_get_regs(struct mv88e6xxx_chip *chip, int port, void *_p)
>  {
>  	u16 *p = _p;
> -	int lane;
> +	int lane = -ENODEV;
>  	u16 reg;
>  	int i;

The reverse christmas tree is wrong here.

    Andrew
