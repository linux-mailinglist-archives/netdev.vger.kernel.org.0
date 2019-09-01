Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2653A4B25
	for <lists+netdev@lfdr.de>; Sun,  1 Sep 2019 20:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729182AbfIASX0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Sep 2019 14:23:26 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:40913 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729036AbfIASX0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Sep 2019 14:23:26 -0400
Received: by mail-lj1-f193.google.com with SMTP id 7so1324372ljw.7
        for <netdev@vger.kernel.org>; Sun, 01 Sep 2019 11:23:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eRqNO50sqHwmWj5P/z58Oe0GaZOHE7FRmJRU0BNdRwA=;
        b=eq6vzzUPapsds+MIIuvqwfoZXAY0z41n2/7fdowjYx2O5oU38D0z/W/9glcxHRQa2e
         WYf410OXkTry4hw084nNU6/X7cFg1locgtY1vqUfOpwr826VafO+TCzi/6t+ttlshkC+
         Sijt9vi6vCi5dE6sI0/8gicWxGp5RchwTfcn7sp2LKVu62LRHYFb14OqYn/1pJpGmPef
         Aj7b+7Bjar191/oCxIVpcgP7PF40d+4DN5npPXMykV6beMkf4rgkProguELGZMDzpeLM
         PrbjKM3rbaqyDlThN1cmN4fO3M5I2yb3ZTA5WYMWuKdsF5nZiMa/eBim7YPJaP48caWx
         hkkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eRqNO50sqHwmWj5P/z58Oe0GaZOHE7FRmJRU0BNdRwA=;
        b=rledcxsBJoDGuudn8Cw7jaCluxLEOIomzJwdJwItejal+iGVjOookdNuA6S2T1acKQ
         jLtZjwM6gN5aGC9YYcbB2FkOsX9PM7bRy7W6HXLnMLFAGAvB5LpTSZ25BqjBKM83VVt/
         TRS//ujvl/WmrtjtKMB58JTynDStbddM07bNN+4BfrgBUxy2jQZxIzvc7OabHOq42vlq
         BgOa0U4sitv47UH47t1szOmGnHjKoozOUrGAx9tFnpXGBBoN780t8V4HF6DLWscYo7VX
         Y5eUUy9y8Fkix7KgCk2o1OBsamksq/WcDaDbq64DQSjz0/C0JeSbSlMvx4+qnxoIvRwy
         wEkg==
X-Gm-Message-State: APjAAAWnO4gebQywcdol0MArO8UJZTHm/xne5fVjSTg5XvJq5U7pUXbM
        ltNUKQf/Z71ZkIAK5dgqfvMHzmGFGnGRV2fsE9YB
X-Google-Smtp-Source: APXvYqxR838XZ/vlMKbRK5g41cM9jK0LAXal1wmVLKOlFPo3+6Zm04hAQdB16tAZbBIQ1PFDnVj27P0uotkvqRNwnFI=
X-Received: by 2002:a05:651c:93:: with SMTP id 19mr14338697ljq.0.1567362204210;
 Sun, 01 Sep 2019 11:23:24 -0700 (PDT)
MIME-Version: 1.0
References: <20190901155205.16877-1-colin.king@canonical.com>
In-Reply-To: <20190901155205.16877-1-colin.king@canonical.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Sun, 1 Sep 2019 14:23:12 -0400
Message-ID: <CAHC9VhR-dBHz_8=OH-8YbidMOO_ecqjioorUTr1GFDV1tTqCJw@mail.gmail.com>
Subject: Re: [PATCH] netlabel: remove redundant assignment to pointer iter
To:     Colin King <colin.king@canonical.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 1, 2019 at 11:52 AM Colin King <colin.king@canonical.com> wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> Pointer iter is being initialized with a value that is never read and
> is being re-assigned a little later on. The assignment is redundant
> and hence can be removed.
>
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  net/netlabel/netlabel_kapi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Acked-by: Paul Moore <paul@paul-moore.com>

> diff --git a/net/netlabel/netlabel_kapi.c b/net/netlabel/netlabel_kapi.c
> index 2b0ef55cf89e..409a3ae47ce2 100644
> --- a/net/netlabel/netlabel_kapi.c
> +++ b/net/netlabel/netlabel_kapi.c
> @@ -607,7 +607,7 @@ static struct netlbl_lsm_catmap *_netlbl_catmap_getnode(
>   */
>  int netlbl_catmap_walk(struct netlbl_lsm_catmap *catmap, u32 offset)
>  {
> -       struct netlbl_lsm_catmap *iter = catmap;
> +       struct netlbl_lsm_catmap *iter;
>         u32 idx;
>         u32 bit;
>         NETLBL_CATMAP_MAPTYPE bitmap;
> --
> 2.20.1

-- 
paul moore
www.paul-moore.com
