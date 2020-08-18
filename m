Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 368D4248A76
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 17:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728169AbgHRPuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 11:50:18 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59236 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728092AbgHRPtx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Aug 2020 11:49:53 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k83ro-009vpx-V1; Tue, 18 Aug 2020 17:49:40 +0200
Date:   Tue, 18 Aug 2020 17:49:40 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Landen Chao <landen.chao@mediatek.com>
Cc:     f.fainelli@gmail.com, vivien.didelot@savoirfairelinux.com,
        matthias.bgg@gmail.com, robh+dt@kernel.org, mark.rutland@arm.com,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
        davem@davemloft.net, sean.wang@mediatek.com, opensource@vdorst.com,
        frank-w@public-files.de, dqfext@gmail.com
Subject: Re: [PATCH net-next v2 2/7] net: dsa: mt7530: support full-duplex
 gigabit only
Message-ID: <20200818154940.GD2330298@lunn.ch>
References: <cover.1597729692.git.landen.chao@mediatek.com>
 <56f9cfec4d337c57e1cb1ea512a2fb404004757a.1597729692.git.landen.chao@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56f9cfec4d337c57e1cb1ea512a2fb404004757a.1597729692.git.landen.chao@mediatek.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 18, 2020 at 03:14:07PM +0800, Landen Chao wrote:
> Remove 1000baseT_Half to advertise correct hardware capability in
> phylink_validate() callback function.

Hi Landem

This seems like a fix? Please submit it against the net tree, and add
a Fixes: tag.

Thanks
  Andrew
