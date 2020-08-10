Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C73A824070A
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 15:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbgHJN4k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 09:56:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:53342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726584AbgHJN4j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Aug 2020 09:56:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EBC1B2078D;
        Mon, 10 Aug 2020 13:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597067799;
        bh=SdnRjVTx+XenxW0mx6UmkUexgdMB8KMdeUjFwmhv2yg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GmhHKG+Sjryr43HZGFUTKyF64RRPiYc5FAw9/8cIHo3kkBMjwdVulsEcYeO9BjFR9
         0eB/ecwLP1aLSHqdyP5XZRAs2wnemDEhF6rSVgnMTdw9pSmFtYSNWu9/eMcE+rzE7F
         KF1P+dHwCz3uAWpbh18BCdePAyIs0LzPHUOe5JWk=
Date:   Mon, 10 Aug 2020 15:56:50 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Izabela Bakollari <izabela.bakollari@gmail.com>
Cc:     nhorman@tuxdriver.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Linux-kernel-mentees] [PATCHv2 net-next] dropwatch: Support
 monitoring of dropped frames
Message-ID: <20200810135650.GA3726113@kroah.com>
References: <20200707171515.110818-1-izabela.bakollari@gmail.com>
 <20200804160908.46193-1-izabela.bakollari@gmail.com>
 <CAC8tkWDuvz3HQDp=Bb-Sfgiks1ETG-j1SMFn6O2nhyzYL5Cc8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAC8tkWDuvz3HQDp=Bb-Sfgiks1ETG-j1SMFn6O2nhyzYL5Cc8Q@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 10, 2020 at 03:39:40PM +0200, Izabela Bakollari wrote:
> I have worked on this feature as part of the Linux Kernel Mentorship
> Program. Your review would really help me in this learning process.

You sent this just a bit less than 1 week ago, and it's the middle of
the kernel merge window, where no maintainer can take any new patches
that are not bugfixes, and they are totally busy with the merge window
issues.

Give people a chance, try resending this after the net-next tree is open
in a few weeks.

thanks,

greg k-h
