Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 459892A376C
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 01:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727002AbgKCADf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 19:03:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:37888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725940AbgKCADf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 19:03:35 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA221208B6;
        Tue,  3 Nov 2020 00:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604361815;
        bh=aTuX4bJS/Qfy40p/ez12ea8zzTmF82ucspRtlZfX0pM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NTm+ISkeetAPNrzcYVg4MzdauoSCkb8KmjIIhsl3lZhJtk7Bmv32h1Thd40QUz7aH
         ghdBXQB2ZtSxUFWCkeTmPa6iWYR8id30mQlXyeAZmB1XN0892QaLOtrdRwbup+8W/L
         fOqYXUdfMmOZbj+wB106plB8itssTJZFsKQ9bqxk=
Date:   Mon, 2 Nov 2020 16:03:34 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>
Subject: Re: [PATCH net-next] drivers: net: xen-netfront: Fixed W=1 set but
 unused warnings
Message-ID: <20201102160334.617fe68a@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201031180435.1081127-1-andrew@lunn.ch>
References: <20201031180435.1081127-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 31 Oct 2020 19:04:35 +0100 Andrew Lunn wrote:
> drivers/net/xen-netfront.c:2416:16: warning: variable =E2=80=98target=E2=
=80=99 set but not used [-Wunused-but-set-variable]
>  2416 |  unsigned long target;
>=20
> Remove target and just discard the return value from simple_strtoul().
>=20
> This patch does give a checkpatch warning, but the warning was there
> before anyway, as this file has lots of checkpatch warnings.
>=20
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Applied, thanks!
