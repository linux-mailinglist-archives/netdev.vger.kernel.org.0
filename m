Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BADD130188F
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 22:41:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726315AbhAWVjd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 16:39:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:56462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725922AbhAWVjZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 23 Jan 2021 16:39:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ADD0522583;
        Sat, 23 Jan 2021 21:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611437925;
        bh=HEXaqUtnerr6Ap4ddBjLCnqAyRczjm/eQSlW5doVBZU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GcRt3U9kS3lQrqcMygQdnmgvmX5hTg/j+KBCUz4B99mRsZgULgJDxqjXYdCDhCLuo
         JiSqm6B8bcAZ/1Rcnaw2gqkKgilnJeWzPr6r+0/CDMY9MOo3CnSErrI6T98huHM8d+
         3Vl7N4faJz2JJazahstafHBygGAjH+ZwaS6A2jPIOcuXXSDOwHThtj+eId1Kk0FPy2
         hVhIMA6aA+WHCOGUWMkRzUD8+OPQHzNm8wmQMz/GyJoxVDv0dOofJdakvTF+o6nmoH
         UsCX54vvglCiAWUJH8pdJi1AAfI9Jlbb3pPf5XMm2c9hhc/ta/056gw2SdazasZXp7
         IViEL8xWWiPQQ==
Date:   Sat, 23 Jan 2021 13:38:43 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Brandon Streiff <brandon.streiff@ni.com>,
        Olof Johansson <olof@lixom.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        David Miller <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net 2/4] net: mvpp2: Remove unneeded Kconfig dependency.
Message-ID: <20210123133843.71f6214d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210123211400.GA6270@hoboy.vegasvil.org>
References: <cover.1611198584.git.richardcochran@gmail.com>
        <1069fecd4b7e13485839e1c66696c5a6c70f6144.1611198584.git.richardcochran@gmail.com>
        <20210121102753.GO1551@shell.armlinux.org.uk>
        <20210121150802.GB20321@hoboy.vegasvil.org>
        <20210122181444.66f9417d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210123132626.GA22662@hoboy.vegasvil.org>
        <20210123121227.16384ff5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210123211400.GA6270@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 23 Jan 2021 13:14:00 -0800 Richard Cochran wrote:
> On Sat, Jan 23, 2021 at 12:12:27PM -0800, Jakub Kicinski wrote:
> > I see. The only thing I'm worried about then is the churn in patch 3.
> > This would land in Linus's tree shortly before rc6, kinda late to be
> > taking chances in the name of minor optimizations :S  
> 
> ;^)
> 
> Yeah, by all means, avoid ARM churn... I remember Bad Things there...
> 
> Maybe you could take #1 and #2 for net-next?

Done, thanks!

> I should probably submit 3-4 throught the SoC tree anyhow.
