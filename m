Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 130E73AB427
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 14:59:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232062AbhFQNBQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 09:01:16 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42580 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230137AbhFQNBP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Jun 2021 09:01:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=hHXkwgKnNfp9L6OW35d26XLF9j9waBFBIWrHzICzUiA=; b=2jrxKMoVFqfxXdyWvZ5FM9OnW/
        7OssGebI5yQ27lLxmuqijnmLicIFZoQ/xbeDezh7OeDMum/zxlJlPDMFk53Z3+JBkxFWb74NmM46v
        QFNqnErKV4bez28i7VyL3LjN7I2lrMP7lRUyQ3yXjKKx9XLQYUduLHgdMiCHr4bZDW2s=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ltrbt-009u8e-CN; Thu, 17 Jun 2021 14:59:05 +0200
Date:   Thu, 17 Jun 2021 14:59:05 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Grzegorz Bernacki <gjb@semihalf.com>, upstream@semihalf.com,
        Samer El-Haj-Mahmoud <Samer.El-Haj-Mahmoud@arm.com>,
        Jon Nettleton <jon@solid-run.com>,
        Tomasz Nowicki <tn@semihalf.com>, rjw@rjwysocki.net,
        lenb@kernel.org
Subject: Re: [net-next: PATCH v2 2/7] net: mdiobus: Introduce
 fwnode_mdbiobus_register()
Message-ID: <YMtHGV/Yr6h3TKKI@lunn.ch>
References: <20210616190759.2832033-1-mw@semihalf.com>
 <20210616190759.2832033-3-mw@semihalf.com>
 <YMpR+lJqcgQU2DMO@lunn.ch>
 <CAPv3WKdOkxV695DbhhYr+wf1rnphtj-pyERZ-74RrdZyQJGt=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPv3WKdOkxV695DbhhYr+wf1rnphtj-pyERZ-74RrdZyQJGt=g@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Actually mvmdio driver is using this fallback for non-dt platforms
> (e.g. Orion). Therefore I would prefer to keep the current behavior.

A quick look at Orion5x, it is now a multi arch MACH. It selects
ARCH_MULTI_V5. Which seems to imply ARCH_MULTIPLATFORM which selects
USE_OF which selects OF.

At least for ARM, i'm not sure you can realistically disable OF.

Having said that acpi_mdiobus_register() also falls back to
mdiobus_register(mdio). So it is symmetric. And
fwmode_mdiobus_register() falling back would keep with the
symmetry. So, O.K.

	  Andrew
