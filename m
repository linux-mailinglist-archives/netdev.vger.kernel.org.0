Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF5F03CEDC9
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 22:31:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387024AbhGSTpW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 15:45:22 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34660 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1385728AbhGSTIa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Jul 2021 15:08:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=MpEyn1pQ8l2HvWMWGEa3AhtkYJDX6GLV9nl0yEUWM14=; b=2s0wrwA8pwvnAuX2PxG+beLmQY
        KpDRKdogrjz2PDRFl6GlhRaEdmMfOI5+R0uQNzQ4pBQsrJdepX6Xg8zlwIG2W68d012YY6c5e2gRB
        cfA3mFDobMR1ySd8gajLhAqvMkJeEIDtSMc0GoHDOmUSmKvwSIiGJDO49od3im9QD/yE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m5ZFc-00DxMj-KL; Mon, 19 Jul 2021 21:48:28 +0200
Date:   Mon, 19 Jul 2021 21:48:28 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Hao Chen <chenhaoa@uniontech.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] net: stmmac: fix 'ethtool -P' return -EBUSY
Message-ID: <YPXXDDcH1Gs2Oek8@lunn.ch>
References: <20210719093207.17343-1-chenhaoa@uniontech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210719093207.17343-1-chenhaoa@uniontech.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 19, 2021 at 05:32:07PM +0800, Hao Chen wrote:
> The permanent mac address should be available for query when the device
> is not up.
> NetworkManager, the system network daemon, uses 'ethtool -P' to obtain
> the permanent address after the kernel start. When the network device
> is not up, it will return the device busy error with 'ethtool -P'. At
> that time, it is unable to access the Internet through the permanent
> address by NetworkManager.
> I think that the '.begin' is not used to check if the device is up.

You forgot to update the commit message.

    Andrew
