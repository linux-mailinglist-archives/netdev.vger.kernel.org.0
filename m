Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D90BB21A943
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 22:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726272AbgGIUq1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 16:46:27 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55996 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726183AbgGIUq0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 16:46:26 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jtdQz-004NZS-6x; Thu, 09 Jul 2020 22:46:21 +0200
Date:   Thu, 9 Jul 2020 22:46:21 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Frank Wunderlich <frank-w@public-files.de>, netdev@vger.kernel.org,
        Sean Wang <sean.wang@mediatek.com>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>,
        linux-mediatek@lists.infradead.org,
        John Crispin <john@phrozen.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        linux-arm-kernel@lists.infradead.org, Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH v2] net: ethernet: mtk_eth_soc: fix mtu warning
Message-ID: <20200709204621.GC1037260@lunn.ch>
References: <20200709055742.3425-1-frank-w@public-files.de>
 <20200709134115.GK928075@lunn.ch>
 <20200709203134.GI1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200709203134.GI1551@shell.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Are there any plans to solve these warnings for Marvell 88e6xxx DSA ports?

Hi Russell

I have patches for FEC + mv88e6xxx. I should post them.

  Andrew
