Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1F1846B07A
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 03:09:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239425AbhLGCM6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 21:12:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235404AbhLGCM6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 21:12:58 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F1F4C061746;
        Mon,  6 Dec 2021 18:09:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1E2ADCE1993;
        Tue,  7 Dec 2021 02:09:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD89EC004DD;
        Tue,  7 Dec 2021 02:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638842964;
        bh=iZpY9szOk3KK1HWTm4hZk7WcVTv4QbN/GLI5/rhmcrg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cPl1HNb3lMfS9xk2wNnYW8sEB6SCV48hFOWCjUTg/ByZA/M71+Or/xorCOHLgkC9m
         W5SEhqVhMHmqib1irFhZrSx+I7zsJZS63XI/Jo/YoRSOCiQI4EsRlI59h6v5GOtbas
         saWoseGh793+Vm5qqBsXrsr4pidUA0FjanBxapwPT5YWPqu5+b9r+UhCYMgvuSgekM
         cAgbhUpIjV5lMmhe6vST+YPFpWk+HNN8IzCkmi2fHhLFT455DXLnwhADinprH9ylQz
         cZOUjyt1qpvtl6RI3w6CZeUly7IBs+kthy6lTtq1uaqOJuLf4B2fI6/IZ9TEL1evxp
         5tGGJSfng92pw==
Date:   Mon, 6 Dec 2021 18:09:22 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH v4 net-next 5/5] net: mscc: ocelot: expose ocelot wm
 functions
Message-ID: <20211206180922.1efe4e51@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211204182858.1052710-6-colin.foster@in-advantage.com>
References: <20211204182858.1052710-1-colin.foster@in-advantage.com>
        <20211204182858.1052710-6-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  4 Dec 2021 10:28:58 -0800 Colin Foster wrote:
> Expose ocelot_wm functions so they can be shared with other drivers.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Yeah.. but there are no in-tree users of these. What's the story?

I see Vladimir reviewed this so presumably we trust that the users 
will materialize rather quickly?
