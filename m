Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62D204514BF
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 21:10:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349417AbhKOUMv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 15:12:51 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:34128 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346991AbhKOTiL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 14:38:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=nW5K4LQEM487yoxv+Y8zAaOQtnroY01SoDtHwL7Mio0=; b=PtrGvvxPoPkYxF+U69ta6Na9LK
        xn63pEQr5OmM5Ot2IfKV0ic0p42gY8V4aggGqBx4lUx0do4DoehVxteVkhDGDHx2DeXD5vpGoVfd9
        a85OCM2s6mNATqeK/5McdaMqbthdqpxbiKNSYdWPfPnpQIKG9HY63XJFaDOqyB9hK1Bk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mmhky-00DWaj-NC; Mon, 15 Nov 2021 20:35:08 +0100
Date:   Mon, 15 Nov 2021 20:35:08 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, upstream@semihalf.com,
        kernel test robot <lkp@intel.com>
Subject: Re: [net: PATCH] net: mvmdio: fix compilation warning
Message-ID: <YZK2bPgHE0BFlDMd@lunn.ch>
References: <20211115153024.209083-1-mw@semihalf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211115153024.209083-1-mw@semihalf.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 15, 2021 at 04:30:24PM +0100, Marcin Wojtas wrote:
> The kernel test robot reported a following issue:
> 
> >> drivers/net/ethernet/marvell/mvmdio.c:426:36: warning:
> unused variable 'orion_mdio_acpi_match' [-Wunused-const-variable]
>    static const struct acpi_device_id orion_mdio_acpi_match[] = {

How come OF never gives these warning, just ACPI? If there something
missing in ACPI which OF has?

> Fixes: c54da4c1acb1 ("net: mvmdio: add ACPI support")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Marcin Wojtas <mw@semihalf.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
