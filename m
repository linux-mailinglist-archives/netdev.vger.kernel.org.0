Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD853DDBFF
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 17:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234813AbhHBPLn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 11:11:43 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57596 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234781AbhHBPLm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 11:11:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=HBY4jDsDP4LGwDO0H4z6oa8+QfGAm7sbgXZN5QvdwYk=; b=V9i4C2LTle8S1xnMqpDOAOq353
        f4BE/a7nRO76dQQPaVkeGzXqGFEOG5BXtc84HO9UGXN9nXs++M+6VtCbrwiVdBrxH/gHoDF9KITeF
        2fnrzd1MDDLjVYQ7oEdYvA8yoSkgxdn67fGQ7/Hu1L2QkPcoRH3AnWcsp4Ov+opR+AKE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mAZbD-00FqJ5-Ku; Mon, 02 Aug 2021 17:11:27 +0200
Date:   Mon, 2 Aug 2021 17:11:27 +0200
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
Subject: Re: [PATCH net-next v2 5/8] ravb: Add gstrings_stats and
 gstrings_size to struct ravb_hw_info
Message-ID: <YQgLH8cK33o4T1e6@lunn.ch>
References: <20210802102654.5996-1-biju.das.jz@bp.renesas.com>
 <20210802102654.5996-6-biju.das.jz@bp.renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210802102654.5996-6-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 02, 2021 at 11:26:51AM +0100, Biju Das wrote:
> The device stats strings for R-Car and RZ/G2L are different.
> 
> R-Car provides 30 device stats, whereas RZ/G2L provides only 15. In
> addition, RZ/G2L has stats "rx_queue_0_csum_offload_errors" instead of
> "rx_queue_0_missed_errors".
> 
> Add structure variables gstrings_stats and gstrings_size to struct
> ravb_hw_info, so that subsequent SoCs can be added without any code
> changes in the ravb_get_strings function.
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
