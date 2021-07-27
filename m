Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0AF23D77CA
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 16:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236667AbhG0OEA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 10:04:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:53244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232136AbhG0OD6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 10:03:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4FDEB61ACE;
        Tue, 27 Jul 2021 14:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627394639;
        bh=hvmgiIrjMv/JCWhCiep8K7mnYMmbjoa9Qy4QYVzHEvw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FlMzhVJ93qJbwPIQnoHMpAvO3U1ffzfqDSdUmOOrqIFzROgJMmLb04b1jvmz3lDln
         YY1zxeUKUgZML2Rpwjw80sTr5C/c/LBWnFLSh5VDd02gUu0a5kH50Nua+k9SQg04Lk
         ay8ry2UnL6nAMuhekQQt51b4M8pea5RWqndJL8a3vLLn17nCv2ufKQf88BdCqvBaGB
         wvl69osZOd4WIHucUDpwewjNhYVOIQo72Ew+4+Oy0uaB7bYEyFL0y9XNS7Nxxn8JtK
         QrJTzuU7W5S7N8tQxQtQJP1i0ylpPOkgxQtnrUNNYE7lD33RhBWG6tkxsyGRnp9BmE
         CFXUzBagMGa2Q==
Date:   Tue, 27 Jul 2021 17:03:55 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/4] net: ipa: kill IPA_VALIDATION
Message-ID: <YQASS66VLBx6bKoB@unreal>
References: <20210726174010.396765-1-elder@linaro.org>
 <YP/rFwvIHOvIwMNO@unreal>
 <5b97f7b1-f65f-617e-61b4-2fdc5f08bc3e@linaro.org>
 <YQACaxKhxDFZSCF3@unreal>
 <07765bd2-eade-ee52-fa18-56f2e573461a@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <07765bd2-eade-ee52-fa18-56f2e573461a@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 27, 2021 at 08:40:42AM -0500, Alex Elder wrote:
> On 7/27/21 7:56 AM, Leon Romanovsky wrote:
> > > In any case I take your point.  I will now add to my task list
> > > a review of these spots.  I'd like to be sure an error message
> > > *is*  reported at an appropriate level up the chain of callers so
> > > I can always identify the culprit in the a WARN_ON() fires (even
> > > though it should never
> > >   happen).  And in each case I'll evaluate
> > > whether returning is better than not.
> > You can, but users don't :). So if it is valid but error flow, that
> > needs user awareness, simply print something to the dmesg with *_err()
> > prints.
> 
> For some reason you seem to care about users.

Yeah, this is my Achilles heel :)

Thanks
