Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 224A6AB541
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 12:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390009AbfIFKC5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 06:02:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54922 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730500AbfIFKC5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Sep 2019 06:02:57 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3F96D85A03;
        Fri,  6 Sep 2019 10:02:57 +0000 (UTC)
Received: from [10.72.12.16] (ovpn-12-16.pek2.redhat.com [10.72.12.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B06F960A97;
        Fri,  6 Sep 2019 10:02:45 +0000 (UTC)
Subject: Re: [PATCH 0/2] Revert and rework on the metadata accelreation
To:     Jason Gunthorpe <jgg@mellanox.com>
Cc:     "mst@redhat.com" <mst@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "aarcange@redhat.com" <aarcange@redhat.com>,
        "jglisse@redhat.com" <jglisse@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
References: <20190905122736.19768-1-jasowang@redhat.com>
 <20190905135907.GB6011@mellanox.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <7785d39b-b4e7-8165-516c-ee6a08ac9c4e@redhat.com>
Date:   Fri, 6 Sep 2019 18:02:35 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190905135907.GB6011@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Fri, 06 Sep 2019 10:02:57 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/9/5 下午9:59, Jason Gunthorpe wrote:
> On Thu, Sep 05, 2019 at 08:27:34PM +0800, Jason Wang wrote:
>> Hi:
>>
>> Per request from Michael and Jason, the metadata accelreation is
>> reverted in this version and rework in next version.
>>
>> Please review.
>>
>> Thanks
>>
>> Jason Wang (2):
>>    Revert "vhost: access vq metadata through kernel virtual address"
>>    vhost: re-introducing metadata acceleration through kernel virtual
>>      address
> There are a bunch of patches in the queue already that will help
> vhost, and I a working on one for next cycle that will help alot more
> too.


I will check those patches, but if you can give me some pointers or 
keywords it would be much appreciated.


>
> I think you should apply the revert this cycle and rebase the other
> patch for next..
>
> Jason


Yes, the plan is to revert in this release cycle.

Thanks

