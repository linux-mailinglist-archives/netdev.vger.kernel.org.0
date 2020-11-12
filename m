Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1AE22AFF12
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 06:44:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728200AbgKLFdR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 00:33:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:41940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728779AbgKLEYt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Nov 2020 23:24:49 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BCE5621D40;
        Thu, 12 Nov 2020 04:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605155089;
        bh=UpzS2iyuHbLF9TBEGmYr9G7I3qKBVm2ivLD8PO4RN0A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YKVS8C3dgm9j1Za6FrftnWSpFmwG+BWt2qlbBwgCVSPC7R8eYp78IAmycu4El1FW9
         1vWhfGrItmUyYGFgSnCJktiKPc0M0+4cAzDQYvHrvsPmQsaT07FUfhzMYpUmLw7Kaz
         WHyLGwNHTAzilwQwf0IVlFNHgaa3h7g4gfLDzivI=
Date:   Wed, 11 Nov 2020 20:24:47 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>,
        Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH net-next v2] drivers: net: sky2: Fix
 -Wstringop-truncation with W=1
Message-ID: <20201111202447.1702bcc3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201110023222.1479398-1-andrew@lunn.ch>
References: <20201110023222.1479398-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Nov 2020 03:32:22 +0100 Andrew Lunn wrote:
> In function =E2=80=98strncpy=E2=80=99,
>     inlined from =E2=80=98sky2_name=E2=80=99 at drivers/net/ethernet/marv=
ell/sky2.c:4903:3,
>     inlined from =E2=80=98sky2_probe=E2=80=99 at drivers/net/ethernet/mar=
vell/sky2.c:5049:2:
> ./include/linux/string.h:297:30: warning: =E2=80=98__builtin_strncpy=E2=
=80=99 specified bound 16 equals destination size [-Wstringop-truncation]
>=20
> None of the device names are 16 characters long, so it was never an
> issue. But replace the strncpy with an snprintf() to prevent the
> theoretical overflow.
>=20
> Suggested-by: Stephen Hemminger <stephen@networkplumber.org>
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Applied, thanks!
