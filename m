Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D9BA46CF2C
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 09:36:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240708AbhLHIjj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 03:39:39 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:56648 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231316AbhLHIji (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 03:39:38 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C7356B81FDE;
        Wed,  8 Dec 2021 08:36:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D7D1C00446;
        Wed,  8 Dec 2021 08:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638952564;
        bh=yJnXl4jzvgEprMEjZxmGkgucyejVpGfnHnH/+kNZK/k=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=ISM/9QAjbK9rehURJd8gG8WaqixuBUFaFI2Pc7F0sDmdi1K2ZJH7mvptw95fnJGl7
         gAh2mRS7+k2RTuPv7Rj6w16NxfWLQtc/Y8mC4wG3sm5NMh15jNAz5UbSpMV4e6fuO3
         29e8/aC5WRmkBMNq/briYVH9u8VFjqqFMc5Q7liebcMDTiFgESpepe8zDMYnlEvdsh
         rW16Bp3Huh+cz+ep0Ex1owqizVNQ7SnQTp2KR4tTp79N/hfp3JhQKTVn1oR3yY/rle
         oP9rwWPF+aDEcFNMxdS9HEhIRbDYRF25+KnDregNugbTo+XOzmPp1sH0wjZiCxIBSL
         7sb1iRNAqEgLA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] carl9170: Use the bitmap API when applicable
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <1fe18fb73f71d855043c40c83865ad539f326478.1638396221.git.christophe.jaillet@wanadoo.fr>
References: <1fe18fb73f71d855043c40c83865ad539f326478.1638396221.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     chunkeey@googlemail.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <163895256077.29041.18198959871670057550.kvalo@kernel.org>
Date:   Wed,  8 Dec 2021 08:36:02 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christophe JAILLET <christophe.jaillet@wanadoo.fr> wrote:

> Use 'bitmap_zalloc()' to simplify code, improve the semantic and avoid some
> open-coded arithmetic in allocator arguments.
> 
> Note, that this 'bitmap_zalloc()' divides by BITS_PER_LONG the amount of
> memory allocated.
> The 'roundup()' used to computed the number of needed long should have
> been a DIV_ROUND_UP.
> 
> 
> Also change the corresponding 'kfree()' into 'bitmap_free()' to keep
> consistency.
> 
> Use 'bitmap_zero()' to avoid hand writing it.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> Acked-by: Christian Lamparter <chunkeey@gmail.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

6273c97296a8 carl9170: Use the bitmap API when applicable

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/1fe18fb73f71d855043c40c83865ad539f326478.1638396221.git.christophe.jaillet@wanadoo.fr/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

