Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48F173F3261
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 19:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234483AbhHTRlu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 13:41:50 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:32920 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229940AbhHTRlt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 13:41:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=jQD2OATswpHp4bNzlY3nCz9N+HNVVMddP1vTz/Eobi4=; b=oEIIcNTZ77tkcpIYxVQ7660CA0
        DQ9L9PJCx48VE/0l6QeLOhpsNtXJZbTsh5mQ1rpx/JJRw8JYBt4YyR32H0ZiW6FyzpYfILqqfU1W6
        XiG2m2odoOcWSMB7PEaGLd07gkcvLB1FHehzm9qObvzugwbw3CpTrRbUmWEFv3fdGa9w=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mH8Vr-001CJX-JT; Fri, 20 Aug 2021 19:41:03 +0200
Date:   Fri, 20 Aug 2021 19:41:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Joel Stanley <joel@jms.id.au>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Karol Gugala <kgugala@antmicro.com>,
        Mateusz Holenko <mholenko@antmicro.com>,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] dt-bindings: net: Add bindings for LiteETH
Message-ID: <YR/pLw8EDKJWt8Uw@lunn.ch>
References: <20210820074726.2860425-1-joel@jms.id.au>
 <20210820074726.2860425-2-joel@jms.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210820074726.2860425-2-joel@jms.id.au>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 20, 2021 at 05:17:25PM +0930, Joel Stanley wrote:
> LiteETH is a small footprint and configurable Ethernet core for FPGA
> based system on chips.

Hi Joel

Just an FYI.

DT is considered ABI. Once released, you should not be making changes
which are not backwards compatible.

All the PHY and MDIO properties you are adding here are unused in the
driver. They all look sensible, and you should be able to make it
work. But when you do come to make that implementation, this
definition is the base of what you have to work with.

	   Andrew
