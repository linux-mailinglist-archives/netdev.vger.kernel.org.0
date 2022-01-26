Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C595349CADA
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 14:31:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234745AbiAZNb2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 08:31:28 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:55450 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229801AbiAZNbZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jan 2022 08:31:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=aKtJLe//v6/EBc+YSSoYzdU6iamB321A9zm7Ba4evZA=; b=inxgVQvBMw6+AGrkC1JRtXm1Gm
        u8OmjNXocXjkDPXV0h26B08F8+lKaIMJiH7/cebeEb6y4aVX0ymKxX5bC6Hw62uW6ybkjwotTtXve
        H2JNhewXo6hJb2NVvlfnRI/puqUyouOex/YFYlaeC9Efjt2mbFF33yeb3gC6OID084v4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nCiOM-002oQJ-Bc; Wed, 26 Jan 2022 14:31:18 +0100
Date:   Wed, 26 Jan 2022 14:31:18 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        Shaohui Xie <Shaohui.Xie@freescale.com>,
        Scott Wood <scottwood@freescale.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/5] dt-bindings: net: xgmac_mdio: Remove
 unsupported "bus-frequency"
Message-ID: <YfFNJlqy41P30GLC@lunn.ch>
References: <20220126101432.822818-1-tobias@waldekranz.com>
 <20220126101432.822818-2-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220126101432.822818-2-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 26, 2022 at 11:14:28AM +0100, Tobias Waldekranz wrote:
> This property has never been supported by the driver. The kernel has
> settled on "clock-frequency" as the standard name for this binding, so
> once that is supported we will document that instead.
> 
> Fixes: 7f93c9d90f4d ("power/fsl: add MDIO dt binding for FMan")
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
