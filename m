Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 295772A7D17
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 12:34:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730073AbgKELcE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 06:32:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:53490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729898AbgKELa6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Nov 2020 06:30:58 -0500
Received: from localhost (otava-0257.koleje.cuni.cz [78.128.181.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C0B32078E;
        Thu,  5 Nov 2020 11:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604575857;
        bh=Dxd/asuG1ffxD38m+faQ2D4wqGfZEZQQ/iK88SC6Vgw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RuUqKC6ALvHpg5g/xQ+Ff2j1vo5BlQDeHcKnmMHuDGGZXP76xIeJ9k6cXVTXNLYLD
         9QX0GPbw2eYrNmMAm2KlDegUoCrLdR13v+rmerXMdwylI3ENeYH1OvU3JhHjjq4lGe
         hkt2hXzrZ8O8onQz8m7gIiJqOilzosJd95iPf+gw=
Date:   Thu, 5 Nov 2020 12:30:43 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Hayes Wang <hayeswang@realtek.com>
Subject: Re: [PATCH net-next 3/5] r8152: add MCU typed read/write functions
Message-ID: <20201105123043.3b114bec@kernel.org>
In-Reply-To: <20201105105642.pgdxxlytpindj5fq@skbuf>
References: <20201103192226.2455-4-kabel@kernel.org>
        <20201103214712.dzwpkj6d5val6536@skbuf>
        <20201104065524.36a85743@kernel.org>
        <20201104084710.wr3eq4orjspwqvss@skbuf>
        <20201104112511.78643f6e@kernel.org>
        <20201104113545.0428f3fe@kernel.org>
        <20201104110059.whkku3zlck6spnzj@skbuf>
        <20201104121053.44fae8c7@kernel.org>
        <20201104121424.th4v6b3ucjhro5d3@skbuf>
        <20201105105418.555d6e54@kernel.org>
        <20201105105642.pgdxxlytpindj5fq@skbuf>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 5 Nov 2020 12:56:42 +0200
Vladimir Oltean <olteanv@gmail.com> wrote:

> On Thu, Nov 05, 2020 at 10:54:18AM +0100, Marek Beh=C3=BAn wrote:
> > I thought that static inline functions are preferred to macros, since
> > compiler warns better if they are used incorrectly... =20
>=20
> Citation needed.

Just search for substring "instead of macro" in git log, there are
multiple such changes that were accepted since it provides better
typechecking. I am not saying it is documented anywhere, just that I
thought it was preffered.

> Also, how do static inline functions wrapped in macros
> (i.e. your patch) stack up against your claim about better warnings?

If they are defined as functions (they don't have to be inline,
of course) instead of macros and they are used incorrectly, the compiler
provides more readable warnings. (Yes, in current versions of gcc it is
much better than in the past, but still there are more lines of
warnings printed: "in expansion of macro"...).


> I guess ease of maintainership should prevail here, and Hayes should
> have the final word. I don't really have any stake here.

Vladimir, your arguments are valid and I accept the reasoning.
I too can see that the resulting code is a little awkward.

Marek


