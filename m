Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8594E28A205
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 00:53:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388276AbgJJWxm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 18:53:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:47904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730251AbgJJSr2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 10 Oct 2020 14:47:28 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F18C9224DF;
        Sat, 10 Oct 2020 18:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602354964;
        bh=zgUFLbA2jj6kOZHMxdsU4mAO1xn9wPziDEYTB3p1TOc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=zDfHkE62Wv7k14GNc2ohYhqM9kuqfisctzgOJ3Q1xllPJ7L48punDYBjrH2qjBCUz
         gNNXJdGzTB21bVuEiE+7EwDDQ56PxEdsICmajY/obHDGzdR4jmRcf/Ycycg5ZJQJ62
         7HVpQvG2wzH1IAPhbKCGhA3KFNMVaEPH5z3ByTAQ=
Date:   Sat, 10 Oct 2020 11:36:02 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Subject: Re: [net-next PATCH v4] net: dsa: rtl8366rb: Roof MTU for switch
Message-ID: <20201010113602.49e63312@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <6a92a2f0-70b8-0fc1-d01f-21eb8d68aea2@gmail.com>
References: <20201008210340.75133-1-linus.walleij@linaro.org>
        <6a92a2f0-70b8-0fc1-d01f-21eb8d68aea2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 8 Oct 2020 14:09:13 -0700 Florian Fainelli wrote:
> On 10/8/2020 2:03 PM, Linus Walleij wrote:
> > The MTU setting for this DSA switch is global so we need
> > to keep track of the MTU set for each port, then as soon
> > as any MTU changes, roof the MTU to the biggest common
> > denominator and poke that into the switch MTU setting.
> > 
> > To achieve this we need a per-chip-variant state container
> > for the RTL8366RB to use for the RTL8366RB-specific
> > stuff. Other SMI switches does seem to have per-port
> > MTU setting capabilities.
> > 
> > Fixes: 5f4a8ef384db ("net: dsa: rtl8366rb: Support setting MTU")
> > Signed-off-by: Linus Walleij <linus.walleij@linaro.org>  
> 
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Applied, thanks!
