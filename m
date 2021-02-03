Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7828930D41A
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 08:35:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232091AbhBCHew (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 02:34:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231560AbhBCHeo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 02:34:44 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 250A2C06174A;
        Tue,  2 Feb 2021 23:33:49 -0800 (PST)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1l7CfJ-00FKfW-BY; Wed, 03 Feb 2021 08:33:29 +0100
Message-ID: <9200710b2d9dafea4bfae4bb449a55fb44245d04.camel@sipsolutions.net>
Subject: Re: [PATCH] wireless: fix typo issue
From:   Johannes Berg <johannes@sipsolutions.net>
To:     samirweng1979 <samirweng1979@163.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        wengjianfeng <wengjianfeng@yulong.com>
Date:   Wed, 03 Feb 2021 08:33:23 +0100
In-Reply-To: <20210203070025.17628-1-samirweng1979@163.com>
References: <20210203070025.17628-1-samirweng1979@163.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-02-03 at 15:00 +0800, samirweng1979 wrote:
> From: wengjianfeng <wengjianfeng@yulong.com>
> 
> change 'iff' to 'if'.
> 
> Signed-off-by: wengjianfeng <wengjianfeng@yulong.com>
> ---
>  net/wireless/chan.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/wireless/chan.c b/net/wireless/chan.c
> index 285b807..2f17edf 100644
> --- a/net/wireless/chan.c
> +++ b/net/wireless/chan.c
> @@ -1084,7 +1084,7 @@ bool cfg80211_chandef_usable(struct wiphy *wiphy,
>   * associated to an AP on the same channel or on the same UNII band
>   * (assuming that the AP is an authorized master).
>   * In addition allow operation on a channel on which indoor operation is
> - * allowed, iff we are currently operating in an indoor environment.
> + * allowed, if we are currently operating in an indoor environment.
>   */

I suspect that was intentional, as a common abbreviation for "if and
only if".

johannes

