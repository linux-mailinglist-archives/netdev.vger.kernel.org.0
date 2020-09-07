Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94A31260537
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 21:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728872AbgIGTkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 15:40:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:60414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728622AbgIGTkO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 15:40:14 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03BF92145D;
        Mon,  7 Sep 2020 19:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599507614;
        bh=QhvzCBDHH6eHS3PHypouoWPEJCGvoQsyCAOApvEh0Xw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=J7nmdgeTLuflMrX4OGTcbuciTYCL7gcdvsiwiwBQcPdGGJmeovnn8QRvhraILvyoh
         Jc/TnUaAVwNlxJSas2aLhXu2XHXLeLc6w6EFO5kBxtXZdk3+N1Vi7JMJAqdBRRrWaI
         1Y6fP9Dd3/YUWvk3qgPavWAY3QTlmqbm0LLQrWlU=
Date:   Mon, 7 Sep 2020 12:40:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH v2] net: dsa: rtl8366rb: Switch to phylink
Message-ID: <20200907124012.5ab33386@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200906212415.99415-1-linus.walleij@linaro.org>
References: <20200906212415.99415-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun,  6 Sep 2020 23:24:15 +0200 Linus Walleij wrote:
> This switches the RTL8366RB over to using phylink callbacks
> instead of .adjust_link(). This is a pretty template
> switchover. All we adjust is the CPU port so that is why
> the code only inspects this port.
> 
> We enhance by adding proper error messages, also disabling
> the CPU port on the way down and moving dev_info() to
> dev_dbg().
> 
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> ChangeLog v1->v2:
> - Fix the function declarations to be static.

Applied, thanks!
