Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A30248C42B
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 13:47:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353257AbiALMq5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 07:46:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353244AbiALMqx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 07:46:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0616DC06173F;
        Wed, 12 Jan 2022 04:46:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CDD9AB81EA7;
        Wed, 12 Jan 2022 12:46:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D21E9C36AE5;
        Wed, 12 Jan 2022 12:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641991610;
        bh=Q/J6JEZ3cVVSxVKhadTn858ZM/rd91mNJYmHU4mHfIg=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=U99u+zmreZJOhJq8CvvcY3iyLgFI7JS44DRn2ZOoCDBLKbVGB+V+wefuIa5P+6tMd
         Z63P3JKuM0hvrMiwhdqbSum6Q5Tr2iXCESBA1+B7JQDpHc2JdFIKK42w1QYp3nX6P3
         3E2o4lGzX2U7DVtHqoxoxW2C67YXo+fQY/qnnSLs6ebPr7qoHxREtZbmLSPsnW7tfy
         TDVq1UkNUinYPY45wIyIFnwUa4vflxV79OZDSLrd2wN62SDGbBzHKijWPjibK1i6XP
         Xm788dUZigBXNZsUm931/h06vq9Qwg4TM6SYf67Cp49Gaq5rymFNeiUzl5nW/V3eOR
         ky0AECcvhk9eA==
From:   Kalle Valo <kvalo@kernel.org>
To:     =?utf-8?B?SsOpcsO0bWU=?= Pouiller <jerome.pouiller@silabs.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-mmc@vger.kernel.org,
        Pali =?utf-8?Q?Roh?= =?utf-8?Q?=C3=A1r?= <pali@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH v9 23/24] wfx: remove from the staging area
References: <20220111171424.862764-1-Jerome.Pouiller@silabs.com>
        <20220111171424.862764-24-Jerome.Pouiller@silabs.com>
        <874k69jsv1.fsf@tynnyri.adurom.net> <65681266.04G08nq4u0@pc-42>
Date:   Wed, 12 Jan 2022 14:46:46 +0200
In-Reply-To: <65681266.04G08nq4u0@pc-42> (=?utf-8?B?IkrDqXLDtG1l?=
 Pouiller"'s message of "Wed,
        12 Jan 2022 10:32:41 +0100")
Message-ID: <87fsptt93d.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com> writes:

> On Wednesday 12 January 2022 08:49:54 CET Kalle Valo wrote:
>> Jerome Pouiller <Jerome.Pouiller@silabs.com> writes:
>>=20
>> > From: J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com>
>> >
>> > Signed-off-by: J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com>
>> > ---
>> >  .../bindings/net/wireless/silabs,wfx.yaml     | 125 ---
>> >  drivers/staging/wfx/Kconfig                   |   8 -
>> >  drivers/staging/wfx/Makefile                  |  25 -
>> >  drivers/staging/wfx/bh.c                      | 330 -------
>> >  drivers/staging/wfx/bh.h                      |  33 -
>> >  drivers/staging/wfx/bus.h                     |  38 -
>> >  drivers/staging/wfx/bus_sdio.c                | 272 ------
>> >  drivers/staging/wfx/bus_spi.c                 | 271 ------
>> >  drivers/staging/wfx/data_rx.c                 |  94 --
>> >  drivers/staging/wfx/data_rx.h                 |  18 -
>> >  drivers/staging/wfx/data_tx.c                 | 596 -------------
>> >  drivers/staging/wfx/data_tx.h                 |  68 --
>> >  drivers/staging/wfx/debug.c                   | 365 --------
>> >  drivers/staging/wfx/debug.h                   |  19 -
>> >  drivers/staging/wfx/fwio.c                    | 405 ---------
>> >  drivers/staging/wfx/fwio.h                    |  15 -
>> >  drivers/staging/wfx/hif_api_cmd.h             | 555 ------------
>> >  drivers/staging/wfx/hif_api_general.h         | 262 ------
>> >  drivers/staging/wfx/hif_api_mib.h             | 346 --------
>> >  drivers/staging/wfx/hif_rx.c                  | 416 ---------
>> >  drivers/staging/wfx/hif_rx.h                  |  17 -
>> >  drivers/staging/wfx/hif_tx.c                  | 513 -----------
>> >  drivers/staging/wfx/hif_tx.h                  |  60 --
>> >  drivers/staging/wfx/hif_tx_mib.c              | 324 -------
>> >  drivers/staging/wfx/hif_tx_mib.h              |  49 --
>> >  drivers/staging/wfx/hwio.c                    | 352 --------
>> >  drivers/staging/wfx/hwio.h                    |  75 --
>> >  drivers/staging/wfx/key.c                     | 241 -----
>> >  drivers/staging/wfx/key.h                     |  20 -
>> >  drivers/staging/wfx/main.c                    | 506 -----------
>> >  drivers/staging/wfx/main.h                    |  43 -
>> >  drivers/staging/wfx/queue.c                   | 307 -------
>> >  drivers/staging/wfx/queue.h                   |  45 -
>> >  drivers/staging/wfx/scan.c                    | 149 ----
>> >  drivers/staging/wfx/scan.h                    |  22 -
>> >  drivers/staging/wfx/sta.c                     | 833=20
> ------------------
>> >  drivers/staging/wfx/sta.h                     |  73 --
>> >  drivers/staging/wfx/traces.h                  | 501 -----------
>> >  drivers/staging/wfx/wfx.h                     | 164 ----
>> >  39 files changed, 8555 deletions(-)
>> >  delete mode 100644 drivers/staging/wfx/Documentation/devicetree/
> bindings/net/wireless/silabs,wfx.yaml
>> >  delete mode 100644 drivers/staging/wfx/Kconfig
>> >  delete mode 100644 drivers/staging/wfx/Makefile
>> >  delete mode 100644 drivers/staging/wfx/bh.c
>> >  delete mode 100644 drivers/staging/wfx/bh.h
>> >  delete mode 100644 drivers/staging/wfx/bus.h
>> >  delete mode 100644 drivers/staging/wfx/bus_sdio.c
>> >  delete mode 100644 drivers/staging/wfx/bus_spi.c
>> >  delete mode 100644 drivers/staging/wfx/data_rx.c
>> >  delete mode 100644 drivers/staging/wfx/data_rx.h
>> >  delete mode 100644 drivers/staging/wfx/data_tx.c
>> >  delete mode 100644 drivers/staging/wfx/data_tx.h
>> >  delete mode 100644 drivers/staging/wfx/debug.c
>> >  delete mode 100644 drivers/staging/wfx/debug.h
>> >  delete mode 100644 drivers/staging/wfx/fwio.c
>> >  delete mode 100644 drivers/staging/wfx/fwio.h
>> >  delete mode 100644 drivers/staging/wfx/hif_api_cmd.h
>> >  delete mode 100644 drivers/staging/wfx/hif_api_general.h
>> >  delete mode 100644 drivers/staging/wfx/hif_api_mib.h
>> >  delete mode 100644 drivers/staging/wfx/hif_rx.c
>> >  delete mode 100644 drivers/staging/wfx/hif_rx.h
>> >  delete mode 100644 drivers/staging/wfx/hif_tx.c
>> >  delete mode 100644 drivers/staging/wfx/hif_tx.h
>> >  delete mode 100644 drivers/staging/wfx/hif_tx_mib.c
>> >  delete mode 100644 drivers/staging/wfx/hif_tx_mib.h
>> >  delete mode 100644 drivers/staging/wfx/hwio.c
>> >  delete mode 100644 drivers/staging/wfx/hwio.h
>> >  delete mode 100644 drivers/staging/wfx/key.c
>> >  delete mode 100644 drivers/staging/wfx/key.h
>> >  delete mode 100644 drivers/staging/wfx/main.c
>> >  delete mode 100644 drivers/staging/wfx/main.h
>> >  delete mode 100644 drivers/staging/wfx/queue.c
>> >  delete mode 100644 drivers/staging/wfx/queue.h
>> >  delete mode 100644 drivers/staging/wfx/scan.c
>> >  delete mode 100644 drivers/staging/wfx/scan.h
>> >  delete mode 100644 drivers/staging/wfx/sta.c
>> >  delete mode 100644 drivers/staging/wfx/sta.h
>> >  delete mode 100644 drivers/staging/wfx/traces.h
>> >  delete mode 100644 drivers/staging/wfx/wfx.h
>>=20
>> I'm not sure what's your plan here, but with staging wireless drivers
>> there's usually a simple simple move (git mv) of the driver from
>> drivers/staging to drivers/net/wireless. An example here:
>>=20
>> https://git.kernel.org/linus/5625f965d764
>>=20
>> What you seem to do here is that you add a new driver to
>> drivers/net/wireless and then remove the old driver from
>> drivers/staging. And I'm guessing these two drivers are not identical
>> and have differences?
>
> Until v7, I have more or less kept in sync this PR and the staging tree.=
=20
> I have been a bit lazy from the v8.
>
> However, I still have the patches in my local tree. I am going to
> clean-up them and send them to staging.

Very good, thanks.

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
