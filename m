Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66AB32B25FA
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 21:55:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbgKMUys (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 15:54:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726092AbgKMUys (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 15:54:48 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 713A2C0613D1
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 12:54:47 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id d17so3600769plr.5
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 12:54:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=mfGd9mOB3wZXsPAjdp9xAJG0EM4ERiIc/f/W2zFpu7I=;
        b=j9GBqpGPkXbuiQaY/HzevHqDXrde9CxuSBfLLODviG2ju5fbPXS+koyXYR0c3gfyyz
         E9jkEgcSaGyXs0a3mKW7Mt6JG2K36oWc6IEcAP1NDgO5/Olyot3h/qq4asuM1PPvrXg2
         Eooy+4ebrwIlmTXXUjqu64+BnTfdG9VV8mS9qNXH+IGXF/tNM59JCiKuC8+GMW9fPz4Y
         Hdlqzu+yxeAnC5aPyDcL8bK3Azlbrtmwj78V5x493dRSGnFsBbmxvkzZaQHw7F6O8eBI
         C8cptOxqOq6PcjAv6S9Zno3uPwnYSmVbPIWpk/loXiBziX5OIe66cWj8ZlqKHVRBSE9c
         5wtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=mfGd9mOB3wZXsPAjdp9xAJG0EM4ERiIc/f/W2zFpu7I=;
        b=FTJjKhuUv//1IMHbUWIL+aUvtLDpqzPBhJZv97WKKCWOOAaKOerf5OnzF+NnQ2lWeS
         h8WSSs0wOYqh4nFzNAkodQNFh3WxGe02R+7a+a66VPjfdVTO76hOXI6zi3DT0V1lnl3Z
         Dq0k+DMoeKuTIL0U1AqGPm0jxeWdm+ECPQPtQDxtbn0lMmB1NdfE1Kp7CvSGUrynyBmG
         QasWoJZ6klpINprakdNvjcUhsvC9OuuR9xeVu6wa7384hU2hTEocKiexM6lx3Et8kxbc
         kQni4h+y/M9G2vAFmOsBXvlVmWvUnI4/b5i//MNaSIZpCzFRIZjZWPHbheCQJvn8W4N3
         qumg==
X-Gm-Message-State: AOAM531B1DG5nE/M3m2WNgOilFEWMva7lZHQbctnQFx5/wK8A4GUJa3z
        Wefqfh/7hcyAG7Kbt1hmy9k=
X-Google-Smtp-Source: ABdhPJzTEivRDElqssFwVqEVOM5Bd8mDIcmI0P0l63gub9Y6r+kKLoot9UmjfBiPJhBkoT2LjvVQqQ==
X-Received: by 2002:a17:902:c38b:b029:d7:cb4b:9555 with SMTP id g11-20020a170902c38bb02900d7cb4b9555mr3374961plg.66.1605300887065;
        Fri, 13 Nov 2020 12:54:47 -0800 (PST)
Received: from ?IPv6:2601:648:8400:9ef4:34d:9355:e74:4f1b? ([2601:648:8400:9ef4:34d:9355:e74:4f1b])
        by smtp.gmail.com with ESMTPSA id j184sm11479468pfg.207.2020.11.13.12.54.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 12:54:46 -0800 (PST)
Message-ID: <e2e330e3313f642e1367a1aca8becf6aa3ff5eca.camel@gmail.com>
Subject: Re: [PATCH 3/3] ICMPv6: define probe message types
From:   Andreas Roeseler <andreas.a.roeseler@gmail.com>
To:     davem@davemloft.net
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        netdev@vger.kernel.org
Date:   Fri, 13 Nov 2020 12:54:46 -0800
In-Reply-To: <20201113050247.8273-1-andreas.a.roeseler@gmail.com>
References: <cover.1605238003.git.andreas.a.roeseler@gmail.com>
         <20201113050247.8273-1-andreas.a.roeseler@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-11-12 at 21:02 -0800, Andreas Roeseler wrote:
> From: Andreas Roeseler <aroeseler@g.hmc.edu>
> 
> Types of ICMPv6 Extended Echo Request and ICMPv6 Extended Echo Reply
> are
> defined by sections 2 and 3 of RFC 8335.
> 
> Signed-off-by: Andreas Roeseler <andreas.a.roeseler@gmail.com>
> ---
>  include/uapi/linux/icmpv6.h | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/include/uapi/linux/icmpv6.h
> b/include/uapi/linux/icmpv6.h
> index c1661febc2dc..183a8b3feb92 100644
> --- a/include/uapi/linux/icmpv6.h
> +++ b/include/uapi/linux/icmpv6.h
> @@ -139,6 +139,12 @@ struct icmp6hdr {
>  #define ICMPV6_UNK_NEXTHDR             1
>  #define ICMPV6_UNK_OPTION              2
>  
> +/*
> + *     Codes for EXT_ECHO (Probe)
> + */
> +#define ICMPV6_EXT_ECHO_REQUEST                160
> +#define ICMPV6_EXT_ECHO_REPLY          161
> +
>  /*
>   *     constants for (set|get)sockopt
>   */


