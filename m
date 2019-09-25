Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C079BBDA4C
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 10:54:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731199AbfIYIx6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 04:53:58 -0400
Received: from mail.toke.dk ([52.28.52.200]:39823 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731534AbfIYIxq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Sep 2019 04:53:46 -0400
X-Greylist: delayed 446 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Sep 2019 04:53:41 EDT
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1569401168; bh=hdI2/8m1XWzYalolj8xZHSopkUVGhtQLUm6AD7C/6rE=;
        h=From:To:Subject:In-Reply-To:References:Date:From;
        b=lnGCwqPn8Xik4+dABeuye2OpcKR61gBj+tf2azZZoiepMCvLys5acy3IEAA+CySH2
         XpGvTv765iKAnzYQNUpf7Y00XFwVyGsUT3ShOReN/2rArjEsMh8kVdmUJaheeNA1Mw
         A8fSIQHBrNUzDQv6bAp2GpCkb/BFUB+646giQysI2lnfync3zPBY7ptF2QJpBStDF9
         c3Q4bwZw+CxdwrDkgOEvUpbi226xIFGNwDtCu+HCOGojbt8uZVyJx9lIwnUMXa59CM
         ikhH6E/y8/5YSbpJvWH3rya/lMZkr25jE3h7vDFC6/NaiaBhJubkJEM0MOqhlMJ26T
         KZU470eZglgHQ==
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: WireGuard to port to existing Crypto API
In-Reply-To: <CAHmME9pmfZAp5zd9BDLFc2fWUhtzZcjYZc2atTPTyNFFmEdHLg@mail.gmail.com>
References: <CAHmME9pmfZAp5zd9BDLFc2fWUhtzZcjYZc2atTPTyNFFmEdHLg@mail.gmail.com>
Date:   Wed, 25 Sep 2019 10:46:08 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87v9tg3grz.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Jason A. Donenfeld" <Jason@zx2c4.com> writes:

> Hi folks,
>
> I'm at the Kernel Recipes conference now and got a chance to talk with
> DaveM a bit about WireGuard upstreaming. His viewpoint has recently
> solidified: in order to go upstream, WireGuard must port to the
> existing crypto API, and handle the Zinc project separately. As DaveM
> is the upstream network tree maintainer, his opinion is quite
> instructive.
>
> I've long resisted the idea of porting to the existing crypto API,
> because I think there are serious problems with it, in terms of
> primitives, API, performance, and overall safety. I didn't want to
> ship WireGuard in a form that I thought was sub-optimal from a
> security perspective, since WireGuard is a security-focused project.
>
> But it seems like with or without us, WireGuard will get ported to the
> existing crypto API. So it's probably better that we just fully
> embrace it, and afterwards work evolutionarily to get Zinc into Linux
> piecemeal. I've ported WireGuard already several times as a PoC to the
> API and have a decent idea of the ways it can go wrong and generally
> how to do it in the least-bad way.
>
> I realize this kind of compromise might come as a disappointment for
> some folks. But it's probably better that as a project we remain
> intimately involved with our Linux kernel users and the security of
> the implementation, rather than slinking away in protest because we
> couldn't get it all in at once. So we'll work with upstream, port to
> the crypto API, and get the process moving again. We'll pick up the
> Zinc work after that's done.

On the contrary, kudos on taking the pragmatic route! Much as I have
enjoyed watching your efforts on Zinc, I always thought it was a shame
it had to hold back the upstreaming of WireGuard. So as far as I'm
concerned, doing that separately sounds like the right approach at this
point, and I'll look forward to seeing the patches land :)

-Toke
