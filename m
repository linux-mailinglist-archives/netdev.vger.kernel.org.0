Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A96F06BC45
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 14:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726978AbfGQM1k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 08:27:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39198 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725936AbfGQM1j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jul 2019 08:27:39 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CA9753DE0F;
        Wed, 17 Jul 2019 12:27:39 +0000 (UTC)
Received: from [10.72.12.61] (ovpn-12-61.pek2.redhat.com [10.72.12.61])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B2E12600C8;
        Wed, 17 Jul 2019 12:27:30 +0000 (UTC)
Subject: Re: [PATCH V3 00/15] Packed virtqueue support for vhost
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jfreimann@redhat.com, tiwei.bie@intel.com,
        maxime.coquelin@redhat.com
References: <20190717105255.63488-1-jasowang@redhat.com>
 <20190717070100-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <af066030-96f1-4a8d-4864-7b6b903477a6@redhat.com>
Date:   Wed, 17 Jul 2019 20:27:28 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190717070100-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Wed, 17 Jul 2019 12:27:39 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/7/17 下午7:02, Michael S. Tsirkin wrote:
> On Wed, Jul 17, 2019 at 06:52:40AM -0400, Jason Wang wrote:
>> Hi all:
>>
>> This series implements packed virtqueues which were described
>> at [1]. In this version we try to address the performance regression
>> saw by V2. The root cause is packed virtqueue need more times of
>> userspace memory accesssing which turns out to be very
>> expensive. Thanks to the help of 7f466032dc9e ("vhost: access vq
>> metadata through kernel virtual address"), such overhead cold be
>> eliminated. So in this version, we can see about 2% improvement for
>> packed virtqueue on PPS.
> Great job, thanks!
> Pls allow a bit more review time than usual as this is a big patchset.
> Should be done by Tuesday.
> -next material anyway.


Sure, just to confirm, I think this should go for your vhost tree?.

Thanks

