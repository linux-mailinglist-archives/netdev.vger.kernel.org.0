Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80FC8AD392
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 09:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387718AbfIIHSa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 03:18:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44636 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731292AbfIIHS3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Sep 2019 03:18:29 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8386310576CC;
        Mon,  9 Sep 2019 07:18:29 +0000 (UTC)
Received: from [10.72.12.61] (ovpn-12-61.pek2.redhat.com [10.72.12.61])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A73161001948;
        Mon,  9 Sep 2019 07:18:06 +0000 (UTC)
Subject: Re: [PATCH 0/2] Revert and rework on the metadata accelreation
To:     David Miller <davem@davemloft.net>
Cc:     jgg@mellanox.com, mst@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, aarcange@redhat.com,
        jglisse@redhat.com, linux-mm@kvack.org
References: <20190905122736.19768-1-jasowang@redhat.com>
 <20190905135907.GB6011@mellanox.com>
 <7785d39b-b4e7-8165-516c-ee6a08ac9c4e@redhat.com>
 <20190906.151505.1486178691190611604.davem@davemloft.net>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <bb9ae371-58b7-b7fc-b728-b5c5f55d3a91@redhat.com>
Date:   Mon, 9 Sep 2019 15:18:01 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190906.151505.1486178691190611604.davem@davemloft.net>
Content-Type: text/plain; charset=iso-2022-jp; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.64]); Mon, 09 Sep 2019 07:18:29 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/9/6 下午9:15, David Miller wrote:
> From: Jason Wang <jasowang@redhat.com>
> Date: Fri, 6 Sep 2019 18:02:35 +0800
>
>> On 2019/9/5 下午9:59, Jason Gunthorpe wrote:
>>> I think you should apply the revert this cycle and rebase the other
>>> patch for next..
>>>
>>> Jason
>> Yes, the plan is to revert in this release cycle.
> Then you should reset patch #1 all by itself targetting 'net'.


Thanks for the reminding. I want the patch to go through Michael's vhost  
tree, that's why I don't put 'net' prefix. For next time, maybe I can  
use "vhost" as a prefix for classification?

