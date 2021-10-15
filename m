Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5026542E6DE
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 04:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233572AbhJOCyG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 22:54:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232508AbhJOCyG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 22:54:06 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98B4FC061570
        for <netdev@vger.kernel.org>; Thu, 14 Oct 2021 19:52:00 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id w14so5500874pll.2
        for <netdev@vger.kernel.org>; Thu, 14 Oct 2021 19:52:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ucGNWVxcRddDN1+ka0dNwUptaDTbn15BT3DH4Hwkw+8=;
        b=k16VEmnWCOJ1z/BCd5eL3yQW1Sh4YHFvAUR4iS02i/18d3V0zTVECjlCChvSz3zkqa
         bRR5izLG+IWEkBK2NjZpl2FBv2Zsk69PqFzlZhBxWJbGGCcvlfd6bkoBCFd19GduBcxg
         Bn6Ls8RxEgUPmomubhvUl3cnzlF/Yr3p5B4/AEOo9auWKfj2buym81OViMmEZs7fE2IQ
         Hk7wDVQhY6BUFjugwwVoCc+bisJWmEtH1sENSUH8wswwwqkuZyZu8vL0EtVBqshxLzhL
         MKT5tDTnYgiQCuNQ1tGEEZp840pi7JCagId5hJY/oXqVd8kOzyvbBkP0yk/Skf6qyfOD
         W1cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ucGNWVxcRddDN1+ka0dNwUptaDTbn15BT3DH4Hwkw+8=;
        b=ULUZPx7t1ErISAxRK3J4rSDol6v9dSYLOivFEcHii9mEyntTtiLKVe3W00tqXFMUbm
         3etK/O0LkP8sckQ3bw1NptgWiev5uZyJaWHExlVPHkjEcSSIyvM3QSxCoJ1w7n2VwcgQ
         YX09T/L6jk69DD3P3p9am+46UlZ4CA5+KYTMufKFkEBMbnHk6LUB5G4mJnRXLYTnK9Id
         Q5pzK7Vj3BoOUBwL7QM2kqoejQ+asesHxC3iFVMsBCvSIi8F3yTXVXGkoUVtJNAQaszn
         kVfJGrwY0al7kZYRsa158tGHmFR+U7BZPOVUVHEmZz9zcVReDt1aoLj46CnUVxCP+D71
         hEqQ==
X-Gm-Message-State: AOAM533GnukCWcRVUgYWNPbwgdPsI4e/VpKv7w0uL7+CMIaztog33Hir
        FrSn4/G6LABPydTbEd824wQ=
X-Google-Smtp-Source: ABdhPJxFFcb8/UXAvxUXngke/UDgp2mjcTrK7f4crhmU+EefFgONVDCXzkF5d5hzi3pWXXWoiLKs8g==
X-Received: by 2002:a17:902:e144:b0:13f:4b7:68c0 with SMTP id d4-20020a170902e14400b0013f04b768c0mr8453206pla.77.1634266320080;
        Thu, 14 Oct 2021 19:52:00 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q18sm4117411pfj.46.2021.10.14.19.51.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 19:51:59 -0700 (PDT)
Date:   Fri, 15 Oct 2021 10:51:54 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Cc:     netdev@vger.kernel.org, roopa@nvidia.com,
        bridge@lists.linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net
Subject: Re: [PATCH net-next v4 10/15] net: bridge: mcast: support for
 IGMPv3/MLDv2 ALLOW_NEW_SOURCES report
Message-ID: <YWjsyk/Dzg2/zVbw@Laptop-X1>
References: <20200907095619.11216-1-nikolay@cumulusnetworks.com>
 <20200907095619.11216-11-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200907095619.11216-11-nikolay@cumulusnetworks.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 07, 2020 at 12:56:14PM +0300, Nikolay Aleksandrov wrote:
> This patch adds handling for the ALLOW_NEW_SOURCES IGMPv3/MLDv2 report
> types and limits them only when multicast_igmp_version == 3 or
> multicast_mld_version == 2 respectively. Now that IGMPv3/MLDv2 handling
> functions will be managing timers we need to delay their activation, thus
> a new argument is added which controls if the timer should be updated.
> We also disable host IGMPv3/MLDv2 handling as it's not yet implemented and
> could cause inconsistent group state, the host can only join a group as
> EXCLUDE {} or leave it.
> 
> v4: rename update_timer to igmpv2_mldv1 and use the passed value from
>     br_multicast_add_group's callers
> v3: Add IPv6/MLDv2 support
> 
> Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
> ---
>  net/bridge/br_multicast.c | 152 ++++++++++++++++++++++++++++++++------
>  net/bridge/br_private.h   |   7 ++
>  2 files changed, 137 insertions(+), 22 deletions(-)
> 
> diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
> index ba2ce875a80e..98600a08114e 100644
> --- a/net/bridge/br_multicast.c
> +++ b/net/bridge/br_multicast.c
> @@ -787,7 +787,8 @@ static int br_multicast_add_group(struct net_bridge *br,
>  				  struct net_bridge_port *port,
>  				  struct br_ip *group,
>  				  const unsigned char *src,
> -				  u8 filter_mode)
> +				  u8 filter_mode,
> +				  bool igmpv2_mldv1)
>  {
>  	struct net_bridge_port_group __rcu **pp;
>  	struct net_bridge_port_group *p;
> @@ -826,7 +827,8 @@ static int br_multicast_add_group(struct net_bridge *br,
>  	br_mdb_notify(br->dev, mp, p, RTM_NEWMDB);
>  
>  found:
> -	mod_timer(&p->timer, now + br->multicast_membership_interval);
> +	if (igmpv2_mldv1)
> +		mod_timer(&p->timer, now + br->multicast_membership_interval);

Hi Nikolay,

Our engineer found that the multicast_membership_interval will not work with
IGMPv3. Is it intend as you said "IGMPv3/MLDv2 handling is not yet
implemented" ?

Thanks
Hangbin
