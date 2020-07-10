Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7943C21B34D
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 12:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbgGJKl0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 06:41:26 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:26807 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726950AbgGJKlM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 06:41:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594377670;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=M5UoexhzgRrAQFFaSl1hdl1q9CRBScTX0FXbMUBveCI=;
        b=eRwoJcK6hdDc+hOaGICmQTPpdO5r/iZPx8k1zzTfIO78GoVH04C6vslUOll+gA5gGK2xME
        5IHf+4RI7henkk0J4/VGvRL6TczTFaIBQpjhlJ2dJO0UL9xiIiSxKqn1QMff09BghQ/ETV
        4Zr2fCgcHCJbqFUcPgYzVRS0QNAaesM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-319-aMk0ES8ROAi4oWTrYtbt4Q-1; Fri, 10 Jul 2020 06:41:08 -0400
X-MC-Unique: aMk0ES8ROAi4oWTrYtbt4Q-1
Received: by mail-wr1-f71.google.com with SMTP id j5so5648924wro.6
        for <netdev@vger.kernel.org>; Fri, 10 Jul 2020 03:41:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=M5UoexhzgRrAQFFaSl1hdl1q9CRBScTX0FXbMUBveCI=;
        b=P67j8CacWiP3TQiJpE8/VhHWqaS2KOL8mvgh+e+//s2grq3GNnoW+MXp+DhJfB5EdH
         dl/6t7fRkeOrAjKMdchFZePcrRSB3MpJwvnKe+9+yrcSSUIC2u4gYChcAXf/46h8V1jC
         Z+nrR+0YXhMXM7J3LjabHEas0BkhcI/FGHY/phRHx5xSsIUifm7IjuFu2zvKAoFgdwuf
         /TaXXwTJtWnNSl7gDprecQ7bCivuK7e7VhcdVssvPN2BJsYCTPrUvJ0rnH01IjiBooi0
         zuOjRi0BMM09Re1UXE1upf8vOrvKGRPjNGZjI4s9gSOuFcLe+XFHaEWARYjnvKWhrTR7
         2zxA==
X-Gm-Message-State: AOAM532Y6PuBENdmx84TCe5qYbMPPh80SgdZQFi0QpwAYDsgcAHnHfQr
        kidEpWxeYtMl/iMuTjzJQHs8rEp0yH7+vGObHvNT0r9Ch/A1Pq5ns6KWtsvAlPpGueFVoGk92qD
        DdNVA1m4yG5R0mEL9
X-Received: by 2002:a05:6000:100c:: with SMTP id a12mr73370696wrx.81.1594377667550;
        Fri, 10 Jul 2020 03:41:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy60ZO1zYTbHETQQGS7sTCxEg96DLLGgaiDRsvrtRzD6t2/yqpDL9PBSe+Ke7VB4naljKUhBQ==
X-Received: by 2002:a05:6000:100c:: with SMTP id a12mr73370675wrx.81.1594377667270;
        Fri, 10 Jul 2020 03:41:07 -0700 (PDT)
Received: from steredhat ([5.171.236.20])
        by smtp.gmail.com with ESMTPSA id u1sm11353994wrb.78.2020.07.10.03.41.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2020 03:41:06 -0700 (PDT)
Date:   Fri, 10 Jul 2020 12:41:03 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     stefanha@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org
Subject: Re: sparse warnings in net/vmw_vsock/virtio_transport.c
Message-ID: <20200710104103.qp47ml6rgsr4l6t7@steredhat>
References: <20200710062421-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200710062421-mutt-send-email-mst@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 10, 2020 at 06:24:51AM -0400, Michael S. Tsirkin wrote:
> RCU trickery:
> 
> net/vmw_vsock/virtio_transport.c:73:17: error: incompatible types in comparison expression (different address spaces):
> net/vmw_vsock/virtio_transport.c:73:17:    struct virtio_vsock [noderef] __rcu *
> net/vmw_vsock/virtio_transport.c:73:17:    struct virtio_vsock *
> net/vmw_vsock/virtio_transport.c:171:17: error: incompatible types in comparison expression (different address spaces):
> net/vmw_vsock/virtio_transport.c:171:17:    struct virtio_vsock [noderef] __rcu *
> net/vmw_vsock/virtio_transport.c:171:17:    struct virtio_vsock *
> net/vmw_vsock/virtio_transport.c:207:17: error: incompatible types in comparison expression (different address spaces):
> net/vmw_vsock/virtio_transport.c:207:17:    struct virtio_vsock [noderef] __rcu *
> net/vmw_vsock/virtio_transport.c:207:17:    struct virtio_vsock *
> net/vmw_vsock/virtio_transport.c:561:13: error: incompatible types in comparison expression (different address spaces):
> net/vmw_vsock/virtio_transport.c:561:13:    struct virtio_vsock [noderef] __rcu *
> net/vmw_vsock/virtio_transport.c:561:13:    struct virtio_vsock *
> net/vmw_vsock/virtio_transport.c:612:9: error: incompatible types in comparison expression (different address spaces):
> net/vmw_vsock/virtio_transport.c:612:9:    struct virtio_vsock [noderef] __rcu *
> net/vmw_vsock/virtio_transport.c:612:9:    struct virtio_vsock *
> net/vmw_vsock/virtio_transport.c:631:9: error: incompatible types in comparison expression (different address spaces):
> net/vmw_vsock/virtio_transport.c:631:9:    struct virtio_vsock [noderef] __rcu *
> net/vmw_vsock/virtio_transport.c:631:9:    struct virtio_vsock *
>   CC [M]  net/vmw_vsock/virtio_transport.o
> 
> can you take a look at fixing this pls?

Thanks for reporting!

We should annotate 'the_virtio_vsock' with __rcu.

I'll send a patch to fix these warnings.

Thanks,
Stefano

