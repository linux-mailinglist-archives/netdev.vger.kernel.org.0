Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 819F72118D
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 03:05:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727891AbfEQBFk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 21:05:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48488 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727370AbfEQBFj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 May 2019 21:05:39 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3D4D430001DD;
        Fri, 17 May 2019 01:05:39 +0000 (UTC)
Received: from [10.72.12.67] (ovpn-12-67.pek2.redhat.com [10.72.12.67])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 58EBB7941E;
        Fri, 17 May 2019 01:05:32 +0000 (UTC)
Subject: Re: [PATCH net 3/4] vhost: vsock: add weight support
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     mst@redhat.com, virtualization@lists.linux-foundation.org,
        kvm@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com
References: <1557992862-27320-1-git-send-email-jasowang@redhat.com>
 <1557992862-27320-4-git-send-email-jasowang@redhat.com>
 <20190516093352.GQ29507@stefanha-x1.localdomain>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <70c24182-9238-1a69-8e35-53c98b957bc7@redhat.com>
Date:   Fri, 17 May 2019 09:05:30 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190516093352.GQ29507@stefanha-x1.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Fri, 17 May 2019 01:05:39 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/5/16 下午5:33, Stefan Hajnoczi wrote:
> On Thu, May 16, 2019 at 03:47:41AM -0400, Jason Wang wrote:
>> @@ -183,7 +184,8 @@ static struct vhost_vsock *vhost_vsock_get(u32 guest_cid)
>>   		virtio_transport_deliver_tap_pkt(pkt);
>>   
>>   		virtio_transport_free_pkt(pkt);
>> -	}
>> +		total_len += pkt->len;
> Please increment total_len before virtio_transport_free_pkt(pkt) to
> avoid use-after-free.


Right, let me fix this.

Thanks


