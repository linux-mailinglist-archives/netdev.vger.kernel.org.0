Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC5D3DDBF4
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 17:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234824AbhHBPI7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 11:08:59 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57536 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233976AbhHBPI7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 11:08:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=fpyD7FLUwkVJb9HRbkEn3x/c3vFTC2wrkNvazwUsB38=; b=AqDvOEBp3KRs+bhGvOfLxbjFTe
        Myd1NszqN17P/CJVJOfxkTD7JNZq/GIQMyCe2nkmPv9NJ2HbYqXnSs/3Vik1Y3MssPB9n4hd3HzJM
        dFT1tvV9vQ8/r6HQncQYk8zcEyp+vhlMi04KHJ+kdDy7sQn9Yv4unLQGp56jIuxjY608=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mAZYW-00FqGE-Ao; Mon, 02 Aug 2021 17:08:40 +0200
Date:   Mon, 2 Aug 2021 17:08:40 +0200
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
Subject: Re: [PATCH net-next v2 2/8] ravb: Add skb_sz to struct ravb_hw_info
Message-ID: <YQgKeElygfWgs145@lunn.ch>
References: <20210802102654.5996-1-biju.das.jz@bp.renesas.com>
 <20210802102654.5996-3-biju.das.jz@bp.renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210802102654.5996-3-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 02, 2021 at 11:26:48AM +0100, Biju Das wrote:
> The maximum descriptor size that can be specified on the reception side for
> R-Car is 2048 bytes, whereas for RZ/G2L it is 8096.
> 
> Add the skb_size variable to struct ravb_hw_info for allocating different
> skb buffer sizes for R-Car and RZ/G2L using the netdev_alloc_skb function.
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
