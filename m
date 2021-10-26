Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0BBA43B73C
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 18:32:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236445AbhJZQep (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 12:34:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50983 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235398AbhJZQeo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 12:34:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635265940;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Kk8o+2VQoE4RWYdoNkT0CrFKoRUVSMQnaHqljlFynL0=;
        b=f5iQVfbQmJ00bVs+bxcO6RvNCoaYXb1HQKnYysvKJvlb+lBMkIqHzQNXBvBOlWyObkqMzl
        iXByWvVJHUKlHDt/X1yi7L0eiubVwwv2vJePoJ4LU9G8fPsfVI1rBGHjvsPybo3BSl43La
        XrOjTrQh0TJGH+MeEztiav0VH3bCKAo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-184-djK_BUN8Pd2ZtDa6MbTwSA-1; Tue, 26 Oct 2021 12:32:18 -0400
X-MC-Unique: djK_BUN8Pd2ZtDa6MbTwSA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DDC291808302;
        Tue, 26 Oct 2021 16:32:16 +0000 (UTC)
Received: from localhost (unknown [10.39.193.201])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6D0CB5C1A1;
        Tue, 26 Oct 2021 16:32:10 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Leon Romanovsky <leonro@nvidia.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        bhelgaas@google.com, jgg@nvidia.com, saeedm@nvidia.com,
        linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, kwankhede@nvidia.com,
        mgurtovoy@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V4 mlx5-next 06/13] vfio: Fix
 VFIO_DEVICE_STATE_SET_ERROR macro
In-Reply-To: <YXgqO0/jUFvDWVHv@unreal>
Organization: Red Hat GmbH
References: <20211026090605.91646-1-yishaih@nvidia.com>
 <20211026090605.91646-7-yishaih@nvidia.com> <87pmrrdcos.fsf@redhat.com>
 <YXgqO0/jUFvDWVHv@unreal>
User-Agent: Notmuch/0.32.1 (https://notmuchmail.org)
Date:   Tue, 26 Oct 2021 18:32:08 +0200
Message-ID: <87h7d3d9x3.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 26 2021, Leon Romanovsky <leonro@nvidia.com> wrote:

> On Tue, Oct 26, 2021 at 05:32:19PM +0200, Cornelia Huck wrote:
>> On Tue, Oct 26 2021, Yishai Hadas <yishaih@nvidia.com> wrote:
>> 
>> > Fixed the non-compiled macro VFIO_DEVICE_STATE_SET_ERROR (i.e. SATE
>> > instead of STATE).
>> >
>> > Fixes: a8a24f3f6e38 ("vfio: UAPI for migration interface for device state")
>> > Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
>> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
>> 
>> This s-o-b chain looks weird; your s-o-b always needs to be last.
>
> It is not such clear as it sounds.
>
> Yishai is author of this patch and at some point of time, this patch passed
> through my tree and it will pass again, when we will merge it. This is why
> my SOB is last and not Yishai's.

Strictly speaking, the chain should be Yishai->you->Yishai and you'd add
your s-o-b again when you pick it. Yeah, that looks like overkill; the
current state just looks weird to me, but I'll shut up now.

