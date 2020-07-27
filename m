Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0D4822EBAF
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 14:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728039AbgG0MFy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 08:05:54 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57108 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727120AbgG0MFx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 08:05:53 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k01t3-0076BD-Mk; Mon, 27 Jul 2020 14:05:45 +0200
Date:   Mon, 27 Jul 2020 14:05:45 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Chris Healy <cphealy@gmail.com>
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Martin Fuzzey <martin.fuzzey@flowbird.group>
Subject: Re: [RESENT PATCH net--stat 1/1] net: ethernet: fec: Revert "net:
 ethernet: fec: Replace interrupt driven MDIO with polled IO"
Message-ID: <20200727120545.GN1661457@lunn.ch>
References: <1587996484-3504-1-git-send-email-fugang.duan@nxp.com>
 <20200727012354.GT28704@pendragon.ideasonboard.com>
 <20200727020631.GW28704@pendragon.ideasonboard.com>
 <20200727021432.GM1661457@lunn.ch>
 <20200727023310.GA23988@pendragon.ideasonboard.com>
 <CAFXsbZrf11Nj4rzLJfisPr-fFo-+stt-G3-XQ_Mwus_2z0nsAg@mail.gmail.com>
 <CAFXsbZrysb6SGisEhgXHzj8NZ5o_EjY-rtiqg3gypgr0w-d-dw@mail.gmail.com>
 <CAFXsbZpBP_kzsC_dLYezJWo7+dQufoRmaFpJgKJbnn6T=sc5QA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFXsbZpBP_kzsC_dLYezJWo7+dQufoRmaFpJgKJbnn6T=sc5QA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 26, 2020 at 08:01:25PM -0700, Chris Healy wrote:
> It appears quite a few boards were affected by this micrel PHY driver change:
> 
> 2ccb0161a0e9eb06f538557d38987e436fc39b8d
> 80bf72598663496d08b3c0231377db6a99d7fd68
> 2de00450c0126ec8838f72157577578e85cae5d8
> 820f8a870f6575acda1bf7f1a03c701c43ed5d79
> 
> I just updated the phy-mode with my board from rgmii to rgmii-id and
> everything started working fine with net-next again:

Hi Chris

Is this a mainline supported board? Do you plan to submit a patch?

Laurent, does the change also work for your board? This is another one
of those cases were a bug in the PHY driver, not respecting the
phy-mode, has masked a bug in the device tree, using the wrong
phy-mode. We had the same issue with the Atheros PHY a while back.

   Andrew
