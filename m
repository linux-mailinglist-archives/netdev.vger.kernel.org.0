Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1BCC21558
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 10:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728850AbfEQI06 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 04:26:58 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36964 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728001AbfEQI06 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 May 2019 04:26:58 -0400
Received: by mail-wm1-f67.google.com with SMTP id 7so5874494wmo.2
        for <netdev@vger.kernel.org>; Fri, 17 May 2019 01:26:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=sEvENpqG7iRDJFzplTTWGKcKFWzhWauRstxh0Bhc8E4=;
        b=ZlKMsXz0A87VVXbP8o/GMIpV/196NN8vBGgy3N9ECU6vG96oaC9xnIbg0fnFt5If7l
         bJ0ML+P3GZbPuEWORVtg52TFgMmIUEfQf/SU1ogSuIdlb+qszAuNpCx38xD21tDU3pGc
         VLbwX2CKyg6d6s+POZOBSqdqmP9zr6NePwfAxcsgKbz/BEsHUNqY++9OSxCvvdpXEvup
         dvqtvoeyAD6HfZ27mSMjXneqX/ZIGG157hkQuV42MzV7fjve+AbWYBPVvm3/Ue9Kcvuh
         pmaVYrhUPAi1Iqg3VGA1NvhO6M+tU2kR/t+gC469/K8TyAipZC2Cni/dABlfaHOUsTv/
         +tQw==
X-Gm-Message-State: APjAAAWCjkiGWbPq73edRP+8ofr/iGRxTIRKwrz3t5WxW5OO+M+MuoIN
        bDY8YhFkcOAStiEztQVZ11jp3w==
X-Google-Smtp-Source: APXvYqzbrpzTZlidwr0VrrxreIABY704QNogR/kYguVAnOeyJIKbn/D8MSRkU5vYa/5xmd361QHBXQ==
X-Received: by 2002:a1c:c015:: with SMTP id q21mr1265915wmf.75.1558081616187;
        Fri, 17 May 2019 01:26:56 -0700 (PDT)
Received: from steredhat (host151-251-static.12-87-b.business.telecomitalia.it. [87.12.251.151])
        by smtp.gmail.com with ESMTPSA id a5sm6714144wrt.10.2019.05.17.01.26.55
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 17 May 2019 01:26:55 -0700 (PDT)
Date:   Fri, 17 May 2019 10:26:53 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH v2 2/8] vsock/virtio: free packets during the socket
 release
Message-ID: <20190517082653.aymkhkqkj5yminfg@steredhat>
References: <20190510125843.95587-1-sgarzare@redhat.com>
 <20190510125843.95587-3-sgarzare@redhat.com>
 <20190516153218.GC29808@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190516153218.GC29808@stefanha-x1.localdomain>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 16, 2019 at 04:32:18PM +0100, Stefan Hajnoczi wrote:
> On Fri, May 10, 2019 at 02:58:37PM +0200, Stefano Garzarella wrote:
> > When the socket is released, we should free all packets
> > queued in the per-socket list in order to avoid a memory
> > leak.
> > 
> > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> > ---
> >  net/vmw_vsock/virtio_transport_common.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> 
> Ouch, this would be nice as a separate patch that can be merged right
> away (with s/virtio_vsock_buf/virtio_vsock_pkt/).

Okay, I'll fix this patch following the David's comment and I'll send
as a separate patch using the virtio_vsock_pkt.

Thanks,
Stefano
