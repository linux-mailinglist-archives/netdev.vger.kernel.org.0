Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A13872729A9
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 17:13:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727750AbgIUPNT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 11:13:19 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47796 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726413AbgIUPNT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 11:13:19 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kKNVB-00Fbrf-3S; Mon, 21 Sep 2020 17:13:13 +0200
Date:   Mon, 21 Sep 2020 17:13:13 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next] net: phy: realtek: enable ALDPS to save
 power for RTL8211F
Message-ID: <20200921151313.GD3717417@lunn.ch>
References: <20200921091354.2bf0a039@xhacker.debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200921091354.2bf0a039@xhacker.debian>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 21, 2020 at 09:13:54AM +0800, Jisheng Zhang wrote:
> Enable ALDPS(Advanced Link Down Power Saving) to save power when
> link down.
> 
> Signed-off-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
