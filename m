Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E89C405A10
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 17:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237302AbhIIPSd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 11:18:33 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35034 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231607AbhIIPSc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 11:18:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=aBKp7ztx9GtUzYI1evBYqZ/XYFZq7YdEWvnavLL7VLM=; b=0Nnksw2xgEuprLl1kEYJMpdz9t
        U8Zpce2xMWBcwJ4JSkfI3lpjOmOfaxXnSfDJ8XH1xAclBgaygohisPXJlpMpo3191eV2wyiTdnlCq
        RAIiMQLYMJzdjN9AznOt/NanBYBbQ1Gam33KBi/oUlMlsDksnAc5n62YQv3mnB97GNO0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mOLnd-005w3T-Dq; Thu, 09 Sep 2021 17:17:13 +0200
Date:   Thu, 9 Sep 2021 17:17:13 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc:     Vladimir Oltean <olteanv@gmail.com>, p.rosenberger@kunbus.com,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Fix for KSZ DSA switch shutdown
Message-ID: <YToleWF8XjHjgh1S@lunn.ch>
References: <20210909095324.12978-1-LinoSanfilippo@gmx.de>
 <20210909101451.jhfk45gitpxzblap@skbuf>
 <81c1a19f-c5dc-ab4a-76ff-59704ea95849@gmx.de>
 <20210909114248.aijujvl7xypkh7qe@skbuf>
 <20210909125606.giiqvil56jse4bjk@skbuf>
 <trinity-85ae3f9c-38f9-4442-98d3-bdc01279c7a8-1631193592256@3c-app-gmx-bs01>
 <781fe00f-046f-28e2-0e23-ea34c1432fd5@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <781fe00f-046f-28e2-0e23-ea34c1432fd5@gmx.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> This is not correct. The kernel I use right now is based on Gregs stable linux-5.10.y.
> The commit number is correct here. Sorry for the confusion.

Can you use 5.14.2?

When we understand the problem, the fixes will need to be for
net-next, which will be based on 5.15-rcX. They will then be
backported to 5.10. So you need to do some testing on a newer
kernel. Such testing will also help us figure out if it is a new
problem, or a backporting problem.

	 Andrew
