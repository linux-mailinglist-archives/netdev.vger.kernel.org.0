Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B50A73208F8
	for <lists+netdev@lfdr.de>; Sun, 21 Feb 2021 07:40:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbhBUGk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Feb 2021 01:40:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:49266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229479AbhBUGkP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Feb 2021 01:40:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B0B864EE9;
        Sun, 21 Feb 2021 06:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613889575;
        bh=30oNEZb8PQcT0GiuTwiFEqcUx3BwhXK5+Nl0tiOURWg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oAlkzfZihU/RdvMLXzOyLJdhdWp+JpZgwTybDlrln5hMaOQb8qDbUYkx3v4JoeMBG
         /xrcOAXgSvPC38SeDYqxmDATOwj7RZwzlOqx6vo9vmGW32QXQWmA+G08DwXcYhAtlP
         iFP8muSdFRVcozozut90ergekY2iY/Ef6KLDKTbImM/zio+fvWIQks9zHdf2x4GDZ0
         FhxzSVl1ZMklsOB+RYFJBEZR41ueWbeaVHNYQgtlmR15JzFi8/kXnaM2Lv5Aj1rln+
         9erTXW1vTxvOICl2fkkqDZhUK8O4qOqAZDP3/uIDMvbYFQ6L/HA0JM3wtGq/BG/tGm
         sjkiJNbMRYKvg==
Date:   Sun, 21 Feb 2021 08:39:31 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Xie He <xie.he.0141@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Martin Schiller <ms@dev.tdt.de>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: Re: [PATCH net-next RFC v4] net: hdlc_x25: Queue outgoing LAPB frames
Message-ID: <YDIAIwLVQK0P4EQW@unreal>
References: <20210216201813.60394-1-xie.he.0141@gmail.com>
 <YC4sB9OCl5mm3JAw@unreal>
 <CAJht_EN2ZO8r-dpou5M4kkg3o3J5mHvM7NdjS8nigRCGyih7mg@mail.gmail.com>
 <YC5DVTHHd6OOs459@unreal>
 <CAJht_EOhu+Wsv91yDS5dEt+YgSmGsBnkz=igeTLibenAgR=Tew@mail.gmail.com>
 <YC7GHgYfGmL2wVRR@unreal>
 <CAJht_EPZ7rVFd-XD6EQD2VJTDtmZZv0HuZvii+7=yhFgVz68VQ@mail.gmail.com>
 <CAJht_EPPMhB0JTtjWtMcGbRYNiZwJeMLWSC5hS6WhWuw5FgZtg@mail.gmail.com>
 <20210219103948.6644e61f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAJht_EOru3pW6AHN4QVjiaERpLSfg-0G0ZEaqU_hkhX1acv0HQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJht_EOru3pW6AHN4QVjiaERpLSfg-0G0ZEaqU_hkhX1acv0HQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 19, 2021 at 12:28:12PM -0800, Xie He wrote:
> On Fri, Feb 19, 2021 at 10:39 AM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > Not entirely sure what the argument is about but adding constants would
> > certainly help.
>
> Leon wants me to replace this:
>
> dev->needed_headroom = 3 - 1;
>
> with this:
>

Leon wants this line to be written good enough:

> /* 2 is the result of 3 - 1 */

And this line like you wrote here:

> dev->needed_headroom = 2;


<...>

> Yes, this patch will break backward compatibility. Users with old
> scripts will find them no longer working.

Did you search in debian/fedora code repositories to see if such scripts exist
as part of any distro package?

Thanks
