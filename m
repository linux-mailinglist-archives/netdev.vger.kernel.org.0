Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D6D12F361F
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 17:48:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728901AbhALQs0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 11:48:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49309 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726386AbhALQs0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 11:48:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610470020;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7XLvB4LbcBXkUbgWfWoZ/f+2FOlUjTLZfN0yNH6UwEk=;
        b=bbFGDRX2r/1HAeQJkwhIZZ2u9qaxmaPr5H/t2X/0IW+fsHeCDoP7+mXgpMoIYfqeBugrQa
        l4Bt9zc87q9EQ69qtxTsUO/Fsv9SU7Pv0+P4Gl4HmgF10RLo1BC8Z9M3mkbVJw34vqz4ns
        HlKb1rtacQRPiuvBPYMStafR5brw12I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-227-YO3jKo9rMU-81LXUdAY2XA-1; Tue, 12 Jan 2021 11:46:56 -0500
X-MC-Unique: YO3jKo9rMU-81LXUdAY2XA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 80B82180A09E;
        Tue, 12 Jan 2021 16:46:54 +0000 (UTC)
Received: from carbon (unknown [10.36.110.51])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 67ACA5D9CD;
        Tue, 12 Jan 2021 16:46:46 +0000 (UTC)
Date:   Tue, 12 Jan 2021 17:46:45 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        lorenzo.bianconi@redhat.com, toshiaki.makita1@gmail.com,
        brouer@redhat.com
Subject: Re: [PATCH bpf-next 1/2] net: xdp: introduce
 __xdp_build_skb_from_frame utility routine
Message-ID: <20210112174645.598a3929@carbon>
In-Reply-To: <40b3a47fb35b06871bd280564a352b33dcf96c95.1608142960.git.lorenzo@kernel.org>
References: <cover.1608142960.git.lorenzo@kernel.org>
        <40b3a47fb35b06871bd280564a352b33dcf96c95.1608142960.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Dec 2020 19:38:33 +0100
Lorenzo Bianconi <lorenzo@kernel.org> wrote:

> Introduce __xdp_build_skb_from_frame utility routine to build
> the skb from xdp_frame. Rely on __xdp_build_skb_from_frame in
> cpumap code.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  include/net/xdp.h   |  3 +++
>  kernel/bpf/cpumap.c | 45 +--------------------------------------------
>  net/core/xdp.c      | 44 ++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 48 insertions(+), 44 deletions(-)

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>


-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

