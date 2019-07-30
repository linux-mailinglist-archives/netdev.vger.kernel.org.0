Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8240D7A56A
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 12:03:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732185AbfG3KDe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 06:03:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58122 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725975AbfG3KDd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jul 2019 06:03:33 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6F9598112E;
        Tue, 30 Jul 2019 10:03:33 +0000 (UTC)
Received: from [10.72.12.185] (ovpn-12-185.pek2.redhat.com [10.72.12.185])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C603C19C6A;
        Tue, 30 Jul 2019 10:03:25 +0000 (UTC)
Subject: Re: [PATCH v4 0/5] vsock/virtio: optimizations to increase the
 throughput
To:     Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
References: <20190717113030.163499-1-sgarzare@redhat.com>
 <20190729095743-mutt-send-email-mst@kernel.org>
 <20190730094013.ruqjllqrjmkdnh5y@steredhat>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <fc568e3d-7af5-5895-89e8-32e35b0f9af4@redhat.com>
Date:   Tue, 30 Jul 2019 18:03:24 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190730094013.ruqjllqrjmkdnh5y@steredhat>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Tue, 30 Jul 2019 10:03:33 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/7/30 下午5:40, Stefano Garzarella wrote:
> On Mon, Jul 29, 2019 at 09:59:23AM -0400, Michael S. Tsirkin wrote:
>> On Wed, Jul 17, 2019 at 01:30:25PM +0200, Stefano Garzarella wrote:
>>> This series tries to increase the throughput of virtio-vsock with slight
>>> changes.
>>> While I was testing the v2 of this series I discovered an huge use of memory,
>>> so I added patch 1 to mitigate this issue. I put it in this series in order
>>> to better track the performance trends.
>> Series:
>>
>> Acked-by: Michael S. Tsirkin <mst@redhat.com>
>>
>> Can this go into net-next?
>>
> I think so.
> Michael, Stefan thanks to ack the series!
>
> Should I resend it with net-next tag?
>
> Thanks,
> Stefano


I think so.

Thanks

