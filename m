Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC7430E2BD
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 19:46:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233110AbhBCSpS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 13:45:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:36290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232365AbhBCSpN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 13:45:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5149164F7E;
        Wed,  3 Feb 2021 18:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612377873;
        bh=N2RrjYaui+qhTkl0HUY1pggmTuEFBO/DoqlHSMpVjcw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LAmVVTDXVTotzk1NrIlEjLg/tTlGEAK3NkgABCE41nxFO3/OO69ipxm8P1CPo/eK4
         hdBBgg3rlot9PBt6ub5ICjnfxb6AdD05kg1demRgohGXtaxGDolExWWQ4Jde9gpgUH
         wy82VgPuq+4vMgkHjtp63+hK99An1b7IQ8GfEa0+W1MGtgWpoBxIrCuEwhxaVA5/eq
         Db3LqcnUodJocFYagwSaZD8QY8i8i/8M5kzMhW9cJuaw4xNTtjQP5AlJGjc5XFK5eH
         z/jbNAFRxcvlN64aAZ2+zCiP8tWRgpCnzgmvfcTbF0qe9ubbJTWkmyHstIaA8D+YKC
         aw+PnsTTUqfIQ==
Date:   Wed, 3 Feb 2021 10:44:32 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hariharan Ananthakrishnan <hari@netflix.com>
Cc:     sdf@google.com, Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Brendan Gregg <bgregg@netflix.com>
Subject: Re: [PATCH] net: tracepoint: exposing sk_family in all
 tcp:tracepoints
Message-ID: <20210203104432.46646d23@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAL70W4qyRuHaPGw96sx=XKXLPe9OkhtneF+JU9WaQ1ko25TxRA@mail.gmail.com>
References: <20210129001210.344438-1-hari@netflix.com>
        <20210201140614.5d73ede0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CANn89i+ZggZvj_bEo7Jd+Ac=kiE9SZGxJ7JQ=NVTHCkM97jE6g@mail.gmail.com>
        <YBrOnJvBGKi0aa7G@google.com>
        <20210203101622.05539541@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAL70W4qyRuHaPGw96sx=XKXLPe9OkhtneF+JU9WaQ1ko25TxRA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 3 Feb 2021 10:25:11 -0800 Hariharan Ananthakrishnan wrote:
> On Wed, Feb 3, 2021 at 10:16 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Wed, 3 Feb 2021 08:26:04 -0800 sdf@google.com wrote:  
> > > They are not ABI and since we are extending tracepoints with additional
> > > info (and not removing any existing fields) it shouldn't be a problem.  
> >
> > Okay, but we should perhaps add the field at the end just to be on the
> > safe side (and avoid weird alignment of the IP addresses).  
> I added it after dport to be consistent with the earlier patch to
> sock:inet_sock_set_state
> https://lore.kernel.org/patchwork/patch/870492/.

I see :(

I'll give it a few more hours and if there are no objections apply the
patch.
