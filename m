Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DF503AA466
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 21:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232865AbhFPThl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 15:37:41 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41148 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231202AbhFPThk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 15:37:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=CtC+jf6jJeo7kAe4PSHF8keAIAdxH3+hcIcsemia9a0=; b=KKsvWyVpanGLzjPPABdmHAPmHk
        2rJUT50zjZuq4nKZaojXmf7oO8pdUjHIJCWhLpvfwYPa8t7WmBxsh3tkV42PrMpGvViFR0ZfJ4j0Y
        M2kPAD6qGlPFeOwMbEyEFXcBClKsCVmM6hUaQ+3JFaO/eGUkwBAWdntj2YGOnqxTdX3Q=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ltbK1-009llC-6H; Wed, 16 Jun 2021 21:35:33 +0200
Date:   Wed, 16 Jun 2021 21:35:33 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, linux@armlinux.org.uk,
        jaz@semihalf.com, gjb@semihalf.com, upstream@semihalf.com,
        Samer.El-Haj-Mahmoud@arm.com, jon@solid-run.com, tn@semihalf.com,
        rjw@rjwysocki.net, lenb@kernel.org
Subject: Re: [net-next: PATCH v2 3/7] net/fsl: switch to
 fwnode_mdiobus_register
Message-ID: <YMpShczKt1TNAqsV@lunn.ch>
References: <20210616190759.2832033-1-mw@semihalf.com>
 <20210616190759.2832033-4-mw@semihalf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210616190759.2832033-4-mw@semihalf.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 16, 2021 at 09:07:55PM +0200, Marcin Wojtas wrote:
> Utilize the newly added helper routine
> for registering the MDIO bus via fwnode_
> interface.

You need to add depends on FWNODE_MDIO

    Andrew
