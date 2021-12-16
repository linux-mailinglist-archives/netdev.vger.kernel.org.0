Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9C94477052
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 12:32:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236809AbhLPLcy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 06:32:54 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:58378 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236796AbhLPLcy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Dec 2021 06:32:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=NtaOGBpB6lsB9P9I29EvKZV1egxUKGFnKpZP4CODS7E=; b=28R2eRHR1w+cVTWtNvv2bcFMLf
        9nGQPsMJrZirtQXa5khRzfr4LPMfyyqJ8llTi+DpwYQqH2vhXPAi4FFEZ/HyQ6FAIyoqXoqi/bpDI
        Wx17S9fSnRD9j+aXsFygcRpNuqLHnixt9rchS4ABMOnfg0ZE3rB66roEXFusDqQagb0o=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mxp09-00Gjb5-Iq; Thu, 16 Dec 2021 12:32:45 +0100
Date:   Thu, 16 Dec 2021 12:32:45 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Francesco Dolcini <francesco.dolcini@toradex.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Philippe Schenker <philippe.schenker@toradex.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Fabio Estevam <festevam@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 3/3] net: fec: reset phy on resume after power-up
Message-ID: <Ybsj3bTp72Vx6ShN@lunn.ch>
References: <DB8PR04MB679570A356B655A5D6BFE818E6769@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <YbnDc/snmb1WYVCt@shell.armlinux.org.uk>
 <Ybm3NDeq96TSjh+k@lunn.ch>
 <20211215110139.GA64001@francesco-nb.int.toradex.com>
 <DB8PR04MB67951CB5217193E4CBF73B26E6779@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20211216075216.GA4190@francesco-nb.int.toradex.com>
 <YbsT2G5oMoe4baCJ@lunn.ch>
 <20211216112433.GB4190@francesco-nb.int.toradex.com>
 <Ybsi00/CAd7oVl17@lunn.ch>
 <20211216113104.GC4190@francesco-nb.int.toradex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211216113104.GC4190@francesco-nb.int.toradex.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Can we safely assume that we do have at most one regulator for the phy?

Seems like a reasonable assumption.

      Andrew
