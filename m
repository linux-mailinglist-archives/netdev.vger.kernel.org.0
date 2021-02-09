Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D511315AAA
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 01:10:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234989AbhBJAH4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 19:07:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234480AbhBIXn1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 18:43:27 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4A69C061756;
        Tue,  9 Feb 2021 15:42:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=JqZPtG/TB/XswZSw5bmUCRK7B7+cprRdrJrDelTSrfY=; b=HNMpo/bbOD2d3JnJjyc1rkAKZb
        DruBe+JtYzJ8aBmUnsFVFwDUEzvWEgXsSBk8E2hD4SLckUg1H7IFfjgywjGLGBJ1KgGiZN3ZaUNYq
        NfKUR/tvgb+iUKU2TVDWyvgUOYxjELmoB23XR6QJWZ/MfbsF2U2gUIJO5Twgf0EiQNks82QKQ4FtH
        xb5GVU/Qo7mRktdpPitUMnhLJcjIkdH/ZTe/V0cTQtc5ZOMwFXqh9/nMy11NRN+I1lZNWV8hcoMr/
        euPS9q9u9UdCKm9eeEffKtKRLNa11tMSg9V5IQ6NYyYMKB7slfRZCXsqtoL/Gu7b11Bz0kUNYC74M
        SV2qZwwQ==;
Received: from [2601:1c0:6280:3f0::cf3b]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1l9ceQ-0005x6-QP; Tue, 09 Feb 2021 23:42:35 +0000
Subject: Re: [PATCH] wireless: brcm80211: Fix the spelling configation to
 configuration in the file d11.h
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, kuba@kernel.org,
        davem@davemloft.net, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210209232921.1255425-1-unixbhaskar@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <b5dbd677-f932-dcd0-0615-4989725510d1@infradead.org>
Date:   Tue, 9 Feb 2021 15:42:28 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210209232921.1255425-1-unixbhaskar@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/9/21 3:29 PM, Bhaskar Chowdhury wrote:
> 
> s/configation/configuration/
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmsmac/d11.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/d11.h b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/d11.h
> index 9035cc4d6ff3..dc395566e495 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/d11.h
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/d11.h
> @@ -1469,7 +1469,7 @@ struct d11rxhdr {
>  /* htphy PhyRxStatus_1: */
>  /* core enables for {3..0}, 0=disabled, 1=enabled */
>  #define PRXS1_HTPHY_CORE_MASK	0x000F
> -/* antenna configation */
> +/* antenna configuration */
>  #define PRXS1_HTPHY_ANTCFG_MASK	0x00F0
>  /* Mixmode PLCP Length low byte mask */
>  #define PRXS1_HTPHY_MMPLCPLenL_MASK	0xFF00
> --
> 2.30.0
> 


-- 
~Randy

