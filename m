Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82C3F193889
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 07:23:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbgCZGXF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 02:23:05 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:35154 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbgCZGXF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 02:23:05 -0400
Received: by mail-pg1-f194.google.com with SMTP id k5so164498pga.2;
        Wed, 25 Mar 2020 23:23:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lt7yrnjsGfLWhUnaKSDp8NGgMCEtuDxazSlsfgBqGYU=;
        b=GOVyjRW+U1nVRRXyOJvyb8y1g3sWhXJMZy05wVSiEZduEbtEu+vsLTFI7AWLfu+LUa
         bqKyU4C1AoteBb4LhHjl4UpRf0WMMUe69biMuqjkXy/N0p41G4MnVOAiPRqXKxoUjIp9
         BL8tjX+rsmwKSSgiOkm5LLin7WZVwyzJbBjHfLaiFSmKzHOSjHGh7gjktKZWN1VWwei9
         YWKTrynogWMd3dzA41BLVJ2DF3UdG7b+l1JwxdqDVTOZ71zBq67ruwvQjDRajlt5k/FF
         5EnXsNzwk9XUpODyCDjORkEdpDN0xb4hUfWtw+BjGDZrUOX2DyoFKlB1bwGpJWV8nJ7L
         r3Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lt7yrnjsGfLWhUnaKSDp8NGgMCEtuDxazSlsfgBqGYU=;
        b=JEowKjuppy/uk678ysQyR77md834aFAzAd4z/S0Q+Z+GFlW4GPd8Uf3J1Autd9cFs1
         q+7/Pl9SdNnGJ+p7BLz0Jh1xayAGRMAgKLVHI4DpFvLxrs39byHkQmKvU7XmFvGUKd1P
         xejZ0be/gIwVavFzQ4fKIMnrRHL4mvFpEFX5eP5mhgig8AYwLUrLPA0ttxLdgGuc9egZ
         FaBPXBp22R8XisGLibBnyIAkBxCjeyGbBE0G/RmrOsUT7v+nMYrzkPAcxT4u5S32lSa9
         gx4ExX+gvyEDjX5jlm8H8tB+TfU1fB+3gPFil4uUZ24V10/YgPpIGKZSwNa4Vleon77s
         q64Q==
X-Gm-Message-State: ANhLgQ0pUzK6dVNvw4luspn7+xObFCtEwKYjBhTnPa6vckZ83xSaV613
        wT1d7XICy+/sSyy4FXTuvrNdjl+3
X-Google-Smtp-Source: ADFU+vvrAGn6VSiJh5PWCQ+fKV19O+mFsxqWpX0B3uCrugGh2pOTNAyhwnInWVuwf9yhbEAdhnkxVw==
X-Received: by 2002:a63:705e:: with SMTP id a30mr7122635pgn.128.1585203784031;
        Wed, 25 Mar 2020 23:23:04 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:5929])
        by smtp.gmail.com with ESMTPSA id i26sm792975pfk.176.2020.03.25.23.23.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 23:23:03 -0700 (PDT)
Date:   Wed, 25 Mar 2020 23:23:01 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     ecree@solarflare.com, yhs@fb.com, daniel@iogearbox.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [bpf-next PATCH 05/10] bpf: verifier, return value is an int in
 do_refine_retval_range
Message-ID: <20200326062301.fvomwkz5grg3b5qb@ast-mbp>
References: <158507130343.15666.8018068546764556975.stgit@john-Precision-5820-Tower>
 <158507155667.15666.4189866174878249746.stgit@john-Precision-5820-Tower>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158507155667.15666.4189866174878249746.stgit@john-Precision-5820-Tower>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 24, 2020 at 10:39:16AM -0700, John Fastabend wrote:
> Mark 32-bit subreg region with max value because do_refine_retval_range()
> catches functions with int return type (We will assume here that int is
> a 32-bit type). Marking 64-bit region could be dangerous if upper bits
> are not zero which could be possible.
> 
> Two reasons to pull this out of original patch. First it makes the original
> fix impossible to backport. And second I've not seen this as being problematic
> in practice unlike the other case.
> 
> Fixes: 849fa50662fbc ("bpf/verifier: refine retval R0 state for bpf_get_stack helper")
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---
>  kernel/bpf/verifier.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 6372fa4..3731109 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -4328,7 +4328,7 @@ static void do_refine_retval_range(struct bpf_reg_state *regs, int ret_type,
>  	     func_id != BPF_FUNC_probe_read_str))
>  		return;
>  
> -	ret_reg->smax_value = meta->msize_max_value;
> +	ret_reg->s32_max_value = meta->msize_max_value;

I think this is not correct.
These two special helpers are invoked via BPF_CALL_x() which has u64 return value.
So despite having 'int' return in bpf_helper_defs.h the upper 32-bit will be correct.
I think this patch should do:
ret_reg->smax_value = meta->msize_max_value;
ret_reg->s32_max_value = meta->msize_max_value;
