Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABE363A2160
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 02:23:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230303AbhFJAZI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 20:25:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230250AbhFJAZH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 20:25:07 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E927C061574
        for <netdev@vger.kernel.org>; Wed,  9 Jun 2021 17:22:58 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id e1so25190pld.13
        for <netdev@vger.kernel.org>; Wed, 09 Jun 2021 17:22:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3OhRgLbpp4lKvT+iMbUmetxgnAYdhm7WeY2/cshcDrc=;
        b=F3we5Mz3YMRL6Tht8RcZY5CYUExkUM/JqwRCqTfREoQ9lWtO5oDsOTqwgUI/8Orx3T
         SCbBaQIGqY06KxUfbhKfXHrlxw5ShlU84iMdTYCT+KE0qIPKuQJfRzH/ieDLfbDRFLfQ
         j/8EX3Rk8emKbBnB7ISwS1fYyvHntv4B5KLClFWO239TPsNE954MjeUwh+nJ3u+eBWe0
         E7UodKZ0px6BNxNORr/L+Q/jyx/Qem9XtKdpcSgVeRrS+TSZKqqfekh0N6+nM/4HIRQm
         ri9PiZ6HJkfprvgnqrKU1WWy/QKGk141Z3dxKhKRibhwRyP8BnxFWkF/u4Mqr9I7RldR
         /IxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3OhRgLbpp4lKvT+iMbUmetxgnAYdhm7WeY2/cshcDrc=;
        b=Pu6bMuRC6ZpLJuVkRB22SLIShczxfZ3RqRbhCEqmbF2KArk/QWd20Fn/6maPTOAMyL
         hJM28IBwNv4pzpA6KVEY6Y9hWM8CFef/99c/64u+WWWYjypEBPgMOrv+sp4dhLzgcYkV
         Ngo0AvQUY15qyhn8uUWhJ9UxiKKGxlB/KQzOJS1/u0sDklwy4AQvt2/uFDgm5LqJFelG
         bT5VgV3qNMtT+IJetUtqNUUU4/CFWqeRK+Pzl3v96CRvrlhfH6yQCefN6F8zhSAyoi8j
         ftrcK6SNCNqZqRhVeSXtmJQauiORd3pRhdOp65NIdvRgjOGN9p03WALsJ/ljzD72ViR+
         pJFw==
X-Gm-Message-State: AOAM533sUr9s9xYawbtfzW4GxBiimik/KMogYYfCtPtSZqB9OEUyr2PY
        8W3wneW3dYEAmcZVoQV9wXkdwf20O0QWjB9f
X-Google-Smtp-Source: ABdhPJy55BxO38QOAOyMlKJglv+i3H44nLzc4EfAgArXQgmUjZKsw1Jnba5W1q+UGBjgaBHh+9153w==
X-Received: by 2002:a17:90b:384b:: with SMTP id nl11mr341664pjb.147.1623284578100;
        Wed, 09 Jun 2021 17:22:58 -0700 (PDT)
Received: from hermes.local (76-14-218-44.or.wavecable.com. [76.14.218.44])
        by smtp.gmail.com with ESMTPSA id s3sm798949pgs.62.2021.06.09.17.22.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 17:22:57 -0700 (PDT)
Date:   Wed, 9 Jun 2021 17:22:49 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Carl Bordum Hansen <carl@bordum.dk>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] ip link docs: mention wireguard interface type
Message-ID: <20210609172249.6eb3b05d@hermes.local>
In-Reply-To: <20210604230534.104899-1-carl@bordum.dk>
References: <20210604230534.104899-1-carl@bordum.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  5 Jun 2021 01:05:34 +0200
Carl Bordum Hansen <carl@bordum.dk> wrote:

> Signed-off-by: Carl Bordum Hansen <carl@bordum.dk>
> ---
>  ip/iplink.c           | 2 +-
>  man/man8/ip-link.8.in | 6 +++++-
>  2 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/ip/iplink.c b/ip/iplink.c
> index 27c9be44..d676a8de 100644
> --- a/ip/iplink.c
> +++ b/ip/iplink.c
> @@ -123,7 +123,7 @@ void iplink_usage(void)
>  			"	   gre | gretap | erspan | ip6gre | ip6gretap | ip6erspan |\n"
>  			"	   vti | nlmon | team_slave | bond_slave | bridge_slave |\n"
>  			"	   ipvlan | ipvtap | geneve | bareudp | vrf | macsec | netdevsim | rmnet |\n"
> -			"	   xfrm }\n");
> +			"	   xfrm | wireguard }\n");


That part of the code has changed recently on main branch, your change no longer applies.

>  	}
>  	exit(-1);
>  }
> diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
> index fd67e611..6fbd5bf4 100644
> --- a/man/man8/ip-link.8.in
> +++ b/man/man8/ip-link.8.in
> @@ -231,7 +231,8 @@ ip-link \- network device configuration
>  .BR macsec " |"
>  .BR netdevsim " |"
>  .BR rmnet " |"
> -.BR xfrm " ]"
> +.BR xfrm " |"
> +.BR wireguard " ]"

List should be alphabetical

>  
>  .ti -8
>  .IR ETYPE " := [ " TYPE " |"
> @@ -377,6 +378,9 @@ Link types:
>  .sp
>  .BR xfrm
>  - Virtual xfrm interface
> +.sp
> +.BR wireguard
> +- Wireguard interface
>  .in -8
>  
>  .TP

