Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A49C48D6EB
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 12:50:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234276AbiAMLub (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 06:50:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231260AbiAMLua (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 06:50:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27E28C06173F;
        Thu, 13 Jan 2022 03:50:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC6DB61982;
        Thu, 13 Jan 2022 11:50:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F2D2C36AE9;
        Thu, 13 Jan 2022 11:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642074629;
        bh=5f0a/xRY41Y6k3AVP6APcWpAYz/w3ntzIrhp4l6IuEc=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=eIefB+vQ9n5nU42IW8t1/J4YrhdpbXA0kvRFzSkdRmB7OiCen0U91Dj9hZJhY/bMc
         6jQZ6d8cBx2qR3Kf4fLezo6Jotu34w7SHPKnIX5YUV/+qaxd5RN1wnp//hA7zyFM+u
         2zEEEePvXzjegrnpy77rXhwzABsc2SL+v4ML7y7Zx01MeEuaIVxbQfa33NrG3YmyQV
         //W8ZV43PwLYNh39Z4PPmQ4iol1FpkkhZNdlh1vQ4kUkFgQsJJvXoE1mB92JVPOAYb
         KbKEEHC/9Gp3f4nXHm5y+pyFpc42GycXlLuhALg5Um1lOXQm55AXXtT5dV9gwgb3tt
         BjmYnYTQM5VoQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     Jerome Pouiller <Jerome.Pouiller@silabs.com>
Cc:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH 02/31] staging: wfx: fix HIF API license
References: <20220113085524.1110708-1-Jerome.Pouiller@silabs.com>
        <20220113085524.1110708-3-Jerome.Pouiller@silabs.com>
Date:   Thu, 13 Jan 2022 13:50:23 +0200
In-Reply-To: <20220113085524.1110708-3-Jerome.Pouiller@silabs.com> (Jerome
        Pouiller's message of "Thu, 13 Jan 2022 09:54:55 +0100")
Message-ID: <877db3ua68.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jerome Pouiller <Jerome.Pouiller@silabs.com> writes:

> From: J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com>
>
> Apache-2.0 is not allowed in the kernel.
>
> Signed-off-by: J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com>
> ---
>  drivers/staging/wfx/hif_api_cmd.h     | 2 +-
>  drivers/staging/wfx/hif_api_general.h | 2 +-
>  drivers/staging/wfx/hif_api_mib.h     | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/staging/wfx/hif_api_cmd.h b/drivers/staging/wfx/hif_=
api_cmd.h
> index b0aa13b23a51..b1829d01a5d9 100644
> --- a/drivers/staging/wfx/hif_api_cmd.h
> +++ b/drivers/staging/wfx/hif_api_cmd.h
> @@ -1,4 +1,4 @@
> -/* SPDX-License-Identifier: Apache-2.0 */
> +/* SPDX-License-Identifier: GPL-2.0-only or Apache-2.0 */

Is the Apache-2.0 license really mandatory? LICENSES/dual/Apache-2.0 is
not really supportive.

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
