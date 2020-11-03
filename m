Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4216E2A376D
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 01:04:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbgKCAEz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 19:04:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:38036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725940AbgKCAEz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 19:04:55 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51BD4208B6;
        Tue,  3 Nov 2020 00:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604361895;
        bh=cqMIw9JiAKVFxt4KpP4IoDu1Iv49MA7IcFwqBXLvpO0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ppcVkeDnCqjsqoj2d8Ijm9be1Asb9xntuxqkog8efSP8z0FzKXh2XO5p+TvmcfkIK
         SXNmhmPlp/zT/BtwEDlk/NHY0SUN4fdkccnlVfdBwXuZYIvyO+zfkEynlvdf/0qvpD
         vF7CzIbCJfLNVsRlHmIzfaCdUeTvxuxoAMktOUU4=
Date:   Mon, 2 Nov 2020 16:04:54 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] drivers: net: wan: lmc: Fix W=1 set but used
 variable warnings
Message-ID: <20201102160454.13b6a61a@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201031181417.1081511-1-andrew@lunn.ch>
References: <20201031181417.1081511-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 31 Oct 2020 19:14:17 +0100 Andrew Lunn wrote:
> drivers/net/wan/lmc/lmc_main.c: In function =E2=80=98lmc_ioctl=E2=80=99:
> drivers/net/wan/lmc/lmc_main.c:356:25: warning: variable =E2=80=98mii=E2=
=80=99 set but not used [-Wunused-but-set-variable]
>   356 |                     u16 mii;
>       |                         ^~~
> drivers/net/wan/lmc/lmc_main.c:427:25: warning: variable =E2=80=98mii=E2=
=80=99 set but not used [-Wunused-but-set-variable]
>   427 |                     u16 mii;
>       |                         ^~~
> drivers/net/wan/lmc/lmc_main.c: In function =E2=80=98lmc_interrupt=E2=80=
=99:
> drivers/net/wan/lmc/lmc_main.c:1188:9: warning: variable =E2=80=98firstcs=
r=E2=80=99 set but not used [-Wunused-but-set-variable]
>  1188 |     u32 firstcsr;
>=20
> This file has funky indentation, and makes little use of tabs. Keep
> with this style in the patch, but that makes checkpatch unhappy.
>=20
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Applied, thanks!
