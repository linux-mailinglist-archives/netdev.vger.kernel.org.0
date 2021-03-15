Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63AE133ACCC
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 08:53:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbhCOHwn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 03:52:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33823 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230330AbhCOHwi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 03:52:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615794758;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=M3VcyCK15wuo7OnaOdUlq2bza4tGVkBBmoXXTmML6Bg=;
        b=hnaksWImQGfRmAj4ejiiuviZ9A/5QcjPsO/kdgDZ/JbnnIAxlxLNVUB4BarHUPrrBoLO4X
        qmvo5k37X6G9xiK6CzmIPBvCEwzYaehXskskF6r8Bz4XNGH/3y7wFuXUTcwX1LsFuibuNl
        x36PH6X9UPTWRPy34dMpwAjdRd8T/eQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-425-QbWxkMulMV6r7TYiz1r-2A-1; Mon, 15 Mar 2021 03:52:35 -0400
X-MC-Unique: QbWxkMulMV6r7TYiz1r-2A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 57C5983DD26;
        Mon, 15 Mar 2021 07:52:33 +0000 (UTC)
Received: from [10.36.112.254] (ovpn-112-254.ams2.redhat.com [10.36.112.254])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B094410023BE;
        Mon, 15 Mar 2021 07:52:29 +0000 (UTC)
Subject: Re: [PATCH 15/17] iommu: remove DOMAIN_ATTR_NESTING
To:     Christoph Hellwig <hch@lst.de>
Cc:     Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Li Yang <leoyang.li@nxp.com>, freedreno@lists.freedesktop.org,
        kvm@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org, dri-devel@lists.freedesktop.org,
        virtualization@lists.linux-foundation.org,
        iommu@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>,
        linux-arm-kernel@lists.infradead.org
References: <20210301084257.945454-1-hch@lst.de>
 <20210301084257.945454-16-hch@lst.de>
 <3e8f1078-9222-0017-3fa8-4d884dbc848e@redhat.com>
 <20210314155813.GA788@lst.de>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <3a1194de-a053-84dd-3d6a-bff8e01ebcd3@redhat.com>
Date:   Mon, 15 Mar 2021 08:52:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210314155813.GA788@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Christoph,

On 3/14/21 4:58 PM, Christoph Hellwig wrote:
> On Sun, Mar 14, 2021 at 11:44:52AM +0100, Auger Eric wrote:
>> As mentionned by Robin, there are series planning to use
>> DOMAIN_ATTR_NESTING to get info about the nested caps of the iommu (ARM
>> and Intel):
>>
>> [Patch v8 00/10] vfio: expose virtual Shared Virtual Addressing to VMs
>> patches 1, 2, 3
>>
>> Is the plan to introduce a new domain_get_nesting_info ops then?
> 
> The plan as usual would be to add it the series adding that support.
> Not sure what the merge plans are - if the series is ready to be
> merged I could rebase on top of it, otherwise that series will need
> to add the method.
OK I think your series may be upstreamed first.

Thanks

Eric
> 

