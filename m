Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89D86437DD9
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 21:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233937AbhJVTKE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 15:10:04 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53394 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234285AbhJVTJp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 15:09:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=x0S/R/4QoH4OSe4XShtLvK6x3SFrADkQJw9qMhBtdz0=; b=L1A83ow3kNfZHc8aWNnGkXEtqQ
        SEUX8EX5Bh2hdaVyUNiuoXFuHucC0X2SHXqiRS1vrLe3IZirGYe7YtkyBMINQbY4HLcRzNXbcKj4+
        SoBxx7f9TM6Xky6Bp6NIEb6rBoQzykprLFJBuNgPOi0Zu9fqLgyHVacUB8f/ilwOEgIk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mdzsw-00BQ75-Nd; Fri, 22 Oct 2021 21:07:22 +0200
Date:   Fri, 22 Oct 2021 21:07:22 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, hkallweit1@gmail.com,
        linux@armlinux.org.uk
Subject: Re: [PATCH net-next 3/8] net: phy: constify netdev->dev_addr
 references
Message-ID: <YXML6qoHPI0OqzUL@lunn.ch>
References: <20211022175543.2518732-1-kuba@kernel.org>
 <20211022175543.2518732-4-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211022175543.2518732-4-kuba@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 22, 2021 at 10:55:38AM -0700, Jakub Kicinski wrote:
> netdev->dev_addr will become a const soon(ish),
> constify the local variables referring to it.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
