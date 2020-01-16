Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6A1E140037
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 00:51:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388600AbgAPXs7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 18:48:59 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:43322 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729923AbgAPXs6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 18:48:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Juuo03VpFA+G7b21XGdIfqDuWHafdyKqwNzDsnhYGFs=; b=SUj75zj+UNmZm/W40IXnWqJoUi
        BwUx5Agz8VbHzuhULWOjwlCfNJ9cMwCcYbLRR9wc0Ud8oDJ/wnA7UdOJi9E6m1s/Mum8ad7yClNmx
        5xGS+ZJcmLU0rJRIEuzAyzgWiZtipZJfp6JOSRjLfJ9/1BprBE1j8kAt92IYFu1VQ/zE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1isEsi-0001Ox-MN; Fri, 17 Jan 2020 00:48:56 +0100
Date:   Fri, 17 Jan 2020 00:48:56 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Grzeschik <m.grzeschik@pengutronix.de>
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, hkallweit1@gmail.com,
        kernel@pengutronix.de
Subject: Re: [PATCH v4] net: phy: dp83867: Set FORCE_LINK_GOOD to default
 after reset
Message-ID: <20200116234856.GK19046@lunn.ch>
References: <20200116.045753.1672747031363850521.davem@davemloft.net>
 <20200116131631.31724-1-m.grzeschik@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200116131631.31724-1-m.grzeschik@pengutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 16, 2020 at 02:16:31PM +0100, Michael Grzeschik wrote:
> According to the Datasheet this bit should be 0 (Normal operation) in
> default. With the FORCE_LINK_GOOD bit set, it is not possible to get a
> link. This patch sets FORCE_LINK_GOOD to the default value after
> resetting the phy.
> 
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
