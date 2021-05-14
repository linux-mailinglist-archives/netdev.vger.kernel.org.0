Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6960380EEC
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 19:28:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231423AbhENR3u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 13:29:50 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40712 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229516AbhENR3u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 May 2021 13:29:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=5WPyLTz7c2kYwCsqXZ8QlYk8yM5FgOmktldw0a24vWg=; b=0Ri8TzPlk83DSzNm8XS4qxv1lk
        ZEsmasQHGA094g0Qa8r1q6ERrhXyIZyDwk15gV6CR2BkU3kHXBrmo2DslV1Q70Sd5hf0D74i/WhqO
        PcrJtA9aYk6YMWM3OklzP63uTL7Up0SeRBDh4osNFsqXpIHqNdWlYnvNm7WMjjvISRYE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lhbbw-004DKu-LU; Fri, 14 May 2021 19:28:28 +0200
Date:   Fri, 14 May 2021 19:28:28 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dario Binacchi <dariobin@libero.it>
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Zhang Qilong <zhangqilong3@huawei.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 1/2] can: c_can: add ethtool support
Message-ID: <YJ6zPGwRUQ23Fu3g@lunn.ch>
References: <20210514165549.14365-2-dariobin@libero.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210514165549.14365-2-dariobin@libero.it>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 14, 2021 at 06:55:47PM +0200, Dario Binacchi wrote:
> With commit 132f2d45fb23 ("can: c_can: add support to 64 message objects")
> the number of message objects used for reception / transmission depends
> on FIFO size.
> The ethtools API support allows you to retrieve this info. Driver info
> has been added too.
> 
> Signed-off-by: Dario Binacchi <dariobin@libero.it>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
