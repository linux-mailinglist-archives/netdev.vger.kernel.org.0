Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 059653C7548
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 18:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232254AbhGMQxx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 12:53:53 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52936 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229650AbhGMQxw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Jul 2021 12:53:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=xXYRKU3APPZdqVIDkqh6GWTtLLzDz/r2IP0QXdrCNhM=; b=efuBX2mSvrOfjLnAGodiXh7Qc8
        dchXtw7BoI+bj/U0wiZxV/St58LTvAg3wYv7mi36Cn/TeMPpRqoxIOTXUs3Feete8JJ111ab+mvo4
        rqWAraLcJ7Wp4QLvvuqIxa11bPWZFncj9nZZsAh5Ae5+j867WHbZBNUimqNi09B6JNL0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m3LcZ-00DES9-Cl; Tue, 13 Jul 2021 18:50:59 +0200
Date:   Tue, 13 Jul 2021 18:50:59 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     alexandru.tachici@analog.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, robh+dt@kernel.org,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org
Subject: Re: [PATCH v2 1/7] ethtool: Add 10base-T1L link mode entries
Message-ID: <YO3Ec1VpeGpTbELb@lunn.ch>
References: <20210712130631.38153-1-alexandru.tachici@analog.com>
 <20210712130631.38153-2-alexandru.tachici@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210712130631.38153-2-alexandru.tachici@analog.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 12, 2021 at 04:06:25PM +0300, alexandru.tachici@analog.com wrote:
> From: Alexandru Tachici <alexandru.tachici@analog.com>
> 
> Add entries for the 10base-T1L full and half duplex supported modes.
> 
> Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
