Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92C0B2730A6
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 19:07:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728558AbgIURH1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 13:07:27 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48080 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727556AbgIURH1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 13:07:27 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kKPHd-00Fccr-99; Mon, 21 Sep 2020 19:07:21 +0200
Date:   Mon, 21 Sep 2020 19:07:21 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, linux@armlinux.org.uk
Subject: Re: [PATCH net-next 3/3] dpaa2-mac: add PCS support through the Lynx
 module
Message-ID: <20200921170721.GE3717417@lunn.ch>
References: <20200921162031.12921-1-ioana.ciornei@nxp.com>
 <20200921162031.12921-4-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200921162031.12921-4-ioana.ciornei@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 21, 2020 at 07:20:31PM +0300, Ioana Ciornei wrote:
> +static void dpaa2_pcs_destroy(struct dpaa2_mac *mac)
> +{
> +	struct lynx_pcs *pcs = mac->pcs;
> +
> +	if (pcs) {
> +		put_device(&pcs->mdio->dev);
> +		lynx_pcs_destroy(pcs);
> +		mac->pcs = NULL;

Hi Ioana

Maybe the put_device() should come after the destroy? It is then the
reverse of the creation.

	Andrew
