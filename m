Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D61C1C5802
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 16:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729258AbgEEOEs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 10:04:48 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42644 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729040AbgEEOEr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 10:04:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=2imX44azv32ai5I1Tmvby9JDO4UnjynDkcj1JvfO+xI=; b=wuqhlXhGQvKagsjIv8qyjqirEk
        rxawIySnvAjtXLTW4D5oXGdKSdYp7Yu69NOEaZSfaiABISGTTgXnc4GRX8qkWyf1uJaCEScC3PbR5
        ciGASjJz2nSLe+CkML/4AZZAx1CwFvuut6vuxB+q/HDbhZtgLnxDL4vaHgFzeVqhAVHc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jVyBf-000wQy-Ht; Tue, 05 May 2020 16:04:43 +0200
Date:   Tue, 5 May 2020 16:04:43 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] [net-next] dsa: sja1105: dynamically allocate stats
 structure
Message-ID: <20200505140443.GK208718@lunn.ch>
References: <20200505135848.180753-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200505135848.180753-1-arnd@arndb.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -	rc = sja1105_port_status_get(priv, &status, port);
> +	rc = sja1105_port_status_get(priv, status, port);
>  	if (rc < 0) {
>  		dev_err(ds->dev, "Failed to read port %d counters: %d\n",
>  			port, rc);
> -		return;
> +		goto out;;

Hi Arnd

I expect static checker people will drive by soon with a fix for the ;; :-)

  Andrew
