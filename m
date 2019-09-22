Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F51CBA052
	for <lists+netdev@lfdr.de>; Sun, 22 Sep 2019 05:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727168AbfIVDGm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Sep 2019 23:06:42 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:42681 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727076AbfIVDGm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Sep 2019 23:06:42 -0400
Received: by mail-pf1-f193.google.com with SMTP id q12so6943476pff.9
        for <netdev@vger.kernel.org>; Sat, 21 Sep 2019 20:06:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=DcoF8SnI6DaECtY9bhX/OaglfSzgcvjrMi9Ez30k22c=;
        b=j20B1rh7utJ06pwS/CI39C/1Lgab/aQuLLyD9GV4ZQFbcahq17xzR28Kl6qSz04sbK
         gni94n3IdjU4zWuPPsoVtQukwm2NDpir2x2pNiDe7rLk7fP4AuvMkNQiwMWWHVuZ6eHt
         3vkNl0V0Op2RlZHmFV6Nv06s/SA4w/LAzXDjWZrAt17BI6WwRA1wnQCBjHzAWPPy/i6D
         K5qj0IwHb5jgtCbArxE6QxiitBjfmHaMZ+PjYKvDrQEamfm0Ke6d6JaGqv7Z22ndcIZk
         HyTS914oc3Yiusw+K6c4QYwrVGGQVSI5iw/+aRBEC5DJw+kX/PY/tPToeTQI2Ny8QcRU
         XgYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=DcoF8SnI6DaECtY9bhX/OaglfSzgcvjrMi9Ez30k22c=;
        b=TYo9DlS0PJKpR8UIo02W8DUVp/GhDk1DSls9XEZj8gmRUT5FBKNY3GSkatI3yHaAX8
         1mbloyfskhQQX5Nggmviw+Tgi3f/llfGmls30vPAE2w0ud/Rk4vHitcrDkDQjJoVpeMn
         ZUfu5lr57cQ6RgAD2DIteM1vphw3c2eLXmsyFItd2ZLM2VX6LEi34Z2vAMsNUq5761lR
         jmGi2ffPVuEykRhbs5buNy3tig2lexJyBMbDNcclgPVscATMP4l0XVuvV10q7n4Iwg6h
         J8mcg3B/4c4gGksXXqP0qxbp4F5gtOtS7GKRGKjFidNRQ/K1zFUIOazj/SyMlhI1JB2y
         tk2w==
X-Gm-Message-State: APjAAAU0103rH2om1drc9mkCcsY5YQljx7GOMPPkkCUm34ZiN6g+34Yk
        GyfZI6sh8GqJZvynffizhugoE3QNtbo=
X-Google-Smtp-Source: APXvYqynyO4uU5/MurUlqEVn0zeersUq/LYW86lNwgAskydNrIYWvzDFd9kiIsrDhBkYMbmvU7U9PA==
X-Received: by 2002:a62:64ca:: with SMTP id y193mr26590956pfb.164.1569121601682;
        Sat, 21 Sep 2019 20:06:41 -0700 (PDT)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id 7sm6499110pfi.91.2019.09.21.20.06.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Sep 2019 20:06:41 -0700 (PDT)
Date:   Sat, 21 Sep 2019 20:06:38 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Uwe =?UTF-8?B?S2xlaW5lLUvDtm5pZw==?= <uwe@kleine-koenig.org>
Cc:     Tal Gilboa <talgi@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] dimlib: make DIMLIB a hidden symbol
Message-ID: <20190921200638.5baf40a9@cakuba.netronome.com>
In-Reply-To: <20190920133115.12802-1-uwe@kleine-koenig.org>
References: <20190920133115.12802-1-uwe@kleine-koenig.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 Sep 2019 15:31:15 +0200, Uwe Kleine-K=C3=B6nig wrote:
> According to Tal Gilboa the only benefit from DIM comes from a driver
> that uses it. So it doesn't make sense to make this symbol user visible,
> instead all drivers that use it should select it (as is already the case
> AFAICT).
>=20
> Signed-off-by: Uwe Kleine-K=C3=B6nig <uwe@kleine-koenig.org>
> ---
>  lib/Kconfig | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>=20
> diff --git a/lib/Kconfig b/lib/Kconfig
> index cc04124ed8f7..9fe8a21fd183 100644
> --- a/lib/Kconfig
> +++ b/lib/Kconfig
> @@ -555,8 +555,7 @@ config SIGNATURE
>  	  Implementation is done using GnuPG MPI library
> =20
>  config DIMLIB
> -	bool "DIM library"
> -	default y
> +	bool
>  	help
>  	  Dynamic Interrupt Moderation library.
>  	  Implements an algorithm for dynamically change CQ moderation values

Hi Uwe! Looks like in the net tree there is a spelling mistake and
moderation is spelled "modertion":

https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git/tree/lib/Kcon=
fig#n562

I'm not seeing any patch to fix that anywhere, is it possible you have
some local change in your tree?
