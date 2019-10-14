Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9119FD5D52
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 10:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730385AbfJNIVw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 04:21:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50490 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729923AbfJNIVw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Oct 2019 04:21:52 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 65465859FC;
        Mon, 14 Oct 2019 08:21:52 +0000 (UTC)
Received: from [10.72.12.241] (ovpn-12-241.pek2.redhat.com [10.72.12.241])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CD2ED1001938;
        Mon, 14 Oct 2019 08:21:39 +0000 (UTC)
Subject: Re: [PATCH v4 1/5] vsock/virtio: limit the memory used per-socket
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org,
        kvm <kvm@vger.kernel.org>
References: <20190717113030.163499-1-sgarzare@redhat.com>
 <20190717113030.163499-2-sgarzare@redhat.com>
 <20190729095956-mutt-send-email-mst@kernel.org>
 <20190830094059.c7qo5cxrp2nkrncd@steredhat>
 <20190901024525-mutt-send-email-mst@kernel.org>
 <CAGxU2F7fA5UtkuMQbOHHy0noOGZUtpepBNKFg5afD81bynMVUQ@mail.gmail.com>
 <20191014081724.GD22963@stefanha-x1.localdomain>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <2398c960-b6d7-8af3-fa25-d75344335db7@redhat.com>
Date:   Mon, 14 Oct 2019 16:21:35 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191014081724.GD22963@stefanha-x1.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Mon, 14 Oct 2019 08:21:52 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/10/14 下午4:17, Stefan Hajnoczi wrote:
> SO_VM_SOCKETS_BUFFER_SIZE might have been useful for VMCI-specific
> applications, but we should use SO_RCVBUF and SO_SNDBUF for portable
> applications in the future.  Those socket options also work with other
> address families.
>
> I guess these sockopts are bypassed by AF_VSOCK because it doesn't use
> the common skb queuing code in net/core/sock.c:(.  But one day we might
> migrate to it...
>
> Stefan


+1, we should really consider to reuse the exist socket mechanism 
instead of re-inventing wheels.

Thanks

