Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 924392A6FFB
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 22:56:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731997AbgKDV4K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 16:56:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:43578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727725AbgKDV4K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 16:56:10 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 411A120780;
        Wed,  4 Nov 2020 21:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604526969;
        bh=P8tb30Qfw9A5hqAEFF7zkf4xUXFtJmK29iuPOkwg0+w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qFmFYsF5neqltro/T6kVZ7Ne4tC5MTvLxvWrySGH+f9aEZDq/zKydLKBQiC9MFwvZ
         xkwIglkpavzlUXrcnw5tXaommFdXzbNxS9+CozjVkyeMrg1KFxgiQOmeqc5Ngc6Yip
         +wBjlWJnZo6dBEcPaj/53hG651KSZWIy9tVy8qpI=
Date:   Wed, 4 Nov 2020 13:56:08 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     <min.li.xe@renesas.com>
Cc:     <richardcochran@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 1/3] ptp: idt82p33: add adjphase support
Message-ID: <20201104135608.4314186f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1604505709-5483-1-git-send-email-min.li.xe@renesas.com>
References: <1604505709-5483-1-git-send-email-min.li.xe@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 4 Nov 2020 11:01:47 -0500 min.li.xe@renesas.com wrote:
> From: Min Li <min.li.xe@renesas.com>
>=20
> Add idt82p33_adjphase() to support PHC write phase mode.
>=20
> Signed-off-by: Min Li <min.li.xe@renesas.com>

This appears to break the build. Each patch must build, otherwise we're
risking breaking builds when people bisect bugs with git bisect.

../drivers/ptp/ptp_idt82p33.c: In function =E2=80=98idt82p33_page_offset=E2=
=80=99:
../drivers/ptp/ptp_idt82p33.c:120:8: error: implicit declaration of functio=
n =E2=80=98_idt82p33_xfer=E2=80=99; did you mean =E2=80=98idt82p33_xfer=E2=
=80=99? [-Werror=3Dimplicit-function-declaration]
  120 |  err =3D _idt82p33_xfer(idt82p33, PAGE_ADDR, &val, sizeof(val), 1);
      |        ^~~~~~~~~~~~~~
      |        idt82p33_xfer
cc1: some warnings being treated as errors
make[3]: *** [drivers/ptp/ptp_idt82p33.o] Error 1
make[2]: *** [drivers/ptp] Error 2
make[2]: *** Waiting for unfinished jobs....
make[1]: *** [drivers] Error 2
make: *** [__sub-make] Error 2
../drivers/ptp/ptp_idt82p33.c: In function =E2=80=98idt82p33_page_offset=E2=
=80=99:
../drivers/ptp/ptp_idt82p33.c:120:8: error: implicit declaration of functio=
n =E2=80=98_idt82p33_xfer=E2=80=99; did you mean =E2=80=98idt82p33_xfer=E2=
=80=99? [-Werror=3Dimplicit-function-declaration]
  120 |  err =3D _idt82p33_xfer(idt82p33, PAGE_ADDR, &val, sizeof(val), 1);
      |        ^~~~~~~~~~~~~~
      |        idt82p33_xfer
cc1: some warnings being treated as errors
make[3]: *** [drivers/ptp/ptp_idt82p33.o] Error 1
make[2]: *** [drivers/ptp] Error 2
make[2]: *** Waiting for unfinished jobs....
make[1]: *** [drivers] Error 2
make: *** [__sub-make] Error 2
