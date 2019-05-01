Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03851107F1
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 14:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726407AbfEAMhz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 08:37:55 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50911 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725971AbfEAMhz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 May 2019 08:37:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=m0uIUv9YcB2rBMJ6vazLEXNKZm0mfkTXXnCh6q5+fEc=; b=gWkzZcyE8qpTPXGdKfBs5Ya1+d
        UYiAlBNAbGOCKKSiMeBpBQ8xvKq6cIWlaa7gKMIaeDYWGFGQMaMdioCOJkYfnMCs/YVIUPsz8CaCG
        Q4YTmOc9Jw+g76NvIdEjmrGYFKmzTEfr+ubOG8iTZwnP1KqNH0QQHi5c1DI9K+JF9DVQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hLoUg-0002l7-JG; Wed, 01 May 2019 14:37:50 +0200
Date:   Wed, 1 May 2019 14:37:50 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Peng Li <lipeng321@huawei.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@huawei.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com
Subject: Re: [PATCH net-next 1/3] net: hns3: add support for multiple media
 type
Message-ID: <20190501123750.GA9844@lunn.ch>
References: <1556679944-100941-1-git-send-email-lipeng321@huawei.com>
 <1556679944-100941-2-git-send-email-lipeng321@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1556679944-100941-2-git-send-email-lipeng321@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 01, 2019 at 11:05:42AM +0800, Peng Li wrote:
> From: Jian Shen <shenjian15@huawei.com>
> 
> Previously, we can only identify copper and fiber type, the
> supported link modes of port information are always showing
> SR type. This patch adds support for multiple media types,
> include SR, LR CR, KR. Driver needs to query the media type
> from firmware periodicly, and updates the port information.
> 
> The new port information looks like this:
> Settings for eth0:
>         Supported ports: [ FIBRE ]
>         Supported link modes:   25000baseCR/Full
>                                 25000baseSR/Full
>                                 1000baseX/Full
>                                 10000baseCR/Full
>                                 10000baseSR/Full
>                                 10000baseLR/Full
>         Supported pause frame use: Symmetric
>         Supports auto-negotiation: No
>         Supported FEC modes: None BaseR
>         Advertised link modes:  25000baseCR/Full
>                                 25000baseSR/Full
>                                 1000baseX/Full
>                                 10000baseCR/Full
>                                 10000baseSR/Full
>                                 10000baseLR/Full

Hi Peng

If it does not support auto-negotiation, do these advertised link
modes make any sense? Does it really advertise, or is it all fixed
configured?

	Andrew
