Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9BBC438B69
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 20:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232036AbhJXSdc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 14:33:32 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55760 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230016AbhJXSdb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 Oct 2021 14:33:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=vxJ7iRLTCAYHM581o3Krywj+CszafIWIU5V6t59wGNg=; b=lER9lAhx1si5VuOYWD8G9LSH3I
        U1BnzPjzoAtJvR+i5BUBSLtwHxR7RBIz8d4qfwH67644sP+gBfHVBUEno/n935cv0C1ZWLIpSpGtv
        pI61GciDnofDcCSLdCbSPMO0VBZIeHzkh05awTlljryjG4wx3bTg26CtLBCVntavRTjE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1meiGx-00BZyZ-0f; Sun, 24 Oct 2021 20:31:07 +0200
Date:   Sun, 24 Oct 2021 20:31:07 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Luo Jie <luoj@codeaurora.org>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sricharan@codeaurora.org
Subject: Re: [PATCH v7 07/14] net: phy: add qca8081 get_features
Message-ID: <YXWmaxjlALd17uLH@lunn.ch>
References: <20211024082738.849-1-luoj@codeaurora.org>
 <20211024082738.849-8-luoj@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211024082738.849-8-luoj@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 24, 2021 at 04:27:31PM +0800, Luo Jie wrote:
> Reuse the at803x phy driver get_features excepting
> adding 2500M capability.
> 
> Signed-off-by: Luo Jie <luoj@codeaurora.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
