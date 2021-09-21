Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAD4C413D8D
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 00:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235972AbhIUWam (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 18:30:42 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53094 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229804AbhIUWal (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Sep 2021 18:30:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=PeyUFrAz+awpOvrAUXirJJUqXebSc29UETMfacD4+9g=; b=W8Cuo7F0mwzNUUxATZVTY7r4KF
        k6Hc0wCR15E5+NNt/llyUCygZG9BdMC22/bLrXtMK/r/C3RrqD4Ecdy07WpAY0EY+h0qibAXDaAj6
        bBebX7Mo8wtxxEsdvEJujCJARb//LEykKn8SOeyr3la9BovGKbFXwLNi7R8mWtVPnBDE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mSoGD-007hJd-Pe; Wed, 22 Sep 2021 00:29:09 +0200
Date:   Wed, 22 Sep 2021 00:29:09 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Asmaa Mnebhi <asmaa@nvidia.com>
Cc:     andy.shevchenko@gmail.com, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, kuba@kernel.org,
        linus.walleij@linaro.org, bgolaszewski@baylibre.com,
        davem@davemloft.net, rjw@rjwysocki.net, davthompson@nvidia.com
Subject: Re: [PATCH v2 2/2] net: mellanox: mlxbf_gige: Replace non-standard
 interrupt handling
Message-ID: <YUpctTXOKn8WtSDs@lunn.ch>
References: <20210920212227.19358-1-asmaa@nvidia.com>
 <20210920212227.19358-3-asmaa@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210920212227.19358-3-asmaa@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 20, 2021 at 05:22:27PM -0400, Asmaa Mnebhi wrote:
> Since the GPIO driver (gpio-mlxbf2.c) supports interrupt
> handling, replace the custom routine with simple IRQ
> request.
> 
> Signed-off-by: Asmaa Mnebhi <asmaa@nvidia.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
