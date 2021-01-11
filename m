Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2816C2F1B44
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 17:43:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389006AbhAKQmg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 11:42:36 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:33678 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387980AbhAKQmg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 11:42:36 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kz0GG-00HZEd-BL; Mon, 11 Jan 2021 17:41:44 +0100
Date:   Mon, 11 Jan 2021 17:41:44 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, pavana.sharma@digi.com,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, kuba@kernel.org,
        lkp@intel.com, davem@davemloft.net, ashkan.boldaji@digi.com,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        olteanv@gmail.com,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Rob Herring <robh@kernel.org>
Subject: Re: [PATCH net-next v14 1/6] dt-bindings: net: Add 5GBASER phy
 interface
Message-ID: <X/x/yHm1QBknGl4S@lunn.ch>
References: <20210111012156.27799-1-kabel@kernel.org>
 <20210111012156.27799-2-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210111012156.27799-2-kabel@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 11, 2021 at 02:21:51AM +0100, Marek Behún wrote:
> From: Pavana Sharma <pavana.sharma@digi.com>
> 
> Add 5gbase-r PHY interface mode.
> 
> Signed-off-by: Pavana Sharma <pavana.sharma@digi.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Reviewed-by: Marek Behún <kabel@kernel.org>
> Acked-by: Rob Herring <robh@kernel.org>

Hi Marek

Now that you are posting these patches, they need your Signed-off-by:
as well as Pavana.

     Andrew
