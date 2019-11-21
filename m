Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2675710489D
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 03:40:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbfKUCk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 21:40:26 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:48838 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725819AbfKUCkZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Nov 2019 21:40:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=8srqg1thXMJvByxbrIntAMonCxEezTrnlySOxZWlfxg=; b=aHWftA/cfuzmy9gloUwA3H7E9E
        ZVUC7WkEZCvXC8PkKhxUUdxquzAWiGfmy7f4w9X4R0wtG+86Qz4GTmJUqX1zBbtH+fFGlqpZX0pHH
        MatiD35Y100SsvohVOVG7be/GuQieVZMueNO4BhjOjVrlBKbS5jlbsFgbHvxqtrnyQsU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iXc9M-00073E-8q; Thu, 21 Nov 2019 03:24:52 +0100
Date:   Thu, 21 Nov 2019 03:24:52 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] net: sfp: add support for module quirks
Message-ID: <20191121022452.GF18325@lunn.ch>
References: <20191120113900.GP25745@shell.armlinux.org.uk>
 <E1iXONe-0005el-H8@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1iXONe-0005el-H8@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static size_t sfp_strlen(const char *str, size_t maxlen)
> +{
> +	size_t size, i;
> +
> +	/* Trailing characters should be filled with space chars */
> +	for (i = 0, size = 0; i < maxlen; i++)
> +		if (str[i] != ' ')
> +			size = i + 1;

Hi Russell

Is this space padding part of the standard? What's the bet there are
some with a NULL character?

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
