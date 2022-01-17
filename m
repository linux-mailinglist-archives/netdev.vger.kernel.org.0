Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 861454908E0
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 13:43:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239997AbiAQMnN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 07:43:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239990AbiAQMnN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 07:43:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B834DC061574;
        Mon, 17 Jan 2022 04:43:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7205EB81059;
        Mon, 17 Jan 2022 12:43:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECC7FC36AF2;
        Mon, 17 Jan 2022 12:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642423390;
        bh=gQ3JpQI+NLCqiEUGL4Ucrm6zsrQhEEqsyVDKB0S3RCU=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=bAPpx2b8U4a2+JcSHOrHi2R4usMjVbgN0Q0YoxfK2r/3Tcg7zTNU61F8OOVnEIZrH
         dWnyxhilHnHyMnOd3G4759HqjkIY+Ygz5xxK0bgfQv3igTAP1lstSwem46h/v1/6gc
         77e9BbKqJP6yu/X2KH7oL3QLywLsTNO82CVFMKXtk9mO1LUHQlWsWbadSSqvkntgcM
         dH5O3DgyEGRmEpeHg+EUdJSmBbOdl96u3rA8TC9++NdNiCxAmOQRRfwGL6FEoM0K47
         ioYhqOC3IhhiIaKMXH9UOQmZeinGGsiBDB1N/Ma1waIeC4P5AavoF1Nwr38Yi2MzUc
         F4uE5xNFWYJBQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wireless/ath/ath9k: remove redundant status variable
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220112080751.667316-1-chi.minghao@zte.com.cn>
References: <20220112080751.667316-1-chi.minghao@zte.com.cn>
To:     cgel.zte@gmail.com
Cc:     ath9k-devel@qca.qualcomm.com, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>, CGEL ZTE <cgel.zte@gmail.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164242338630.27899.7808869240043107600.kvalo@kernel.org>
Date:   Mon, 17 Jan 2022 12:43:07 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

cgel.zte@gmail.com wrote:

> Return value directly instead of taking this in another redundant
> variable.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
> Signed-off-by: CGEL ZTE <cgel.zte@gmail.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

76d7b996aab8 ath9k: remove redundant status variable

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220112080751.667316-1-chi.minghao@zte.com.cn/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

