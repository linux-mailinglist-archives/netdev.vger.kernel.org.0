Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 138AB6CCC9
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 12:32:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389549AbfGRKbz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 06:31:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50538 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726482AbfGRKby (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jul 2019 06:31:54 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AB7823084029;
        Thu, 18 Jul 2019 10:31:54 +0000 (UTC)
Received: from [10.72.12.199] (ovpn-12-199.pek2.redhat.com [10.72.12.199])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 814325D6A9;
        Thu, 18 Jul 2019 10:31:42 +0000 (UTC)
Subject: Re: [RFC v2] vhost: introduce mdev based hardware vhost backend
From:   Jason Wang <jasowang@redhat.com>
To:     Tiwei Bie <tiwei.bie@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>, mst@redhat.com,
        maxime.coquelin@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, dan.daly@intel.com,
        cunming.liang@intel.com, zhihong.wang@intel.com, idos@mellanox.com,
        Rob Miller <rob.miller@broadcom.com>,
        Ariel Adam <aadam@redhat.com>
References: <20190703115245.GA22374@___>
 <64833f91-02cd-7143-f12e-56ab93b2418d@redhat.com> <20190703130817.GA1978@___>
 <b01b8e28-8d96-31dd-56f4-ca7793498c55@redhat.com>
 <20190704062134.GA21116@___> <20190705084946.67b8f9f5@x1.home>
 <20190708061625.GA15936@___>
 <deae5ede-57e9-41e6-ea42-d84e07ca480a@redhat.com>
 <20190709063317.GA29300@___>
 <9aafdc4d-0203-b96e-c205-043db132eb06@redhat.com>
 <20190710062233.GA16212@___>
 <1b49aa84-2c1f-eec2-2809-711e1f2dd7de@redhat.com>
Message-ID: <90e6a722-ce7b-2ab3-0d2d-19b2ca09f2d1@redhat.com>
Date:   Thu, 18 Jul 2019 18:31:36 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1b49aa84-2c1f-eec2-2809-711e1f2dd7de@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Thu, 18 Jul 2019 10:31:54 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/7/10 下午3:22, Jason Wang wrote:
>> Yeah, that's a major concern. If it's true, is it something
>> that's not acceptable?
>
>
> I think not, but I don't know if any other one that care this.
>
>
>>
>>> And I do see some new RFC for VFIO to add more DMA API.
>> Is there any pointers?
>
>
> I don't remember the details, but it should be something related to 
> SVA support in recent intel IOMMU.


E.g this series:

https://www.spinics.net/lists/iommu/msg37146.html

Thanks

