Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE4E6ED8F
	for <lists+netdev@lfdr.de>; Sat, 20 Jul 2019 05:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727861AbfGTD7c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 23:59:32 -0400
Received: from mail-pf1-f177.google.com ([209.85.210.177]:43910 "EHLO
        mail-pf1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726856AbfGTD7b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 23:59:31 -0400
Received: by mail-pf1-f177.google.com with SMTP id i189so14985210pfg.10
        for <netdev@vger.kernel.org>; Fri, 19 Jul 2019 20:59:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=ZHRE2dx/c8UHkbvcZK2mEBXOPC6/oh3r7wvlIu05cV4=;
        b=qF2Jv1450bhhRYiq9BZNu8syOWYDbXewwEbZY0cBNbCt/MyXIkJ3ZXwVvcDBR7KcYl
         n0Cb+wmTfa+5GVmnIetwMBcdVE52HKfoHxrnm5NfEzWqBtZTFIHaSOxbbw/OdY2KKmSO
         KHdsamVsjdNl2lPCAEDhN7msa8zvyLsr25VUwnKLjkD+zYunTIVSKEeHTZ/wa0oJGCnt
         i2Hfm/TmAvVN9BxVZgGqdszcCmTFXcl0fswuD9Ah8zPYpozEI0gzfuSwQlgq/+9qfsMp
         vf1jXsX0nJwWyDqiJ3lFLuYYlxJs7z8sFD7xwbQyqHBSaVqoODvnysyunXQvcxcvuP/5
         qfvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=ZHRE2dx/c8UHkbvcZK2mEBXOPC6/oh3r7wvlIu05cV4=;
        b=eqZIMh96RH2QPExXRipL7KJnC5WvGm4v4n4UWlV+5zCOsFDVieKvenGMv77mrXDcjR
         NJU8X4OxFhbhePKI0NBWirO0QRT4MSV7grKg8xhREDWq5dl+LE1GhSqx6CZwpii9uUxt
         QYHhGQtPHyXZ/OrhxXcnqpTwDGGaSgIeQS+koef119I4SA4rT3uP6fFfms9rRQMropl4
         iuPErusUFfT3qWkWU499nqdu8I3Vtnu6/c6Mwl+13i+46NC4J6WGtWZ7goNEtpabPhCj
         6lYW/rfCQNs+qguTGmRR7fSRixRPp86ciyGjFYuwaaYuPQiF89oIQtWWn970bYeGjbVg
         NdUA==
X-Gm-Message-State: APjAAAUVT96mz9+7i1AyRQQwuGPIVU+6qHDIZQ7BJmaevpNITV3Wgzl/
        hQqTaUL/D02FFps9duOnk7jnKw==
X-Google-Smtp-Source: APXvYqzPZAXNSVea+t7L+nf+tjF434mEbNkfFZKv/Sg73GuaJ1SFcAubx0Yh7sNj7Bs4NFPc1tN/AA==
X-Received: by 2002:a17:90a:fa18:: with SMTP id cm24mr60355053pjb.120.1563595171189;
        Fri, 19 Jul 2019 20:59:31 -0700 (PDT)
Received: from cakuba ([156.39.10.47])
        by smtp.gmail.com with ESMTPSA id q8sm68669183pjq.20.2019.07.19.20.59.30
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 19 Jul 2019 20:59:31 -0700 (PDT)
Date:   Fri, 19 Jul 2019 20:59:27 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        sthemmin@microsoft.com, dsahern@gmail.com, dcbw@redhat.com,
        mkubecek@suse.cz, andrew@lunn.ch, parav@mellanox.com,
        saeedm@mellanox.com, mlxsw@mellanox.com
Subject: Re: [patch net-next rfc 7/7] net: rtnetlink: add possibility to use
 alternative names as message handle
Message-ID: <20190719205927.6638187f@cakuba>
In-Reply-To: <20190719110029.29466-8-jiri@resnulli.us>
References: <20190719110029.29466-1-jiri@resnulli.us>
        <20190719110029.29466-8-jiri@resnulli.us>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 19 Jul 2019 13:00:29 +0200, Jiri Pirko wrote:
> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> index 1fa30d514e3f..68ad12a7fc4d 100644
> --- a/net/core/rtnetlink.c
> +++ b/net/core/rtnetlink.c
> @@ -1793,6 +1793,8 @@ static const struct nla_policy ifla_policy[IFLA_MAX+1] = {
>  	[IFLA_MAX_MTU]		= { .type = NLA_U32 },
>  	[IFLA_ALT_IFNAME_MOD]	= { .type = NLA_STRING,
>  				    .len = ALTIFNAMSIZ - 1 },
> +	[IFLA_ALT_IFNAME]	= { .type = NLA_STRING,
> +				    .len = ALTIFNAMSIZ - 1 },

What's the disadvantage of just letting IFLA_IFNAME to get longer 
on input? Is it just that the handling would be asymmetrical?

>  };
>  
>  static const struct nla_policy ifla_info_policy[IFLA_INFO_MAX+1] = {

