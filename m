Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 530764552BA
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 03:24:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238046AbhKRC1c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 21:27:32 -0500
Received: from out0.migadu.com ([94.23.1.103]:56485 "EHLO out0.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232265AbhKRC1b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 21:27:31 -0500
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1637202271;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1NeQgv3kO7N6HsfCAo95sxicgls2Yy2dg7xo+E7QLo8=;
        b=xas53mhbls0La6IEgl2u4BLcrkLh7W0EoW3JUalH4PdWpzPuqBW7jDfdvLDJK2K14Sj2mR
        dCC0qZvHAdzxt2/IIM8reqg1UeeAOhbcLBMM/pCTOGMzWAoKFlepAhfh+0fjvo16zIWIKk
        i1EY9b4GSpu1LQDWSnmryFdd+XAMPj4=
Date:   Thu, 18 Nov 2021 02:24:30 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   yajun.deng@linux.dev
Message-ID: <b152a438cb03908f390c27e98c2c5ca0@linux.dev>
Subject: Re: [PATCH net-next] neigh: introduce __neigh_confirm() for
 __ipv{4, 6}_confirm_neigh
To:     "Eric Dumazet" <eric.dumazet@gmail.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <8696b472-efee-7801-8480-dd0a5ebf173b@gmail.com>
References: <8696b472-efee-7801-8480-dd0a5ebf173b@gmail.com>
 <20211117120215.30209-1-yajun.deng@linux.dev>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

November 18, 2021 1:36 AM, "Eric Dumazet" <eric.dumazet@gmail.com> wrote:=
=0A=0A> On 11/17/21 4:02 AM, Yajun Deng wrote:=0A> =0A>> Those __ipv4_con=
firm_neigh(), __ipv6_confirm_neigh() and __ipv6_confirm_neigh_stub()=0A>>=
 functions have similar code. introduce __neigh_confirm() for it.=0A> =0A=
> At first glance, this might add an indirect call ?=0A=0AYes, But this n=
eed keep __ipv4_confirm_neigh() the same parameters as __ipv6_confirm_nei=
gh().
