Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3F4739306B
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 16:06:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235885AbhE0OHl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 10:07:41 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60178 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234837AbhE0OHl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 10:07:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=EI+5jWsOjg0K5HJyDtR89/JI64J4p+NAgrB0Sar1CXA=; b=2vXDbHxBrLtc47ZKwxRS3hg2vj
        ADzAFJiVrlWKTQUo8wJxT7Iy0UlnoG1Rl58RpyvNWAKjciZv6bpsAuz2eSMe0RTWlQd9Z7/04Z0J2
        RtNcF6W7yZrNhUV+upCYyV2tCQ+hmfXv7zXP+0ssFnAawmBaembkH8xGpNO7LIzZ2QGY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lmGe6-006Xfx-RC; Thu, 27 May 2021 16:05:58 +0200
Date:   Thu, 27 May 2021 16:05:58 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "frieder.schrempf@kontron.de" <frieder.schrempf@kontron.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH V1 net-next 0/2] net: fec: fix TX bandwidth fluctuations
Message-ID: <YK+nRkzOhQHn9LDO@lunn.ch>
References: <20210527120722.16965-1-qiangqing.zhang@nxp.com>
 <DB8PR04MB679585D9D94C0D5D90003ED2E6239@DB8PR04MB6795.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DB8PR04MB679585D9D94C0D5D90003ED2E6239@DB8PR04MB6795.eurprd04.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 27, 2021 at 12:10:47PM +0000, Joakim Zhang wrote:
> 
> Hi Frieder,
> 
> As we talked before, could you please help test the patches when you are free? Thanks.

Hi Frieder

If you can, could you also test it with traffic with a mixture of VLAN
priorities. You might want to force the link to 10Full, so you can
overload it. Then see what traffic actually makes it through.

	 Andrew
