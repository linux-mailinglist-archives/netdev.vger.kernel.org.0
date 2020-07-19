Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A91BA2252F2
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 19:08:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726097AbgGSRIA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 13:08:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbgGSRIA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 13:08:00 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47717C0619D2
        for <netdev@vger.kernel.org>; Sun, 19 Jul 2020 10:08:00 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id t11so7874670pfq.11
        for <netdev@vger.kernel.org>; Sun, 19 Jul 2020 10:08:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sP1D1TouSE8OLaiBgEq8ysO5gk3dgTEKQtRPfEpvJrc=;
        b=s0fHDGDifHs2yh2TrW415Izc2qFsrEgbBBWpEl31PWJDM9pmuNUOL5mQjDa3mmcE0x
         /VJLvEMdsuzsszcNMM/KLVlFqs12MDZN6yfreznkj7Ef7VIGUAxq/mFThFwHRkcSHeqe
         F/NrEyFYhoN5OfkHK7VSqdg2CqCb26nbW452fkUXF0BCZivwF2pJyThm3d/SKuTDwpj5
         3ixBIUCshz5cy4BEjgGiMOWDEm5blpieqE8Gtix+irG6FTOCcWZdzQasV1Faj852EqPb
         oYK8WEfqkmrXQlIbfFHJUtInt+6JwNgWqMfVcUp3a98PZkX59Uj4TsRJQ6Z9Y5+ZOl8k
         zmSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sP1D1TouSE8OLaiBgEq8ysO5gk3dgTEKQtRPfEpvJrc=;
        b=VxPXGxgtay/QChBQ+FLWN2zsFj+RqaqMKP4RUJQdqYU/E8pJ9JyAKMm6SK61p9amIu
         xZ0NcbylZA+bZ+QAeayOcsPs5+z0+JXPLvL3ogajNEUkBuJKCF+ioy8oVYUYP6uP1/j6
         2IhiSZLIse1OmfBlmGjMYp2ldGCiPR5dNYZ11SKqNfnp/nsff320z6bO6/tNvtanKckD
         9CR5Frv3bFy+prQNauESo3zfv1Q/f7DKwR7Lk9yjio+mFc9l6VlFggvFjP6L/n3i7KXY
         bOQwmu+4Yn19/+axpt7tETF4nU+zLKEHX2Khn/Kuayc+bVWx4E6T1gZiEm9kRByAzrv2
         7Kow==
X-Gm-Message-State: AOAM532RlQoN+K2KxVwPKtO7C4IRL4oZp1TlUOeoBDXPKJov7giHwtHO
        WRSVFVLS8f09DXRDqzUqBZ/IVtpLpeER2g==
X-Google-Smtp-Source: ABdhPJzK7NF9hjBYDlIqbN9A5G4w4u2SzNfDv2LxKz5awWU7eiN5f8x7y11CkN+bNlj22hhNkvfWNA==
X-Received: by 2002:a63:6442:: with SMTP id y63mr15370831pgb.18.1595178479853;
        Sun, 19 Jul 2020 10:07:59 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id i13sm9009552pjd.33.2020.07.19.10.07.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jul 2020 10:07:59 -0700 (PDT)
Date:   Sun, 19 Jul 2020 10:07:56 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jamie Gloudon <jamie.gloudon@gmx.fr>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH iproute2] tc/m_estimator: Print proper value for
 estimator interval in raw.
Message-ID: <20200719100756.5895a292@hermes.lan>
In-Reply-To: <20200717150530.GA2987@defense.gouv.fr>
References: <20200717150530.GA2987@defense.gouv.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 17 Jul 2020 11:05:30 -0400
Jamie Gloudon <jamie.gloudon@gmx.fr> wrote:

> While looking at the estimator code, I noticed an incorrect interval
> number printed in raw for the handles. This patch fixes the formatting.
> 
> Before patch:
> 
> root@bytecenter.fr:~# tc -r filter add dev eth0 ingress estimator
> 250ms 999ms matchall action police avrate 12mbit conform-exceed drop
> [estimator i=4294967294 e=2]
> 
> After patch:
> 
> root@bytecenter.fr:~# tc -r filter add dev eth0 ingress estimator
> 250ms 999ms matchall action police avrate 12mbit conform-exceed drop
> [estimator i=-2 e=2]
> 
> Signed-off-by: Jamie Gloudon <jamie.gloudon@gmx.fr>
> ---
>  tc/m_estimator.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tc/m_estimator.c b/tc/m_estimator.c
> index ef62e1bb..b5f4c860 100644
> --- a/tc/m_estimator.c
> +++ b/tc/m_estimator.c
> @@ -57,7 +57,7 @@ int parse_estimator(int *p_argc, char ***p_argv, struct tc_estimator *est)
>  		return -1;
>  	}
>  	if (show_raw)
> -		fprintf(stderr, "[estimator i=%u e=%u]\n", est->interval, est->ewma_log);
> +		fprintf(stderr, "[estimator i=%hhd e=%u]\n", est->interval, est->ewma_log);
>  	*p_argc = argc;
>  	*p_argv = argv;
>  	return 0;
> --
> 2.17.5
> 

Looks ok to me. Could you update estimator to print JSON as well?
