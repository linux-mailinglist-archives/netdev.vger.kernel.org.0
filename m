Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C38481F1A51
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 15:47:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729832AbgFHNre (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 09:47:34 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39528 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729302AbgFHNre (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 09:47:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=HzzbNliZ9TvYoUDJFmNkzkIkNb1vhWYSQ9c76IBE4Zg=; b=TOjirWLkJ/naxIFRzOerVtQxXu
        eWLNrFajyLzjfuO51ELz4+tjzf3gz0NL1DlMCCD5HlSsDH4xiGfh7wwpUkIzpDsoQOfDlGZGGGmcE
        K7YlYc7KSYklnA9Gj2Ql65RpXWnAPU09ReroCx/7qw3gxa0Us58l8HEmSVDYB5UD2Hik=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jiI7L-004PHE-MY; Mon, 08 Jun 2020 15:47:11 +0200
Date:   Mon, 8 Jun 2020 15:47:11 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Amit Cohen <amitc@mellanox.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>, Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "gustavo@embeddedor.com" <gustavo@embeddedor.com>,
        "cforno12@linux.vnet.ibm.com" <cforno12@linux.vnet.ibm.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "linux@rempel-privat.de" <linux@rempel-privat.de>,
        "alexandru.ardelean@analog.com" <alexandru.ardelean@analog.com>,
        Aya Levin <ayal@mellanox.com>,
        Petr Machata <petrm@mellanox.com>, mlxsw <mlxsw@mellanox.com>,
        "liuhangbin@gmail.com" <liuhangbin@gmail.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>
Subject: Re: [RFC PATCH net-next 05/10] Documentation: networking:
 ethtool-netlink: Add link extended state
Message-ID: <20200608134711.GC1006885@lunn.ch>
References: <20200607145945.30559-1-amitc@mellanox.com>
 <20200607145945.30559-6-amitc@mellanox.com>
 <20200607164759.GG1022955@lunn.ch>
 <AM0PR0502MB382638933BF9B7BE0AB34E81D7850@AM0PR0502MB3826.eurprd05.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM0PR0502MB382638933BF9B7BE0AB34E81D7850@AM0PR0502MB3826.eurprd05.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 08, 2020 at 10:02:04AM +0000, Amit Cohen wrote:
> Andrew Lunn <andrew@lunn.ch> writes:
> 
> >> +Link extended states:
> >> +
> >> +  ============================    =============================================
> >> +  ``Autoneg failure``             Failure during auto negotiation mechanism
> >
> >I think you need to define 'failure' here.
> >
> >Linux PHYs don't have this state. auto-neg is either ongoing, or has completed. There is no time limit for auto-neg. If there is no link partner, auto-neg does not fail, it just continues until there is a link partner which responds and negotiation completes.
> >
> >Looking at the state diagrams in 802.3 clause 28, what do you consider as failure?
> >
> 
> Ok, you're right. What about renaming this state to "Autoneg issue" and then as ext_substate you can use something like "Autoneg ongoing"? 

Hi Amit

I'm not sure 'issue' is correct here. Just because it has not
completed does not mean there is an issue. It takes around 1.5 seconds
anyway, best case. And if there is no link partner, it is not supposed
to complete. So i would suggest just ``Autoneg``.

	  Andrew
