Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD89F2ECE
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 14:04:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388820AbfKGNEM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 08:04:12 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:54170 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388574AbfKGNEL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Nov 2019 08:04:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=gbf7zk8dhXAY3xkboojvSWk46awthw6w/BOzWbnO/Wo=; b=2jIJhSPm9hSY114D0x3CpEFxYt
        pkQ+J8TMddqP97vJmKKNT7oAtgjSCra7S5KxUW2wt6AsBP4eQxE22AU1YY18GLHstCgA/G9yi7NHL
        04iiHB32RJ3MLXct7cCmwCstOYWxC0OZ92s1QPxOy6PxajN4tqQ9tqoe9TPmsaXxbCPg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iShSB-00065k-O8; Thu, 07 Nov 2019 14:03:59 +0100
Date:   Thu, 7 Nov 2019 14:03:59 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Christophe Roullier <christophe.roullier@st.com>
Cc:     robh@kernel.org, davem@davemloft.net, joabreu@synopsys.com,
        mark.rutland@arm.com, mcoquelin.stm32@gmail.com,
        alexandre.torgue@st.com, peppe.cavallaro@st.com,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org
Subject: Re: [PATCH V4 net-next 1/4] net: ethernet: stmmac: Add support for
 syscfg clock
Message-ID: <20191107130359.GD22978@lunn.ch>
References: <20191107084757.17910-1-christophe.roullier@st.com>
 <20191107084757.17910-2-christophe.roullier@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107084757.17910-2-christophe.roullier@st.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 07, 2019 at 09:47:54AM +0100, Christophe Roullier wrote:
> Add optional support for syscfg clock in dwmac-stm32.c
> Now Syscfg clock is activated automatically when syscfg
> registers are used
> 
> Signed-off-by: Christophe Roullier <christophe.roullier@st.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
