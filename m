Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44A43E0E36
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 00:29:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389139AbfJVW3X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 18:29:23 -0400
Received: from mail-lj1-f176.google.com ([209.85.208.176]:37531 "EHLO
        mail-lj1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732686AbfJVW3X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 18:29:23 -0400
Received: by mail-lj1-f176.google.com with SMTP id l21so18902975lje.4
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 15:29:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=9FOtoCFESHJi4wxTzN6IqBIN6ywWAlgMoghhNwhRpqM=;
        b=MmHCB89CJklZxCu7RA3AVIPVHrD3pzJXbkPORYa3HjFwqiJPCTkxBvQuhvsW2IfrFe
         5HEuCjOyed5FfpdhPxjYI6VSrQ9YDwG1mNmmcTVz7u6SYPobeqXP5PeuQ3nvNo9pZpFU
         8EEbgNiJymkvE2oWBuXpPC0Vprl/lFjvT1ALZq07LtleWptY0pZf/p0gRtBo5dLsHmEa
         N3KHQFZnRXR+j633ENPBwNPxuC9Y/Em9G5NUDrUJM6RrIclvlnCmd89D/94o10I9zti1
         lr99WphJoyUGhe1oDW+N1ZNhH/oZtBj8XU8lW6ZGTctX5+48ereaGKhtkfKzM6wlohje
         aAXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=9FOtoCFESHJi4wxTzN6IqBIN6ywWAlgMoghhNwhRpqM=;
        b=jKGFD3GEjJq4qEGQXz4QXdKiksvg8D8zQcvPyaP6E5kl07MhNUyeJuKwoZyP2ycxV8
         QWyBTYh3us0uTUmGchq8cF1EcoDGZ0QnhZDHXxSLP912jJZldL2KME20NjKoFBaG3Beq
         V3LNowMesNBHJ2+kyRSf0ZynQx91cSvqCe8E5XlAijXzgXdkm++A6zPo95a0GY55XIzE
         SAX9Jb4D8yzDiUDw85TU9dh8b1vOxVrVPdIReyDNtJyFwV0u2inbl//eyLb3R1bx3R+U
         XGDx0Gnp4NykxvtRdpEmdYQ5rrFDG0gqSvnNUCXdHoQjui6QVni3BNOYg0t8PS4+3/fi
         cSsQ==
X-Gm-Message-State: APjAAAWFpI7vHr13ZUdyjWcryWwK3rGc5vNX+I9M3C8VZEXCGT6tJdyB
        7oXaVzocNjKWqLTtcJ/JWPphtA==
X-Google-Smtp-Source: APXvYqw9u+Fbae9zCZZJofKlkrDbCHtrHbcSTTrEc5Ccg3iiYwsVqWefC8WGWjEwghACsA+sUNYang==
X-Received: by 2002:a2e:3c05:: with SMTP id j5mr20619250lja.24.1571783361168;
        Tue, 22 Oct 2019 15:29:21 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id j26sm7660642lja.25.2019.10.22.15.29.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2019 15:29:20 -0700 (PDT)
Date:   Tue, 22 Oct 2019 15:29:14 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     "Ben Dooks (Codethink)" <ben.dooks@codethink.co.uk>
Cc:     linux-kernel@lists.codethink.co.uk,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [V2] net: hwbm: if CONFIG_NET_HWBM unset, make stub
 functions static
Message-ID: <20191022152914.19790aea@cakuba.netronome.com>
In-Reply-To: <20191022152551.19730-1-ben.dooks@codethink.co.uk>
References: <20191022152551.19730-1-ben.dooks@codethink.co.uk>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Oct 2019 16:25:51 +0100, Ben Dooks (Codethink) wrote:
> If CONFIG_NET_HWBM is not set, then these stub functions in
> <net/hwbm.h> should be declared static to avoid trying to
> export them from any driver that includes this.
> 
> Fixes the following sparse warnings:
> 
> ./include/net/hwbm.h:24:6: warning: symbol 'hwbm_buf_free' was not declared. Should it be static?
> ./include/net/hwbm.h:25:5: warning: symbol 'hwbm_pool_refill' was not declared. Should it be static?
> ./include/net/hwbm.h:26:5: warning: symbol 'hwbm_pool_add' was not declared. Should it be static?
> 
> Signed-off-by: Ben Dooks (Codethink) <ben.dooks@codethink.co.uk>

Same story, going over 80 chars here, please fix and post v2.

>  include/net/hwbm.h | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/include/net/hwbm.h b/include/net/hwbm.h
> index 81643cf8a1c4..76a303b2925c 100644
> --- a/include/net/hwbm.h
> +++ b/include/net/hwbm.h
> @@ -21,9 +21,9 @@ void hwbm_buf_free(struct hwbm_pool *bm_pool, void *buf);
>  int hwbm_pool_refill(struct hwbm_pool *bm_pool, gfp_t gfp);
>  int hwbm_pool_add(struct hwbm_pool *bm_pool, unsigned int buf_num);
>  #else
> -void hwbm_buf_free(struct hwbm_pool *bm_pool, void *buf) {}
> -int hwbm_pool_refill(struct hwbm_pool *bm_pool, gfp_t gfp) { return 0; }
> -int hwbm_pool_add(struct hwbm_pool *bm_pool, unsigned int buf_num)
> +static inline void hwbm_buf_free(struct hwbm_pool *bm_pool, void *buf) {}
> +static inline int hwbm_pool_refill(struct hwbm_pool *bm_pool, gfp_t gfp) { return 0; }
> +static inline int hwbm_pool_add(struct hwbm_pool *bm_pool, unsigned int buf_num)
>  { return 0; }
>  #endif /* CONFIG_HWBM */
>  #endif /* _HWBM_H */

