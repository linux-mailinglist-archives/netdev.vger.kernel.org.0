Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DAB43A3371
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 20:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbhFJSnJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 14:43:09 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57250 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230086AbhFJSnI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 14:43:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=nmp1JrKWQ1DrFzI3CBSSvjm1La6Wxfkpwm0/xwJFPC0=; b=iTHE1jHz6kJQoC1g0ChuvSbnfh
        +dX8Jld4Q//+aEnfCZ8pejM/SIoj5UFliJzTILkegSTjBeRUKrWgPrTSNQBhyRnA5+L7r4Rd2HJTV
        QgWTfR+tdH5qaVhU/f0v73BQ9UJ7PSsAfVc/ZPKNkg+/gEUgLnznNyo31MNzBRYV3CpE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lrPbs-008iCD-3e; Thu, 10 Jun 2021 20:40:56 +0200
Date:   Thu, 10 Jun 2021 20:40:56 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     Jon Nettleton <jon@solid-run.com>,
        Ioana Ciornei <ciorneiioana@gmail.com>,
        Grant Likely <grant.likely@arm.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Saravana Kannan <saravanak@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Calvin Johnson <calvin.johnson@nxp.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux.cj" <linux.cj@gmail.com>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Len Brown <lenb@kernel.org>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: [PATCH net-next v8 00/15] ACPI support for dpaa2 driver
Message-ID: <YMJcuIaqi8Bzb29A@lunn.ch>
References: <20210610163917.4138412-1-ciorneiioana@gmail.com>
 <YMJEMXEDAE/m9MhA@lunn.ch>
 <CABdtJHv-Xu5bC2-T7a0UgbYpkNP1SLfWwdLWLLKj5MBvA2Ajyw@mail.gmail.com>
 <CAJZ5v0iNTaFQuZZid77qTpfbs-4YdDgZdcC+rt4+mXV9f=OpTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJZ5v0iNTaFQuZZid77qTpfbs-4YdDgZdcC+rt4+mXV9f=OpTA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> And I believe that you have all of the requisite ACKs from the ACPI
> side now, so it is up to the networking guys to decide what to do
> next.

Thanks for the Acked-by's.

Since they were missing, the networking guys have deliberately been
ignoring this code. Now they have been given, we will start the review
work.

Thanks
	Andrew
