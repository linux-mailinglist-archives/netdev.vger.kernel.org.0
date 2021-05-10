Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1E3A379817
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 22:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbhEJUDx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 16:03:53 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33640 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230170AbhEJUDw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 May 2021 16:03:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=bJVPp8Oq76w+IrO5IiCTQeRbtmZHcczJWi97wQoWyQs=; b=adcZzuq65bieyZdrPS+QJAGZE1
        2edNmy2XxL+twllMKz2Yvm1g+7WDvevFz4h/sXNDn5VQjz8CSw5qeSFVCsW6UfcyXUh9cmHK1TpVd
        wkoWn3EPNx1sxUuQ1GcAJBQSfy8mpX9c/xAPNCYjjzmlhLHKaZKNIczdjOajMT1FsWFw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lgC6j-003d4I-Rb; Mon, 10 May 2021 22:02:25 +0200
Date:   Mon, 10 May 2021 22:02:25 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Zhen Lei <thunder.leizhen@huawei.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        b43-dev <b43-dev@lists.infradead.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/1] b43: phy_n: Delete some useless empty code
Message-ID: <YJmRUQwPPDE+hWiN@lunn.ch>
References: <20210510145117.4066-1-thunder.leizhen@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210510145117.4066-1-thunder.leizhen@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 10, 2021 at 10:51:17PM +0800, Zhen Lei wrote:
> These TODO empty code are added by
> commit 9442e5b58edb ("b43: N-PHY: partly implement SPUR workaround"). It's
> been more than a decade now. I don't think anyone who wants to perfect
> this workaround can follow this TODO tip exactly. Instead, it limits them
> to new thinking. Remove it will be better.
> 
> No functional change.

No function change, apart from the new warning?

Does your bot to compile the change and look for new warnings/errors?

     Andrew
