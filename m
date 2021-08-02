Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB1C73DDC18
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 17:14:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234859AbhHBPOf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 11:14:35 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57668 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234508AbhHBPOf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 11:14:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=DLQPvzdcA7QsDPnfK7T2K+k3oMxnMiho+iwjjvOZ4lk=; b=hfsJb3SyJ3skkMSt7KIe+Ld9OW
        N6aSansWmZpdqWCQXeSowvJzDjDfX6NBY2M7YwOYFP+sLkOgQ7JlllyWQTB8h1Ch28bO2fw534x2E
        3ycLx9WIW6EajI7eL5T0EDNUDKk+QcpaWpg4qQfmQCrno2Pme+dyb2T9Rofhei1icDfI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mAZdx-00FqLK-0M; Mon, 02 Aug 2021 17:14:17 +0200
Date:   Mon, 2 Aug 2021 17:14:16 +0200
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
Subject: Re: [PATCH net-next v2 8/8] ravb: Add tx_drop_cntrs to struct
 ravb_hw_info
Message-ID: <YQgLyEc+wNr+tVQ7@lunn.ch>
References: <20210802102654.5996-1-biju.das.jz@bp.renesas.com>
 <20210802102654.5996-9-biju.das.jz@bp.renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210802102654.5996-9-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 02, 2021 at 11:26:54AM +0100, Biju Das wrote:
> The register for retrieving TX drop counters is present only on R-Car Gen3
> and RZ/G2L; it is not present on R-Car Gen2.
> 
> Add the tx_drop_cntrs hw feature bit to struct ravb_hw_info, to enable this
> feature specifically for R-Car Gen3 now and later extend it to RZ/G2L.
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
