Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E31542AEDC6
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 10:30:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727218AbgKKJaA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 04:30:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727193AbgKKJ36 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 04:29:58 -0500
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A06CC0613D1;
        Wed, 11 Nov 2020 01:29:58 -0800 (PST)
Received: by mail-ot1-x334.google.com with SMTP id 79so1523116otc.7;
        Wed, 11 Nov 2020 01:29:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=zKusWzXmLlOMRnj3BtSPpyun+4DjiVw4QxGAPL3NRyc=;
        b=aQxj+p014zNzgfjUsnYJpKUEHCvRJHHONE2RhqqJYCQQ+1LVWso6n9NwAMGIUQaovQ
         t+JpMlgrtxOkfvHp5j+WHItDxcHf0v6mfa/rIjAnUuQHBg/pCXyZqZMRpu1EY7ADGrgA
         ExYf8RY+ILh1+im8jtaSb0qDMS/naL0RB3Z+I2yBvltBlQxW4GR3VchT9Z/eIwcQKeWk
         P/+S2G0CozeguW2w98qYF81QiFMjkd5xHsy2UwVwD+85vUu0OV98ERxWxMRhcNMMdki6
         pvMZnS7BK4gewU58YDhz3bRmX+70xqFtgfvbNfh+q7IZZRwVR8zNlXyjyil3N0wZiKMn
         j5ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=zKusWzXmLlOMRnj3BtSPpyun+4DjiVw4QxGAPL3NRyc=;
        b=qS5UTow8GmU6Fx3fR5lmcW/F+cI9pJjqB+iTfZjXQWBBjF21+cViDK0IUvujRemvKG
         ec43RGzgPS8LzdkrVCQ85/uAEkiLu8pe57c+7XjRQ0IqMpzFQ5kDQ8zdn6yLalMueVk9
         erJbvNElZFDxFosdc9fxlCdaPSm87igHaVj0FMDezetxljVzc0qgU78XOtTzxttpt5ir
         bXlysJjh7yq+OMhUJcU/V2KXoSHq4Bu0W+l1gylgykikQlz57cCvgJnkGSfGqqL2wpN9
         jFhhr+HxXbC8JrezH8FvijcrUx0xesFjBnOHxpzWXPeSF7IEGew+5lN40+NlWnnqXTSQ
         lO4Q==
X-Gm-Message-State: AOAM530Rvx54N1UgzTQQDivC+ZEG6MvQFgwIBsLLNftdGtzGjA4GR/Po
        SOpGauPXzZUyphuQ35fmN8bDAoXTyUs2ew==
X-Google-Smtp-Source: ABdhPJxFA/1RexfH5LkDfECu8U/iKhMuqB+8biYkM+x6HoBHAZLwDJcJ9VrTbtHwm4GU0783TS8G2Q==
X-Received: by 2002:a9d:32f6:: with SMTP id u109mr15911371otb.255.1605086997592;
        Wed, 11 Nov 2020 01:29:57 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id a5sm110537oto.1.2020.11.11.01.29.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2020 01:29:56 -0800 (PST)
Date:   Wed, 11 Nov 2020 01:29:48 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        lorenzo.bianconi@redhat.com, brouer@redhat.com,
        ilias.apalodimas@linaro.org
Message-ID: <5fabaf0c4a68a_bb2602085a@john-XPS-13-9370.notmuch>
In-Reply-To: <1229970bf6f36fd4689169a2e47fdcc664d28366.1605020963.git.lorenzo@kernel.org>
References: <cover.1605020963.git.lorenzo@kernel.org>
 <1229970bf6f36fd4689169a2e47fdcc664d28366.1605020963.git.lorenzo@kernel.org>
Subject: RE: [PATCH v5 net-nex 2/5] net: page_pool: add bulk support for
 ptr_ring
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenzo Bianconi wrote:
> Introduce the capability to batch page_pool ptr_ring refill since it is
> usually run inside the driver NAPI tx completion loop.
> 
> Suggested-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Co-developed-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  include/net/page_pool.h | 26 ++++++++++++++++
>  net/core/page_pool.c    | 69 +++++++++++++++++++++++++++++++++++------
>  net/core/xdp.c          |  9 ++----
>  3 files changed, 87 insertions(+), 17 deletions(-)

[...]

> +/* Caller must not use data area after call, as this function overwrites it */
> +void page_pool_put_page_bulk(struct page_pool *pool, void **data,
> +			     int count)
> +{
> +	int i, bulk_len = 0, pa_len = 0;
> +
> +	for (i = 0; i < count; i++) {
> +		struct page *page = virt_to_head_page(data[i]);
> +
> +		page = __page_pool_put_page(pool, page, -1, false);
> +		/* Approved for bulk recycling in ptr_ring cache */
> +		if (page)
> +			data[bulk_len++] = page;
> +	}
> +
> +	if (unlikely(!bulk_len))
> +		return;
> +
> +	/* Bulk producer into ptr_ring page_pool cache */
> +	page_pool_ring_lock(pool);
> +	for (i = 0; i < bulk_len; i++) {
> +		if (__ptr_ring_produce(&pool->ring, data[i]))
> +			data[pa_len++] = data[i];

How about bailing out on the first error? bulk_len should be less than
16 right, so should we really keep retying hoping ring->size changes?

> +	}
> +	page_pool_ring_unlock(pool);
> +
> +	if (likely(!pa_len))
> +		return;
> +
> +	/* ptr_ring cache full, free pages outside producer lock since
> +	 * put_page() with refcnt == 1 can be an expensive operation
> +	 */
> +	for (i = 0; i < pa_len; i++)
> +		page_pool_return_page(pool, data[i]);
> +}
> +EXPORT_SYMBOL(page_pool_put_page_bulk);
> +

Otherwise LGTM.
