Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C45B77907D
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 18:13:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728536AbfG2QNZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 12:13:25 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45246 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726825AbfG2QNZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 12:13:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=k+pY4BNjcj+Rs1KaJHTZzkyKwY60RatbH+nODMGqyuc=; b=1p65XXu7gNeQsYGAvt9+Ma+XS0
        8iiSrpF0SEUgZEP7k2FsCkUhqNiurhDOQcqHHq+sYoFnlpO+SrXOhBaMJa2AB6U4Sinuky8lfc2BR
        Gi0+bIt67uZUkFTPdtHjfVpvf/HRg2iWoRzhrsnq8/Y9gkzC0NWJJWYG3g7lZ0d0xMXs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hs7hQ-0002VA-NJ; Mon, 29 Jul 2019 17:36:32 +0200
Date:   Mon, 29 Jul 2019 17:36:32 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        alexandru.marginean@nxp.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 3/4] dt-bindings: net: fsl: enetc: Add
 bindings for the central MDIO PCIe endpoint
Message-ID: <20190729153632.GH4110@lunn.ch>
References: <1564394627-3810-1-git-send-email-claudiu.manoil@nxp.com>
 <1564394627-3810-4-git-send-email-claudiu.manoil@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1564394627-3810-4-git-send-email-claudiu.manoil@nxp.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 29, 2019 at 01:03:46PM +0300, Claudiu Manoil wrote:
> The on-chip PCIe root complex that integrates the ENETC ethernet
> controllers also integrates a PCIe endpoint for the MDIO controller
> providing for centralized control of the ENETC mdio bus.
> Add bindings for this "central" MDIO Integrated PCIe Endpoint.
> 
> Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
