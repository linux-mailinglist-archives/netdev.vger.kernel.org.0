Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C7A263697
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 15:15:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726679AbfGINP4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 09:15:56 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35108 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726046AbfGINP4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jul 2019 09:15:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=K4UCax0/kiN71VxfRMIrE25Yv0RyTL5D3nDe2dnFdGQ=; b=GZNbmBmqFt68izQ5LhY4CRUb9a
        Ii4MDaNJHjizw4C8WNauzl6yP0AII8ZU1gJsbQPUDj+DXgr7YuJQuI8qkQmkZIvoZUMM1+BIMuqxc
        ocbodrF3+HYurVmYEe9Zq1ekGF9y1vl+SLxjjNyFAAHPXROgLbPGHZhw+x1khDM9yX80=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hkpyM-0000hK-Cb; Tue, 09 Jul 2019 15:15:54 +0200
Date:   Tue, 9 Jul 2019 15:15:54 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     josua@solid-run.com
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v2 4/4] net: mvmdio: defer probe of orion-mdio if a clock
 is not ready
Message-ID: <20190709131554.GB1965@lunn.ch>
References: <20190706151900.14355-1-josua@solid-run.com>
 <20190709130101.5160-1-josua@solid-run.com>
 <20190709130101.5160-5-josua@solid-run.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190709130101.5160-5-josua@solid-run.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 09, 2019 at 03:01:01PM +0200, josua@solid-run.com wrote:
> From: Josua Mayer <josua@solid-run.com>
> 
> Defer probing of the orion-mdio interface when getting a clock returns
> EPROBE_DEFER. This avoids locking up the Armada 8k SoC when mdio is used
> before all clocks have been enabled.
> 
> Signed-off-by: Josua Mayer <josua@solid-run.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
