Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14EB6258D4C
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 13:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbgIALRE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 07:17:04 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:55096 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726352AbgIALOn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 07:14:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598958882;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=STUtmyXZIT8KzVqJU5XU2kgQYureljA3Ku1GnLyYimw=;
        b=eflOJVhF4wU+cFqUufWQbmr0ly5UkDL027i6zHChfvAQluBtOVBB4t57Etw0iwiwLuknIz
        C6FLshb30wE32PSSs983xOx0tIM6rykIBvq30gSH9SFKbVc3QUbXjr9TdjJVwszXqM9Emt
        w5CIgpqc5ub7CF0uOXucpuBdge+yn2I=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-548-_SfhHxZqM-mKUPOKrvIYUw-1; Tue, 01 Sep 2020 07:14:40 -0400
X-MC-Unique: _SfhHxZqM-mKUPOKrvIYUw-1
Received: by mail-wm1-f72.google.com with SMTP id l26so276886wmg.7
        for <netdev@vger.kernel.org>; Tue, 01 Sep 2020 04:14:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=STUtmyXZIT8KzVqJU5XU2kgQYureljA3Ku1GnLyYimw=;
        b=LghQdq2Am9J/dekhBYeRVzbrzbWQA2gmyW+Zoo8Z3OwxDnpV/WHIw6jx97XeO0uyvv
         gTt71yeePjNiJTeMwXfVXnD0yxfgRMQlLsXdiWwcBMdxL9F1ZHeKVik3ctzmnjD6kMjP
         vr37bu1D2lWhI77ME+hoWF3En0lQV67/NiEsnn+GduHoaU8Tkem2CmmRRtc6HmQjZ4bN
         wlhv65tn8WpKrbSY8ooC+xNudXh9KsBMFobTtxWJmwtKv61lIsLDXIyEWqfvvqc1iuxy
         zTl/yC3p3gvH1HnltAbzrdy5LO7RkBAiPtMt6LI90LoMMGf40ttNJcJMuT8lWG0JX9ci
         wwWA==
X-Gm-Message-State: AOAM532SBQLIZAXjbR0Fcl4YTV11I//eSC2c63vbBvK3epttvKJPzoHf
        mDLuOgPQXM4Pc43cIFK5qZ7Xj/zpTmOW/Oa1v6lAfWZ6Og/EtNeAJwaXDK9GwYOKEwr0yA1BGpg
        y64qvTuiXVrHbHIvo
X-Received: by 2002:a7b:c925:: with SMTP id h5mr1261027wml.28.1598958879597;
        Tue, 01 Sep 2020 04:14:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyhiep0HYoVEPjzoTxNmrDMLvfem8Qoq1Zugr1LpbcVQJKpBDMnkFnDG0mj5yp0i4zCh7HKeg==
X-Received: by 2002:a7b:c925:: with SMTP id h5mr1261007wml.28.1598958879391;
        Tue, 01 Sep 2020 04:14:39 -0700 (PDT)
Received: from redhat.com (bzq-79-181-14-13.red.bezeqint.net. [79.181.14.13])
        by smtp.gmail.com with ESMTPSA id d18sm1614949wrm.10.2020.09.01.04.14.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2020 04:14:38 -0700 (PDT)
Date:   Tue, 1 Sep 2020 07:14:35 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     jasowang@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@huawei.com
Subject: Re: [PATCH net-next] vhost: fix typo in error message
Message-ID: <20200901071400-mutt-send-email-mst@kernel.org>
References: <1598927949-201997-1-git-send-email-linyunsheng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1598927949-201997-1-git-send-email-linyunsheng@huawei.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 01, 2020 at 10:39:09AM +0800, Yunsheng Lin wrote:
> "enable" should be "disable" when the function name is
> vhost_disable_notify(), which does the disabling work.
> 
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>

Acked-by: Michael S. Tsirkin <mst@redhat.com>

Why net-next though? It's a bugfix, can go into net.


> ---
>  drivers/vhost/vhost.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 5857d4e..b45519c 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -2537,7 +2537,7 @@ void vhost_disable_notify(struct vhost_dev *dev, struct vhost_virtqueue *vq)
>  	if (!vhost_has_feature(vq, VIRTIO_RING_F_EVENT_IDX)) {
>  		r = vhost_update_used_flags(vq);
>  		if (r)
> -			vq_err(vq, "Failed to enable notification at %p: %d\n",
> +			vq_err(vq, "Failed to disable notification at %p: %d\n",
>  			       &vq->used->flags, r);
>  	}
>  }
> -- 
> 2.8.1

