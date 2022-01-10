Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5432489A21
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 14:38:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232807AbiAJNij (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 08:38:39 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:58842 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232695AbiAJNij (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jan 2022 08:38:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=FmTR09Oqz1bW5Lxwav5e3Ryx2EwoQsLw1Q/s1FDqmR4=; b=Lc8LL1YzPGnL1TWVsscyZPvo8I
        fuX+teKvbB8XVobFbenMg/zjLdjv1xlwE8Gd+8M44uCaFWRqRGls88qlj+Mbihf8i8mNeoRMkkMg8
        KBT2ZaXn6emicmbkOKOXajAOG2flIQ4XOwitiUye7CR95IJIfWl0ZhGPZS14/vvfkSPk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n6usd-000zU7-Uy; Mon, 10 Jan 2022 14:38:35 +0100
Date:   Mon, 10 Jan 2022 14:38:35 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: at803x: make array offsets static
Message-ID: <Ydw228SaeS8Ro8He@lunn.ch>
References: <20220109231716.59012-1-colin.i.king@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220109231716.59012-1-colin.i.king@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 09, 2022 at 11:17:16PM +0000, Colin Ian King wrote:
> Don't populate the read-only const array offsets on the stack
> but instead make it static. Also makes the object code a little smaller.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
