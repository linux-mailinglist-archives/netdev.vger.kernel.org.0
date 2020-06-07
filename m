Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89E341F0D2E
	for <lists+netdev@lfdr.de>; Sun,  7 Jun 2020 18:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbgFGQsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jun 2020 12:48:17 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38802 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726571AbgFGQsR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 7 Jun 2020 12:48:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=7QnPJQET26vP+9zTP+5M9ZPMqfH2yUgRHGgUANNW0SI=; b=Bb2wVKVXJcc9QOJ+E1SaEJfIKZ
        CGJwtG/7TbNnTthxi0ewtb6F1hMnINVwMk85RipyUSPiDFsUIStjxSRV98tSgJaerZF45jIYEtNcG
        cZLuUg8DJDff0Ej4tLrr24BjylszjSusuz1vs5/1kT0tHC9JgeXPW1lJ5/LI/+zuWIQs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jhySl-004LiI-1n; Sun, 07 Jun 2020 18:47:59 +0200
Date:   Sun, 7 Jun 2020 18:47:59 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Amit Cohen <amitc@mellanox.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        corbet@lwn.net, jiri@mellanox.com, idosch@mellanox.com,
        shuah@kernel.org, mkubecek@suse.cz, gustavo@embeddedor.com,
        cforno12@linux.vnet.ibm.com, f.fainelli@gmail.com,
        linux@rempel-privat.de, alexandru.ardelean@analog.com,
        ayal@mellanox.com, petrm@mellanox.com, mlxsw@mellanox.com,
        liuhangbin@gmail.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [RFC PATCH net-next 05/10] Documentation: networking:
 ethtool-netlink: Add link extended state
Message-ID: <20200607164759.GG1022955@lunn.ch>
References: <20200607145945.30559-1-amitc@mellanox.com>
 <20200607145945.30559-6-amitc@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200607145945.30559-6-amitc@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +Link extended states:
> +
> +  ============================    =============================================
> +  ``Autoneg failure``             Failure during auto negotiation mechanism

I think you need to define 'failure' here.

Linux PHYs don't have this state. auto-neg is either ongoing, or has
completed. There is no time limit for auto-neg. If there is no link
partner, auto-neg does not fail, it just continues until there is a
link partner which responds and negotiation completes.

Looking at the state diagrams in 802.3 clause 28, what do you consider
as failure?

	 Andrew
