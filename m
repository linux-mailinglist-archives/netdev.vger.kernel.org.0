Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20633302547
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 14:09:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728532AbhAYNDc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 08:03:32 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:57824 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728376AbhAYNB7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 08:01:59 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l41UP-002Wyw-6j; Mon, 25 Jan 2021 14:01:05 +0100
Date:   Mon, 25 Jan 2021 14:01:05 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     netdev@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Frank Wunderlich <frank-w@public-files.de>,
        David Woodhouse <dwmw2@infradead.org>,
        =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>
Subject: Re: [PATCH net-next v2] net: ethernet: mediatek: support setting MTU
Message-ID: <YA7BERdgmzKcAYus@lunn.ch>
References: <20210125042046.5599-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210125042046.5599-1-dqfext@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 25, 2021 at 12:20:46PM +0800, DENG Qingfang wrote:
> MT762x HW, except for MT7628, supports frame length up to 2048
> (maximum length on GDM), so allow setting MTU up to 2030.
> 
> Also set the default frame length to the hardware default 1518.
> 
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
