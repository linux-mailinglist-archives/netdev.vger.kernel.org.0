Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0036735E925
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 00:42:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348633AbhDMWme (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 18:42:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245719AbhDMWmd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 18:42:33 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27988C061756
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 15:42:13 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id j7so9037561plx.2
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 15:42:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cgaYXSZOTsyuI2WQc1xYtFXeTOnpeK93EKkn9K0IUZM=;
        b=NHIvJLjZvj2yheXBL2MqUjNQkNY6Uy6WHGfb4g/3dEzh4TtbeUyH5d6KDvP/WGzgJc
         ffs9qn6MA654xYGiq/7HyT1k000QhAyXejXNBqy0fa0DtjAp/YdEgaxNMznM0IIv5Gxi
         ve2QWYQ00T2YjJT8IxxW9fS4mMqqF/S+7z65yB2XSiwa6npHuGlax3v7Q/OafRxcolOb
         iKoSJfABpJYpj8M74t+Hk2tL6mPhongynPs1tGlKiQpaWLTMCn3ywjgS1BCJbQbKMwTL
         +rZMzeDdauSTD9udmKrZ/5fHXJpVcm26j0c3jwGmSOgMqZsz5K6Q1aQQg1dcGFBiqqo7
         ruqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cgaYXSZOTsyuI2WQc1xYtFXeTOnpeK93EKkn9K0IUZM=;
        b=ttNZSF1YwBypLuOtx7BnqreYRt+0M2//33T7E4tGZBN67B1kVq6b710FZMe+d4WmUw
         bH/8hcGowL82aus2vwXbsbdbiqx7QwyNDBA7p5NIe485IhqbyMRVfctI+ym8F/TkZD8A
         sLbJqAnw3jBbq57fXZnCAONmUCf+vicEuUenH5Vs+ZkQdNSSJma8HxD439SbTtNAolVJ
         URdHcGaorucdS2wnh0u7znHaCknKEKIMogbVXPXCFC4SPrPdvMuQNGkTfFua3U5qJKqI
         1sBIybLw/LkF35tWrqdTtw675TPL8QEFcLBD2kH2eGnl0ZhYADlR1yXl5PeArN0Ol80+
         8N9A==
X-Gm-Message-State: AOAM532eegVng9erkLYnTU/T8Yzu0NoB7RQrVg9hDBqsB2ZklkLFXA+d
        oRaF2OGNoMaRoum6oFXvjn5T0pCsPWy3VA==
X-Google-Smtp-Source: ABdhPJyxb5q2GZ1mmHMGL3ezR77APOp1QJYh0z5peMbiSCu3uKwrKSFnHn7ItND/dn+v9f4YWSdmuw==
X-Received: by 2002:a17:90a:5998:: with SMTP id l24mr45539pji.76.1618353732705;
        Tue, 13 Apr 2021 15:42:12 -0700 (PDT)
Received: from hermes.local (76-14-218-44.or.wavecable.com. [76.14.218.44])
        by smtp.gmail.com with ESMTPSA id e190sm13244357pfe.3.2021.04.13.15.42.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 15:42:12 -0700 (PDT)
Date:   Tue, 13 Apr 2021 15:42:04 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: Space: remove hp100 probe
Message-ID: <20210413154204.1ae59d6a@hermes.local>
In-Reply-To: <20210413141627.2414092-1-arnd@kernel.org>
References: <20210413141627.2414092-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 13 Apr 2021 16:16:17 +0200
Arnd Bergmann <arnd@kernel.org> wrote:

> From: Arnd Bergmann <arnd@arndb.de>
> 
> The driver was removed last year, but the static initialization got left
> behind by accident.
> 
> Fixes: a10079c66290 ("staging: remove hp100 driver")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/net/Space.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/net/Space.c b/drivers/net/Space.c
> index 7bb699d7c422..a61cc7b26a87 100644
> --- a/drivers/net/Space.c
> +++ b/drivers/net/Space.c
> @@ -59,9 +59,6 @@ static int __init probe_list2(int unit, struct devprobe2 *p, int autoprobe)
>   * look for EISA/PCI cards in addition to ISA cards).
>   */
>  static struct devprobe2 isa_probes[] __initdata = {
> -#if defined(CONFIG_HP100) && defined(CONFIG_ISA)	/* ISA, EISA */
> -	{hp100_probe, 0},
> -#endif
>  #ifdef CONFIG_3C515
>  	{tc515_probe, 0},
>  #endif

Thanks, do we even need to have the static initialization anymore?
