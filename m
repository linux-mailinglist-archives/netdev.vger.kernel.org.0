Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AC6C74076
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 22:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728185AbfGXUxy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 16:53:54 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35823 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726458AbfGXUxy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 16:53:54 -0400
Received: by mail-wr1-f68.google.com with SMTP id y4so48409443wrm.2;
        Wed, 24 Jul 2019 13:53:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4vlSApADqMaTQFZAxWh91F0OWIIUGfY31jKzlHYv4ro=;
        b=eiRIOuBUTR85cjQF+CPoya5Fs/9ywSqpR5yxsKy2OoKDwpDfmYISZAxFPz5JbK2f8K
         xgt758mkixIxl9ofXh0aWVuwQU9feueVDNoJ8q9egwsqwZAghlLX4EwOmWAaQY3wX8TI
         a8ScX6njDe62XzQ1Ct1GpuNHHfgRdOCh+oHn/F6g9f2KGRxWXMxZfXOkzrQn1YdFfepT
         P7F2e46Wnlnq0nP8O0S/MfLgi2AOOfzuBSmKQ9yAQZBitZgfezJwl5IRJ0gPIvEc5LNs
         KnrPcTuQ79hQe/VpXActnjZJT/zJPMOnBVhMuKjNbF6BOBDQNq+Sqbz0FcL3w8m6CdN0
         4YuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4vlSApADqMaTQFZAxWh91F0OWIIUGfY31jKzlHYv4ro=;
        b=gwLR0LReX3f8Ro5SVF5QzayvpbysUmG+KAANc3q2xXmGq3rW8qIyXNl65cjCoEMts7
         3nHl0wSdA/tNfKztcuVDCWRk8CgtfEypzROg4mXUyA3pHdPQqNl/EN+3mTx+qlqjaMF+
         FCyEgiv2pFeF8yfr+iXpgfyP/9D3Ic57+N8NZYoyvyn2xMVERXQwpA7RSxJgHZqwuEaH
         HqUCc8VmE9vfojhBfTyUxe2bjpXGDqTncqDPTZKdq4yFR+MmQvdVKqWobKyWz1HhieRT
         J26KsS7j4k/9KqXEtlx/OgBPV62chZLefxx6nEjG+ehaVXzx6QmUGz6UEyp9i0RJTSRc
         anrQ==
X-Gm-Message-State: APjAAAX5GVFO8oWaVNP1ARPG4kh/qckLRfG3Q7Vgs6y4/W20TbM6bUFX
        HoQJVLMdTFgRHXKdH2qPW4c=
X-Google-Smtp-Source: APXvYqxB08CWxE94JVIMWBJ0C3dksYR7ciXCx/OVdhC20OJs3uxrZmlNIjoEmeVN2tCy9tbBT5jkAQ==
X-Received: by 2002:adf:ce82:: with SMTP id r2mr13381528wrn.223.1564001632521;
        Wed, 24 Jul 2019 13:53:52 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f43:4200:60e4:dd99:f7ec:c519? (p200300EA8F43420060E4DD99F7ECC519.dip0.t-ipconnect.de. [2003:ea:8f43:4200:60e4:dd99:f7ec:c519])
        by smtp.googlemail.com with ESMTPSA id g12sm66827271wrv.9.2019.07.24.13.53.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Jul 2019 13:53:51 -0700 (PDT)
Subject: Re: [PATCH] r8169: fix a typo in a comment
To:     Corentin Musard <corentinmusard@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     trivial@kernel.org
References: <20190724123443.GA9626@user.home>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <647a446f-f922-016b-0118-ff2854f9419e@gmail.com>
Date:   Wed, 24 Jul 2019 22:53:46 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190724123443.GA9626@user.home>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24.07.2019 14:34, Corentin Musard wrote:
> Replace "additonal" by "additional" in a comment.
> Typo found by checkpatch.pl.
> 
> Signed-off-by: Corentin Musard <corentinmusard@gmail.com>
> ---
>  drivers/net/ethernet/realtek/r8169_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> index 0637c6752a78..7231ab3573ff 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -6334,7 +6334,7 @@ rtl8169_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
>  	stats->multicast	= dev->stats.multicast;
>  
>  	/*
> -	 * Fetch additonal counter values missing in stats collected by driver
> +	 * Fetch additional counter values missing in stats collected by driver
>  	 * from tally counters.
>  	 */
>  	if (pm_runtime_active(&pdev->dev))
> 
Should have been annotated net-next and sent also to me. Apart from that:
Reviewed-by: Heiner Kallweit <hkallweit1@gmail.com>
