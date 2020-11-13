Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5E42B14C5
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 04:37:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726050AbgKMDhT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 22:37:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726011AbgKMDhT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 22:37:19 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ABFAC0613D1
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 19:37:01 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id h16so1918800pgb.7
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 19:37:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ATARJHqPD9zawKFyBCkMWKOU4zPAdcvM8fWCyZA632U=;
        b=VHwLJYPkpmKN4VpnYRjE0Q5BIJCJcDUfgmY4mJrLTrLM1mc6nb2iVhTMXCapMxsFVC
         FQ/RuSMdDp+De6Ul6rl2j4GNIkW9jnPkK4NBSknAXo2CBFEXKDrPKRCBzHUySWRSLh3t
         KIDuPvlafIkBNFOrGu9rs+webt7yOTWPV2AgJoFjwWCx9nHJyuUy5X05idnE8huYMWhC
         agoiqM+ddpk9DIxMV53sxitnm0iSeG3Vxov5AomrJqzocCqj05wt87Rr2Cv2cGdcE6ei
         Vx7Mlkhxo72Hle4WneHVtE7txP1pwcHImx24hkIgBzVy+vMbtUGofmwN2XbLRhLNldEF
         n1rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ATARJHqPD9zawKFyBCkMWKOU4zPAdcvM8fWCyZA632U=;
        b=PyFrR2rT2kuUtSqodR5PRMYioDEj4lh9+UlEX4sgNUajdWBTzvdR3NcXstDdP5fTT8
         R7WS07fP7yJpMYgkAvSvDux4c+p//FDxOtaIUzu7jJsnNTsnBcwIFUcLR2SA3hPU7Frg
         COk1obCA9ttTheTdAapCPUb1dwvaxmtci3k3BI1p+di605pTVUO2shPfjfmJp0TYfit3
         9DTYWAU0MN7ct2W3SPwmTatuuoooLw66cQDmo9xn3USp+ZC8WAyFSZeNC9oRCuNEVrxC
         /BFGSDZIhjZfWdjRdCD7aARCz9aeGmFg5WY9+QJjycEpVThRSBDferP1tAPbI0DDbWJ8
         tNMQ==
X-Gm-Message-State: AOAM533NnC3D/wVf/2kVoBIRwg4V1ejhzdirt/VRgKSoNCVx+MYjtNET
        9znq4fSy1+bS9Q/7YKexE34SZ6jL/8uTmDu9
X-Google-Smtp-Source: ABdhPJxKvxCyWw0hCFMYdKphs/Yb6yQeAla7JIwl/wBbA1RXVY77TjRsseZVNAJ69NmdQjiN84zyKA==
X-Received: by 2002:a17:90a:4208:: with SMTP id o8mr584229pjg.19.1605238620597;
        Thu, 12 Nov 2020 19:37:00 -0800 (PST)
Received: from hermes.local (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id t32sm7759545pgl.0.2020.11.12.19.36.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 19:37:00 -0800 (PST)
Date:   Thu, 12 Nov 2020 19:36:56 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Russell Strong <russell@strong.id.au>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: DSCP in IPv4 routing
Message-ID: <20201112193656.73621cd5@hermes.local>
In-Reply-To: <20201113120637.39c45f3f@192-168-1-16.tpgi.com.au>
References: <20201113120637.39c45f3f@192-168-1-16.tpgi.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Nov 2020 12:06:37 +1000
Russell Strong <russell@strong.id.au> wrote:

> diff --git a/include/uapi/linux/in_route.h
> b/include/uapi/linux/in_route.h index 0cc2c23b47f8..db5d236b9c50 100644
> --- a/include/uapi/linux/in_route.h
> +++ b/include/uapi/linux/in_route.h
> @@ -28,6 +28,6 @@
>  
>  #define RTCF_NAT	(RTCF_DNAT|RTCF_SNAT)
>  
> -#define RT_TOS(tos)	((tos)&IPTOS_TOS_MASK)
> +#define RT_TOS(tos)	((tos)&IPTOS_DS_MASK)
>  

Changing behavior of existing header files risks breaking applications.

> diff --git a/net/ipv4/fib_rules.c b/net/ipv4/fib_rules.c
> index ce54a30c2ef1..1499105d1efd 100644
> --- a/net/ipv4/fib_rules.c
> +++ b/net/ipv4/fib_rules.c
> @@ -229,7 +229,7 @@ static int fib4_rule_configure(struct fib_rule
> *rule, struct sk_buff *skb, int err = -EINVAL;
>  	struct fib4_rule *rule4 = (struct fib4_rule *) rule;
>  
> -	if (frh->tos & ~IPTOS_TOS_MASK) {
> +	if (frh->tos & ~IPTOS_RT_MASK) {

This needs to be behind a sysctl and the default has to be to keep
the old behavior
