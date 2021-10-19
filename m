Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 687AA433C61
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 18:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233961AbhJSQhS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 12:37:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:57606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234398AbhJSQhC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 12:37:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 420F96103B;
        Tue, 19 Oct 2021 16:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634661287;
        bh=kzPs/DWVlwgydEODR2VoJTg8ImK2wGJ4wrDakuRWRYE=;
        h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
        b=BPDA9ADs0SysaVUK1fUokPL7mKAXl2N7u52B3P+KbiNSp2Yc6Nj25mbS+1J5gTmuO
         jTjuw6SLHjFrnM73v2Oi74RpIwHtbU41HyoxbhiE113yehykXD9nV60lfaYODPJkG3
         I0LNKRH282k1aQcYIAuAzdLCG+XIRJ2TmAAdj4lxSvbnTm019aw5eBn8ymWb5kd244
         bgT8G7wzJ+fLD3mR2ysr0DA/nZ7mG1ivFVamxpEtvfOUCx3afWYdAKMQ2LOW6xcSSV
         hwaWaQth8k4dEbrIHPTrCruCprET3Dy4NfZttKsG6QndSDtMuZcDsrLxVF9YMG9Ued
         R/KTyxFgTTWNg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20211012155542.827631-1-atenart@kernel.org>
References: <20211012155542.827631-1-atenart@kernel.org>
Subject: Re: [RFC net-next] net: sysctl data could be in .bss
From:   Antoine Tenart <atenart@kernel.org>
Cc:     jonathon.reinhart@gmail.com, netdev@vger.kernel.org
To:     davem@davemloft.net, kuba@kernel.org
Message-ID: <163466128470.990901.10474363636661625269@kwain>
Date:   Tue, 19 Oct 2021 18:34:44 +0200
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Antoine Tenart (2021-10-12 17:55:42)
>=20
> This is sent as an RFC as I'd like a fix[1] to be merged before to
> avoid introducing a new warning. But this can be reviewed in the
> meantime.
>=20
> I'm not sending this as a fix to avoid possible new warnings in stable
> kernels. (The actual fixes of sysctl files should go).
>=20
> [1] https://lore.kernel.org/all/20211012145437.754391-1-atenart@kernel.or=
g/T/

The related fix[1] was merged in the nf tree. It's not in net-next yet
and I'm not sure it'll have a chance to get there before the merge
window, but I don't think this matter much (there is no real dependency
between the two, except for avoiding to introduce a runtime warning).
I'll submit this formally.

Antoine
