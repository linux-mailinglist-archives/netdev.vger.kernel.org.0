Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6FFE40044E
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 19:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350014AbhICRuB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 13:50:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349916AbhICRuB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 13:50:01 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16E6AC061575;
        Fri,  3 Sep 2021 10:49:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=OJ2pEw5jPPStfKuNWXFd6825jYJnL3pOyXkglFCIiQ4=; b=pwlxB4IL3DK1Eftvqa6FVK++Yc
        coLVKGyAD06wolmKKZjYt/FJE7rS1cPtB/k5RwW+exKdv5MFxxXxlQ1AqhpCgJdWF078l3AweMU4F
        y0uDq++WnpDSBj1MOqrVGcUifhMQWoGXObMhAxWVfhhLoEATtpz798h/V8t+cG461E1qMODC3iNvq
        +j9u3ZE0VWiUru3vhJzP0Z8VUSvA+EKDEiv3jGqoeuXVn5jm8Gx602Ehzz9/zwQyICK+jUpbeM/1o
        q6Bg2m0GvfDya+8BbKOsq4iFQmrvyds97Re89fhTPvIuzmKICNif99ecRvOtclR9Xyw6M3tD22wuX
        6qJn/jnw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mMDJ9-00CVS0-My; Fri, 03 Sep 2021 17:48:55 +0000
Date:   Fri, 3 Sep 2021 10:48:55 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     dingsenjie@163.com
Cc:     jirislaby@kernel.org, mickflemm@gmail.com, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dingsenjie <dingsenjie@yulong.com>
Subject: Re: [PATCH] wireless: ath5k: Remove unnecessary label of
 ath5k_beacon_update
Message-ID: <YTJgB4MNNolkrLYS@bombadil.infradead.org>
References: <20210903062316.11756-1-dingsenjie@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210903062316.11756-1-dingsenjie@163.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 03, 2021 at 02:23:16PM +0800, dingsenjie@163.com wrote:
> From: dingsenjie <dingsenjie@yulong.com>
> 
> The label just used as return, so we delete it and
> use the return statement instead of the goto statement.
> 
> Signed-off-by: dingsenjie <dingsenjie@yulong.com>
> ---
>  drivers/net/wireless/ath/ath5k/base.c | 13 ++++---------
>  1 file changed, 4 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
> index 4c6e57f..9739189 100644
> --- a/drivers/net/wireless/ath/ath5k/base.c
> +++ b/drivers/net/wireless/ath/ath5k/base.c
> @@ -1896,23 +1896,18 @@ static int ath5k_remove_padding(struct sk_buff *skb)
>  	struct ath5k_vif *avf;
>  	struct sk_buff *skb;

Just initialize ret = -EINVAL at the top, and you to get clear out a few
braces which are not needed anymore. Anyway, this code is not reflected
on linux-next, what codebase are you using? If the code change is just
a cleanup it should remove more code than add, and a commmit log should
reflect that clearly.

  Luis
