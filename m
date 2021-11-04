Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B07B6445217
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 12:19:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231305AbhKDLWR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 07:22:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22750 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230509AbhKDLWQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 07:22:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636024778;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CGsR36Tf8Zco3ONitbn6lIwM0U71XOPWuuitVNowbAQ=;
        b=BVEWfm/FfxCExXv6GTpJUWsDUYqcW5tX0j3T9aAGGdVokoYkuhdpWkSEsMVWxBEh8Bzsjo
        OS2xWeQ7Ix/018mXeD6C62bdANTL1jtPiUa2fickIi4RBGV1jhfbwax9apfetVHHDHkCbp
        fY4adSaxb3wzdbMJnHM7xtmsKkIxZ5Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-204-a8X7VlfGNP-YhpQlYX9_-g-1; Thu, 04 Nov 2021 07:19:34 -0400
X-MC-Unique: a8X7VlfGNP-YhpQlYX9_-g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0D102800053;
        Thu,  4 Nov 2021 11:19:33 +0000 (UTC)
Received: from localhost (unknown [10.39.193.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 62E1D6F951;
        Thu,  4 Nov 2021 11:19:13 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Subject: Re: [PATCH V2 mlx5-next 12/14] vfio/mlx5: Implement vfio_pci driver
 for mlx5 devices
In-Reply-To: <20211103120411.3a470501.alex.williamson@redhat.com>
Organization: Red Hat GmbH
References: <20211028234750.GP2744544@nvidia.com>
 <20211029160621.46ca7b54.alex.williamson@redhat.com>
 <20211101172506.GC2744544@nvidia.com>
 <20211102085651.28e0203c.alex.williamson@redhat.com>
 <20211102155420.GK2744544@nvidia.com>
 <20211102102236.711dc6b5.alex.williamson@redhat.com>
 <20211102163610.GG2744544@nvidia.com>
 <20211102141547.6f1b0bb3.alex.williamson@redhat.com>
 <20211103120955.GK2744544@nvidia.com>
 <20211103094409.3ea180ab.alex.williamson@redhat.com>
 <20211103161019.GR2744544@nvidia.com>
 <20211103120411.3a470501.alex.williamson@redhat.com>
User-Agent: Notmuch/0.32.1 (https://notmuchmail.org)
Date:   Thu, 04 Nov 2021 12:19:12 +0100
Message-ID: <877ddob233.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


So, I doubt that I'm the only person trying to follow this discussion
who has lost the overview about issues and possible solutions here. I
think it would be a good idea to summarize what has been brought up so
far outside of this thread.

To that effect, I've created an etherpad at
https://etherpad.opendev.org/p/VFIOMigrationDiscussions and started
filling it with some points. It would be great if others could fill in
the blanks so that everyone has a chance to see what is on the table so
far, so that we can hopefully discuss this on-list and come up with
something that works.

