Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8373120A4
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 01:59:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbhBGA6E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 19:58:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:59884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229683AbhBGA5y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Feb 2021 19:57:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9961C64E8B;
        Sun,  7 Feb 2021 00:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612659434;
        bh=2RKfvxmY71nPWHYwG+9Kb2b+6Ca+t+s+Q+MmSO7aDHQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZVYLhVWkkiAUgT4LMG0nhjOCRn1UyPPPk/LgXCI5QqWnhX7fHDSa8m1D6IsF4rUK0
         9yOKwjoetcH6JogT1FAZ6sFvlg2E3FzEnj/woZbJl6FgIk7rgag8ky0bGIvnx0cZCD
         H+LWybgpg1sDZJHaar2aPqWho9MmgFtKCHtoG0Tkl4rDsau2c2Z8sO1Vu9fmaKUGHG
         vna8IS9KMDG8TzMO4vH+L9ukB/GhM2xfVhbf7NISvEHcfVMzeAmSNt6Z9aIaE5vN3H
         3coAiYNBhz7RQx1pgmd0VN9Q4fd9/G6+U3gtWZK+R/96h582SsqLRrbYNiFCjCdg2S
         8VQXv9c8HwJIg==
Date:   Sat, 6 Feb 2021 16:57:12 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Xie He <xie.he.0141@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        John Ogness <john.ogness@linutronix.de>,
        Tanner Love <tannerlove@google.com>,
        Eyal Birger <eyal.birger@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net/packet: Improve the comment about LL
 header visibility criteria
Message-ID: <20210206165712.69f3281b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CA+FuTScLTZqZhNU7bWEw4OMTQzcKV106iRLwA--La0uH+JrTtg@mail.gmail.com>
References: <20210205224124.21345-1-xie.he.0141@gmail.com>
        <CA+FuTScLTZqZhNU7bWEw4OMTQzcKV106iRLwA--La0uH+JrTtg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 5 Feb 2021 21:51:36 -0500 Willem de Bruijn wrote:
> On Fri, Feb 5, 2021 at 5:42 PM Xie He <xie.he.0141@gmail.com> wrote:
> >
> > The "dev_has_header" function, recently added in
> > commit d549699048b4 ("net/packet: fix packet receive on L3 devices
> > without visible hard header"),
> > is more accurate as criteria for determining whether a device exposes
> > the LL header to upper layers, because in addition to dev->header_ops,
> > it also checks for dev->header_ops->create.
> >
> > When transmitting an skb on a device, dev_hard_header can be called to
> > generate an LL header. dev_hard_header will only generate a header if
> > dev->header_ops->create is present.
> >
> > Signed-off-by: Xie He <xie.he.0141@gmail.com>  
> 
> Acked-by: Willem de Bruijn <willemb@google.com>
> 
> Indeed, existence of dev->header_ops->create is the deciding factor. Thanks Xie.

Applied, thanks!
