Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 961753E3B1C
	for <lists+netdev@lfdr.de>; Sun,  8 Aug 2021 17:30:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232051AbhHHPaI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 11:30:08 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38828 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229923AbhHHPaH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 8 Aug 2021 11:30:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=kFPCh7JAhBnmZtTF9Kdic0vRFx4iPcluqAVKggzCljo=; b=MbkN08r5JVHVsWZ/mmW/xRt9aV
        wTQIFqvenSzSes0e4EpBWnYzU2eoWfCe00AuPvl2N8AFhoocJpU6CekO0NQ3WzqRdXiAVV6C7oYjm
        TSpKp1va3cvunoTyln4bjVzO3TP4MmECZNS5YweuZFMKZFfu+r9eZGIXhkcXc1KN9xv0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mCkkC-00Gamm-UA; Sun, 08 Aug 2021 17:29:44 +0200
Date:   Sun, 8 Aug 2021 17:29:44 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Luo Jie <luoj@codeaurora.org>
Cc:     hkallweit1@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sricharan@codeaurora.org
Subject: Re: [PATCH v1 1/2] net: mdio: Add the reset function for IPQ MDIO
 driver
Message-ID: <YQ/4aK3yYPvYQdhD@lunn.ch>
References: <20210808072111.8365-1-luoj@codeaurora.org>
 <20210808072111.8365-2-luoj@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210808072111.8365-2-luoj@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +	/* Configure MDIO clock source frequency if clock is specified in the device tree */
> +	if (!IS_ERR_OR_NULL(priv->mdio_clk)) {

Please document the clock in the binding. Make it clear which devices
require the clock, and which don't.

	Andrew
