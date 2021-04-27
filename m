Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7047836BE19
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 06:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbhD0EDV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 00:03:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbhD0EDV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Apr 2021 00:03:21 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44225C061574
        for <netdev@vger.kernel.org>; Mon, 26 Apr 2021 21:02:37 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id m12so708953pgr.9
        for <netdev@vger.kernel.org>; Mon, 26 Apr 2021 21:02:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Y3uAkds03Pwq6+pdouLjMNz3647lgEcn40tEplxgX+w=;
        b=hRvbHlAkUIXXCtak0mbpBkUawOEPwV38UqpkNZthLLIaZGni+812ZjrtiP8GDzjmlT
         9BOa3ha6VEsDTJbzoZdWIBvDW7eAbEFo0Bxwj2+gq7F64OTrHoMDS1hyRJzO3TOR7fSq
         Ol0NUMBnL4x/R6/bbkmek9D2SEtoqAOnT8XVYErMuHtJHDlD91u4Fsa+v0Lvhs4TNg2H
         aCUgrMujHul3Dng/DMmYzv8V0SXhtOX8O58riclu9gppVelAJ2GfY+84wmB3k2wrBPac
         QJ92LPGt+0gcVcvsVM0nlpKNeU9tJBYXww5bIcnCDmgVa+CkMO0xznqG2LbCb4+mmUkY
         sVDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Y3uAkds03Pwq6+pdouLjMNz3647lgEcn40tEplxgX+w=;
        b=YfSH6I41Ugu4EOCejAO0Yc5u0d4TTHPCISPxRO0hQZ4csdZJBhJA18SNe3oxkwiRrf
         HaP3+jIjJwjJv5bYh4rweG8NjmPyvAcKmIBiaCbj5U2ZcD8sb2nV5HEEZKY5W4UTtOIh
         ItRi3CXryDwP6pfzjx5fM7jjhNfNUpFhBTMlk7RxVy4RAdp8HYC0unrRPGZP/gQkaHgo
         rQa1eS7e2706MXGdXlV34eKg7C0ODWhphqgZaNTvJJHRqDIMBy3MeKHCcPfsdIq4fEG2
         kM1MOc6bASfIdXr9HYLsPrwUfAPJ6AU1h26URi1ir3Cl/KieAzoc+tSIHOKxhcAfPeSP
         EvkQ==
X-Gm-Message-State: AOAM532TATW2h6bZEJd/rS/aHGRvwhuvUuo226pPm/j4cZR5noP2BA69
        QcNk3x0lmriDy5cWp8vnfJwvtNn+01lF8A==
X-Google-Smtp-Source: ABdhPJyrrBtjM8CRwTqPePhQea+S+C/kFBlOWEv0hCeJpMUZTO/2w4EC2oq9EJZV1BjwAwWah5LQNA==
X-Received: by 2002:a62:25c4:0:b029:276:a40:5729 with SMTP id l187-20020a6225c40000b02902760a405729mr9401066pfl.80.1619496156478;
        Mon, 26 Apr 2021 21:02:36 -0700 (PDT)
Received: from hermes.local (76-14-218-44.or.wavecable.com. [76.14.218.44])
        by smtp.gmail.com with ESMTPSA id z29sm12549807pga.52.2021.04.26.21.02.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 21:02:36 -0700 (PDT)
Date:   Mon, 26 Apr 2021 21:02:33 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jethro Beekman <kernel@jbeekman.nl>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH iproute2-next] ip: Clarify MACVLAN private mode
Message-ID: <20210426210233.7941b7f1@hermes.local>
In-Reply-To: <8685da8c-3502-34c7-c91f-db28a0a450d6@jbeekman.nl>
References: <8685da8c-3502-34c7-c91f-db28a0a450d6@jbeekman.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 24 Apr 2021 23:28:52 +0200
Jethro Beekman <kernel@jbeekman.nl> wrote:

> Traffic isn't really "disallowed" but rather some broadcast traffic is filtered.
> 
> Signed-off-by: Jethro Beekman <kernel@jbeekman.nl>
> ---
>  man/man8/ip-link.8.in | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
> index fd67e611..a4abae5f 100644
> --- a/man/man8/ip-link.8.in
> +++ b/man/man8/ip-link.8.in
> @@ -1366,10 +1366,12 @@ the following additional arguments are supported:
>  .BR /dev/tapX " to be used just like a " tuntap " device."
>  
>  .B mode private
> -- Do not allow communication between
> +- Do not allow broadcast communication between
>  .B macvlan
>  instances on the same physical interface, even if the external switch supports
> -hairpin mode.
> +hairpin mode. Unicast traffic is transmitted over the physical interface as in
> +.B vepa
> +mode, but the lack of ARP responses may hamper communication.

The grammar here is a little awkward. It is using passive voice and the two clauses
in compound sentence don't match. Let me consult the grammar expert (my spouse is
a writer) and reword this in next release.


>  .B mode vepa
>  - Virtual Ethernet Port Aggregator mode. Data from one
> @@ -1394,7 +1396,7 @@ forces the underlying interface into promiscuous mode. Passing the
>  using standard tools.
>  
>  .B mode source
> -- allows one to set a list of allowed mac address, which is used to match
> +- Allows one to set a list of allowed mac address, which is used to match
>  against source mac address from received frames on underlying interface. This
>  allows creating mac based VLAN associations, instead of standard port or tag
>  based. The feature is useful to deploy 802.1x mac based behavior,

The original is also awkward wording here. Lets get rid of passive voice as well.
