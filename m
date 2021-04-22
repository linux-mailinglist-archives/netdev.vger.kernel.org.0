Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7688736804D
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 14:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236166AbhDVMYe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 08:24:34 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35588 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235795AbhDVMYe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 08:24:34 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lZYN6-000Um9-NN; Thu, 22 Apr 2021 14:23:52 +0200
Date:   Thu, 22 Apr 2021 14:23:52 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Cc:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH net-next 00/14] mtk_eth_soc: fixes and performance
 improvements
Message-ID: <YIFq2NIhdMWTDshX@lunn.ch>
References: <20210422040914.47788-1-ilya.lipnitskiy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210422040914.47788-1-ilya.lipnitskiy@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 21, 2021 at 09:09:00PM -0700, Ilya Lipnitskiy wrote:
> Most of these changes come from OpenWrt where they have been present and
> tested for months.
> 
> First three patches are bug fixes. The rest are performance
> improvements. The last patch is a cleanup to use the iopoll.h macro for
> busy-waiting instead of a custom loop.

Do you have any benchmark numbers you can share?

   Andrew
