Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2E6A28E9DF
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 03:20:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731375AbgJOBUS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 21:20:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387939AbgJOBTh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Oct 2020 21:19:37 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CF95C0F26F1;
        Wed, 14 Oct 2020 18:01:43 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id h2so622566pll.11;
        Wed, 14 Oct 2020 18:01:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LwerkOdRsnCJHMpXddlyMckRobHsa+u7GtVSMhhS8lI=;
        b=BRE6k+Vlxcm645Daww/9IQr9e9BY6KhXtwvPZlpEIhh0C2EpOyQJJV1s0DyVkUfAnW
         lLUUxoRvG4PP+D3yINPpReSX12FcGN0zeOLAZQK6lqthjnaBlqfJu9zZvc9Wph5FwmQV
         kqt59vRi7nRFgVW2OVpggU3ow0k1dBH2cTXAiZ0XGDK/pQbHa45AvBwvDL3CszbvqWnK
         qHIpcUQrvn2h1NYYAOilf8NFXv5fvN2S3rVQaZGecrRRzBpVR5pWGQDC52M8cNUB/dD6
         F2PzyrvKh+11CTndbIM1aUHsl2bUA/CNJDApYwpuVbszwGr9IsZ9oOYrUPXXl9W1yA9n
         dXEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LwerkOdRsnCJHMpXddlyMckRobHsa+u7GtVSMhhS8lI=;
        b=gSgBHAlmgplxJvJeKKA4RWaA9x2Cf+TDg50+CAw+62PCEi+5lOgr5Av1rQbuFdKKGB
         wojRqx90hurJDalaXJsp5zYZ7Rf6Ppsm8LlbWwdU+rHfVd86MUpfZMkqHQ8oWSqREh1O
         jxiM1uUBC7A2kGcL4F8ripXKUUhRdapN6cKQyvTZEdYeEMS2eQ0m3x5My32MeaRa8yNz
         2UNK0SO1Xs99n6guSVsEzRbBW5F20+MWcue+VwO8U53VhL3zhdjJ832WuDpW8C1utp2y
         VblTtq9Ol+VuJAow6tMCrB4tK3A3BCU04q8SZ4nDFFkrIiVhqd/fx8mD3036Ei08mmRa
         A3Uw==
X-Gm-Message-State: AOAM531eabsqJk9HCPC2BmuMV/Yx+YN3py6grgtgaYvTGA7deJL/jjxn
        6qsMTtyFpsH6YM2H8c73Ahw=
X-Google-Smtp-Source: ABdhPJwzGaRcZXELQQDsb0RL51HUB5jeCVJnKyJOaYKWfqyyAK9/uRi+xYiHOEOpXkfpn3UNqDhd/Q==
X-Received: by 2002:a17:90b:1215:: with SMTP id gl21mr1714511pjb.132.1602723702701;
        Wed, 14 Oct 2020 18:01:42 -0700 (PDT)
Received: from f3 (ae055068.dynamic.ppp.asahi-net.or.jp. [14.3.55.68])
        by smtp.gmail.com with ESMTPSA id m3sm792258pjv.52.2020.10.14.18.01.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2020 18:01:41 -0700 (PDT)
Date:   Thu, 15 Oct 2020 10:01:36 +0900
From:   Benjamin Poirier <benjamin.poirier@gmail.com>
To:     Coiby Xu <coiby.xu@gmail.com>
Cc:     devel@driverdev.osuosl.org, Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Manish Chopra <manishc@marvell.com>,
        "supporter:QLOGIC QLGE 10Gb ETHERNET DRIVER" 
        <GR-Linux-NIC-Dev@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:QLOGIC QLGE 10Gb ETHERNET DRIVER" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/7] staging: qlge: replace ql_* with qlge_* to avoid
 namespace clashes with other qlogic drivers
Message-ID: <20201015010136.GB31835@f3>
References: <20201014104306.63756-1-coiby.xu@gmail.com>
 <20201014104306.63756-2-coiby.xu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201014104306.63756-2-coiby.xu@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-10-14 18:43 +0800, Coiby Xu wrote:
> To avoid namespace clashes with other qlogic drivers and also for the
> sake of naming consistency, use the "qlge_" prefix as suggested in
> drivers/staging/qlge/TODO.
> 
> Suggested-by: Benjamin Poirier <benjamin.poirier@gmail.com>
> Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
> ---
>  drivers/staging/qlge/TODO           |    4 -
>  drivers/staging/qlge/qlge.h         |  190 ++--
>  drivers/staging/qlge/qlge_dbg.c     | 1073 ++++++++++++-----------
>  drivers/staging/qlge/qlge_ethtool.c |  231 ++---
>  drivers/staging/qlge/qlge_main.c    | 1257 +++++++++++++--------------
>  drivers/staging/qlge/qlge_mpi.c     |  352 ++++----
>  6 files changed, 1551 insertions(+), 1556 deletions(-)
> 
> diff --git a/drivers/staging/qlge/TODO b/drivers/staging/qlge/TODO
> index f93f7428f5d5..5ac55664c3e2 100644
> --- a/drivers/staging/qlge/TODO
> +++ b/drivers/staging/qlge/TODO
> @@ -28,10 +28,6 @@
>  * the driver has a habit of using runtime checks where compile time checks are
>    possible (ex. ql_free_rx_buffers(), ql_alloc_rx_buffers())
>  * reorder struct members to avoid holes if it doesn't impact performance
> -* in terms of namespace, the driver uses either qlge_, ql_ (used by
> -  other qlogic drivers, with clashes, ex: ql_sem_spinlock) or nothing (with
> -  clashes, ex: struct ob_mac_iocb_req). Rename everything to use the "qlge_"
> -  prefix.

You only renamed ql -> qlge. The prefix needs to be added where there is
currently none like the second example of that text.

Besides, the next patch reintroduces the name struct ql_adapter.
