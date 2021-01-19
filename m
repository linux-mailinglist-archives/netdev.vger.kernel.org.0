Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C949F2FC572
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 01:14:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390495AbhASNuI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 08:50:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48258 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391219AbhASLKt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 06:10:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611054562;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O2fMZZDQuJKWa78kHqWy72u0NbSs/ePOoOI7YgyeE0M=;
        b=HIFE3zTVFrXFBuYGDlTVQxAfvS1JIQD89HXqM213EGUa0vZYLkIj7qDsjPxnXiSCEJqrQl
        99AME3I7GYnfaULQ33E0wjNiRGz5DmffkkwN4Qm/x0/xboTcBuQEfgUMIIuC0QbgN9xRfj
        Ij83qoCBNvR2+pmYa4rhxnEn1+obY3k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-559-xrMHlhRrMF6ofmY135qcAA-1; Tue, 19 Jan 2021 06:09:21 -0500
X-MC-Unique: xrMHlhRrMF6ofmY135qcAA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CCBF1806662;
        Tue, 19 Jan 2021 11:09:19 +0000 (UTC)
Received: from [10.72.13.139] (ovpn-13-139.pek2.redhat.com [10.72.13.139])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9475372167;
        Tue, 19 Jan 2021 11:09:13 +0000 (UTC)
Subject: Re: [PATCH linux-next v3 6/6] vdpa_sim_net: Add support for user
 supported devices
To:     Parav Pandit <parav@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Eli Cohen <elic@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Sean Mooney <smooney@redhat.com>
References: <20201112064005.349268-1-parav@nvidia.com>
 <20210105103203.82508-1-parav@nvidia.com>
 <20210105103203.82508-7-parav@nvidia.com>
 <20210105064707-mutt-send-email-mst@kernel.org>
 <BY5PR12MB4322E5E7CA71CB2EE0577706DCD10@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20210105071101-mutt-send-email-mst@kernel.org>
 <BY5PR12MB432235169D805760EC0CF7CEDCD10@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20210105082243-mutt-send-email-mst@kernel.org>
 <BY5PR12MB4322EC8D0AD648063C607E17DCAF0@BY5PR12MB4322.namprd12.prod.outlook.com>
 <66dc44ac-52da-eaba-3f5e-69254e42d75b@redhat.com>
 <BY5PR12MB43225D83EA46004E3AF50D3ADCA80@BY5PR12MB4322.namprd12.prod.outlook.com>
 <01213588-d4af-820a-bcf8-c28b8a80c346@redhat.com>
 <BY5PR12MB4322309C33E4871C11535F3CDCA70@BY5PR12MB4322.namprd12.prod.outlook.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <8bc2cf97-3ee4-797a-0ffb-1528b7ce350f@redhat.com>
Date:   Tue, 19 Jan 2021 19:09:11 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <BY5PR12MB4322309C33E4871C11535F3CDCA70@BY5PR12MB4322.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/1/15 下午2:27, Parav Pandit wrote:
>>> With that mac, mtu as optional input fields provide the necessary flexibility
>> for different stacks to take appropriate shape as they desire.
>>
>>
>> Thanks for the clarification. I think we'd better document the above in the
>> patch that introduces the mac setting from management API.
> Yes. Will do.
> Thanks.


Adding Sean.

Regarding to mac address setting. Do we plan to allow to modify mac 
address after the creation? It looks like Openstack wants this.

Sean may share more information on this.

Thanks

