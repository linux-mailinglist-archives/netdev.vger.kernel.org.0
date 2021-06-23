Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BEB23B21CC
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 22:28:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbhFWUbF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 16:31:05 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52430 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229688AbhFWUbD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Jun 2021 16:31:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=rW69eeaIoxqiBjOCnjVc6wb8e+CNjfx78uClzN/Tr+0=; b=rgHnQTei+sH40C+OWT9r0I9UME
        3Z05BwfZOCLIfhkIHyIe/Cr8ENp2QB6iuy/5Vtwmaq3RRfF/rk0OYqJB5ZX0ZtjrxPlZAw79w4DZM
        zLdPiBHAcVTtnI37cazQ7ItH+c5e/45Q525Oi4QQxKR8ijC3ypqJhxsULuTbLNBkRbG4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lw9UK-00AtBJ-30; Wed, 23 Jun 2021 22:28:44 +0200
Date:   Wed, 23 Jun 2021 22:28:44 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, linux@armlinux.org.uk,
        jaz@semihalf.com, gjb@semihalf.com, upstream@semihalf.com,
        Samer.El-Haj-Mahmoud@arm.com, jon@solid-run.com, tn@semihalf.com,
        rjw@rjwysocki.net, lenb@kernel.org
Subject: Re: [net-next: PATCH v3 4/6] net: mvmdio: add ACPI support
Message-ID: <YNOZfB4pBRrOYETA@lunn.ch>
References: <20210621173028.3541424-1-mw@semihalf.com>
 <20210621173028.3541424-5-mw@semihalf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210621173028.3541424-5-mw@semihalf.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 21, 2021 at 07:30:26PM +0200, Marcin Wojtas wrote:
> This patch introducing ACPI support for the mvmdio driver by adding
> acpi_match_table with two entries:
> 
> * "MRVL0100" for the SMI operation
> * "MRVL0101" for the XSMI mode

Same as the freescale MDIO bus driver, you should add

depends on FWNODE_MDIO

Otherwise you might find randconfig builds end up with it disabled,
and then linker errors.

       Andrew
