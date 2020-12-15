Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C8DC2DA6BD
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 04:24:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727102AbgLODX4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 22:23:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:44882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726883AbgLODXo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Dec 2020 22:23:44 -0500
Date:   Mon, 14 Dec 2020 19:23:03 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608002584;
        bh=+EZRYS4aFLmrPikE8qjt9KpGXsnXxr6gnk0oUwx+/bg=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ec5a8SWXJnnAC5kMecD8fHM8+bfqpQEd8Nxu7kNEIX8l+fvxOhSlQ2c4rmKXAGxm5
         f1IacPtOdQlAjGA3A5toPhgPtoddeTyH5u5uXfwyMN83UU6FeLcawiMmm95Uz/priq
         WDuIKVduz1WIXuLPaog+hKM4qkzxBTCnd2yKfov3YYoHX8l6R78knEM6bFF3d4ITxi
         JUdgBjpwZ7irvJM5Gx5KRKMbCyDqU0d5V6frfc6iQrDgaiYMVIEt+QIaBICQZzNMeB
         +LuBk/8IEZCfp86pEp0hz6a3ttxMCASiLNdF4yKNjUBB6rGwIY+7e1BjfC7PoAYg/e
         pgag/xiMMrmVA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Geoff Levand <geoff@infradead.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Evgeniy Polyakov <zbr@ioremap.net>, netdev@vger.kernel.org
Subject: Re: [PATCH] net/connector: Add const qualifier to cb_id
Message-ID: <20201214192303.32a38c7a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <71249d9e-ab8e-ee81-0ea2-6533e6126c5b@infradead.org>
References: <71249d9e-ab8e-ee81-0ea2-6533e6126c5b@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 12 Dec 2020 18:47:01 -0800 Geoff Levand wrote:
> The connector driver never modifies any cb_id passed to it, so add a const
> qualifier to those arguments so callers can declare their struct cb_id as=
 a
> constant object.
>=20
> Fixes build warnings like these when passing a constant struct cb_id:
>=20
>   warning: passing argument 1 of =E2=80=98cn_add_callback=E2=80=99 discar=
ds =E2=80=98const=E2=80=99 qualifier from pointer target
>=20
> Signed-off-by: Geoff Levand <geoff@infradead.org>

This does not apply to net-next. Please rebase against:

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/
