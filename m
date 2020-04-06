Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21F0719FFFF
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 23:14:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726421AbgDFVOM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 17:14:12 -0400
Received: from mail-lf1-f41.google.com ([209.85.167.41]:43104 "EHLO
        mail-lf1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725895AbgDFVOM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 17:14:12 -0400
Received: by mail-lf1-f41.google.com with SMTP id k28so635910lfe.10
        for <netdev@vger.kernel.org>; Mon, 06 Apr 2020 14:14:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+Xd1xzbAohX/FqkqTk1cM6F9kOwM40uvkJrnhkR7+Fo=;
        b=1MwGnWt2vQYBfJnOaGiMooJfZu8yPk9Lnh8IpQq4l4Fbk8acKx7Q0J83j4fbMJhmTX
         Bz+eZjKKF+Ub1qTlSs94FqivztSEebggGwKqOO2o5c+66jj41PmWZIOIuYytFsaBqmG8
         vbyS8SUkw8WPy8l9fXvKJ/eTAO6MGiT8QjtZbd1sQ9eBCMAg61zLKtD8blKSPCHXxeBc
         XiVn5iAZEWta1iZrNBRvwoGTxeux9ycBqcHT22tBvWp4wUHFIRiKeN3mDGTuN9nsKMVN
         8v0178c+aA+YlM+cBBDnBIF5MieLOOec2d4ecPVr44unPekjdEqBzjzuGLrRYzF7VbXT
         XeQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=+Xd1xzbAohX/FqkqTk1cM6F9kOwM40uvkJrnhkR7+Fo=;
        b=DBrTsmSstY/QNODkV23RWE8zmNnpjzw6WuQCbJbXURP9GUnnDzOksefccOd8Wq6W13
         FGANIRSjHUo+YmpGI8CHLKluTUI4XF1WoaScH+WeSRbIn8unakx0rbMSbDoc43Qe+GtK
         3s8azTD3W3OpSlp3If5GB1ADMXpiWw3ijH443q4oBZCoxOX5wtxYVim+T+KF5qSmju0m
         DfOcGEDFj1hVgcoKQMQKDGwqCnpK52tfe0rVhHqfnKTQk/vncFrw1TSSvncq9NFpNnA+
         bML+by6350xZd7A/9RiyOrJEwkFxDAxumUPmT982ty9FuwiHTzsXJJHUYjsJUGQP+D7I
         h0eQ==
X-Gm-Message-State: AGi0PubqnZv2Jl5xDtTBxv/Id9bLCBfCQU/tQBTcJ0FaGGT0IOkzHnwN
        fjZbhMudIPXN5rJk8iPzy9bklw==
X-Google-Smtp-Source: APiQypLi+4wO9Y/cU95F3kWj2BAO3JcE28FDvZp9goT7P7q6xIUprCvzvB04YOF9s/5Y3E2PeokoTA==
X-Received: by 2002:a19:40d0:: with SMTP id n199mr14028200lfa.161.1586207649535;
        Mon, 06 Apr 2020 14:14:09 -0700 (PDT)
Received: from wasted.cogentembedded.com ([2a00:1fa0:462e:583f:4b1:b175:1ecb:fb31])
        by smtp.gmail.com with ESMTPSA id h16sm10509386ljl.73.2020.04.06.14.14.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 Apr 2020 14:14:08 -0700 (PDT)
Subject: Re: question about drivers/net/ethernet/renesas/ravb_main.c
To:     Julia Lawall <julia.lawall@inria.fr>, horms+renesas@verge.net.au,
        tho.vu.wh@rvc.renesas.com, uli+renesas@fpond.eu
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, joe@perches.com
References: <alpine.DEB.2.21.2004031559240.2694@hadrien>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
Message-ID: <4c39386e-4259-ba45-1f7f-1e6307a7753a@cogentembedded.com>
Date:   Tue, 7 Apr 2020 00:14:07 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.21.2004031559240.2694@hadrien>
Content-Type: text/plain; charset=utf-8
Content-Language: en-MW
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 04/03/2020 05:04 PM, Julia Lawall wrote:

> In the function ravb_hwtstamp_get in ravb_main.c, the following code looks
> suspicious:
> 
>         if (priv->tstamp_rx_ctrl & RAVB_RXTSTAMP_TYPE_V2_L2_EVENT)
>                 config.rx_filter = HWTSTAMP_FILTER_PTP_V2_L2_EVENT;
>         else if (priv->tstamp_rx_ctrl & RAVB_RXTSTAMP_TYPE_ALL)
>                 config.rx_filter = HWTSTAMP_FILTER_ALL;
>         else
>                 config.rx_filter = HWTSTAMP_FILTER_NONE;
> 
> According to drivers/net/ethernet/renesas/ravb.h,
> RAVB_RXTSTAMP_TYPE_V2_L2_EVENT is 0x00000002 and RAVB_RXTSTAMP_TYPE_ALL is
> 0x00000006.  Therefore, if the test on RAVB_RXTSTAMP_TYPE_ALL should be
> true, it will never be reached.  How should the code be changed?

   After looking at the code, I think that setting RAVB_RXTSTAMP_TYPE_ALL to
0x00000004 should be enough. BTW, the RAVB_{R,T}XTSTAMP_VALID don't seem be
used anywhere...

> thanks,
> julia

MBR, Sergei
