Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85BAC175B16
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 14:02:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727865AbgCBNCA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 08:02:00 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:41250 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727644AbgCBNCA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Mar 2020 08:02:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=FiLor1i8rXZoXEJEzNkZ/KpyLzC6P9f7qqRBo8GyGJA=; b=M4boMbZWwibGWaDa9Ay/YE+uzp
        +FavjE7Y3btmzUCr8WYtI8x+aN1Z8phBn6zQ7lHkgG3TpDu2gpxWfd3NLUrk9mNI1XJaoW33RVU26
        e2MF9T63w/jicFdTjjFJqWgKKVovfVmpElwvpb7EPJ/BbjF98dKBFqwkfuh8mhkwz+GI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j8khn-0005Sl-V7; Mon, 02 Mar 2020 14:01:55 +0100
Date:   Mon, 2 Mar 2020 14:01:55 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     sunil.kovvuri@gmail.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Geetha sowjanya <gakula@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: Re: [PATCH 3/7] octeontx2-pf: Support to enable/disable pause frames
 via ethtool
Message-ID: <20200302130155.GE31977@lunn.ch>
References: <1583133568-5674-1-git-send-email-sunil.kovvuri@gmail.com>
 <1583133568-5674-4-git-send-email-sunil.kovvuri@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1583133568-5674-4-git-send-email-sunil.kovvuri@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sunil

> +static int otx2_set_pauseparam(struct net_device *netdev,
> +			       struct ethtool_pauseparam *pause)
> +{
> +	struct otx2_nic *pfvf = netdev_priv(netdev);
> +
> +	if (pause->autoneg)
> +		return -EOPNOTSUPP;

Nice to see somebody getting that bit correct.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
