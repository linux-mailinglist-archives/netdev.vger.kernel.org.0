Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5443317FCF6
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 14:25:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730295AbgCJNYl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 09:24:41 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55142 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727391AbgCJNYk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Mar 2020 09:24:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=rJn5zMEeyKEpdgzeDpLuHWjmnGAtyMaZbRTxuWpfM88=; b=RAWM/eklBGXXMA3h7Bq7Rio8kp
        svHjjH9VNAAtDF+tgkTuML85pgXe6zRd2yDTut0nfjKLlT9WG1ZpXPURBiwkQwlIfmUvU0/hsPpRW
        A6kiRScXy00m0BJ1udPM/9tDGFvCyGYD9xryq35YanDgsFOmjZn0e4RuwScz6S/1i4EE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jBes9-0001oj-DC; Tue, 10 Mar 2020 14:24:37 +0100
Date:   Tue, 10 Mar 2020 14:24:37 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     davem@davemloft.net, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 3/3] net: phy: mscc: fix header defines and
 descriptions
Message-ID: <20200310132437.GG5932@lunn.ch>
References: <20200310090720.521745-1-antoine.tenart@bootlin.com>
 <20200310090720.521745-4-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200310090720.521745-4-antoine.tenart@bootlin.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 10, 2020 at 10:07:20AM +0100, Antoine Tenart wrote:
> Cosmetic commit fixing the MSCC PHY header defines and descriptions,
> which were referring the to MSCC Ocelot MAC driver (see
> drivers/net/ethernet/mscc/).
> 
> Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
