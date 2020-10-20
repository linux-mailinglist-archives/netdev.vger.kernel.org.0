Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B2EF293A37
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 13:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393373AbgJTLp0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 07:45:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38880 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2392246AbgJTLpZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 07:45:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603194324;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wDwUpRJnTUQ2pS+wnEOM7NYhKs7UkxzW53goaPdV3ss=;
        b=NThpCLB8NVGr9z51KSKzu/9VjXUJYW/fXByiNInqzoDybRVaJVgarcgKAIfjX2fPoqIt0p
        PdgyOzlftix3egtsSEG8K4FBKpFdRsoBOox40EWDwzS5XwKvrPjsu96hfecyHEhjPYpU9t
        JcBOyuhFUOIvgYyrur5sebSbZB/1ylA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-501-PqmBdmdjM3Ggnc8VcMLgLg-1; Tue, 20 Oct 2020 07:45:20 -0400
X-MC-Unique: PqmBdmdjM3Ggnc8VcMLgLg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A7CDD1074658;
        Tue, 20 Oct 2020 11:45:18 +0000 (UTC)
Received: from redhat.com (ovpn-112-214.ams2.redhat.com [10.36.112.214])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 847DA5D9EF;
        Tue, 20 Oct 2020 11:45:13 +0000 (UTC)
Date:   Tue, 20 Oct 2020 07:45:09 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        kernel test robot <lkp@intel.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH net v2] Revert "virtio-net: ethtool configurable RXCSUM"
Message-ID: <20201020073651-mutt-send-email-mst@kernel.org>
References: <20201018103122.454967-1-mst@redhat.com>
 <20201019121500.4620e276@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201019121500.4620e276@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 19, 2020 at 12:15:00PM -0700, Jakub Kicinski wrote:
> On Mon, 19 Oct 2020 13:32:12 -0400 Michael S. Tsirkin wrote:
> > This reverts commit 3618ad2a7c0e78e4258386394d5d5f92a3dbccf8.
> > 
> > When the device does not have a control vq (e.g. when using a
> > version of QEMU based on upstream v0.10 or older, or when specifying
> > ctrl_vq=off,ctrl_rx=off,ctrl_vlan=off,ctrl_rx_extra=off,ctrl_mac_addr=off
> > for the device on the QEMU command line), that commit causes a crash:
> 
> Hi Michael!
> 
> Only our very first (non-resend) version got into patchwork:
> 
> https://patchwork.ozlabs.org/project/netdev/list/?submitter=2235&state=*
> 
> Any ideas why?

I really don't! Any ideas?

-- 
MST

