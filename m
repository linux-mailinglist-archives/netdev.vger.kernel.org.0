Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 740EA2D473A
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 17:55:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728082AbgLIQyP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 11:54:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726698AbgLIQyF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 11:54:05 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7D2DC0613CF
        for <netdev@vger.kernel.org>; Wed,  9 Dec 2020 08:53:24 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id c198so2125453wmd.0
        for <netdev@vger.kernel.org>; Wed, 09 Dec 2020 08:53:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=DKlheH024hCbze1khY2C7KUGP5M0yDY21kAxIn9QpCI=;
        b=rykqrIbc+SuSfAUrXUzkEmU9UQK5JnB9jMbogLBaimBrhQOTOLU84LRQIjh4/73zip
         lf6iHBvd4NrDF0fVGu5qh9dDjxiOc4RgjTT9+X5Sm2P8DeQhsGWFfJfKa6gavo65ZMgE
         y7OztPdRPsIT1tFPMfmQYn97TgihHVhZuqIuRM8iCVL9yLZR2rk3Th0jGxZW910ziR2e
         e924vy4rhiOs/IsVBIcOaGfNt8HAq3frxa76gT+xrrN8sNU0RD03BEZnl6at/9JYS0Rr
         +h9r0ItN3kNGA2V103U3i9i5ESiaF72p88WKm11lhv18+VlUe1K/aCcMPYFyOjr15qn9
         ANZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=DKlheH024hCbze1khY2C7KUGP5M0yDY21kAxIn9QpCI=;
        b=FZIxwrAOExtc9Yo6XtQl+u4I5h9YWCITvAkBOXD2MWqY29GpL9xyJURCuyfiELZkdQ
         GsFIibQTezL4K77SUMOjAZ2RSsXjUEz0qG0gqmuU8IGGBdrz7Ust0Jr+rav3r+eXGZW/
         1NCrhNmLcGVgW2w3xe99SttRwD/daeHuATzMuqWXfBEquiJRjAxmQX5H4DjWAqXIjpUT
         S5slDVlJHZTx55SLlQ51Solah9z/Y1+ZNCNq2ADJg3cHgmzelZSZHs4Vb70KsG7qk5zb
         IXKgA4+R5Nxz7fVxjacERaV5QgK12HDV7wccMliv4cu/EDjFqt9lAavJ3SrGvvI8pMSV
         KNvw==
X-Gm-Message-State: AOAM530NyKewuaJ4k048/szsxifTkBkAzt4slBqgdAfLZiphdbaVfMqb
        Mo8OnEOwXcLp8eprJaUTyy4Dxg==
X-Google-Smtp-Source: ABdhPJytNcjPeIsFhnonG07KLoDdTw78wdJLrO1yds12d3RmepFsSoQKYY2aveyb6bqSI3LnbxtGLA==
X-Received: by 2002:a7b:cd91:: with SMTP id y17mr3608718wmj.171.1607532803637;
        Wed, 09 Dec 2020 08:53:23 -0800 (PST)
Received: from netronome.com ([2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a])
        by smtp.gmail.com with ESMTPSA id s13sm4156977wmj.28.2020.12.09.08.53.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 08:53:22 -0800 (PST)
Date:   Wed, 9 Dec 2020 17:53:22 +0100
From:   Simon Horman <simon.horman@netronome.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        oss-drivers@netronome.com, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH net-next] nfp: silence set but not used warning with
 IPV6=n
Message-ID: <20201209165319.GA8699@netronome.com>
References: <20201209161821.1040796-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201209161821.1040796-1-kuba@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 09, 2020 at 08:18:21AM -0800, Jakub Kicinski wrote:
> Test robot reports:
> 
> drivers/net/ethernet/netronome/nfp/crypto/tls.c: In function 'nfp_net_tls_rx_resync_req':
> drivers/net/ethernet/netronome/nfp/crypto/tls.c:477:18: warning: variable 'ipv6h' set but not used [-Wunused-but-set-variable]
>   477 |  struct ipv6hdr *ipv6h;
>       |                  ^~~~~
> In file included from include/linux/compiler_types.h:65,
>                     from <command-line>:
> drivers/net/ethernet/netronome/nfp/crypto/tls.c: In function 'nfp_net_tls_add':
> include/linux/compiler_attributes.h:208:41: warning: statement will never be executed [-Wswitch-unreachable]
>   208 | # define fallthrough                    __attribute__((__fallthrough__))
>       |                                         ^~~~~~~~~~~~~
> drivers/net/ethernet/netronome/nfp/crypto/tls.c:299:3: note: in expansion of macro 'fallthrough'
>   299 |   fallthrough;
>       |   ^~~~~~~~~~~
> 
> Use the IPv6 header in the switch, it doesn't matter which header
> we use to read the version field.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Thanks Jakub,

this looks good to me.

Reviewed-by: Simon Horman <simon.horman@netronome.com>

