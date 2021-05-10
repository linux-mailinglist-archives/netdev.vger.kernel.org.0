Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3619379807
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 21:53:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231667AbhEJTyT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 15:54:19 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33598 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230342AbhEJTyF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 May 2021 15:54:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=jMrkWSl6+Edrxsk1kWvz7BBj9etcXkiLlCz/mhjTDF0=; b=ETWWiwsPlmW/JfaaEad68aqKI4
        tfwDU79iIuec8TIqD8LE/0q65Yx74mHiiGHcwIl/mVkIIR1BSbiqf9jnw8PomKYJLZfoKTKieHy4c
        XGzh043zJfgI81i0XX0Vfi6ZgViTx1ZVhHq4T8Mvjxh5Q1IxqJfUfZjsycHYzpB8wPSs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lgBxG-003cxK-Tl; Mon, 10 May 2021 21:52:38 +0200
Date:   Mon, 10 May 2021 21:52:38 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Zhu Yanjun <zyjzyj2000@gmail.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Rain River <rain.1986.08.12@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/1] forcedeth: Delete a redundant condition branch
Message-ID: <YJmPBjsKK2MTxlyA@lunn.ch>
References: <20210510135656.3960-1-thunder.leizhen@huawei.com>
 <CAD=hENe9A-dbq8FGoCS=0_RV6qMmE8irb4crKjnLrSyc1orFCA@mail.gmail.com>
 <20210510113124.414f3924@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210510113124.414f3924@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> This patch (and the stmmac one) removes a branch based on the fact that
> it's the same as the default / catch all case. It's has a net negative
> effect on the reability of the code since now not all cases are
> explicitly enumerated. But it's at least the 3rd time we got that
> stmmac patch so perhaps not worth fighting the bots...

Hi Jakub

Is it the same bot every time? Or are the masters of the bots learning
what good code actually looks like and fixing their bots? Unless we
push back, the bot masters are not going to get any better at managing
their bots.

    Andrew
