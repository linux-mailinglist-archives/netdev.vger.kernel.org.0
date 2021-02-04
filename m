Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45D0930EB08
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 04:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234563AbhBDDgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 22:36:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234299AbhBDDgO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 22:36:14 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B653C0613D6;
        Wed,  3 Feb 2021 19:35:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=RTA4Y7T9qGIKM9F3nJcTBv5m2a4gpWmNB7L4kQjCvhI=; b=WLTxlOP161Gc0fjjMp/Rsuw7Vk
        OeBQ2dLdVPhhHHeWwSPHMyeULAURxHtwVVL0+ADk95prJ/ivhvqmyHjPkckbgq47aOv4ht9IR6RxQ
        pyQegFiuHZ8I+XTd1q/scLeTEGj4XfBoKMucj7RvYNvfGmK+wi99tsddLvSSNPadO0kbyCMMfQUrQ
        PlSWQCowNMg4EwFbC76kKGScviy5qS3dLvGNQRz/2RhqPl/4zTIsf9WneSwHJju0+pTCDdCYftX2e
        gyj/DgI+Z+lw/pypNU7DvlsiUF6eosOgFbQH6dxrdLJT3WifY2qyEgeQgOwvWMjBvldnkWh5m5GOY
        EZnphLug==;
Received: from [2601:1c0:6280:3f0::aec2]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1l7VQa-0007B5-0I; Thu, 04 Feb 2021 03:35:32 +0000
Subject: Re: [PATCH V3] drivers: net: ethernet: i825xx: Fix couple of
 spellings in the file ether1.c
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210204031648.27300-1-unixbhaskar@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <fca68f0f-e1f9-c6d0-3287-b889e22ce1eb@infradead.org>
Date:   Wed, 3 Feb 2021 19:35:27 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20210204031648.27300-1-unixbhaskar@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/3/21 7:16 PM, Bhaskar Chowdhury wrote:
> 
> 
> s/initialsation/initialisation/
> s/specifiing/specifying/
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>

Aside from the Subject: being longer than needed, as Jakub commented,
it's fine for me.  Thanks.

Acked-by: Randy Dunlap <rdunlap@infradead.org>


> ---
> Changes from V2:
>    Adjust and make changes which are obvious as per Randy's suggestions
> 
>  drivers/net/ethernet/i825xx/ether1.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/i825xx/ether1.c b/drivers/net/ethernet/i825xx/ether1.c
> index a0bfb509e002..c612ef526d16 100644
> --- a/drivers/net/ethernet/i825xx/ether1.c
> +++ b/drivers/net/ethernet/i825xx/ether1.c
> @@ -20,7 +20,7 @@
>   * 1.02	RMK	25/05/1997	Added code to restart RU if it goes not ready
>   * 1.03	RMK	14/09/1997	Cleaned up the handling of a reset during the TX interrupt.
>   *				Should prevent lockup.
> - * 1.04 RMK	17/09/1997	Added more info when initialsation of chip goes wrong.
> + * 1.04 RMK	17/09/1997	Added more info when initialisation of chip goes wrong.
>   *				TDR now only reports failure when chip reports non-zero
>   *				TDR time-distance.
>   * 1.05	RMK	31/12/1997	Removed calls to dev_tint for 2.1
> @@ -117,7 +117,7 @@ ether1_outw_p (struct net_device *dev, unsigned short val, int addr, int svflgs)
>   * Some inline assembler to allow fast transfers on to/off of the card.
>   * Since this driver depends on some features presented by the ARM
>   * specific architecture, and that you can't configure this driver
> - * without specifiing ARM mode, this is not a problem.
> + * without specifying ARM mode, this is not a problem.
>   *
>   * This routine is essentially an optimised memcpy from the card's
>   * onboard RAM to kernel memory.
> --


-- 
~Randy

