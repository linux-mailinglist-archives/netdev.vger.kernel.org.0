Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1B9C1E1021
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 16:11:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403940AbgEYOK6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 10:10:58 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48182 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403936AbgEYOK6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 May 2020 10:10:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=I0JcXOa65pxt0xeOn7XZQNU2idxhZWDbbjFj+EaaSWo=; b=XIC82vWt8QdxYgP2GkmVIy9T3l
        veUjidrRo4BVKiloackNjz5i742888MBHPsFodv7WcoggCkk5k1IYqD4yRz4hS6/3ANYgLCepIpUD
        V2Qo1sDTJ7rq7vCI/bvLRvYvkkwI7BbRKpXjTFTXTdn4P9BIKpUPpDfHt9F7GsbN/4G4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jdDoW-003C8t-15; Mon, 25 May 2020 16:10:48 +0200
Date:   Mon, 25 May 2020 16:10:48 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Fugang Duan <fugang.duan@nxp.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, kuba@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, mcoquelin.stm32@gmail.com,
        p.zabel@pengutronix.de, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] stmmac: platform: add "snps,dwmac-5.10a" IP compatible
 string
Message-ID: <20200525141048.GF752669@lunn.ch>
References: <1590394945-5571-1-git-send-email-fugang.duan@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1590394945-5571-1-git-send-email-fugang.duan@nxp.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 25, 2020 at 04:22:25PM +0800, Fugang Duan wrote:
> Add "snps,dwmac-5.10a" compatible string for 5.10a version that can
> avoid to define some plat data in glue layer.

Documentation/devicetree/bindings/net/snps,dwmac.yaml ?

      Andrew
