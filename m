Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 929972F3715
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 18:29:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391093AbhALR1l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 12:27:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732976AbhALR1l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 12:27:41 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D07CFC061575;
        Tue, 12 Jan 2021 09:27:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=5tDr7aGlDz3PeLcWiqxZrrnAZ5+05QuRz8RnWDW1ykk=; b=coFDAqFatOSMe9YScssCANk8Ou
        ckZ1ZnzvJ3fNKx14nYfPTRzdg0wKfn+J3Cu66Dd3vn0yLqhUjzoTRWp6vr/hf6kw3DKJWd+4eeQZN
        oBcjdHXfa+VtsxlgaQnp9e7KyQnvtuOu/ONtSLb/lY7W4Q5aqULLy00YzsIKBKd+ba24W6Svm4zl+
        X955olxkuAvxGDGJHhgAlBOjcuhzieuYWCd20TWsz8v/n8F4aG2vpGg8+79/et3K6l2XiAGt/kMJh
        xrZVM/mgCtCl30KH5MAzgytKJLu8+OWBlZDkSEpRpr28yh9NDFMOnDJOuCTmk5PCsSxVKP4c0mw/9
        sTCg3rfw==;
Received: from [2601:1c0:6280:3f0::79df]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kzNRW-0005Z8-UB; Tue, 12 Jan 2021 17:26:55 +0000
Subject: Re: [PATCH V3] drivers: net: marvell: Fixed two spellings,controling
 to controlling and oen to one
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, mw@semihalf.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        gustavo@embeddedor.com
References: <20210112103152.13222-1-unixbhaskar@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <2cf30ec7-07cc-650c-d94b-a9cd7aadb906@infradead.org>
Date:   Tue, 12 Jan 2021 09:26:48 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20210112103152.13222-1-unixbhaskar@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/12/21 2:31 AM, Bhaskar Chowdhury wrote:
> s/oen/one/
> s/controling/controlling/
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

> ---
> Changes from V2 : Correct the versioning,mentioned both the changes
> 
>  drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.h
> index 8867f25afab4..663157dc8062 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.h
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.h
> @@ -143,7 +143,7 @@ struct mvpp2_cls_c2_entry {
>  /* Number of per-port dedicated entries in the C2 TCAM */
>  #define MVPP22_CLS_C2_PORT_N_FLOWS	MVPP2_N_RFS_ENTRIES_PER_FLOW
> 
> -/* Each port has oen range per flow type + one entry controling the global RSS
> +/* Each port has one range per flow type + one entry controlling the global RSS
>   * setting and the default rx queue
>   */
>  #define MVPP22_CLS_C2_PORT_RANGE	(MVPP22_CLS_C2_PORT_N_FLOWS + 1)
> ./--
> 2.26.2
> 


-- 
~Randy

