Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9525FF2EB9
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 14:01:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388925AbfKGNBs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 08:01:48 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:54144 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726873AbfKGNBs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Nov 2019 08:01:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=jHxGgHR+MvtMvpcV2DnkxEJ54Pnbf1wGrTSOTpugnMY=; b=YDWfRnjyeObkcRL2t2Zb5tPqix
        coWfPvd0lOlCbWsQhX8ilqcW1tj8K+0ouMryJJITtHsLSZtmGWtwb+1D945wMS3RZeZsAABsvGiFf
        4gtPsiMiybmzhYLbtlsLEgD8ZW3K/nRXnML+fAxnEDNO1rMH9hhBjhbB9pFpRHZvQkhE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iShQ0-00064k-3Q; Thu, 07 Nov 2019 14:01:44 +0100
Date:   Thu, 7 Nov 2019 14:01:44 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] dpaa2-eth: add ethtool MAC counters
Message-ID: <20191107130144.GC22978@lunn.ch>
References: <1573087748-31303-1-git-send-email-ioana.ciornei@nxp.com>
 <20191107014758.GA8978@lunn.ch>
 <VI1PR0402MB280021AE88E253270FEEC02CE0780@VI1PR0402MB2800.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR0402MB280021AE88E253270FEEC02CE0780@VI1PR0402MB2800.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Anyhow, I'll add this to the list of things to improve in the fw :)

Hi Ioana

I also later thought about snapshotting. Often the hardware supports
taking an atomic copy of all the statistics. You can then read back
the copy, knowing that the values should be consistent. None get
incremented while you read individual counters.

Something else you can consider adding to the firmware.

	  Andrew
