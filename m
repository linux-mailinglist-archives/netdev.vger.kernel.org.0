Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABFBA1E093C
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 10:48:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389248AbgEYIr6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 04:47:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388800AbgEYIr6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 04:47:58 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0468C061A0E;
        Mon, 25 May 2020 01:47:57 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jd8ls-002abo-Ls; Mon, 25 May 2020 10:47:44 +0200
Message-ID: <ab7cac9c73dc8ef956a1719dc090167bcfc24b63.camel@sipsolutions.net>
Subject: Re: [PATCH] mac80211_hwsim: report the WIPHY_FLAG_SUPPORTS_5_10_MHZ
 capability
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Ramon Fontes <ramonreisfontes@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Cc:     kvalo@codeaurora.org, davem@davemloft.net
Date:   Mon, 25 May 2020 10:47:43 +0200
In-Reply-To: <20200515164640.97276-1-ramonreisfontes@gmail.com> (sfid-20200515_184649_139967_003E7ED8)
References: <20200515164640.97276-1-ramonreisfontes@gmail.com>
         (sfid-20200515_184649_139967_003E7ED8)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.2 (3.36.2-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-05-15 at 13:46 -0300, Ramon Fontes wrote:
> Signed-off-by: Ramon Fontes <ramonreisfontes@gmail.com>
> ---
>  drivers/net/wireless/mac80211_hwsim.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
> index 0528d4cb4..67f97ac36 100644
> --- a/drivers/net/wireless/mac80211_hwsim.c
> +++ b/drivers/net/wireless/mac80211_hwsim.c
> @@ -2995,6 +2995,7 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
>  	hw->wiphy->flags |= WIPHY_FLAG_SUPPORTS_TDLS |
>  			    WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL |
>  			    WIPHY_FLAG_AP_UAPSD |
> +                            WIPHY_FLAG_SUPPORTS_5_10_MHZ |

Not sure this is enough? How about wmediumd, for example?

And also, 5/10 MHz has many more channels inbetween the normal ones, no?
Shouldn't those also be added?

johannes

