Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB4E3EB6AA
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 16:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240326AbhHMO0R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 10:26:17 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48622 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240082AbhHMO0Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Aug 2021 10:26:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=WlPeAz+fOM46u4crKDyWZXDMo6OIVTCqZUK83A3UzQA=; b=iYRWKU+sLrPy3kawzxm6vKVQj3
        Rct6m1QVc+he+YyI0LnY3NIpevKiULYD7Clm0TaWcoaUermgrIY3lvOxWf5GpqZjqHR9U95MbPJjF
        kM/hXOOfAHUn0/ebPmZrwM3nE68mDNl2Gmyayr0feJJxjAAoCIWFkDDg8VDD+M/YR58c=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mEY7t-00HVYl-QT; Fri, 13 Aug 2021 16:25:37 +0200
Date:   Fri, 13 Aug 2021 16:25:37 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Hongbo Wang <hongbo.wang@nxp.com>,
        Hongjun Chen <hongjun.chen@nxp.com>, Po Liu <po.liu@nxp.com>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        Leo Li <leoyang.li@nxp.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [EXT] Re: [PATCH v1] arm64: dts: fsl: ls1028a-rdb: Add dts file
 to choose swp5 as dsa master
Message-ID: <YRaA4VeRM0deApXu@lunn.ch>
References: <20210813030155.23097-1-hongbo.wang@nxp.com>
 <YRZvItRlSpF2Xf+S@lunn.ch>
 <VI1PR04MB56773CC01AB86A8AA1A33F9AE1FA9@VI1PR04MB5677.eurprd04.prod.outlook.com>
 <20210813140745.fwjkmixzgvikvffz@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210813140745.fwjkmixzgvikvffz@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >   this "fsl-ls1028a-rdb-dsa-swp5-eno3.dts" is also for fsl-ls1028a-rdb platform,
> > the only difference with "fsl-ls1028a-rdb.dts" is that it use swp5 as dsa master, not swp4,
> > and it's based on "fsl-ls1028a-rdb.dts", so I choose this manner,
> > if "fsl-ls1028a-rdb.dts" has some modification for new version, this file don't need be changed.
> 
> I tend to agree with Hongbo. What confusion is it going to cause?

I don't know if Debian, or any other distribution, ever implemented
it, but it was suggested that the install media read the available DT
blobs and present the user with a list they can choose from. I've no
idea if this was based on the blob filename, or if it read the
compatible string.

The Compatible string is also printed in the kernel log at boot. If it
is not unique, you need further information to figure out the blob
sources.

We probably needs Rob input. Are there other boards with multiple
blobs? Do they use the same or different compatible strings?

       Andrew
