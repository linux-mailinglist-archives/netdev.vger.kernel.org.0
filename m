Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10BE84326CF
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 20:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232080AbhJRSt2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 14:49:28 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44948 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229696AbhJRSt0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 14:49:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=rwicn//mOhJ02F5EjK/QSZSwZD0PCubIDqfmMCSwouM=; b=uQ5zNLjWkyrQy8slNmByQD9p5T
        /vVL2U/jRiOIBztFbnAzaELbXkAJ7Z8ii1weKAs/4RLnVbM2xeEjjgwaMPtrLO/7BMRC7ou6AQP84
        Buz+9WAji+pMaUkKJUuBClYaxHkAS7Q0HtxREPoFiSqsac4k4Q3Z3XmsrcXp0ePK4v98=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mcXfD-00Azrw-BS; Mon, 18 Oct 2021 20:47:11 +0200
Date:   Mon, 18 Oct 2021 20:47:11 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Luo Jie <luoj@codeaurora.org>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sricharan@codeaurora.org
Subject: Re: [PATCH v3 05/13] net: phy: add qca8081 ethernet phy driver
Message-ID: <YW3BLwiNGiQGUje9@lunn.ch>
References: <20211018033333.17677-1-luoj@codeaurora.org>
 <20211018033333.17677-6-luoj@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211018033333.17677-6-luoj@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -1441,6 +1455,7 @@ static struct mdio_device_id __maybe_unused atheros_tbl[] = {
>  	{ PHY_ID_MATCH_EXACT(ATH8032_PHY_ID) },
>  	{ PHY_ID_MATCH_EXACT(ATH8035_PHY_ID) },
>  	{ PHY_ID_MATCH_EXACT(ATH9331_PHY_ID) },
> +	{ PHY_ID_MATCH_EXACT(QCA8081_PHY_ID) },
>  	{ }

What tree is this against? I have:

static struct mdio_device_id __maybe_unused atheros_tbl[] = {
        { ATH8030_PHY_ID, AT8030_PHY_ID_MASK },
        { PHY_ID_MATCH_EXACT(ATH8031_PHY_ID) },
        { PHY_ID_MATCH_EXACT(ATH8032_PHY_ID) },
        { PHY_ID_MATCH_EXACT(ATH8035_PHY_ID) },
        { PHY_ID_MATCH_EXACT(ATH9331_PHY_ID) },
        { PHY_ID_MATCH_EXACT(QCA8337_PHY_ID) },
        { PHY_ID_MATCH_EXACT(QCA8327_A_PHY_ID) },
        { PHY_ID_MATCH_EXACT(QCA8327_B_PHY_ID) },
        { PHY_ID_MATCH_EXACT(QCA9561_PHY_ID) },
        { }
};

	Andrew
