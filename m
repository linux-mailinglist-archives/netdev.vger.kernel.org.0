Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6A2E3A8B1C
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 23:31:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbhFOVd6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 17:33:58 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38892 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229931AbhFOVd5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Jun 2021 17:33:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=P07u4UYwoQ9Uc6/dX1RvhZ+MWQHN7tef+regVgBkCNE=; b=pN/YI47psGOhCKlCQBvZsPxLav
        IyJwirTB4PbSWTyV3aHc+bKaqJaE78+lg5L1H9sfH7keKQqHNQhITvEcweo4CnwAVC1Wq1EBjSF7T
        K64QBsb2oQvE6T9V+Cl2y/riSHr1HjqgNYMdC7hKBpe8wX18qXzcwALj5pOd+K4X5b/U=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ltGex-009bL8-Ky; Tue, 15 Jun 2021 23:31:47 +0200
Date:   Tue, 15 Jun 2021 23:31:47 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ioana Ciornei <ciorneiioana@gmail.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        calvin.johnson@oss.nxp.com, hkallweit1@gmail.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: [PATCH net-next] mdio: mdiobus: setup of_node for the MDIO device
Message-ID: <YMkcQ6F2FXWvpeKu@lunn.ch>
References: <20210615154401.1274322-1-ciorneiioana@gmail.com>
 <20210615171330.GW22278@shell.armlinux.org.uk>
 <YMjx6iBD88+xdODZ@lunn.ch>
 <20210615210907.GY22278@shell.armlinux.org.uk>
 <20210615212153.fvfenkyqabyqp7dk@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210615212153.fvfenkyqabyqp7dk@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The fwnode_operations declared in drivers/acpi/property.c also suggest
> the ACPI fwnodes are not refcounted.

Is this because ACPI is not dynamic, unlike DT, where you can
add/remove overlays at runtime?

   Andrew
