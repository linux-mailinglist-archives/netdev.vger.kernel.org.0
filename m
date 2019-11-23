Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D46E5107C15
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 01:40:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726760AbfKWAkx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 19:40:53 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:35385 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbfKWAkx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 19:40:53 -0500
Received: by mail-lj1-f193.google.com with SMTP id j6so309852lja.2
        for <netdev@vger.kernel.org>; Fri, 22 Nov 2019 16:40:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=LGmuNByLrRRGPoX7LROr9SUx/jNH7fm6HEWSd41eDAk=;
        b=yftHYP1SMbEX3og/6Sud/w4boXvOMNgYf3eDoCUvtJt4LeKC7JPHXZ2cjOElUCyt1A
         hCI4UdarUgATSZtBU59aOUCawYcetoAOFseWvsFNxmFiufCIZsXXpuY5J0ttUOcLNcHf
         o6zvi//nvrZu8oXeonXOQ0LeOvt9HcRdwPOWCLvM8ljFCgF45O8SUYbOvxpj0vmiIkEY
         yekSAWmgBwjbN+KFuDhLHXVg8agBLQLJsGKrWydSrGzwp2/PHAAUpmppYRbYB4uaFB80
         L3lX61ljuj76d3v3lNLFMo7C1KfVrQGJrDnx5vphoswDRUNYsK5mRfHMZq35XG4+CxdZ
         rEGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=LGmuNByLrRRGPoX7LROr9SUx/jNH7fm6HEWSd41eDAk=;
        b=k3rOOqTG0GVaU7eyDO15UNaxA28pmHxERrhPkKPVJPIXIgr80Jc2R7GN7jNl7zUzHV
         risw8i6Ksoll8C8tMBujSU8f5jlSqg/xe/DaWas+le3fIDOWb6PaduOy/wAu6Frx9O46
         jSqAt8IyU4MP82tuqKha8Xj8ZdmOP73TtNFmINsjOKExu5Rb7288lRvVgYWqwGlPo5Sa
         5XwJq+9yBEeEjBbcnYJuernOLMAZ5Ezlw+1cpRDiqjamB9yknel4B3UTw7UTS5iLbA7Y
         XrvilKS4SqdUfIW/N23Ytr9zan+lBlWGuokLbiIgacGb9EPsIzCy1Yy2s+ADAVsQdnI3
         cvfw==
X-Gm-Message-State: APjAAAWli1N4fsnv6FYfYuAGF5WDyp8qZidTvvdnkVud/wr2dZxjm095
        9NZwdxUj1LddiveZZQF9+wMS1Q==
X-Google-Smtp-Source: APXvYqw/h7E8n9AmtYOP1hIl5xKQruSU3unBhNrvFvGcELytRTuO4dETAr69gZbDWI95D3vvBogf2A==
X-Received: by 2002:a05:651c:331:: with SMTP id b17mr14185318ljp.133.1574469651382;
        Fri, 22 Nov 2019 16:40:51 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id d4sm3746128lfi.32.2019.11.22.16.40.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2019 16:40:50 -0800 (PST)
Date:   Fri, 22 Nov 2019 16:40:41 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Ariel Elior <aelior@marvell.com>, GR-everest-linux-l2@marvell.com,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] qed: remove redundant assignments to rc
Message-ID: <20191122164041.1819414b@cakuba.netronome.com>
In-Reply-To: <20191122233839.110620-1-colin.king@canonical.com>
References: <20191122233839.110620-1-colin.king@canonical.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Nov 2019 23:38:39 +0000, Colin King wrote:
> diff --git a/drivers/net/ethernet/qlogic/qed/qed_sp_commands.c b/drivers/net/ethernet/qlogic/qed/qed_sp_commands.c
> index 7e0b795230b2..12fc5f3b5cb4 100644
> --- a/drivers/net/ethernet/qlogic/qed/qed_sp_commands.c
> +++ b/drivers/net/ethernet/qlogic/qed/qed_sp_commands.c
> @@ -331,7 +331,7 @@ int qed_sp_pf_start(struct qed_hwfn *p_hwfn,
>  	u8 sb_index = p_hwfn->p_eq->eq_sb_index;
>  	struct qed_spq_entry *p_ent = NULL;
>  	struct qed_sp_init_data init_data;
> -	int rc = -EINVAL;
> +	int rc;
>  	u8 page_cnt, i;
>  
>  	/* update initial eq producer */

I like the clean up but, the variables here are ordered longest 
to shortest, please don't break people's coding style :(
