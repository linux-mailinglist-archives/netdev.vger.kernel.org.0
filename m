Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE6433EBEC7
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 01:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235814AbhHMXeg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 19:34:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:34780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235776AbhHMXef (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Aug 2021 19:34:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 26340610EA;
        Fri, 13 Aug 2021 23:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628897648;
        bh=tKafd6vECbPEMazy83H7Z+3j1QWPve7a1WWuqNbDzxI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aCwww65gyLPOi0lL60q9Q20jxDYE5yRFH8FCYxrOB+CyLc/NNHeYRQuTracAG+2FM
         JT5uGGtEFVBiRKuofJL2vFmjUqfLlGEeudCNNxw+JKD/ffTZUuRpUNgd2IQYZhlm41
         Dtr8hWLcpmswR86swRtuBlWTZnKDc3AFewZJ5uq4idaW6pigsGXRa2uBMPSi2BYcNy
         Z5SEjsVVz2mdd4SUvpwr+YQYlePXnxqe+1Xu/fDVOdCFY56pPyBqupnuJ2Tlj+W9Wk
         jMWHkHTlglAXSPTU8Vl7oPQwcdXEecYUlnT7YzfsqltJWQH7i9NGyeK6RDD0vtiNOf
         cppP63hYMSsRg==
Date:   Fri, 13 Aug 2021 16:34:07 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Kconfig symbol clean-up on net
Message-ID: <20210813163407.3bde8d47@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210812083806.28434-1-lukas.bulwahn@gmail.com>
References: <20210812083806.28434-1-lukas.bulwahn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Aug 2021 10:38:03 +0200 Lukas Bulwahn wrote:
> The script ./scripts/checkkconfigsymbols.py warns on invalid references to
> Kconfig symbols (often, minor typos, name confusions or outdated references).
> 
> This patch series addresses all issues reported by
> ./scripts/checkkconfigsymbols.py in ./net/ and ./drivers/net/ for Kconfig
> and Makefile files. Issues in the Kconfig and Makefile files indicate some
> shortcomings in the overall build definitions, and often are true actionable
> issues to address.
> 
> These issues can be identified and filtered by:
> 
>   ./scripts/checkkconfigsymbols.py \
>   | grep -E "(drivers/)?net/.*(Kconfig|Makefile)" -B 1 -A 1
> 
> After applying this patch series on linux-next (next-20210811), the command
> above yields no further issues to address.

FWIW there's also:

arch/arm/configs/ixp4xx_defconfig:79:CONFIG_IPX=m
