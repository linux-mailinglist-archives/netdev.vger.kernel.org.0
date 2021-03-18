Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3B46340F64
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 21:54:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232134AbhCRUx2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 16:53:28 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35486 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230368AbhCRUxT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Mar 2021 16:53:19 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lMzdq-00BkAw-SU; Thu, 18 Mar 2021 21:53:14 +0100
Date:   Thu, 18 Mar 2021 21:53:14 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Stefan Chulski <stefanc@marvell.com>
Cc:     "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "rmk+kernel@armlinux.org.uk" <rmk+kernel@armlinux.org.uk>,
        "atenart@kernel.org" <atenart@kernel.org>,
        "rabeeh@solid-run.com" <rabeeh@solid-run.com>
Subject: Re: [EXT] Re: [V2 net-next] net: mvpp2: Add reserved port private
 flag configuration
Message-ID: <YFO9ug0gZp8viEHn@lunn.ch>
References: <1615481007-16735-1-git-send-email-stefanc@marvell.com>
 <YEpMgK1MF6jFn2ZW@lunn.ch>
 <CO6PR18MB38733E25F6B3194D4858147BB06B9@CO6PR18MB3873.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO6PR18MB38733E25F6B3194D4858147BB06B9@CO6PR18MB3873.namprd18.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> 2. CM3 code has very small footprint requirement, we cannot
> implement the complete Serdes and PHY infrastructure that kernel
> provides as part of CM3 application. Therefore I would like to
> continue relying on kernel configuration for that.

How can that work? How does Linux know when CM3 has up'ed the
interface? How does CM3 know the status of the link? How does CM3 set
its flow control depending on what auto-neg determines, etc?

> 3. In some cases we need to dynamically switch the port "user"
> between CM3 and kernel. So I would like to preserve this
> functionality.

And how do you synchronize between Linux and CM3 so you know how is
using it and who cannot use it?

      Andrew
