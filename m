Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 899C645F6A7
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 22:52:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232110AbhKZVzM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 16:55:12 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:54162 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233701AbhKZVxK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Nov 2021 16:53:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=xUgaoNGaDT4Lcfr0G8yawimpo3GqUdmVV4/OKFNe9yA=; b=dPJ0th0ffPSRPuMvYTf4MHo7Ql
        Xzwj/i0sPvchyIixCmu/s1Z1n02IP60v5wQ+b0N2dstJYSZCIfbn1ZSE2c0rdQnrWI6s00S8tWFjg
        scKQEKqihpozGS6aJ4IeMhvxpSJ0VMzjKSSa7K27CXLpRlkn6JVA3iWWBE6SCQr06wng=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mqj6Q-00EjOf-JA; Fri, 26 Nov 2021 22:49:54 +0100
Date:   Fri, 26 Nov 2021 22:49:54 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Holger Brunck <holger.brunck@hitachienergy.com>,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 2/2] dsa: mv88e6xxx: make serdes SGMII/Fiber output
 amplitude configurable
Message-ID: <YaFWgk0xoQnp+mIe@lunn.ch>
References: <20211126154249.2958-1-holger.brunck@hitachienergy.com>
 <20211126154249.2958-2-holger.brunck@hitachienergy.com>
 <20211126205625.5c0e38c5@thinkpad>
 <YaFHAbXbEH1fokkx@lunn.ch>
 <20211126221345.5e17e48d@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211126221345.5e17e48d@thinkpad>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> You're right, device_property_read() needs a device, and this seems
> like a port-specific property. But from the patch it seems Holger is
> using the switch device node:
> 
>   struct device_node *np = chip->dev->of_node;
> 
> so either this is wrong or he could use device_property API.

I already commented it should be a port property, probably to patch
1/2.

> Of course
> that would need a complete conversion, with device_* or fwnode_*.
> functions. I was wondering if device_* + fwnode_* functions are
> preferred instead of of_* functions (since they can be used also with
> ACPI, for example).

I doubt ACPI is ever going to happen for DSA. Despite the A in ACPI,
ACPI is for simple hardware, server and desktop like hardware.

   Andrew
