Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 477A92747E
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 04:38:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729621AbfEWChs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 22:37:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35600 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727305AbfEWChr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 22:37:47 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AA1143082163;
        Thu, 23 May 2019 02:37:47 +0000 (UTC)
Received: from [10.72.12.128] (ovpn-12-128.pek2.redhat.com [10.72.12.128])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4A6D910AFEC9;
        Thu, 23 May 2019 02:37:40 +0000 (UTC)
Subject: Re: [PATCH V2 0/4] Prevent vhost kthread from hogging CPU
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, stefanha@redhat.com
References: <1558067392-11740-1-git-send-email-jasowang@redhat.com>
 <20190520085207-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <aa132e69-4646-da70-7def-b6ad72d4ebda@redhat.com>
Date:   Thu, 23 May 2019 10:37:39 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190520085207-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Thu, 23 May 2019 02:37:47 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/5/20 下午8:52, Michael S. Tsirkin wrote:
> On Fri, May 17, 2019 at 12:29:48AM -0400, Jason Wang wrote:
>> Hi:
>>
>> This series try to prevent a guest triggerable CPU hogging through
>> vhost kthread. This is done by introducing and checking the weight
>> after each requrest. The patch has been tested with reproducer of
>> vsock and virtio-net. Only compile test is done for vhost-scsi.
>>
>> Please review.
>> This addresses CVE-2019-3900.
> OK I think we should clean this code some more but given
> it's a CVE fix maybe it's best to do as a patch on top.
>
> Acked-by: Michael S. Tsirkin<mst@redhat.com>
>
> Dave do you want to merge this or should I?
>

According to David's last reply, it's better for you to merge I think.

Thanks

