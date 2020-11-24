Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4A252C1ABD
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 02:20:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729779AbgKXBPI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 20:15:08 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:46412 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728052AbgKXBPI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 20:15:08 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1khMv5-008ZiA-3H; Tue, 24 Nov 2020 02:14:59 +0100
Date:   Tue, 24 Nov 2020 02:14:59 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Moshe Shemesh <moshe@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Adrian Pop <pop.adrian61@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org,
        Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: Re: [PATCH net-next v2 0/2] Add support for DSFP transceiver type
Message-ID: <20201124011459.GD2031446@lunn.ch>
References: <1606123198-6230-1-git-send-email-moshe@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1606123198-6230-1-git-send-email-moshe@mellanox.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 23, 2020 at 11:19:56AM +0200, Moshe Shemesh wrote:
> Add support for new cable module type DSFP (Dual Small Form-Factor Pluggable
> transceiver). DSFP EEPROM memory layout is compatible with CMIS 4.0 spec. Add
> CMIS 4.0 module type to UAPI and implement DSFP EEPROM dump in mlx5.

So the patches themselves look O.K.

But we are yet again kicking the can down the road and not fixing the
underlying inflexibility of the API.

Do we want to keep kicking the can, or is now the time to do the work
on this API?

   Andrew
