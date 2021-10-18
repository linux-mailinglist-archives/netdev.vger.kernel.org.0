Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98618432670
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 20:33:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232589AbhJRSf5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 14:35:57 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44858 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229696AbhJRSf4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 14:35:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=qSfgwAnz3Mbpuw7nTB8D+WcNsoYQGy2qaInep62CBIU=; b=4WFbKdNm4pVqBKnr7JutC5GKMG
        mR/RQiPs9Qe7DE0e5E7zglfxJIQqdC08Ypzv1Q6LdJ07X5qciMrNvoOESBQYcnqjQsSQIhRWLqunN
        Ecx3DgqZKXslav5galRQn4XxI3QjDuBtmmfsgrLr9BVx3MIEjHrsD3L7xDVXqNH/sPno=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mcXS4-00Azkv-DZ; Mon, 18 Oct 2021 20:33:36 +0200
Date:   Mon, 18 Oct 2021 20:33:36 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Luo Jie <luoj@codeaurora.org>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sricharan@codeaurora.org
Subject: Re: [PATCH v3 01/13] net: phy: at803x: replace AT803X_DEVICE_ADDR
 with MDIO_MMD_PCS
Message-ID: <YW2+ANaccrfvRn2N@lunn.ch>
References: <20211018033333.17677-1-luoj@codeaurora.org>
 <20211018033333.17677-2-luoj@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211018033333.17677-2-luoj@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 18, 2021 at 11:33:21AM +0800, Luo Jie wrote:
> Replace AT803X_DEVICE_ADDR with MDIO_MMD_PCS defined in mdio.h.
> 
> Signed-off-by: Luo Jie <luoj@codeaurora.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
