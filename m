Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7D2A2C4B27
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 00:01:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728795AbgKYXBC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 18:01:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:60194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728704AbgKYXBC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Nov 2020 18:01:02 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DFC8B206B5;
        Wed, 25 Nov 2020 23:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606345262;
        bh=99YqQdcdjfCfae4p2QMKn4PmBo0T4qcup05PcVLEHVQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eOHGU62SOeTBr4V0R+9wmLSP80LIr57nZ1J9pHTyv8CghsJxC/ssodKAAmRd3/+Va
         qu5Yl9P/HGElgeidV/apik0umheJi4fGSu340Lhw4KjuGrzsFQulzWjKWYk7HOMKXr
         yLpdeXM3j7jX5rmp5HB2UXRLodzIfQDvEFileah8=
Date:   Wed, 25 Nov 2020 15:01:00 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Thomas Karlsson <thomas.karlsson@paneda.se>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: Hardcoded multicast queue length in macvlan.c driver causes
 poor multicast receive performance
Message-ID: <20201125150100.287ac72a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <956c4fca-2a54-97cb-5b4c-3a286743884b@paneda.se>
References: <485531aec7e243659ee4e3bb7fa2186d@paneda.se>
        <147b704ac1d5426fbaa8617289dad648@paneda.se>
        <20201123143052.1176407d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <b93a6031-f1b4-729d-784b-b1f465d27071@paneda.se>
        <20201125085848.4f330dea@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <4e3c9f30-d43c-54b1-2796-86f38d316ef3@paneda.se>
        <20201125100710.7e766d7e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <956c4fca-2a54-97cb-5b4c-3a286743884b@paneda.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 25 Nov 2020 23:15:39 +0100 Thomas Karlsson wrote:
> >> This is my first time ever attemting a contribution to the kernel so
> >> I'm quite happy to keep it simple like that too :)  
> > 
> > Module params are highly inflexible, we have a general policy not 
> > to accept them in the netdev world.
> 
> I see, although the current define seems even less flexible :)

Just to be clear - the module parameter is a no-go. 
No point discussing it.

> Although, I might not have fully understood the .changelink you suggest.
> Is it via the ip link set ... command? 

Yes.

> Or is there a way to set the parameters in a more "raw" form that
> does not require a patch to iproute2 with parameter parsing, error
> handing, man pages updates, etc. I feel that I'm getting in over my
> head here.

We're here to assist! Netlink takes a little bit of effort 
to comprehend but it's very simple once you get the mechanics!
