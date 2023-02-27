Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9AE16A3F74
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 11:29:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbjB0K3R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 05:29:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230124AbjB0K3L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 05:29:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF82E93E8;
        Mon, 27 Feb 2023 02:29:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9DE52B80BE8;
        Mon, 27 Feb 2023 10:29:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C2ECC433EF;
        Mon, 27 Feb 2023 10:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677493747;
        bh=pENnWtPDvVEta8mXe3BDFlQ4zbEkcs9MwowNNbN6XF0=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=qU39AJE2gHd+JSE1r0TZvJiK5xcKvtXGjKrkIzkY6p1VwwANSPcJvAf3/stfPtSNr
         q1InqFHv5IUNcOpZB2X6qwHFY42jFVdQUUiOFIeRNX+A/IOD1lOXyNczo8dAICFQUL
         cmd/gxnT7EWBvpT1fgwv35XIjOBrqtVA/708vUHiNmwyTA3qxsiIWeRJ/ZJK7rksel
         zh7EBGLTZ3V90GF/81ze7VQ83hsAqItul53CYQD/dVkXpTcnCnodwDAjV/aD/wLso8
         zOyVgpdxqL/WkbB3ClT0PIDPKq+GgITMw+1goIXAFaR3EoAU3+kz1/3sTiKWyMvHPJ
         4YZz6GKdxbuVw==
From:   Kalle Valo <kvalo@kernel.org>
To:     Ganapathi Kondraju <ganapathi.kondraju@silabs.com>
Cc:     linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Amol Hanwate <amol.hanwate@silabs.com>,
        Angus Ainslie <angus@akkea.ca>,
        Jakub Kicinski <kuba@kernel.org>,
        Jerome Pouiller <Jerome.Pouiller@silabs.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Marek Vasut <marex@denx.de>,
        Martin Fuzzey <martin.fuzzey@flowbird.group>,
        Martin Kepplinger <martink@posteo.de>,
        Narasimha Anumolu <narasimha.anumolu@silabs.com>,
        Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
        Shivanadam Gude <shivanadam.gude@silabs.com>,
        Siva Rebbagondla <siva8118@gmail.com>,
        Srinivas Chappidi <srinivas.chappidi@silabs.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3] MAINTAINERS: Add new maintainers to Redpine driver
References: <1675433281-6132-1-git-send-email-ganapathi.kondraju@silabs.com>
Date:   Mon, 27 Feb 2023 12:28:57 +0200
In-Reply-To: <1675433281-6132-1-git-send-email-ganapathi.kondraju@silabs.com>
        (Ganapathi Kondraju's message of "Fri, 3 Feb 2023 19:38:01 +0530")
Message-ID: <87lekj1jx2.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ganapathi Kondraju <ganapathi.kondraju@silabs.com> writes:

> Silicon Labs acquired Redpine Signals recently. It needs to continue
> giving support to the existing REDPINE WIRELESS DRIVER. This patch adds
> new Maintainers for it.
>
> Signed-off-by: Ganapathi Kondraju <ganapathi.kondraju@silabs.com>
> ---
> V2:
> - Add proper prefix for patch subject.
> - Reorder the maintainers list alphabetically.
> - Add a new member to the list.
> ---
> V3:
> - Fix sentence formation in the patch subject and description.
> ---
>
>  MAINTAINERS | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index ea941dc..04a08c7 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17709,8 +17709,14 @@ S:	Maintained
>  F:	drivers/net/wireless/realtek/rtw89/
>=20=20
>  REDPINE WIRELESS DRIVER
> +M:	Amol Hanwate <amol.hanwate@silabs.com>
> +M:	Ganapathi Kondraju <ganapathi.kondraju@silabs.com>
> +M:	J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com>
> +M:	Narasimha Anumolu <narasimha.anumolu@silabs.com>
> +M:	Shivanadam Gude <shivanadam.gude@silabs.com>
> +M:	Srinivas Chappidi <srinivas.chappidi@silabs.com>
>  L:	linux-wireless@vger.kernel.org
> -S:	Orphan
> +S:	Maintained
>  F:	drivers/net/wireless/rsi/

For me six maintainers is way too much. Just last November I marked this
driver as orphan, I really do not want to add all these people to
MAINTAINERS and never hear from them again.

Ideally I would prefer to have one or two maintainers who would be
actively working with the drivers. And also I would like to see some
proof (read: reviewing patches and providing feedback) that the
maintainers are really parciticiping in upstream before changing the
status.

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
