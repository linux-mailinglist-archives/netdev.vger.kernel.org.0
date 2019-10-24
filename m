Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D260BE3E43
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 23:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729342AbfJXVew (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 17:34:52 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:33012 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726386AbfJXVev (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 17:34:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=IZQJFNpYUYmrmYD2pl3WhIXeTRC9Ye4KtRWu2hxooI4=; b=PckC3OkePRDuLc+fS+5PP7mtY
        rKNs0JDtJFiG+7V0FFHdkIp+bj1ouh8bGbz3rGhG1nkwj1IiNAWaXBqUgXzp0wafSLLkpM5nDodfJ
        tWkQmn/1Jpgse0eerkyUHQAiEYwcVrDKXfK6xrOlfauxXtdxoe3j2LVWhnQJ0l7hwYhodSVVmzJ3r
        C1Ug12g6tJnlj1qxgJcrQap4dot4tureYLtecj8PAjwZcDkMRaNQ5UQCSaCb+oKny0zOtzA3edpWQ
        cX8GRuW1bJ0n6yAkHFxhysGysXj/oBOJs7DZw4gS/QFBa4bwHGlgZIs30S99SUZVwIm9dpdhe2Pnb
        yLebSzKNA==;
Received: from [2601:1c0:6280:3f0::9ef4]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iNkko-0007wS-NI; Thu, 24 Oct 2019 21:34:46 +0000
Subject: Re: [PATCH] mac80211: typo fixes in kerneldoc comments
To:     Chris Packham <chris.packham@alliedtelesis.co.nz>,
        johannes@sipsolutions.net, davem@davemloft.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        trivial@kernel.org, linux-kernel@vger.kernel.org
References: <20191024212915.4201-1-chris.packham@alliedtelesis.co.nz>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <34877d81-728b-f4fe-0480-f9cb1b5ace4e@infradead.org>
Date:   Thu, 24 Oct 2019 14:34:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191024212915.4201-1-chris.packham@alliedtelesis.co.nz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/24/19 2:29 PM, Chris Packham wrote:
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 523c6a09e1c8..93d774e0d082 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -312,7 +312,7 @@ struct ieee80211_vif_chanctx_switch {
>   * @BSS_CHANGED_KEEP_ALIVE: keep alive options (idle period or protected
>   *	keep alive) changed.
>   * @BSS_CHANGED_MCAST_RATE: Multicast Rate setting changed for this interface
> - * @BSS_CHANGED_FTM_RESPONDER: fime timing reasurement request responder
> + * @BSS_CHANGED_FTM_RESPONDER: fine timing reasurement request responder

                                              measurement

>   *	functionality changed for this BSS (AP mode).
>   * @BSS_CHANGED_TWT: TWT status changed
>   * @BSS_CHANGED_HE_OBSS_PD: OBSS Packet Detection status changed.

thanks.
-- 
~Randy

