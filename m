Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 630053380F0
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 23:53:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231216AbhCKWxE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 17:53:04 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:52932 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231197AbhCKWws (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 17:52:48 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lKUAb-00AQjE-2g; Thu, 11 Mar 2021 23:52:41 +0100
Date:   Thu, 11 Mar 2021 23:52:41 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Kurt Kanzenbach <kurt@kmk-computers.de>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/6] net: dsa: hellcreek: Report META data usage
Message-ID: <YEqfOc3Wii7UTH8g@lunn.ch>
References: <20210311175344.3084-1-kurt@kmk-computers.de>
 <20210311175344.3084-3-kurt@kmk-computers.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210311175344.3084-3-kurt@kmk-computers.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 11, 2021 at 06:53:40PM +0100, Kurt Kanzenbach wrote:
> Report the META data descriptor usage via devlink.

Jakubs question is also relevant here. Please could you give a bit
more background about what the meta data is?

Thanks
	Andrew
