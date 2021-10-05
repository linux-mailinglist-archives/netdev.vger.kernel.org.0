Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 859B7422B81
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 16:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235569AbhJEOxb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 10:53:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:58562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235090AbhJEOxY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 10:53:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E497961216;
        Tue,  5 Oct 2021 14:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633445494;
        bh=H4au8cRKsKlT2WzVzVUciC3U/eOkaJQmybq+e0GbWOk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SnE2WI3jxMf2cz6uVcQbgGBPvXjU9qHKP+8K8GW5RPHi2epco2Ye2/6d3CLfCUkZN
         cAaHPnBU5yEkfCF1xOVevl0+MutHaG7tOIMvxzxDiwQCWHHDEqPa8r5nmBKlB7Oe/i
         P5GoMkXSagskClxL7bUlIRTugUuNlrWByg92P5O1v7twzlFFD1CA7Vx5sfd0v2x84q
         eFYbHfcRRF/2a1mlVfg8z4TDra3zYn/7o8wSNPaaqocDWu8xzubBklQw5sNZFnVv0P
         nAUrC+M4z1Z0yS8XcHdMFP+0kbVcrAXb7eAzhAJK3+lBJEQIvwP/CQzlosVKdc0Mg9
         lVdwI8p+pnBYg==
Date:   Tue, 5 Oct 2021 07:51:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Subject: Re: pull request: bluetooth 2021-10-04
Message-ID: <20211005075133.38a31995@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CABBYNZKJaD01+o8Tuh7AX7=3Hct_6YqzQcWWzDvOcRpRdPOizQ@mail.gmail.com>
References: <20211004222146.251892-1-luiz.dentz@gmail.com>
        <20211004182158.10df611b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CABBYNZKJaD01+o8Tuh7AX7=3Hct_6YqzQcWWzDvOcRpRdPOizQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 4 Oct 2021 20:47:35 -0700 Luiz Augusto von Dentz wrote:
> On Mon, Oct 4, 2021 at 6:22 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Mon,  4 Oct 2021 15:21:46 -0700 Luiz Augusto von Dentz wrote:  
> > > bluetooth-next pull request for net-next:
> > >
> > >  - Add support for MediaTek MT7922 and MT7921
> > >  - Add support for TP-Link UB500
> > >  - Enable support for AOSP extention in Qualcomm WCN399x and Realtek
> > >    8822C/8852A.
> > >  - Add initial support for link quality and audio/codec offload.
> > >  - Rework of sockets sendmsg to avoid locking issues.
> > >  - Add vhci suspend/resume emulation.  
> >
> > Now it's flipped, it's complaining about Luiz being the committer
> > but there's only a sign off from Marcel :(  
> 
> I did have both sign-off, or are you saying Ive now become the
> committer of other patches as well? Which means whoever rebases the
> tree has to sign-off the entire set as well, I guess other trees does
> better with this because they don't have multiple committer but once
> you have that it is kind hard to maintain this rule of committer must
> sign-off, shouldn't we actually just check if there is one sign-off by
> one of the maintainers that shall be considered acceptable?

I think most trees don't do rebases. The issue does indeed seem to be
that whoever does a rebase becomes the committer, so you need to make
sure that whenever you rebase you add your sign-off to the commits
initially done by other maintainers (in the range of commits that are
being modified).

> Or perhaps there is some documentation on the matter?

I don't think there's any docs.


Since this looks very painful to fix at this point I'll pull as is
from the initial PR from Oct 1st (since it had fewer warnings).

About the content of the PR there is a whole bunch of things here
(fixes, simple device ID additions) which really look like they should
have been targeting net, not net-next.

Okay, enough complaining ;)  

Pulled v1, thanks!
