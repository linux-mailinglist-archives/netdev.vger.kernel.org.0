Return-Path: <netdev+bounces-7045-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BAF907196A5
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 11:17:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 70EC02816E4
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 09:17:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8729F14271;
	Thu,  1 Jun 2023 09:17:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3175E79DF
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 09:17:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B02B0C433D2;
	Thu,  1 Jun 2023 09:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685611069;
	bh=q0CJdSwXOIJZvPvJU/z1sdvR3U3gXtkEs4k/nknZCKE=;
	h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
	b=Pu4TajYAxmVtPK8l64pTxUbVC50dU99ybV9kjG4vUZuzP1MTiXLq4ebRN9JEswJPC
	 9gqrdWezwjMfxd3n8dW2tpct1bHWQ4u/93au/v8Ux9Tn2lMsGg9DtedCWXQrl0L6Dy
	 70unoZ4Q5hx+1uCP5TK8MUelatzwOkP2LxASzUrk8EcPyukgPdwemfpC9dCCW9NZ+Z
	 7BXfENmmF9ewBz4RvAlGyhE6Gzqcy9lX8vR7qfkUcC/Fx3WeoO9RGi2Op2l7NOyd09
	 evmmFrp0BeDKZlLbqrbIBAgIRIK5LA9G73XQTjOEdbjz5+P4Vl+3A7uUQn4xvZbxrO
	 uzmTG7QxQxGsQ==
From: Kalle Valo <kvalo@kernel.org>
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc: "David S. Miller" <davem@davemloft.net>,  Eric Dumazet <edumazet@google.com>,  Jakub Kicinski <kuba@kernel.org>,  Paolo Abeni <pabeni@redhat.com>,  ath10k@lists.infradead.org,  linux-wireless@vger.kernel.org,  netdev@vger.kernel.org,  kernel@pengutronix.de
Subject: Re: [PATCH net-next 0/4] Convert to platform remove callback returning void
References: <20230601082556.2738446-1-u.kleine-koenig@pengutronix.de>
Date: Thu, 01 Jun 2023 12:17:44 +0300
In-Reply-To: <20230601082556.2738446-1-u.kleine-koenig@pengutronix.de> ("Uwe
	\=\?utf-8\?Q\?Kleine-K\=C3\=B6nig\=22's\?\= message of "Thu, 1 Jun 2023 10:25:52
 +0200")
Message-ID: <87h6rrk0cn.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de> writes:

> the motivation for this series is patch #3, patch #2 is a preparation for=
 it
> and patches #1 and #4 are just cleanups that I noticed en passant.
>
> Best regards
> Uwe
>
> Uwe Kleine-K=C3=B6nig (4):
>   ath10k: Drop cleaning of driver data from probe error path and remove
>   ath10k: Drop checks that are always false
>   ath10k: Convert to platform remove callback returning void
>   atk10k: Don't opencode ath10k_pci_priv() in ath10k_ahb_priv()
>
>  drivers/net/wireless/ath/ath10k/ahb.c  | 20 +++-----------------
>  drivers/net/wireless/ath/ath10k/snoc.c |  8 +++-----
>  2 files changed, 6 insertions(+), 22 deletions(-)

ath10k patches go to my ath.git tree, not net-next. Also "wifi:" is
missing from the title but I can add that.

No need to resend because of these.

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes

