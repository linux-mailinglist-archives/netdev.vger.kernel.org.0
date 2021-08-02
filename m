Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6AAD3DDBF6
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 17:09:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234724AbhHBPJg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 11:09:36 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57566 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234460AbhHBPJf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 11:09:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=txFVZInyghR6Spfsv+yZYObVKB1wxxpp8B+q3GBttJo=; b=twxbAuhTXIGlRhLQ0hpjN+rmYJ
        DAk7mrUo6sX1sFVy9jiFkDMcvEg3V6MMImn0Q45ITtjgVFKWFVxUejz1/NlN6MAmNSilMYOqklNep
        4NQbIygW9YDyCQ9BMgaRM+wOdw+/1VcxGz+cMr5FQN7y0TU1fS8MYPAe0H4GIJ/0G63Y=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mAZZA-00FqHV-1F; Mon, 02 Aug 2021 17:09:20 +0200
Date:   Mon, 2 Aug 2021 17:09:20 +0200
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
Subject: Re: [PATCH net-next v2 3/8] ravb: Add num_gstat_queue to struct
 ravb_hw_info
Message-ID: <YQgKoPRxK00HMAsJ@lunn.ch>
References: <20210802102654.5996-1-biju.das.jz@bp.renesas.com>
 <20210802102654.5996-4-biju.das.jz@bp.renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210802102654.5996-4-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 02, 2021 at 11:26:49AM +0100, Biju Das wrote:
> The number of queues used in retrieving device stats for R-Car is 2,
> whereas for RZ/G2L it is 1.
> 
> Add the num_gstat_queue variable to struct ravb_hw_info, to add subsequent
> SoCs without any code changes to the ravb_get_ethtool_stats function.
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
