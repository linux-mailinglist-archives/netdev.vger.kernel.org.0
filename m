Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC4103E06DE
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 19:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237171AbhHDRlk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 13:41:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:46096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231410AbhHDRlj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 13:41:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 61ABE60F58;
        Wed,  4 Aug 2021 17:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628098886;
        bh=U3KRI9kii54Qtwjzrk1Npm0+r70GBdSKFuG2YWpj8Zs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pU63zVaxR7SVGjYaZ1Q4pfjg/faIfFdI++PoYbJcFl0jXLivXvRnyuviYLVqhYNEf
         xmxIwneFk+eYH0haBMUh47iwR+39xEg7Og+0wO7w+iP9eEZO0508e2Arbq/NqueZKg
         ZblbMpOSYb1P7JOKysDIJ8qBzlXj4KyyFHN3KnYkLp0XiExa4zlxFLthOgeuWh42/c
         B3FALwvf0AxKKnAtyjXGq/ZMDZQlMWHwJ0DVmC7HtLnTmZUZmThfSOCXHep99djY1l
         E/vxECJucdUs1bzZxLzKZyDFH42bAuAV6mB9LO2g1rVvygsmy3omQHtECRJK24SDBB
         /8QkbPQqdgmcQ==
Date:   Wed, 4 Aug 2021 13:41:25 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Eric Woudstra <ericwouds@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH AUTOSEL 4.19 5/6] mt7530 fix mt7530_fdb_write vid missing
 ivl bit
Message-ID: <YQrRRar2TymxP2WP@sashalap>
References: <20210727132015.835651-1-sashal@kernel.org>
 <20210727132015.835651-5-sashal@kernel.org>
 <e1508978-8f0e-40a6-baa8-3d3bc4c82811@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <e1508978-8f0e-40a6-baa8-3d3bc4c82811@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 31, 2021 at 03:27:04PM +0200, Eric Woudstra wrote:
>
>A few days after this patch, I send in another as it needs a fix. If you apply this patch, please also apply the other: set ivl bit only for vid larger than 1.

Looks like the fix didn't make it yet, so I'll drop this one for now.

-- 
Thanks,
Sasha
