Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E79484AE025
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 18:58:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236901AbiBHR6H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 12:58:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385134AbiBHR5z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 12:57:55 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8407C03FEF6
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 09:57:32 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id w20so5218647plq.12
        for <netdev@vger.kernel.org>; Tue, 08 Feb 2022 09:57:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BxRYCCAmLrhwkvVRq3ywvApfEBJJjt5ZkHgrGpdB/V8=;
        b=lhFI02mu0CJbT5iQl+zP1TuhOoA1SeBvrDl5ue1qQ/65ePMZnXWj28a8KNnu4LKNDH
         BjR7R93Xw82iurWhVbzMF+KYLTSIbaGO8C+PKD5XdK0fuAch2L7e4YHBD4GqVnaHAFed
         p20J2WK2FCKgdCWfF9intkQtCpycBmu9bhHu2HQRgV7h1RJZYoPlH9LUcVlU/mSQyzav
         zbp2hOGZt8o3PlNqgqV+tD7bDFNOIaIemsEaYKAqdN+Q25odPPj91Ob3YUti+ri0W0+b
         IQm4yGfN4nefuge7ENDvpbJA9+9l41RaH8LkyigqgatO8fRQOv6pBvr1JMVYPOrgngH0
         Ug+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BxRYCCAmLrhwkvVRq3ywvApfEBJJjt5ZkHgrGpdB/V8=;
        b=qPgxVd1kiiauN3ZHVAncMPtUkIyg3gnBzZkePjWGjx9PrEG6CN7TpGvkEKzePEimRB
         DvQv3zPPh20JIMF2gYlZuGO6dcYcb9kEBLBQ8xZwVZd1F2pFhdK/37/n+l36+lh8qMFi
         +4SdV9YHIUqqImiUm4eOHGZqkR8b1BW5tUg7822q+XEMiLWQ8YZaOPeqXOmQJux//tFh
         igKMmO8DF9iblRCYf8JKstGEM3cowlUIwF1+HZ+TwxmueO08t1B62tnwXicMFg+m3DF3
         5ZLjWKni7qKx8nueQOfyk40eITxHZHFQnUTaJZBC4Y0KZiRtn7Qh9Lyt9xCRVmzaa2+W
         aiFA==
X-Gm-Message-State: AOAM530VadN8qVRnJvv3mPqpubDxSwK3qOeKT7JE52m8VqxCb7sczSKV
        lcOUwpmFJ8EEmhFZ/S2Ytuucaw==
X-Google-Smtp-Source: ABdhPJwguKWTLWg1vD89Lh5Cpzxv/t43NNGVg6+qTJkVG4jxhQfXPZA/Hj9sRAQvdWz21O2jvVD8LQ==
X-Received: by 2002:a17:903:2350:: with SMTP id c16mr5745362plh.4.1644343052217;
        Tue, 08 Feb 2022 09:57:32 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id z13sm16525070pfe.20.2022.02.08.09.57.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 09:57:31 -0800 (PST)
Date:   Tue, 8 Feb 2022 09:57:29 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Gal Pressman <gal@nvidia.com>
Cc:     David Ahern <dsahern@gmail.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH iproute2-next] tunnel: Fix missing space after
 local/remote print
Message-ID: <20220208095729.35701fd7@hermes.local>
In-Reply-To: <20220208144005.32401-1-gal@nvidia.com>
References: <20220208144005.32401-1-gal@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 8 Feb 2022 16:40:05 +0200
Gal Pressman <gal@nvidia.com> wrote:

> The cited commit removed the space after the local/remote tunnel print
> and resulted in "broken" output:
> 
> gre remote 1.1.1.2local 1.1.1.1ttl inherit erspan_ver 0 addrgenmode eui64 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
>     ^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> Fixes: 5632cf69ad59 ("tunnel: fix clang warning")
> Signed-off-by: Gal Pressman <gal@nvidia.com>
> ---
>  ip/tunnel.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/ip/tunnel.c b/ip/tunnel.c
> index f2632f43babf..7200ce831317 100644
> --- a/ip/tunnel.c
> +++ b/ip/tunnel.c
> @@ -299,6 +299,8 @@ void tnl_print_endpoint(const char *name, const struct rtattr *rta, int family)
>  	}
>  
>  	print_string_name_value(name, value);
> +	if (!is_json_context())
> +		print_string(PRINT_FP, NULL, " ", NULL);

is_json_context is not needed here.

