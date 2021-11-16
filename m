Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE2DC453714
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 17:16:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbhKPQR7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 11:17:59 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:36366 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229712AbhKPQRx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 11:17:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=PASFtIvmXiuXx07CpS5qPMWdo9F5rRsD+QtwJAjZM6g=; b=cRzLZXkbPG/+EWHe3Ieb6zRQAx
        QtkvuoERuuD+/QVMx0krTm9TCvjQe7tUvSYWi0ajliw7L3wcXHYkOoQFquObSzVn6WSsfVRWhlaem
        DfZW7cQ9SZcJPNe/ETaDzvqbxJ5NWwI7QaXxw4Lf5XSPr9eI2dghFTumcnjrSTa/wOVE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mn16f-00Dg7y-RA; Tue, 16 Nov 2021 17:14:49 +0100
Date:   Tue, 16 Nov 2021 17:14:49 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Modi, Geet" <geet.modi@ti.com>
Cc:     "Nagalla, Hari" <hnagalla@ti.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Sharma, Vikram" <vikram.sharma@ti.com>,
        "Strashko, Grygorii" <grygorii.strashko@ti.com>
Subject: Re: [EXTERNAL] Re: [PATCH net-next] net: phy: add support for TI
 DP83561-SP phy
Message-ID: <YZPY+WSLVcTtkDwm@lunn.ch>
References: <20211116102015.15495-1-hnagalla@ti.com>
 <YZO33aidzEwo3YFC@lunn.ch>
 <722B4304-CE9B-436C-A157-48007D289956@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <722B4304-CE9B-436C-A157-48007D289956@ti.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 16, 2021 at 03:58:27PM +0000, Modi, Geet wrote:
> Hello Andrew,
> 
>  
> 
> We being Texas Instruments are conservative and don't promote meaningless
> marketing as well. Please note DP83561-SP is a Radiation Hardened Space Grade
> Gigabit PHY. It has been tested for Single Event Latch up upto 121 MeV, the
> critical reliability parameter Space Designs look for.

That statement i have no problems with, it is clearly factual.

> The dp83561-sp is a high reliability gigabit ethernet PHY designed

is clearly Marketing, who would design a low reliability gigabit
ethernet PHY? It is meaningless.

So please use your text from above in the commit message, it nicely
describes what this PHY is in engineering terms.

   Andrew
