Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC7A94D2973
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 08:28:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbiCIH3P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 02:29:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230126AbiCIH3O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 02:29:14 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9240622B00
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 23:28:15 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id 6so1297561pgg.0
        for <netdev@vger.kernel.org>; Tue, 08 Mar 2022 23:28:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tGryQlIw34w2ani09obXo9M34KoKBh4H6bp8Rka7AYQ=;
        b=f01ug/4W9eCov0JXMol9H6pEOupne+Mp/Ra6SayxkcVUNtDKsAep19b1nr5sM3miOf
         Z4PDtnBudBJ8i1nAt55vYpMzSEsRRKAWhbMzB/hc2LCxs2J+P3VYAmKXI8eCkHkreqpp
         eoISxmqAorJHXSNt6M8YroJj4bPcWuBuS0l21DlfI1V3+byUeqkGIO5/3e5PVG3CudQF
         qAUEy4s7X3hbsM+z4NyIAwrCWf1U2WpS6bJJnDAOcYxLU+ZW4dpTa/KJSImVyYhbHJAe
         aPRN8h/VFEZvuKDkH9cS46Lz9y3QZAJWl9fB7IDiaQt7HmmYNBBggwdlr83gJBNjhh8v
         8hWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tGryQlIw34w2ani09obXo9M34KoKBh4H6bp8Rka7AYQ=;
        b=LWZUUM26SUY0mCgRRszQ0BloGhAqZRcO8dpyIZ3LOUsME8Cqt1nRQXCrWMJN7B9v0c
         otcoVl6ECRp4IxdcWDGg7tccRH0vU/gzmyg+12PE7ThAaPXN25PIXF37fpqdmz3mrx95
         cR+RW+KqpmyGHaEpOYTd08IDke3HUv/v+Jd6JeJjDnu+OXEtgd8KfBXLr+yD2iLQOzzZ
         IOjJaXIPXqXW6O6uUgZAZZU/0bWP8I/A3MpEABfOjkn9QJ7HEM8nx27s63/0ubN6atfv
         osFO2rDc0IW43bxtIQ2Eyg2/TSD8N4wn2elibrzbboHKvu09/6Gn3lA3R/5oO6otTQaf
         r6Nw==
X-Gm-Message-State: AOAM5331PE3sp6QIHN/0PxijOnrE4gnEVQHLTTjKBem6ddBczImFguD4
        83XBaNqHlG3gXh6MVgIslVBoXQ==
X-Google-Smtp-Source: ABdhPJyiXCOicAZVfsoCXH5DiJT6jvBSiPpmoWP7GGYtvrQ4uLBgeqzfUu9k2L+7cM/6ZN60Eui5dw==
X-Received: by 2002:a63:ad49:0:b0:374:916e:46e1 with SMTP id y9-20020a63ad49000000b00374916e46e1mr17476334pgo.18.1646810895007;
        Tue, 08 Mar 2022 23:28:15 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id t24-20020a056a00139800b004f7586bc170sm1379894pfg.95.2022.03.08.23.28.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 23:28:14 -0800 (PST)
Date:   Tue, 8 Mar 2022 23:28:12 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Joachim Wiberg <troglobit@gmail.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: Re: [PATCH iproute2-next v2 4/6] man: ip-link: document new
 bcast_flood flag on bridge ports
Message-ID: <20220308232812.5dc9e7f5@hermes.local>
In-Reply-To: <20220309071716.2678952-5-troglobit@gmail.com>
References: <20220309071716.2678952-1-troglobit@gmail.com>
        <20220309071716.2678952-5-troglobit@gmail.com>
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

On Wed,  9 Mar 2022 08:17:14 +0100
Joachim Wiberg <troglobit@gmail.com> wrote:

> Signed-off-by: Joachim Wiberg <troglobit@gmail.com>
> ---
>  man/man8/ip-link.8.in | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
> index 19a0c9ca..6dd18f7b 100644
> --- a/man/man8/ip-link.8.in
> +++ b/man/man8/ip-link.8.in
> @@ -2366,6 +2366,8 @@ the following additional arguments are supported:
>  ] [
>  .BR mcast_flood " { " on " | " off " }"
>  ] [
> +.BR bcast_flood " { " on " | " off " }"
> +] [
>  .BR mcast_to_unicast " { " on " | " off " }"
>  ] [
>  .BR group_fwd_mask " MASK"
> @@ -2454,6 +2456,10 @@ option above.
>  - controls whether a given port will flood multicast traffic for which
>    there is no MDB entry.
>  
> +.BR bcast_flood " { " on " | " off " }"
> +- controls flooding of broadcast traffic on the given port. By default
> +this flag is on.
> +
>  .BR mcast_to_unicast " { " on " | " off " }"
>  - controls whether a given port will replicate packets using unicast
>    instead of multicast. By default this flag is off.

Minor nit, would be better to put options in alphabetical order in document.
Certainly not splitting the two mcast options.
