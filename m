Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B08347CCC1
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 07:02:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242635AbhLVGCT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 01:02:19 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:52016 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242616AbhLVGCT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 01:02:19 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 75D6A617EB;
        Wed, 22 Dec 2021 06:02:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 087CDC36AE8;
        Wed, 22 Dec 2021 06:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640152937;
        bh=qXyUNNLvS7M9znduJ26fMO1HSy/mFrpEP7RsPdj07tI=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=HCrqFJkbMjlDDzOhgktAVb6qXWZoFcpU/AZnj0Z3/IPuh9ZYhbbfETJ4LaQIx9+Nr
         3QXrrF/no6Vumzu+uZqEoqHfd+nSzElzxJDLx/pWQeIXqDitpNhtMdjOotl4Dxzsx7
         okrSWBIE0zFgfHxAqIJWFnZvwSqRXGKRxgdoSJk6VQryy4AyzJSBSHm9p09xOR167H
         5XCCDKh7W0P4GmtggDJwlHey4t2swarmDnxfK5MWDdpQ2A/i6ieWn9OqOBCCe4kT3M
         ltOSNERqRWeMrk/Pz+Mwm9K4RjFpv/yMPTtWpU8Tsz5XsZV16RXoSqrD3+ubBnH6Lw
         xR2AvySpy1c6Q==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: replace strlcpy with strscpy
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20211221070931.725720-1-wangborong@cdjrlc.com>
References: <20211221070931.725720-1-wangborong@cdjrlc.com>
To:     Jason Wang <wangborong@cdjrlc.com>
Cc:     kuba@kernel.org, davem@davemloft.net, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Wang <wangborong@cdjrlc.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164015293355.20356.17369576129448229832.kvalo@kernel.org>
Date:   Wed, 22 Dec 2021 06:02:15 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jason Wang <wangborong@cdjrlc.com> wrote:

> The strlcpy should not be used because it doesn't limit the source
> length. So that it will lead some potential bugs.
> 
> But the strscpy doesn't require reading memory from the src string
> beyond the specified "count" bytes, and since the return value is
> easier to error-check than strlcpy()'s. In addition, the implementation
> is robust to the string changing out from underneath it, unlike the
> current strlcpy() implementation.
> 
> Thus, replace strlcpy with strscpy.
> 
> Signed-off-by: Jason Wang <wangborong@cdjrlc.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

9d364b828ae5 ath10k: replace strlcpy with strscpy

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20211221070931.725720-1-wangborong@cdjrlc.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

