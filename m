Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A63313E3B2F
	for <lists+netdev@lfdr.de>; Sun,  8 Aug 2021 17:48:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232168AbhHHPsV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 11:48:21 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38872 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229923AbhHHPsU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 8 Aug 2021 11:48:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=AoMxxYHDUOavE6GBUyRj0Ix+K3KECgaO7h8drwWWxkw=; b=mHjkZSYy6x7IuRJk2nDwYnT5H5
        Lmx9Z/N8BMtixEEtOYp0rI2DSrSuVzicxWkRy2L0FkZgzNW/EpyfQTSlg98ssNIKMCnAYWINAQQWl
        1VrOIcNA9I5UN43KasUEGG48JOIH/jnC+l3wKQcY6R0EgEP28zdEzi5klnnQkxVOA2Uw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mCl1n-00Gar2-HS; Sun, 08 Aug 2021 17:47:55 +0200
Date:   Sun, 8 Aug 2021 17:47:55 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Luo Jie <luoj@codeaurora.org>
Cc:     agross@kernel.org, bjorn.andersson@linaro.org, davem@davemloft.net,
        kuba@kernel.org, robh+dt@kernel.org, robert.marko@sartura.hr,
        linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        sricharan@codeaurora.org
Subject: Re: [PATCH] dt-bindings: net: Add the properties for ipq4019 MDIO
Message-ID: <YQ/8q6gR6Eji2hKD@lunn.ch>
References: <20210808075328.30961-1-luoj@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210808075328.30961-1-luoj@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 08, 2021 at 03:53:28PM +0800, Luo Jie wrote:
> The new added properties resource "reg" is for configuring
> ethernet LDO in the IPQ5018 chipset, the property "clocks"
> is for configuring the MDIO clock source frequency.
> 
> This patch depends on the following patch:
> Commit 2b8951cb4670 ("net: mdio: Add the reset function for IPQ MDIO
> driver")

Please always make binding patches part of the series containing the
driver code. We sometimes need to see both to do a proper review.

Add a comment about when the second address range and clock is
required. Does qcom,ipq5018-mdio require them?

	  Andrew
