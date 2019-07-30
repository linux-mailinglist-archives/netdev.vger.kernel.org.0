Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53C717A4C6
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 11:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730903AbfG3JkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 05:40:17 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36895 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727009AbfG3JkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 05:40:17 -0400
Received: by mail-wr1-f67.google.com with SMTP id n9so39916770wrr.4
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 02:40:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=fQg1192WhNDyv6FjBGie6urrqGv9zjrLIH2bCUp56uc=;
        b=SkoWiAaJzgSrR7Tc2p5yrnk88xUTVMrW3ZqlKi/52mIqWMoTypCEu0Ic3HLQcMv5A9
         iKm+8MgtibZQW9o7MP0RYWJz6cFhj5cCK/1GhpfGo0PkZV9Zx+qvf+F/125QqzAlHWUD
         oGomxOgBM1PlQxZ/U/Wy7nn3rKGtx65hpVOTwFsPdanJpUJwzdeWxADRFZve0VqUuCU3
         MN9SPPSCJYvzT+DLWnK2HMpfHg0chzle4uBoPu7iWT9tSzbxucJVxnSVbJ2s4DRvRpeP
         OaWnU5gpB8+p1wOsmrSHVF029+/CFWKI1JWU+ZMm97G4b95W7oHilWwrgeJNJO011VxB
         +7EQ==
X-Gm-Message-State: APjAAAVe1I08fTfs83AkrRASo10WT+8VHEkWlovYVzrGaDvGswqbBfoa
        Lec9tG7LqcF1IMHzHhD9XoMXig==
X-Google-Smtp-Source: APXvYqwQrJXSgJVI83eo1dkA3KRV/8pRzTuIDgoLCeF0kh3lvGAFxSVFdhlDZkRo9pud0n2msXMp9A==
X-Received: by 2002:a5d:50d1:: with SMTP id f17mr72705216wrt.124.1564479615723;
        Tue, 30 Jul 2019 02:40:15 -0700 (PDT)
Received: from steredhat (host122-201-dynamic.13-79-r.retail.telecomitalia.it. [79.13.201.122])
        by smtp.gmail.com with ESMTPSA id r12sm77203676wrt.95.2019.07.30.02.40.14
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 30 Jul 2019 02:40:15 -0700 (PDT)
Date:   Tue, 30 Jul 2019 11:40:13 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v4 0/5] vsock/virtio: optimizations to increase the
 throughput
Message-ID: <20190730094013.ruqjllqrjmkdnh5y@steredhat>
References: <20190717113030.163499-1-sgarzare@redhat.com>
 <20190729095743-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190729095743-mutt-send-email-mst@kernel.org>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 29, 2019 at 09:59:23AM -0400, Michael S. Tsirkin wrote:
> On Wed, Jul 17, 2019 at 01:30:25PM +0200, Stefano Garzarella wrote:
> > This series tries to increase the throughput of virtio-vsock with slight
> > changes.
> > While I was testing the v2 of this series I discovered an huge use of memory,
> > so I added patch 1 to mitigate this issue. I put it in this series in order
> > to better track the performance trends.
> 
> Series:
> 
> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> 
> Can this go into net-next?
> 

I think so.
Michael, Stefan thanks to ack the series!

Should I resend it with net-next tag?

Thanks,
Stefano
