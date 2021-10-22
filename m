Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B243C437EA9
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 21:31:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234257AbhJVTdR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 15:33:17 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53462 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234231AbhJVTdR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 15:33:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=eVH+cO11i3jEQf18AsXW8XkRx/mOz8QvgQ1rxAXOCEI=; b=6IA2gNCOpyfZ7CLlWmMzd7UbdT
        ordUFH170fiTzOTktwkRzewcuV/G5S/4W/CldlPUDw13vjAbZPo9UjwG4jMpdRqN9yJF3UDeYdw1M
        +AzehZ6z7QNb+xg3VExtM6ymfPOaAjPnhJI4iS3M+2Z/ObBoO4FUt7E5AhtdiSq2FQd4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1me0Fi-00BQG5-Ub; Fri, 22 Oct 2021 21:30:54 +0200
Date:   Fri, 22 Oct 2021 21:30:54 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Doug Berger <opendmb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:BROADCOM GENET ETHERNET DRIVER" 
        <bcm-kernel-feedback-list@broadcom.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 2/3] dt-bindings: net: bcmgenet: Document 7712
 binding
Message-ID: <YXMRbs8bWOpdzzOX@lunn.ch>
References: <20211022161703.3360330-1-f.fainelli@gmail.com>
 <20211022161703.3360330-3-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211022161703.3360330-3-f.fainelli@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 22, 2021 at 09:17:02AM -0700, Florian Fainelli wrote:
> 7712 includes a GENETv5 adapter with an on-chip 10/100 16nm Ethernet PHY
> which requires us to document that controller's integration specifically
> for proper driver keying.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
