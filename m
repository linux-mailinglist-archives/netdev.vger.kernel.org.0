Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC852238C3
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 11:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726013AbgGQJzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 05:55:39 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:59102 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725864AbgGQJzi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 05:55:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594979737;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4HgPVQZqjqb0IpDr7SjvsRwk4Vd9x6AjV+gBUFiaZ0Q=;
        b=RZbK2QrB82iYuDhHDdeO9j6CENviSF7yI/+TOrgImzXjOX3z9VoUYBsUbQD5f37IFoSJ+l
        zEenTjW8eF6VoQ6YbKS5iLzNZWQdUwV2wwGFSiM3j0K85iZyS7es6bpWlb9tsBGmEIPZUm
        Ic3puPT4f/MmZnRswl9Krq1maTVjbvU=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-273-zd0Z0HhVPdOuP1ApQosnfA-1; Fri, 17 Jul 2020 05:55:35 -0400
X-MC-Unique: zd0Z0HhVPdOuP1ApQosnfA-1
Received: by mail-wr1-f72.google.com with SMTP id c6so8349067wru.7
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 02:55:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4HgPVQZqjqb0IpDr7SjvsRwk4Vd9x6AjV+gBUFiaZ0Q=;
        b=TFipE/CfGH/YijpAsoHXhYMrXNJWxgg5JnXjewPcAujb46sOYv4q/k5hYWd3ygcHr6
         slP6QQ0AZx8JhQrj2tkPjaArzy0pylFl4MynjB18xBg1zHIU/wcKLqsAuYft+66rq5ql
         OZn4lQ6p6Erk4chrkR8+BuGr4tyw4f4BhsuqYSPwnnqJH/BQDZo2T4uS/vAsMYajnwJW
         5eqEProqIW2l6kY/vjfV5pnrExP7nbUN1H8PRz86PKWRmIKkmGMnta2nR0OsWvDUNqtQ
         PSQ/CBSjmqcR5N9YOX3xIalw30Hz5cOpUXAhXxIuuyHjwd+J1qI0FHIlvCBKFUDXeUTY
         flDw==
X-Gm-Message-State: AOAM53014zkriI+HUs8urPnLrL60z0tkR9WSPqH6JalTcyA/SwVLH7Vm
        wji26YCFisnXAm3KA1pa3frCzuQf9ZPW5CG6iCWi13qO2B5H87Ch5LKT43jeJGHto+MDqx82A/6
        Hxao02RRm7zEYVBti
X-Received: by 2002:adf:dd83:: with SMTP id x3mr10318050wrl.292.1594979734561;
        Fri, 17 Jul 2020 02:55:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy4+Zr1F1gcwhjUzG2pfo/XM6x9pdAuuOtlRv+hQq37XGji0nBAAJxaOygMIggGY2z8qSRxSg==
X-Received: by 2002:adf:dd83:: with SMTP id x3mr10318032wrl.292.1594979734315;
        Fri, 17 Jul 2020 02:55:34 -0700 (PDT)
Received: from pc-2.home (2a01cb058529bf0075b0798a7f5975cb.ipv6.abo.wanadoo.fr. [2a01:cb05:8529:bf00:75b0:798a:7f59:75cb])
        by smtp.gmail.com with ESMTPSA id 1sm12525772wmf.21.2020.07.17.02.55.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2020 02:55:33 -0700 (PDT)
Date:   Fri, 17 Jul 2020 11:55:32 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Martin Varghese <martinvarghesenokia@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Martin Varghese <martin.varghese@nokia.com>
Subject: Re: [PATCH net-next v3] bareudp: Reverted support to enable &
 disable rx metadata collection
Message-ID: <20200717095532.GA6073@pc-2.home>
References: <1594953312-4580-1-git-send-email-martinvarghesenokia@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1594953312-4580-1-git-send-email-martinvarghesenokia@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 17, 2020 at 08:05:12AM +0530, Martin Varghese wrote:
> From: Martin Varghese <martin.varghese@nokia.com>
> 
> The commit fe80536acf83 ("bareudp: Added attribute to enable & disable
> rx metadata collection") breaks the the original(5.7) default behavior of
> bareudp module to collect RX metadadata at the receive. It was added to
> avoid the crash at the kernel neighbour subsytem when packet with metadata
> from bareudp is processed. But it is no more needed as the
> commit 394de110a733 ("net: Added pointer check for
> dst->ops->neigh_lookup in dst_neigh_lookup_skb") solves this crash.
> 
Acked-by: Guillaume Nault <gnault@redhat.com>

