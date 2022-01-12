Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C4F448BFA9
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 09:16:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237994AbiALIQc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 03:16:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237603AbiALIQ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 03:16:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67B66C06173F;
        Wed, 12 Jan 2022 00:16:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E5D9B81DD1;
        Wed, 12 Jan 2022 08:16:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBF4DC36AEA;
        Wed, 12 Jan 2022 08:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641975385;
        bh=9EFeKomqm/RZMFGY/sJcgGMLUJMbkJqiFq42XZPB+Xc=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=kJTXwfxB58H2Y1RaXeOQJMu0vLdcS7XgXYDd2Duqt4ke9RkGpZTAkBDlGEZHZh7ix
         BwdM3L8KQFwX1tAFJ6bF0441gdgS7wHGY6c6tCQ7ylWJAU1kFSRMseibbSS5chqo63
         rdpaNU/x7JCAIhGq5FevEkpFb5vMHEaRB/k28/6TgiewDr74vreW4KZTBY7T3Kw5CZ
         iNZaQZZXwlZD1T/PIDgmcqhj3T1xsSG1XV0W07jjCgL31vkTL19LEPJQ/TvqpebxQ4
         vObiLpO6tMgTOthZxSb37Aw1vdIsPCS61xrl9qJ7ov4bjZA+er4tewND7FU4JHs9OI
         FbXIxJFS1DT7Q==
From:   Kalle Valo <kvalo@kernel.org>
To:     cgel.zte@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH] drivers/net/wireless: remove redundant ret variable
References: <20220112080715.667254-1-chi.minghao@zte.com.cn>
Date:   Wed, 12 Jan 2022 10:16:20 +0200
In-Reply-To: <20220112080715.667254-1-chi.minghao@zte.com.cn> (cgel zte's
        message of "Wed, 12 Jan 2022 08:07:15 +0000")
Message-ID: <87sftttlm3.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

cgel.zte@gmail.com writes:

> From: Minghao Chi <chi.minghao@zte.com.cn>
>
> Return value directly instead of taking this in another redundant
> variable.
>
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
> Signed-off-by: CGEL ZTE <cgel.zte@gmail.com>
> ---
>  drivers/net/wireless/marvell/libertas/cfg.c | 14 +++-----------
>  1 file changed, 3 insertions(+), 11 deletions(-)

The subject prefix should be "libertas:", I can fix that.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
