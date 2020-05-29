Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 134C71E82E0
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 18:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbgE2QDP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 12:03:15 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:21310 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725795AbgE2QDO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 12:03:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590768194;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JQJBuKxibYAvW+zZiY/Y9en7xdW7sDWElJX/eOrT0u8=;
        b=CLLgeOaNnDndo+Eij9yQM/WZOUoNYF5PVirMqW67rJqPCavBtp+1bWYBzuR/ymmHrljmM6
        6B/Pm7rd5rFm5XVeUt30xLXj0KJls5BfhwRPtREli0883PCLSRrHGhtjjOHGDRMzWVZa7w
        2VMrLkzKHIEsT7OW8a1UWhHMk8YoSUA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-20-zP8Og08BPN-Dpgg_zOU6EQ-1; Fri, 29 May 2020 12:03:10 -0400
X-MC-Unique: zP8Og08BPN-Dpgg_zOU6EQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2A54B107AD74;
        Fri, 29 May 2020 16:03:08 +0000 (UTC)
Received: from carbon (unknown [10.40.208.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DF1A75D9EF;
        Fri, 29 May 2020 16:02:57 +0000 (UTC)
Date:   Fri, 29 May 2020 18:02:56 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        toke@redhat.com, lorenzo@kernel.org, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        brouer@redhat.com
Subject: Re: [PATCH v3 bpf-next 1/5] devmap: Formalize map value as a named
 struct
Message-ID: <20200529180256.2e4d3940@carbon>
In-Reply-To: <2a121938-fe50-694c-40c6-0f4b8edbefb5@gmail.com>
References: <20200529052057.69378-1-dsahern@kernel.org>
        <20200529052057.69378-2-dsahern@kernel.org>
        <20200529102256.22dd50da@carbon>
        <2a121938-fe50-694c-40c6-0f4b8edbefb5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 29 May 2020 09:36:14 -0600
David Ahern <dsahern@gmail.com> wrote:

> On 5/29/20 2:22 AM, Jesper Dangaard Brouer wrote:
> > We do need this struct bpf_devmap_val, but I think it is wrong to make this UAPI.
> > 
> > A BPF-prog can get this via:  #include "vmlinux.h"  
> 
> sure. I see that now.
> 
> I forgot to fold in a small update to the selftests, so I need to send a
> v4 anyways. I will wait until later in the day in case there are other
> comments.

I've just posted a patchset on top of this V3, that moves struct
bpf_devmap_val, and that demonstrate via code that I mean by
leveraging BTF for dynamic config API.

https://lore.kernel.org/netdev/159076794319.1387573.8722376887638960093.stgit@firesoul/

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

