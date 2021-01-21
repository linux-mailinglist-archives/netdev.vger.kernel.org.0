Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20DA02FE1D1
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 06:37:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727482AbhAUFhW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 00:37:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:49488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727378AbhAUFgE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Jan 2021 00:36:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 836F02389E;
        Thu, 21 Jan 2021 05:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611207324;
        bh=g5JUIUEnhugmhrR446EIGWsLAMR8sWf8n/Y9fvKh0ck=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sHe9v/OgHedayeZEwaPvSpRF7qJveMTdWDheeiDbJwd+fTTJ2xW5DE+KGSZYYxxSH
         F8bEvVla9smGdpsaZpNYk0JIB2hekgjWtpSBY25h2s2EMBuXPDgelchvPzLjFSF4D8
         plmdQ/lTjwijgO3tWVHREaG9Am7JqpqwYcTQI3py6K74Bp7vwEwTauVt0Y4egXDcsT
         DpwAJ/6Tqhde3+ErY98IolSAdgVR05R1bwj0M6njCxvjGJDBL8MeqywHuZeYo+IYnX
         ub8kgALBNrG2gELEnJ2C6dUTC4Zf73iraVqBHayl7VgQ1EeZfKJcUlOinkUwEK2bnB
         U/IunzOVVDHxA==
Date:   Wed, 20 Jan 2021 21:35:22 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, elder@kernel.org, evgreen@chromium.org,
        bjorn.andersson@linaro.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 3/5] net: ipa: have gsi_channel_update() return
 a value
Message-ID: <20210120213522.4042c051@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210120220401.10713-4-elder@linaro.org>
References: <20210120220401.10713-1-elder@linaro.org>
        <20210120220401.10713-4-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 Jan 2021 16:03:59 -0600 Alex Elder wrote:
> Have gsi_channel_update() return the first transaction in the
> updated completed transaction list, or NULL if no new transactions
> have been added.
>=20
> Signed-off-by: Alex Elder <elder@linaro.org>

> @@ -1452,7 +1452,7 @@ void gsi_channel_doorbell(struct gsi_channel *chann=
el)
>  }
> =20
>  /* Consult hardware, move any newly completed transactions to completed =
list */
> -static void gsi_channel_update(struct gsi_channel *channel)
> +struct gsi_trans *gsi_channel_update(struct gsi_channel *channel)

Why did it lose the 'static'?

drivers/net/ipa/gsi.c:1455:19: warning: no previous prototype for =E2=80=98=
gsi_channel_update=E2=80=99 [-Wmissing-prototypes]
 1455 | struct gsi_trans *gsi_channel_update(struct gsi_channel *channel)
      |                   ^~~~~~~~~~~~~~~~~~
