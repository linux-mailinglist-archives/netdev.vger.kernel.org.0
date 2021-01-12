Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D35F82F3632
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 17:53:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404671AbhALQwF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 11:52:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51748 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390816AbhALQwE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 11:52:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610470238;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eXRq5FkLjQCjrLgNBmZ5SK/YeAT6zlrPLfyN9cRDM30=;
        b=XvCqxkqAAPuOZlKh6ki79iSJDq1bBdsp07GKMCdxOV4Khberm8eAqQFaLQ8mooKOkWUN71
        b/us4kcs2MQjtxX3wuS3kbyImDwXf0RCGx/P1wJHNS9eip6JtIX0vsXyOFEqUOLOQJVwBT
        Xgqmh0kOPt4TwDTScLmEF5X36NdYSc8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-558-on_ZDqD-N3a69Yv3dz33lQ-1; Tue, 12 Jan 2021 11:50:34 -0500
X-MC-Unique: on_ZDqD-N3a69Yv3dz33lQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 721F41006C84;
        Tue, 12 Jan 2021 16:50:33 +0000 (UTC)
Received: from carbon (unknown [10.36.110.51])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 38E455B698;
        Tue, 12 Jan 2021 16:50:25 +0000 (UTC)
Date:   Tue, 12 Jan 2021 17:50:23 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        lorenzo.bianconi@redhat.com, toshiaki.makita1@gmail.com,
        brouer@redhat.com
Subject: Re: [PATCH bpf-next 2/2] net: xdp: introduce
 xdp_build_skb_from_frame utility routine
Message-ID: <20210112175023.67a5516c@carbon>
In-Reply-To: <9d24e4c90c91aa2d9de413ee38adc4e8e44fc81a.1608142960.git.lorenzo@kernel.org>
References: <cover.1608142960.git.lorenzo@kernel.org>
        <9d24e4c90c91aa2d9de413ee38adc4e8e44fc81a.1608142960.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Dec 2020 19:38:34 +0100
Lorenzo Bianconi <lorenzo@kernel.org> wrote:

> Introduce xdp_build_skb_from_frame utility routine to build the skb
> from xdp_frame. Respect to __xdp_build_skb_from_frame,
> xdp_build_skb_from_frame will allocate the skb object. Rely on
> xdp_build_skb_from_frame in veth driver.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/veth.c | 18 +++---------------
>  include/net/xdp.h  |  2 ++
>  net/core/xdp.c     | 15 +++++++++++++++
>  3 files changed, 20 insertions(+), 15 deletions(-)

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

