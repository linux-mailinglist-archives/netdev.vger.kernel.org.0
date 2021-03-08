Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A2E5330FBE
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 14:43:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbhCHNmf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 08:42:35 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:45588 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229701AbhCHNm3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Mar 2021 08:42:29 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lJG9R-009pfL-OF; Mon, 08 Mar 2021 14:42:25 +0100
Date:   Mon, 8 Mar 2021 14:42:25 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sunil Kovvuri <sunil.kovvuri@gmail.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        George Cherian <gcherian@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alex Marginean <alexandru.marginean@nxp.com>
Subject: Re: Query on new ethtool RSS hashing options
Message-ID: <YEYpwWXyHwmAyoDX@lunn.ch>
References: <CA+sq2CdJf0FFMAMbh0OZ67=j2Fo+C2aqP3qTKcYkcRgscfTGiw@mail.gmail.com>
 <20210305150702.1c652fe2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YELKIZzkU9LxpEE9@lunn.ch>
 <CA+sq2CfAsyFHEj=w3=ewTKk-qbF60FcCQNtk9e7_1wxf=tB7QA@mail.gmail.com>
 <20210306131814.h4u323smlihpf3ds@skbuf>
 <CA+sq2Cdx4X7HBjdE8bU6OcS6g+yzx1Xj7n1VmPh_a+AoGPyvsg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+sq2Cdx4X7HBjdE8bU6OcS6g+yzx1Xj7n1VmPh_a+AoGPyvsg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> This is Marvell OcteonTx2/CN10K RVU controller
> drivers/net/ethernet/marvell/octeontx2.
> And no the controller doesn't have a internal switch and hence
> currently there is no switchdev support.
> The switch I referred to is an external one whose CPU port is
> connected to this controller.

Hi Sunil

That is a classic Linux DSA setup. I know it is no longer an issue,
but you might want to look at how switches are supported in Linux. I'm
sure there are people here who are interested in the setup, and having
the MAC do the DSA header work in hardware poses interesting questions
for the Linux DSA architecture. What would a tag driver in
net/dsa/tag_<FOO>.c look like, how do we tell the MAC about the switch
ports it needs to have slave interfaces for, etc.

      Andrew
