Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E9833240B8
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 16:30:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235677AbhBXPWS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 10:22:18 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:55898 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237561AbhBXN4K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Feb 2021 08:56:10 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lEudJ-008EX6-KS; Wed, 24 Feb 2021 14:55:17 +0100
Date:   Wed, 24 Feb 2021 14:55:17 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marco Wenzel <marco.wenzel@a-eberle.de>
Cc:     george.mccollister@gmail.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Andreas Oetken <andreas.oetken@siemens.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Arvid Brodin <Arvid.Brodin@xdin.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: hsr: add support for EntryForgetTime
Message-ID: <YDZaxXkP25RjN02G@lunn.ch>
References: <CAFSKS=PnV-aLnGeNqjqrsT4nfFby18uYQpScCCurz6dZ39AynQ@mail.gmail.com>
 <20210224094653.1440-1-marco.wenzel@a-eberle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210224094653.1440-1-marco.wenzel@a-eberle.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 24, 2021 at 10:46:49AM +0100, Marco Wenzel wrote:
> In IEC 62439-3 EntryForgetTime is defined with a value of 400 ms. When a
> node does not send any frame within this time, the sequence number check
> for can be ignored. This solves communication issues with Cisco IE 2000
> in Redbox mode.
> 
> Fixes: f421436a591d ("net/hsr: Add support for the High-availability Seamless Redundancy protocol (HSRv0)")
> Signed-off-by: Marco Wenzel <marco.wenzel@a-eberle.de>
> Reviewed-by: George McCollister <george.mccollister@gmail.com>
> Tested-by: George McCollister <george.mccollister@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
