Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E64543B20B
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 14:12:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235414AbhJZMOp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 08:14:45 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59456 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232378AbhJZMOp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 08:14:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=XbtrM0kCz28GkdYHz/LczKiylEviSIxhi48F/wTyC5k=; b=BI1gDaSv9ZP8qybbGwGB4h3qF2
        qtm1KIrQUUWh0sYld++1sPP2BTDmzO9qzY5L/5vRiZXms3RMp3l6WBX27Yg2vfU7Fodd98UorFuXN
        oOPgPrgxBJt+iNHMknHviIOH98ijVgS6xUVPJ8nWfSRdQzWXDX1V3fMZJwgfg+afIGO0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mfLJM-00Bm9n-Lu; Tue, 26 Oct 2021 14:12:12 +0200
Date:   Tue, 26 Oct 2021 14:12:12 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Luo Jie <luoj@codeaurora.org>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: fixed warning: Function parameter not described
Message-ID: <YXfwnHKeY58AVgU9@lunn.ch>
References: <20211026102957.17100-1-luoj@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211026102957.17100-1-luoj@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 26, 2021 at 06:29:57PM +0800, Luo Jie wrote:
> Fixed warning: Function parameter or member 'enable' not
> described in 'genphy_c45_fast_retrain'
> 
> Signed-off-by: Luo Jie <luoj@codeaurora.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
