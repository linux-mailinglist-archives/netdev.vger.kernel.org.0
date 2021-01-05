Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B58352EB0E7
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 18:04:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730189AbhAERDm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 12:03:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725868AbhAERDl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 12:03:41 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B3DBC061574;
        Tue,  5 Jan 2021 09:03:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=rMPv1IvmKfzbItAZ3NuTy2uqOFR0uICt6s7TBvhS5Uo=; b=FGmN7u/uPtpVsj1L52gZ0QmtBt
        jqT1wClSJEmA7r9BZPIheBXpgc3nlI1dYNQDZ9iaHKE+tQ+ZffvDM51J9JDezkj54FeKdyPSxZikQ
        L41nHX5qk6Xs+FphUW29YzRALK/y3XOVFPJTia8cHiw5p0/P35m7HT7Ti/D0RHDc0Edhlhhw7u6r0
        UvalQ3PTKkuc4IeR5RyKJQQrV+CpFUQ1kHwqwilnrki2tWHFDuh0OeoLwtKze3vzBcKl8U6EDX4Sj
        UJVu5v2umP5pUbAwl61DnGqIbgn7siJradVZk8pi4D4Nj3XkAlXCJVxAkzCPC8fg6UgOH7rQqhMdV
        5ZfNBnOA==;
Received: from [2601:1c0:6280:3f0::64ea]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kwpjU-0000V5-Ok; Tue, 05 Jan 2021 17:02:57 +0000
Subject: Re: [PATCH] drivers: net: wireless: realtek: Fix the word association
 defautly de-faulty
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, pkshih@realtek.com,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        Larry.Finger@lwfinger.net, zhengbin13@huawei.com,
        baijiaju1990@gmail.com, christophe.jaillet@wanadoo.fr,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210105101738.13072-1-unixbhaskar@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <35a634c1-3672-b757-101e-9b8f3c0163a7@infradead.org>
Date:   Tue, 5 Jan 2021 09:02:46 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20210105101738.13072-1-unixbhaskar@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/5/21 2:17 AM, Bhaskar Chowdhury wrote:
> s/defautly/de-faulty/p
> 
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
> ---
>  drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
> index c948dafa0c80..7d02d8abb4eb 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
> @@ -814,7 +814,7 @@ bool rtl88ee_is_tx_desc_closed(struct ieee80211_hw *hw, u8 hw_queue, u16 index)
>  	u8 own = (u8)rtl88ee_get_desc(hw, entry, true, HW_DESC_OWN);
> 
>  	/*beacon packet will only use the first
> -	 *descriptor defautly,and the own may not
> +	 *descriptor de-faulty,and the own may not
>  	 *be cleared by the hardware
>  	 */
>  	if (own)
> --

Yes, I agree with "by default". I don't know what "the own"
means.

Also, there should be a space after each beginning "*.

I saw another patch where the comment block began with /**,
which should mean "begin kernel-doc comment block", but it's
not kernel-doc, so that /** should be changed to just "/*".


-- 
~Randy

