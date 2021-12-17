Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B76214786F9
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 10:21:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234081AbhLQJVe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 04:21:34 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:59818 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234055AbhLQJVd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 04:21:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=lmmVZodH+XHI9GDoiWHcr0IkTJwRbmnhN5h+KNSpVpk=; b=BK
        r1KVsosIdBw72VbeyknR6azh2mx+mr+Cbb/lFw6eSzntXZ52HlitBEb8RYR20Q44WNtH0GlbYPI9Y
        TaDiUnS7+hnJ3tmBtxu/NCmvNW9pKOqibtaS6nT70T4uC+xIE5R70e8U/yMyLYLZ9rkWAZ0a0u1vb
        Vh1GICp+yeaubws=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1my9Qf-00GofP-3D; Fri, 17 Dec 2021 10:21:29 +0100
Date:   Fri, 17 Dec 2021 10:21:29 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alvin =?utf-8?Q?=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     "luizluca@gmail.com" <luizluca@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>
Subject: Re: [PATCH net-next 03/13] net: dsa: realtek: rename realtek_smi to
 realtek_priv
Message-ID: <YbxWmbwrkSvuN4BZ@lunn.ch>
References: <20211216201342.25587-1-luizluca@gmail.com>
 <20211216201342.25587-4-luizluca@gmail.com>
 <4a95c493-5ea3-5f2d-b57a-70674b10a7f0@bang-olufsen.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4a95c493-5ea3-5f2d-b57a-70674b10a7f0@bang-olufsen.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 16, 2021 at 11:22:33PM +0000, Alvin Šipraga wrote:
> Hi Luiz,
> 
> On 12/16/21 21:13, luizluca@gmail.com wrote:
> > From: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> > 
> > In preparation to adding other interfaces, the private data structure
> > was renamed to priv. Also the only two direct calls from subdrivers
> > to realtek-smi lib were converted into references inside priv.
> 
> Maybe split this patch to separate the churn from the more interesting 
> change, which I guess is needed to support different bus types for the 
> subdrivers.
> 
> See some comments inline below, related to that latter change.

Hi Alvin

Thanks for reviewing the patches.

Please could you trim the email when replying. Just include enough of
the original email to give context. Sometimes comments gets missed
because of the continual page down, page down, page down....

Thanks
	Andrew
