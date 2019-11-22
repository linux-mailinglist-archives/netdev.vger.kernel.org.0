Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 834CB107B43
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 00:21:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbfKVXVr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 18:21:47 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:33321 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbfKVXVr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 18:21:47 -0500
Received: by mail-pj1-f65.google.com with SMTP id o14so3708114pjr.0
        for <netdev@vger.kernel.org>; Fri, 22 Nov 2019 15:21:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SRxeP6JYxXwcDjXxRxvxSG10sfRbRAVNy5e7o8L+Unw=;
        b=KsOWuxi/0PxjefEDm2r60M34w2W3ctdF5MBaULRIuvo6rhK0YoWJZj+U5/8+/uv5s4
         ErvO0UGhCWUiaucHXjJpvBjVsayTBHFlJYPo6SQrM0qQ0ahSEbrt7Se40GXfjuciL19a
         d7pRk9mcFYR4FzDhOsAN1JPANFUe8IAt516e1/tROV/n0ayZpsqmdQLCsEHqsFCtychZ
         DHS617nxrIwyen6l4ouJb/y/VG0CJxx3tJoJRYB2lOxAA2aArXDqweuDKXJsMRDxWHFA
         j7ASJ6M3gY6C+WSyRS8jDr2mAJu4lF/xPkCRgcPodYzewwZPTIroV2uI1jv9F3W1D/Bk
         VUSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SRxeP6JYxXwcDjXxRxvxSG10sfRbRAVNy5e7o8L+Unw=;
        b=noZ8UE/X6R25RLxDvDluKjE78Ibz6oqtVsSCoERA8fa6dnjOpHUzb3Dz1HqOm/SF0S
         /jVcKRUrtPXRdvTIxmi/JLgzhOshZOHM/Fn86upHc5C0UjL+7dS4vpgri2qUpLIoSZOA
         IJ3m5IAlOINl/THe0Kp1mUwMl8O0AqPgvvEi/iRR2EzHrxcruTnx/VKLvRetP08d8P69
         41riufgtgHw3U3pswlGJIi/GaQNpkoJViNYAsUDB4ioD71+DIwXiPVGnvbNU/SEOlB3V
         6gYsDY/F3QKcrPNxc9aoMPh0unTzuTApypByQaaPiF1VZofeQJKDV3Ppa41GTK9mBhuj
         0BNQ==
X-Gm-Message-State: APjAAAUup7RQ3a9kJ8HRAbkBEJbRXL6WxIePHSGABELHm6q9rocPDkn7
        XI0XhGWJhTN62QbTNXbTSjYCsQ==
X-Google-Smtp-Source: APXvYqwpjc5ll2gBwpxqQTjvkHdw+9SQZNpM+YTp2pPw9mGEcjP0Q3IqtOmK+ISnIHglNlAEMDoQMA==
X-Received: by 2002:a17:90a:1ac8:: with SMTP id p66mr21599142pjp.24.1574464905489;
        Fri, 22 Nov 2019 15:21:45 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id c84sm8613847pfc.112.2019.11.22.15.21.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2019 15:21:45 -0800 (PST)
Date:   Fri, 22 Nov 2019 15:21:37 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        f.fainelli@gmail.com
Subject: Re: [PATCH net-next] net: bridge: add STP stat counters
Message-ID: <20191122152137.33f9f9d7@hermes.lan>
In-Reply-To: <20191122230742.1515752-1-vivien.didelot@gmail.com>
References: <20191122230742.1515752-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Nov 2019 18:07:42 -0500
Vivien Didelot <vivien.didelot@gmail.com> wrote:

> This adds rx_bpdu, tx_bpdu, rx_tcn, tx_tcn, transition_blk,
> transition_fwd stat counters to the bridge ports, along with sysfs
> statistics nodes under a "statistics" directory of the "brport" entry,
> providing useful information for STP, for example:
> 
>     # cat /sys/class/net/lan0/brport/statistics/tx_bpdu
>     26
>     # cat /sys/class/net/lan5/brport/statistics/transition_fwd
>     3
> 
> At the same time, make BRPORT_ATTR define a non-const attribute as
> this is required by the attribute group structure.
> 
> Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>

Please don't add more sysfs stuff. put it in netlink.

> ---
>  net/bridge/br_private.h  |  8 ++++++++
>  net/bridge/br_stp.c      |  8 ++++++++
>  net/bridge/br_stp_bpdu.c |  4 ++++
>  net/bridge/br_sysfs_if.c | 35 ++++++++++++++++++++++++++++++++++-
>  4 files changed, 54 insertions(+), 1 deletion(-)
> 
> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
> index 36b0367ca1e0..360d8030e3b2 100644
> --- a/net/bridge/br_private.h
> +++ b/net/bridge/br_private.h
> @@ -283,6 +283,14 @@ struct net_bridge_port {
>  #endif
>  	u16				group_fwd_mask;
>  	u16				backup_redirected_cnt;
> +
> +	/* Statistics */
> +	atomic_long_t			rx_bpdu;
> +	atomic_long_t			tx_bpdu;
> +	atomic_long_t			rx_tcn;
> +	atomic_long_t			tx_tcn;
> +	atomic_long_t			transition_blk;
> +	atomic_long_t			transition_fwd;
>  };
>  

There is no these need to be atomic.
Atomic is expensive.

