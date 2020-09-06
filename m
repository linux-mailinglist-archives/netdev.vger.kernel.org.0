Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 663E525EF5E
	for <lists+netdev@lfdr.de>; Sun,  6 Sep 2020 19:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbgIFRbG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Sep 2020 13:31:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:33308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725816AbgIFRbE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Sep 2020 13:31:04 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4ED3C20738;
        Sun,  6 Sep 2020 17:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599413464;
        bh=MqVcRlfk0qDq54++QFCj/b1YOz+RcgNx3eCRs/sKyvo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oOr11OP7O423lEKVgPJSFFTOZq5OjkNtcMstO2LvuB72CIuuG/NnPQmJUGsZN0ubt
         PFTMTEElus+m4vf20KwkjAZXdCPcGSmzq6hyL6YpfGH1UWzahEX/D1HQ6l6BBxq9X4
         lbdm5WQDoKn31kW5Gz1sc2PGwVvJ6FYkzssvvOhw=
Date:   Sun, 6 Sep 2020 10:31:02 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH] net: dsa: rtl8366rb: Support setting MTU
Message-ID: <20200906103102.735c2e93@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <8c5a87e1-a8db-3a48-8311-cf6537723de4@gmail.com>
References: <20200905215914.77640-1-linus.walleij@linaro.org>
        <8c5a87e1-a8db-3a48-8311-cf6537723de4@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 5 Sep 2020 18:58:08 -0700 Florian Fainelli wrote:
> On 9/5/2020 2:59 PM, Linus Walleij wrote:
> > This implements the missing MTU setting for the RTL8366RB
> > switch.
> > 
> > Apart from supporting jumboframes, this rids us of annoying
> > boot messages like this:
> > realtek-smi switch: nonfatal error -95 setting MTU on port 0
> > 
> > Signed-off-by: Linus Walleij <linus.walleij@linaro.org>  
> 
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Applied, thanks!
