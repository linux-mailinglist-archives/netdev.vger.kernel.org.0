Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FACD3C5EB2
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 17:00:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235296AbhGLPCx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 11:02:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:40560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233784AbhGLPCw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Jul 2021 11:02:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id F1EE261167;
        Mon, 12 Jul 2021 15:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626102004;
        bh=mljpCQRGjQpLsHXqAqpOZUrcMlrjdQpqcBhjcHIhIro=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ChgPGyHMVfQB1wm2/Pz7Qnh0tI1qsjb3fsqb/D0vtrGIAZt+4FrOPkMWR1RvgQb5n
         YuYQktBP6R1FlVOFLA9OdJ6Itx1cV7JpN0c5fBRadw18IwH61TDk1XjRyWsYdml2Ir
         xv6OMML1qxcJ7Tqb7xeEkYbYkdGDLew/MDpeN8SBNgbJmrziaR5m8wbX8gatTtRURr
         Zq5q34QoqEqYZS5QLpnoYUligQafQuM55eDpzHSMSUpLdVE5548p4r2ZZILg7T9fmk
         lOB3+CoIkyfPNHC7QFe7kuBvramu7hoZlDytRCyYMkMsUWmfRVPOofuZcC+6hSzI+N
         vjeY6Q3UfJMJg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E4C9F609CD;
        Mon, 12 Jul 2021 15:00:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] doc/af_xdp: fix bind flags option typo
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162610200393.12678.17305655891966604853.git-patchwork-notify@kernel.org>
Date:   Mon, 12 Jul 2021 15:00:03 +0000
References: <1656fdf94704e9e735df0f8b97667d8f26dd098b.1625550240.git.baruch@tkos.co.il>
In-Reply-To: <1656fdf94704e9e735df0f8b97667d8f26dd098b.1625550240.git.baruch@tkos.co.il>
To:     Baruch Siach <baruch@tkos.co.il>
Cc:     bjorn@kernel.org, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (refs/heads/master):

On Tue,  6 Jul 2021 08:44:00 +0300 you wrote:
> Use 'XDP_ZEROCOPY' as this options is named in if_xdp.h.
> 
> Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> ---
>  Documentation/networking/af_xdp.rst | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Here is the summary with links:
  - doc/af_xdp: fix bind flags option typo
    https://git.kernel.org/bpf/bpf/c/f35e0cc25280

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


