Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5E9731D207
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 22:28:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbhBPV1Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 16:27:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229878AbhBPV1Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 16:27:24 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11419C061574
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 13:26:44 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id a9so4093331plh.8
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 13:26:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=s4T4umekr2qX+nGjE6M770FXWJ3NNSC0Ftv6bZcHGt0=;
        b=W7zsG85mjqBdC6D6+WlZGWw+g2w0MvJLaQ9M1JiSaD37qNlXORRpCT4sETzWmrnyVl
         Y+kg94gIiPmLXJHZqR/an3pHwtkPnmF5C6d7mmhbuiFqrqkgYq72u1hwq+HspDRdWaUp
         NLPi+bR5aKpTYF0729H7PphP/zb7y5HzDa/tRpyHpjcZ8LtHe56iuKaLeJU0hsKxrN5r
         /bsIoCCb0oTOa4mL3ksg70IB57iydeA9/1k2uFZTCYry8ekVpEXK25APv+HrUghw13IQ
         ZZ58pifWQOEcMKvWiVTRmYWru2YHa2cWVW/mwYy6T1ayUwwd66XzOw3S75pTKMXbDA9f
         BP3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=s4T4umekr2qX+nGjE6M770FXWJ3NNSC0Ftv6bZcHGt0=;
        b=KvfqI1i7ADUSs3DhcQ4C/gL3ZhvqIoVO6b6mQqWCK+Rr7JUnEdvSRqqvknhXBZtmKj
         0YYo4x7X4TzGUJKWsopfuop0pT/LEdmuyF2rmZ0+6GuW1Oryhrwem/8mdmAnTdTvWICy
         56Lppr5BN9uAiusQKSQVCHLQ4lvLxS1PKH3cwRT8CSZd5rauqnjuZvMueJ0GdcjxBUGM
         QsM/b3taST/Ob2evqmHf1RZ16SkgSijQ7TPPS/8zF/1DYqln7R19fYx20D6QmfvoGzEj
         rEPKef24JilR1Yd3gVz0LcgXbaF0Eu/8E68RpCeGHJGVcfigdE2B1GtjHdqdZXYSrHKm
         Q3Rg==
X-Gm-Message-State: AOAM532Vot0hMdq/SkPYDD6j7t+wVjBF1I3h+1BaaXUiXCioO8PvSG3d
        JThsRWZrjilrGumOzK0zywuUZg==
X-Google-Smtp-Source: ABdhPJzkYfP+Jnwu7eLrIQbr432vHn081t5ZoOBSpnSBGEyu8EcIHog1HbFTfvAfjT96xAxbS3/S9A==
X-Received: by 2002:a17:902:e5cc:b029:de:cdab:2da5 with SMTP id u12-20020a170902e5ccb02900decdab2da5mr21275068plf.32.1613510803585;
        Tue, 16 Feb 2021 13:26:43 -0800 (PST)
Received: from Shannons-MacBook-Pro.local ([50.53.47.17])
        by smtp.gmail.com with ESMTPSA id h1sm70904pgj.59.2021.02.16.13.26.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Feb 2021 13:26:43 -0800 (PST)
Subject: Re: [PATCH] ionic: Remove unused function pointer typedef
 ionic_reset_cb
To:     Chen Lin <chen45464546@163.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     drivers@pensando.io, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chen Lin <chen.lin5@zte.com.cn>
References: <1613448330-4783-1-git-send-email-chen45464546@163.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <93451a68-293a-2f21-f837-317778c18c89@pensando.io>
Date:   Tue, 16 Feb 2021 13:26:41 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <1613448330-4783-1-git-send-email-chen45464546@163.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/15/21 8:05 PM, Chen Lin wrote:
> From: Chen Lin <chen.lin5@zte.com.cn>
>
> Remove the 'ionic_reset_cb' typedef as it is not used.
>
> Signed-off-by: Chen Lin <chen.lin5@zte.com.cn>
> ---
>   drivers/net/ethernet/pensando/ionic/ionic_lif.h |    2 --
>   1 file changed, 2 deletions(-)
>
> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
> index 9bed427..563dba3 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
> @@ -249,8 +249,6 @@ static inline u32 ionic_coal_usec_to_hw(struct ionic *ionic, u32 usecs)
>   	return (usecs * mult) / div;
>   }
>   
> -typedef void (*ionic_reset_cb)(struct ionic_lif *lif, void *arg);
> -
>   void ionic_link_status_check_request(struct ionic_lif *lif, bool can_sleep);
>   void ionic_get_stats64(struct net_device *netdev,
>   		       struct rtnl_link_stats64 *ns);

Yep - thanks.

Acked-by: Shannon Nelson <snelson@pensando.io>

