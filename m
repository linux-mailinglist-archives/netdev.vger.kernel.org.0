Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A864A197E65
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 16:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbgC3Oam (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 10:30:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:54416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725268AbgC3Oam (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Mar 2020 10:30:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99DB5206CC;
        Mon, 30 Mar 2020 14:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585578642;
        bh=ygF7scOjU6Oni4bU79VbLdNq26gBvmSZ1JDfQ9Vyk3E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=c7d8qBT7bThPDe1GaIm5Kri/k2Mxx7ZP+CPIs3gQ+J1mEzxjIjmpfLnivS4+gTNqT
         eICYm68ebxI8okxdLhC5cJfrRgJ79PmIdm6kEDZOscp9/OXxCiTmFf/TdCxhycs5HY
         VI0yBPqQySQCqiF5JeX20XdFyZEkbhJp3SUZ2v+I=
Date:   Mon, 30 Mar 2020 16:30:38 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     David Miller <davem@davemloft.net>, nic_swsd@realtek.com,
        cwhuang@android-x86.org, netdev@vger.kernel.org
Subject: Re: issue with 85a19b0e31e2 on 4.19 -> revert
Message-ID: <20200330143038.GA449036@kroah.com>
References: <40373530-6d40-4358-df58-13622a4512c2@gmail.com>
 <20200327.155753.1558332088898122758.davem@davemloft.net>
 <d2a7f1f1-cf74-ab63-3361-6adc0576aa89@gmail.com>
 <20200327.162400.1906897622883505835.davem@davemloft.net>
 <05d53fd2-f210-1963-96d1-2dc3d0a3a8c7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <05d53fd2-f210-1963-96d1-2dc3d0a3a8c7@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 28, 2020 at 10:52:19AM +0100, Heiner Kallweit wrote:
> On 28.03.2020 00:24, David Miller wrote:
> > From: Heiner Kallweit <hkallweit1@gmail.com>
> > Date: Sat, 28 Mar 2020 00:10:57 +0100
> > 
> >> Somehow that change made it to -stable. See e.g. commit
> >> 85a19b0e31e256e77fd4124804b9cec10619de5e for 4.19.
> > 
> > This is a serious issue in that it seems that the people maintaining
> > the older stable release integrate arbitrary patches even if they
> > haven't been sent to v5.4 and v5.5
> > 
> > And I don't handle -stable backport submissions that far back anyways.
> > 
> > Therefore, I'm not going to participate in that ongoing problem, so
> > feel free to contact the folks who integrated those changes into
> > -stable and ask them to revert.
> > 
> > Thanks.
> > 
> Greg,
> 
> commit 85a19b0e31e2 ("r8169: check that Realtek PHY driver module is loaded")
> made it accidentally to 4.19 and causes an issue with Android/x86.
> Could you please revert it?

Now reverted.  Should I also drop this from 5.4.y and 5.5.y?

thanks,

greg k-h
