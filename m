Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5965E40DC6A
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 16:07:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238379AbhIPOJP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 10:09:15 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44262 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238473AbhIPOJL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 10:09:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Y7ONHrozJTI92ehosxlMrkJMK5/1S9Q891cAYJYj7FA=; b=UzQkG8YtabapUi4fOmKFVhF98Z
        Vl8HemrwSOs3WSxuHeeydVtxk1uTWw0WGLSBKzqBm5cbs8HlNEgw1qTXTA1gXMpfDP+JPYIBzZ1RQ
        xGSKc5AURP6ZlcLBlM2eE4qjA6lIhi2JfRICMZOblEI/d+FeiAQR1ZuhftqZ+bioCBqw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mQs3J-006uwM-Rq; Thu, 16 Sep 2021 16:07:49 +0200
Date:   Thu, 16 Sep 2021 16:07:49 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Asmaa Mnebhi <asmaa@nvidia.com>
Cc:     andy.shevchenko@gmail.com, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, kuba@kernel.org,
        linus.walleij@linaro.org, bgolaszewski@baylibre.com,
        davem@davemloft.net, rjw@rjwysocki.net, davthompson@nvidia.com
Subject: Re: [PATCH v1 2/2] net: mellanox: mlxbf_gige: Replace non-standard
 interrupt handling
Message-ID: <YUNPtcDs6yeSo40W@lunn.ch>
References: <20210915222847.10239-1-asmaa@nvidia.com>
 <20210915222847.10239-3-asmaa@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210915222847.10239-3-asmaa@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 15, 2021 at 06:28:47PM -0400, Asmaa Mnebhi wrote:
> Since the GPIO driver (gpio-mlxbf2.c) supports interrupt handling,
> replace the custom routine with simple IRQ request.
> 
> Signed-off-by: Asmaa Mnebhi <asmaa@nvidia.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
