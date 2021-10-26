Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB40043B5B7
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 17:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236987AbhJZPkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 11:40:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57780 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236984AbhJZPkC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 11:40:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635262657;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=I9aArYQBYTlIeaGnK89lJ08k0OM+ZE9Vpe6hYzP2dBQ=;
        b=IWnSQPs0hM/IMVVEsFMYeE9CHFVTZEpE/P1/Dr0eoTe9gZHbltFrDe+8lMz3k0smntcWox
        Vp2Fwog//CkCGcWZn1Vz9IwOddLbJakIUA8LnOfFTjgjOZSRe7+w09krZM9X/SjDxAUDAN
        e9cqO/V7v3f4kXMBbEbhY89XCAy9iWI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-238-S2amtw1HN12UHe5IEHa8SA-1; Tue, 26 Oct 2021 11:37:34 -0400
X-MC-Unique: S2amtw1HN12UHe5IEHa8SA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6A93A100C672;
        Tue, 26 Oct 2021 15:37:32 +0000 (UTC)
Received: from localhost (unknown [10.39.193.201])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 07E615DF21;
        Tue, 26 Oct 2021 15:37:31 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        bhelgaas@google.com, jgg@nvidia.com, saeedm@nvidia.com
Cc:     linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, yishaih@nvidia.com,
        maorg@nvidia.com
Subject: Re: [PATCH V4 mlx5-next 07/13] vfio: Add a macro for
 VFIO_DEVICE_STATE_ERROR
In-Reply-To: <20211026090605.91646-8-yishaih@nvidia.com>
Organization: Red Hat GmbH
References: <20211026090605.91646-1-yishaih@nvidia.com>
 <20211026090605.91646-8-yishaih@nvidia.com>
User-Agent: Notmuch/0.32.1 (https://notmuchmail.org)
Date:   Tue, 26 Oct 2021 17:37:30 +0200
Message-ID: <87mtmvdcg5.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 26 2021, Yishai Hadas <yishaih@nvidia.com> wrote:

> Add a macro for VFIO_DEVICE_STATE_ERROR to be used to set/check an error
> state.
>
> In addition, update existing macros that include _SAVING | _RESUMING to
> use it.
>
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> ---
>  include/uapi/linux/vfio.h | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

