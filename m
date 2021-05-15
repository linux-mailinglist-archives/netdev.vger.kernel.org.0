Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6193D381AF6
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 22:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234815AbhEOUSN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 16:18:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231280AbhEOUSM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 May 2021 16:18:12 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C13FFC061573
        for <netdev@vger.kernel.org>; Sat, 15 May 2021 13:16:58 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id c20so3437931ejm.3
        for <netdev@vger.kernel.org>; Sat, 15 May 2021 13:16:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-disposition:in-reply-to;
        bh=p4+4voOVtneXUQw0Tbb7XWOawuWKBJcb4CODcRdpLOM=;
        b=Rx+FNibRRb99gg4vdgx3OfRmrmt5eCiUZQ/9NmCwx3VVBXikCXsLj+DHRMhTKXP+Wp
         kR7PAu53RxKfX0xOo4qBAw67Mn8eb3fsX7cKA+fL8EgZa8byTFOxobRwKJkMVq3j24e3
         msAzUZ263/0g2t2t7ln23FWp3R0tBv6iSIy0bOMEJ+rhd3q2FDo0+K0d3uJWLZeegPZ8
         lxF0SgAz7XcYFmvzxAUHnXKG/IhuAb3mgGzz/aCJ3muh1LdiKiridVmubgNHFocaSHho
         gnnU0HSOGR+BNKjTtOInZFPaD+dFPT0qCjzKnCLo6XkhBg5wTK3kDaLctFzaVgz49kfd
         TQmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:reply-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=p4+4voOVtneXUQw0Tbb7XWOawuWKBJcb4CODcRdpLOM=;
        b=VccFlax8b3oqTgwaqL7Cq/YvJSm2RsuyVPyH0zf/Cli3c/B8BWpPr1BgCrF6SfmZ33
         1nhDI5KrcXt9UoWHVTD1Zn2qphtn4LEENRAAXl87iDPnVh5npLkVe5WeUQ9rUN1PPL5e
         Nj8KGFnWtikECEgMCAMIAy0TSCPwmlkOFqrMutiH6TteY9iQQIV6NCVO8r31qOcyjWUI
         scJe5N/DH17XvR2G4I0KoifSHpb3hUiuDpQIvkwgQO9ZEjPikrFyVXx3Dw/rRBazIcK2
         RahjJSu0LVSJbkxxy8tdl95wRozxeINaYJzIYR7wns0KC1JJ/ZJVzosZqxH08OC1tzKr
         HYBQ==
X-Gm-Message-State: AOAM532kJF0TzaGApr1Nml7fwqRJRvTKV6NjKaxgxXOF58IXE7x/oj1s
        HZsJvEoovaLr1sDZJB1AfRGtcjUgBcovWw==
X-Google-Smtp-Source: ABdhPJwvI/JUt6sfwyE4tCyPTo4DZZ/pmq9lety72eX6gHmppv0Z+b5QQBvUsSwIdAXUGX9T/v1RUg==
X-Received: by 2002:a17:907:10d8:: with SMTP id rv24mr53857399ejb.542.1621109817549;
        Sat, 15 May 2021 13:16:57 -0700 (PDT)
Received: from pevik ([62.201.25.198])
        by smtp.gmail.com with ESMTPSA id x9sm1515631eje.64.2021.05.15.13.16.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 May 2021 13:16:57 -0700 (PDT)
Date:   Sat, 15 May 2021 22:16:54 +0200
From:   Petr Vorel <petr.vorel@gmail.com>
To:     David Ahern <dsahern@kernel.org>
Cc:     stephen@networkplumber.org, netdev@vger.kernel.org,
        heiko.thiery@gmail.com
Subject: Re: [PATCH iproute2-next] config.mk: Rerun configure when it is
 newer than config.mk
Message-ID: <YKAsNriY7P53v7Dw@pevik>
Reply-To: Petr Vorel <petr.vorel@gmail.com>
References: <20210515201320.7435-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210515201320.7435-1-dsahern@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

> config.mk needs to be re-generated any time configure is changed.
> Rename the existing make target and add a check that the config.mk
> file needs to exist and must be newer than configure script.

> Signed-off-by: David Ahern <dsahern@kernel.org>
> Reviewed-by: Petr Vorel <petr.vorel@gmail.com>
Tested-by: Petr Vorel <petr.vorel@gmail.com>

Thanks!

Kind regards,
Petr

> ---
>  Makefile | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)

> diff --git a/Makefile b/Makefile
> index 19bd163e2e04..5bc11477ab7a 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -60,7 +60,7 @@ SUBDIRS=lib ip tc bridge misc netem genl tipc devlink rdma dcb man vdpa
>  LIBNETLINK=../lib/libutil.a ../lib/libnetlink.a
>  LDLIBS += $(LIBNETLINK)

> -all: config.mk
> +all: config
>  	@set -e; \
>  	for i in $(SUBDIRS); \
>  	do echo; echo $$i; $(MAKE) -C $$i; done
> @@ -80,8 +80,10 @@ all: config.mk
>  	@echo "Make Arguments:"
>  	@echo " V=[0|1]             - set build verbosity level"

> -config.mk:
> -	sh configure $(KERNEL_INCLUDE)
> +config:
> +	@if [ ! -f config.mk -o configure -nt config.mk ]; then \
> +		sh configure $(KERNEL_INCLUDE); \
> +	fi

>  install: all
>  	install -m 0755 -d $(DESTDIR)$(SBINDIR)
