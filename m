Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90D213E9420
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 16:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232898AbhHKO7T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 10:59:19 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45284 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232871AbhHKO7S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 10:59:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=G1+EmfpBKcPDyvMCIc7/dEMpI7YHnByfxi9Wq3B3J3o=; b=azJD3R7eiZKOLJNttUr/gTYHDh
        qt4XCEK08Kr3FMrQPzLGWcbwi9BBX+Njdzbd/ZiCb7EZIBnnIEOwgebyt8jtAEE8zgNk4kJ0ucuhc
        HMrb2sVexCpAM+oLfWPjx05N0ws/eO5p7/oOlqnc+6vjptXWAM+MXNsXMUiwkAMVGp00=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mDpgw-00H8My-Lk; Wed, 11 Aug 2021 16:58:50 +0200
Date:   Wed, 11 Aug 2021 16:58:50 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Luo Jie <luoj@codeaurora.org>
Cc:     agross@kernel.org, bjorn.andersson@linaro.org, davem@davemloft.net,
        kuba@kernel.org, robh+dt@kernel.org, hkallweit1@gmail.com,
        linux@armlinux.org.uk, robert.marko@sartura.hr,
        linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        sricharan@codeaurora.org
Subject: Re: [PATCH v2 3/3] dt-bindings: net: Add the properties for ipq4019
 MDIO
Message-ID: <YRPlqgszKOtFMVt7@lunn.ch>
References: <20210810133116.29463-1-luoj@codeaurora.org>
 <20210810133116.29463-4-luoj@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210810133116.29463-4-luoj@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 10, 2021 at 09:31:16PM +0800, Luo Jie wrote:
> The new added properties resource "reg" is for configuring
> ethernet LDO in the IPQ5018 chipset, the property "clocks"
> is for configuring the MDIO clock source frequency.
> 
> Signed-off-by: Luo Jie <luoj@codeaurora.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
