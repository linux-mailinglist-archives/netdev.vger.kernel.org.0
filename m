Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21A422A5DF1
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 06:55:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728225AbgKDFzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 00:55:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:36074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725535AbgKDFzj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 00:55:39 -0500
Received: from localhost (otava-0257.koleje.cuni.cz [78.128.181.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB84522277;
        Wed,  4 Nov 2020 05:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604469338;
        bh=ulrctn58nWpOeI9G11CI0aD9F6DLafz43fc2b6CeGJ8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=p2yghxSUeToQZQRRZg4CzEx7NlLykMgZEsD8WQwz/Nzges87T45tu/oMf55j465Ew
         o43yF1YqQsLfQXNJonwoaX9t04F8BK/95SwlU9NjXUelL8cPL19/HWk3sp9b2fCETv
         94ji4hztnCawNs+6B9f5t9oSwv2Jzl0hPMVS2Y3Y=
Date:   Wed, 4 Nov 2020 06:55:24 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Hayes Wang <hayeswang@realtek.com>
Subject: Re: [PATCH net-next 3/5] r8152: add MCU typed read/write functions
Message-ID: <20201104065524.36a85743@kernel.org>
In-Reply-To: <20201103214712.dzwpkj6d5val6536@skbuf>
References: <20201103192226.2455-1-kabel@kernel.org>
        <20201103192226.2455-4-kabel@kernel.org>
        <20201103214712.dzwpkj6d5val6536@skbuf>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 3 Nov 2020 23:47:12 +0200
Vladimir Oltean <olteanv@gmail.com> wrote:

> On Tue, Nov 03, 2020 at 08:22:24PM +0100, Marek Beh=C3=BAn wrote:
> > Add pla_ and usb_ prefixed versions of ocp_read_* and ocp_write_*
> > functions. This saves us from always writing MCU_TYPE_PLA/MCU_TYPE_USB
> > as parameter.
> >=20
> > Signed-off-by: Marek Beh=C3=BAn <kabel@kernel.org>
> > --- =20
>=20
> You just made it harder for everyone to follow the code through pattern
> matching. Token concatenation should be banned from the C preprocessor.

So you aren't complaining about the definition of pla_ and usb_
functions, just that they are defined via macros?
