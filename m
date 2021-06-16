Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8907E3AA4C7
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 21:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233195AbhFPT4b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 15:56:31 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41250 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233173AbhFPT43 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 15:56:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=pLLldil+lfeXxgQFcH17D14Xoc+0vx5akwPW/updQh8=; b=DpxYjwr3IUyGNqrHzHjHTBAdcg
        9hBy+9GAYH59qzhhiTQlJdkqWpkBMQkIh29QqMBqSS4HF7xv8FrKmfQHcBY+wHusBBcl2sDhXkCzq
        DdENCJFRNh6HUvF2B0+PnmivVQtiJB1/p7doNZAd22W3mBuyR8uSGpGqquOHmGl84t1g=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ltbcD-009luR-G8; Wed, 16 Jun 2021 21:54:21 +0200
Date:   Wed, 16 Jun 2021 21:54:21 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, linux@armlinux.org.uk,
        jaz@semihalf.com, gjb@semihalf.com, upstream@semihalf.com,
        Samer.El-Haj-Mahmoud@arm.com, jon@solid-run.com, tn@semihalf.com,
        rjw@rjwysocki.net, lenb@kernel.org
Subject: Re: [net-next: PATCH v2 7/7] net: mvpp2: remove unused 'has_phy'
 field
Message-ID: <YMpW7Y/A7ZYhPuJx@lunn.ch>
References: <20210616190759.2832033-1-mw@semihalf.com>
 <20210616190759.2832033-8-mw@semihalf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210616190759.2832033-8-mw@semihalf.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 16, 2021 at 09:07:59PM +0200, Marcin Wojtas wrote:
> The 'has_phy' field from struct mvpp2_port is no longer used.
> Remove it.
> 
> Signed-off-by: Marcin Wojtas <mw@semihalf.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
