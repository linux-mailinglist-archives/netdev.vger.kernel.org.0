Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D58083DDC06
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 17:12:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234401AbhHBPMr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 11:12:47 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57620 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234492AbhHBPMq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 11:12:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=AxIn3ITPIytVpVplKd5h44DbwgHq6HJ4vIIKr8C9Mrg=; b=ZGvgo3bS04JOaIeGgagO4rha6V
        v8UgNe5Grkceux6sDwPCIX8CgIghBqDm1cB19bVj+awYKl/G09OSddS4j8MLSl0GC45iX3VQITwen
        bytg/6hvIAFDJ7iW34sTgOrLRec9+Uf0h4Bto1ETL9sx1zULBuknnkPXC7U/+HlJIuy4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mAZcF-00FqJs-9S; Mon, 02 Aug 2021 17:12:31 +0200
Date:   Mon, 2 Aug 2021 17:12:31 +0200
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
Subject: Re: [PATCH net-next v2 6/8] ravb: Add net_features and
 net_hw_features to struct ravb_hw_info
Message-ID: <YQgLX873RGUuTfON@lunn.ch>
References: <20210802102654.5996-1-biju.das.jz@bp.renesas.com>
 <20210802102654.5996-7-biju.das.jz@bp.renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210802102654.5996-7-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 02, 2021 at 11:26:52AM +0100, Biju Das wrote:
> On R-Car the checksum calculation on RX frames is done by the E-MAC
> module, whereas on RZ/G2L it is done by the TOE.
> 
> TOE calculates the checksum of received frames from E-MAC and outputs it to
> DMAC. TOE also calculates the checksum of transmission frames from DMAC and
> outputs it E-MAC.
> 
> Add net_features and net_hw_features to struct ravb_hw_info, to support
> subsequent SoCs without any code changes in the ravb_probe function.
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
