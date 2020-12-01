Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A5312CA888
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 17:45:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388362AbgLAQoZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 11:44:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:58644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726485AbgLAQoZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Dec 2020 11:44:25 -0500
Received: from kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE4392076C;
        Tue,  1 Dec 2020 16:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606841021;
        bh=/4jrMcP32LSnKeYZZ/sDmA7PrGEwuYfMoP2zFqrEWqQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PBdLYyjprHBie7dt3VzZZ74KkVrYNi04za5NtcmW0JELfBaJtAPNzNgqoEmBJOjx/
         0Qjg0TtH1Fvc4iAUr9vhzIY0MOIPQ71YTnN5kxa8lyr5MvJlBN5rWn+Yzb3/p7b2qC
         dYb8Nfit6dpWN0szam/xvWgDrOvF2aeBB3r+Ev6A=
Date:   Tue, 1 Dec 2020 08:43:39 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Aleksandr Nogikh <aleksandrnogikh@gmail.com>, fw@strlen.de,
        davem@davemloft.net, johannes@sipsolutions.net,
        edumazet@google.com, andreyknvl@google.com, dvyukov@google.com,
        elver@google.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        willemdebruijn.kernel@gmail.com,
        Aleksandr Nogikh <nogikh@google.com>,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH v5 2/3] net: add kcov handle to skb extensions
Message-ID: <20201201084339.6d4efa5a@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201201073529.GA1473056@shredder.lan>
References: <20201029173620.2121359-1-aleksandrnogikh@gmail.com>
        <20201029173620.2121359-3-aleksandrnogikh@gmail.com>
        <20201121160941.GA485907@shredder.lan>
        <20201130175248.7f0b5309@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <20201201073529.GA1473056@shredder.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 1 Dec 2020 09:35:29 +0200 Ido Schimmel wrote:
> > Looking at the patch from Marco to move back to a field now I'm
> > wondering how you run into this, Ido :D
> > 
> > AFAIU the extension is only added if process as a KCOV handle.
> > 
> > Are you using KCOV?  
> 
> Hi Jakub,
> 
> Yes. We have an internal syzkaller instance where this is enabled. See
> "syz-executor.0" in the trace below.

I see, thanks! The world makes sense again :)
