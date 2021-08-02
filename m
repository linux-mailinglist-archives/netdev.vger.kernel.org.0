Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 576BB3DDBCB
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 17:03:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234729AbhHBPDU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 11:03:20 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57500 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234313AbhHBPDU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 11:03:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=CpjFTsHcUNkF4A9FYIvAaVzwEShRcBrFT7sRZXDvKLg=; b=hDAlEe0VRsDc28y+q8Duc8mNkR
        BMz+6cM/tWPrPYB7GbNuusIA5k6eYmdOS1ubgGiS+W0iLO2K9muO6EHV+RE4cmrlWmZOGaRZrFw9Z
        Y6rWmvoLNHOczD3PjtBPmiTYAKFcsekNMvh2zrxi1VjK+q26AuIetlVC+fmjWtmN6Rek=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mAZSz-00FqDo-1B; Mon, 02 Aug 2021 17:02:57 +0200
Date:   Mon, 2 Aug 2021 17:02:57 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Biju Das <biju.das.jz@bp.renesas.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: Re: [PATCH net-next v2 1/8] ravb: Add struct ravb_hw_info to driver
 data
Message-ID: <YQgJIbd3KDnS+RAu@lunn.ch>
References: <20210802102654.5996-1-biju.das.jz@bp.renesas.com>
 <20210802102654.5996-2-biju.das.jz@bp.renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210802102654.5996-2-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 02, 2021 at 11:26:47AM +0100, Biju Das wrote:
> The DMAC and EMAC blocks of Gigabit Ethernet IP found on RZ/G2L SoC are
> similar to the R-Car Ethernet AVB IP. With a few changes in the driver we
> can support both IPs.
> 
> Currently a runtime decision based on the chip type is used to distinguish
> the HW differences between the SoC families.
> 
> The number of TX descriptors for R-Car Gen3 is 1 whereas on R-Car Gen2 and
> RZ/G2L it is 2. For cases like this it is better to select the number of
> TX descriptors by using a structure with a value, rather than a runtime
> decision based on the chip type.
> 
> This patch adds the num_tx_desc variable to struct ravb_hw_info and also
> replaces the driver data chip type with struct ravb_hw_info by moving chip
> type to it.
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

Hi Biju

This is better. A lot clearer what is going on. I personally would of
done the num_tx_desc change as a separate patch, but this is O.K.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
