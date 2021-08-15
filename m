Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 508F93EC9B6
	for <lists+netdev@lfdr.de>; Sun, 15 Aug 2021 16:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238849AbhHOOu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Aug 2021 10:50:59 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50708 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238596AbhHOOu6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 15 Aug 2021 10:50:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=LbWUNWQyscgnkukZMfrnzCpVi+Euu9yicra71/I0Fgg=; b=uNk+FEyBC2ergDUJUWzUXmjdzX
        A6IrypFb4e4e+BTo+MhPUOv1q4m0g/fIjIAn7rHSXUi0tpv9Ec/67sWpUczhY52R479dpcbjrP4z8
        Vr2D3COs4rJLKN94l5mLvd6XQr0NivOyxAhiFMwRF1PAEue0Aw+nUSx9U5NlUkQBzuc8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mFHSx-000FQe-If; Sun, 15 Aug 2021 16:50:23 +0200
Date:   Sun, 15 Aug 2021 16:50:23 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Luo Jie <luoj@codeaurora.org>
Cc:     agross@kernel.org, bjorn.andersson@linaro.org, davem@davemloft.net,
        kuba@kernel.org, robh+dt@kernel.org, hkallweit1@gmail.com,
        linux@armlinux.org.uk, robert.marko@sartura.hr,
        linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        sricharan@codeaurora.org
Subject: Re: [PATCH v3 3/3] dt-bindings: net: Add the properties for ipq4019
 MDIO
Message-ID: <YRkprxDswcEWYyFV@lunn.ch>
References: <20210812100642.1800-1-luoj@codeaurora.org>
 <20210812100642.1800-4-luoj@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210812100642.1800-4-luoj@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 12, 2021 at 06:06:42PM +0800, Luo Jie wrote:
> The new added properties resource "reg" is for configuring
> ethernet LDO in the IPQ5018 chipset, the property "clocks"
> is for configuring the MDIO clock source frequency.
> 
> Signed-off-by: Luo Jie <luoj@codeaurora.org>
> ---

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
