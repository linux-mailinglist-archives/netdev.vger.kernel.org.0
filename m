Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2559C4126A9
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 21:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347725AbhITTSw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 15:18:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:50214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346556AbhITTQw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Sep 2021 15:16:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 415126109E;
        Mon, 20 Sep 2021 19:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632165324;
        bh=NgWYGuW8aQKhfdhD/69amt2tnbkaADFk26vm/M64g/k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jctbjdKF8E8SqzjydPNVwAYBSW7B/cjVeYM5gp1AhwSjFOWq+yobVS1NdpVnyUMZI
         eg0Baiz4NUT9F3cukov80oQH6aa/Te0G4mwPpXoRbhRtZW8GTYS0910sAqR3q144Ll
         M9Xpi8lw4CXqSEGEM6Ir3vLcwn4pfTpoNsVkdb8fkUK6TB7Ik6y3oQ+92XQybKMnZK
         RIqJ/dG4r7eg2YUdo9BKlHJaJeDSdpk8+chYjcD3jTV9QMyWHaHSHZNeTQaKTTPILe
         ya59P5N13j6uTDYrkAJbAhbmi5TUDcmfLVrHtQRq1b2mkj3mEBDMcawmnX2UqkWTnb
         7OXyH9fBYCdOQ==
Date:   Mon, 20 Sep 2021 12:15:23 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Maciej =?UTF-8?B?xbtlbmN6eWtvd3NraQ==?= <zenczykowski@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux NetDev <netdev@vger.kernel.org>,
        Hayes Wang <hayeswang@realtek.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Maciej Zenczykowski <maze@google.com>
Subject: Re: nt: usb: USB_RTL8153_ECM should not default to y
Message-ID: <20210920121523.7da6f53d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAMuHMdUeoVZSkP24Uu7ni3pUf_9uQHsq2Xm3D6dHnzuQLXeOFA@mail.gmail.com>
References: <CANP3RGeaOqxOMwCFKb=3X5EFaXNG+k3N2CfV4YT-8NiY5GW3Tg@mail.gmail.com>
        <20210917114924.2a7bda93@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAMuHMdUeoVZSkP24Uu7ni3pUf_9uQHsq2Xm3D6dHnzuQLXeOFA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 18 Sep 2021 12:53:31 +0200 Geert Uytterhoeven wrote:
> > Yeah.. more context here:
> >
> > https://lore.kernel.org/all/7fd014f2-c9a5-e7ec-f1c6-b3e4bb0f6eb6@samsung.com/
> >
> > default !USB_RTL8152 would be my favorite but that probably doesn't
> > compute in kconfig land. Or perhaps bring back the 'y' but more clearly
> > mark it as a sub-option of CDCETHER? It's hard to blame people for
> > expecting drivers to default to n, we should make it clearer that this
> > is more of a "make driver X support variation Y", 'cause now it sounds
> > like a completely standalone driver from the Kconfig wording. At least
> > to a lay person like myself.  
> 
> If it can be a module (tristate), it must be a separate (sub)driver, right?

Fair point.
