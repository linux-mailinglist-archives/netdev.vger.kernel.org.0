Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAFF35EC720
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 17:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231923AbiI0PBn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 11:01:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231600AbiI0PBk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 11:01:40 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C708915F8;
        Tue, 27 Sep 2022 08:01:32 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id h8-20020a17090a054800b00205ccbae31eso3287937pjf.5;
        Tue, 27 Sep 2022 08:01:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=gZiBMQs0z73rJMB2fq1G2rEopYe6FV32v/POQXxCThI=;
        b=BgPo8+N+HAR7bhrUYKwglwPiXoPs75yN7aqZYK7IjxWA34HsOq/O2zoaAnrORCH0wt
         PCVYZf05hYR/oZXWCTLxoQ9xg8SwJug3ajzuY3XzOq6NJ+kIu4fKogQvGhjv/ajXGCwe
         wg66r3kRUfz4VtC7KwZyNtE9pm46eCqlEGQLIQsr2NNkJlr8r1eVIysfDnxlIqgQZYa9
         WNDBve3USNFI6Ev0Bk1FMMXuxkbi9OjpPPLNXCpNeWQT25mFBv2IRvpoylPDz+pwRxo6
         koRjnwAAPJl/ZlBnwNfm4v4NkFKDgyVghC8L2YyeqJ4axzOMFz4WjwcoixRmkhfgfxBl
         U5yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=gZiBMQs0z73rJMB2fq1G2rEopYe6FV32v/POQXxCThI=;
        b=a9rTwHcT/UzBshVCeHJN29M3FDM+mRp6hNpjtCdf8peH+PXtqNL8Ji3gNvPHU8DBe7
         A3vtiJADq4v6ke9CELca2x/k2WbunklQ6JrzhFo8JC7zbkEMMWyy2Xva8cJnGMFSS0lL
         smObewAevKXPDNMFwJIOeLIPJxrijzhLs/GIgkD+yZRuCgy8WkRokxTrZ0KaJyPWFcXj
         YDQXcd5A6gTwdU7zsxDrUX/ArlSxe3TBrBtxfShd5UPitAC7B5OnhzjyvngflCTl5Uaz
         yj6qWyFe4iGeWixKZe03fhtQOcdbcLtWxZpRjjluJ8r2ElnC2bzhHjHKU18BidvQw513
         SPig==
X-Gm-Message-State: ACrzQf2fjdG6YS1PWFgn74FWTgmmdcBCT1Rve7rLGCnq1BRPVFOT3gT8
        iLdiU20lagAG27TjnjNlHuFmi2ktaVI=
X-Google-Smtp-Source: AMsMyM6xiqjrzeRVGyvvYOMt0uUJUdcZdwvkGUMD7YLVFZvJJ8802sLzaxKNtsFOwZlaTTUbL++60w==
X-Received: by 2002:a17:90b:3505:b0:203:b7b1:2bc3 with SMTP id ls5-20020a17090b350500b00203b7b12bc3mr5148716pjb.242.1664290891506;
        Tue, 27 Sep 2022 08:01:31 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id c3-20020a170903234300b001780e4e6b65sm1691015plh.114.2022.09.27.08.01.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 08:01:31 -0700 (PDT)
Date:   Tue, 27 Sep 2022 08:01:28 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Bo Liu <liubo03@inspur.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptp: Remove usage of the deprecated ida_simple_xxx API
Message-ID: <YzMQSJtLA1LDMGOm@hoboy.vegasvil.org>
References: <20220926012744.3363-1-liubo03@inspur.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220926012744.3363-1-liubo03@inspur.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 25, 2022 at 09:27:44PM -0400, Bo Liu wrote:
> Use ida_alloc_xxx()/ida_free() instead of
> ida_simple_get()/ida_simple_remove().
> The latter is deprecated and more verbose.

I can't say that I am excited about this.  It seems like a way to
create a regression.  I don't see any need to change.  After all,
there are many "deprecated" interfaces in use.

> Signed-off-by: Bo Liu <liubo03@inspur.com>
> ---
>  drivers/ptp/ptp_clock.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
> index 688cde320bb0..51cae72bb6db 100644
> --- a/drivers/ptp/ptp_clock.c
> +++ b/drivers/ptp/ptp_clock.c
> @@ -174,7 +174,7 @@ static void ptp_clock_release(struct device *dev)
>  	mutex_destroy(&ptp->tsevq_mux);
>  	mutex_destroy(&ptp->pincfg_mux);
>  	mutex_destroy(&ptp->n_vclocks_mux);
> -	ida_simple_remove(&ptp_clocks_map, ptp->index);
> +	ida_free(&ptp_clocks_map, ptp->index);
>  	kfree(ptp);
>  }
>  
> @@ -217,7 +217,7 @@ struct ptp_clock *ptp_clock_register(struct ptp_clock_info *info,
>  	if (ptp == NULL)
>  		goto no_memory;
>  
> -	index = ida_simple_get(&ptp_clocks_map, 0, MINORMASK + 1, GFP_KERNEL);
> +	index = ida_alloc_max(&ptp_clocks_map, MINORMASK, GFP_KERNEL);

Typo?   You changed the value of the second argument.

Thanks,
Richard



>  	if (index < 0) {
>  		err = index;
>  		goto no_slot;
> @@ -332,7 +332,7 @@ struct ptp_clock *ptp_clock_register(struct ptp_clock_info *info,
>  	mutex_destroy(&ptp->tsevq_mux);
>  	mutex_destroy(&ptp->pincfg_mux);
>  	mutex_destroy(&ptp->n_vclocks_mux);
> -	ida_simple_remove(&ptp_clocks_map, index);
> +	ida_free(&ptp_clocks_map, index);
>  no_slot:
>  	kfree(ptp);
>  no_memory:
> -- 
> 2.27.0
> 
