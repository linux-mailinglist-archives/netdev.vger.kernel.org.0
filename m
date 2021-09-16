Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 351D440D391
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 09:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234642AbhIPHFK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 03:05:10 -0400
Received: from comms.puri.sm ([159.203.221.185]:44780 "EHLO comms.puri.sm"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234539AbhIPHFH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 03:05:07 -0400
Received: from localhost (localhost [127.0.0.1])
        by comms.puri.sm (Postfix) with ESMTP id 0EA49E014D;
        Thu, 16 Sep 2021 00:03:17 -0700 (PDT)
Received: from comms.puri.sm ([127.0.0.1])
        by localhost (comms.puri.sm [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id IV5lmIVpzozF; Thu, 16 Sep 2021 00:03:16 -0700 (PDT)
From:   Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
To:     netdev@vger.kernel.org, Marek Vasut <marex@denx.de>
Cc:     Marek Vasut <marex@denx.de>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Angus Ainslie <angus@akkea.ca>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Karun Eagalapati <karun256@gmail.com>,
        Martin Fuzzey <martin.fuzzey@flowbird.group>,
        Martin Kepplinger <martink@posteo.de>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH] rsi: Fix module dev_oper_mode parameter description
Date:   Thu, 16 Sep 2021 09:03:08 +0200
Message-ID: <5957470.R6RXr1ZQNe@pliszka>
In-Reply-To: <20210915080841.73938-1-marex@denx.de>
References: <20210915080841.73938-1-marex@denx.de>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On =C5=9Broda, 15 wrze=C5=9Bnia 2021 10:08:41 CEST Marek Vasut wrote:
> +#define DEV_OPMODE_PARAM_DESC		\
> +	__stringify(DEV_OPMODE_WIFI_ALONE)	"[Wi-Fi alone], "	\
> +	__stringify(DEV_OPMODE_BT_ALONE)	"[BT classic alone], "	\
> +	__stringify(DEV_OPMODE_BT_LE_ALONE)	"[BT LE], "	=09
\
> +	__stringify(DEV_OPMODE_BT_DUAL)		"[BT Dual], "	=09
\
> +	__stringify(DEV_OPMODE_STA_BT)		"[Wi-Fi STA + BT=20
classic], " \
> +	__stringify(DEV_OPMODE_STA_BT_LE)	"[Wi-Fi STA + BT LE], "	\
> +	__stringify(DEV_OPMODE_STA_BT_DUAL)	"[Wi-Fi STA + BT=20
classic + BT LE], " \
> +	__stringify(DEV_OPMODE_AP_BT)		"[AP + BT classic], "=09
\
> +	__stringify(DEV_OPMODE_AP_BT_DUAL)	"[AP + BT classic + BT LE]"

There's still some inconsistency in mode naming - how about:=20

=2D Wi-Fi STA
=2D BT classic
=2D BT LE
=2D BT classic + BT LE
=2D Wi-Fi STA + BT classic
=2D Wi-Fi STA + BT LE
=2D Wi-Fi STA + BT classic + BT LE
=2D Wi-Fi AP + BT classic
=2D Wi-Fi AP + BT classic + BT LE

"alone" could be added to the first three modes (you missed it in BT LE).

Cheers,
Sebastian


