Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 185F646E9D3
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 15:18:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233044AbhLIOVu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 09:21:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232049AbhLIOVt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 09:21:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CCEFC061746;
        Thu,  9 Dec 2021 06:18:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 54203B8232B;
        Thu,  9 Dec 2021 14:18:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85D23C004DD;
        Thu,  9 Dec 2021 14:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639059493;
        bh=NDR1+cOTjE99IH1//NVh1k6K3xUweDemHi2a82+imkk=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=qj8JyAZtc7gMMZWgvtZTSHmuLTPaYZBaDRaxz/gppSHJ3Sd8oSzwSjNreIU8trau3
         GOqOPorBav5iDKjDSEMd9+Lg+nDF2iivV2Mj4FsWsp4ERTOGKqIPqvqpedFvRstgyx
         l0uo9MqyEkrS3QIG2Mi8jUyMhOAKgUM98betLHb1Ijjq5RWfjqG7KG1osB3LNjmLPa
         2cxsC1mHLzpUPcBauUpEE9H7+oTEgV1YHnSj0Qg3G/rVi+yh2aFU2UTKtUTRwSuQtj
         Oa6Gy2YUtNEE2+QZ1Quh97XJrXfaDrxohRMz5FPZmiXtJEeBnZkWJEoYxE8nqzwwxF
         /ol4bN8z4oSuQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        heikki.krogerus@linux.intel.com
Subject: Re: [PATCH v1 1/1] include/linux/unaligned: Replace kernel.h with the necessary inclusions
References: <20211209123823.20425-1-andriy.shevchenko@linux.intel.com>
Date:   Thu, 09 Dec 2021 16:18:05 +0200
In-Reply-To: <20211209123823.20425-1-andriy.shevchenko@linux.intel.com> (Andy
        Shevchenko's message of "Thu, 9 Dec 2021 14:38:23 +0200")
Message-ID: <87lf0t3lr6.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andy Shevchenko <andriy.shevchenko@linux.intel.com> writes:

> When kernel.h is used in the headers it adds a lot into dependency hell,
> especially when there are circular dependencies are involved.
>
> Replace kernel.h inclusion with the list of what is really being used.
>
> The rest of the changes are induced by the above and may not be split.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/xtlv.c | 2 ++
>  include/linux/unaligned/packed_struct.h                 | 2 +-
>  lib/lz4/lz4defs.h                                       | 2 ++
>  3 files changed, 5 insertions(+), 1 deletion(-)

I assume this will go via some other tree:

Acked-by: Kalle Valo <kvalo@kernel.org>

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
