Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12DED4CA1D8
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 11:10:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234834AbiCBKKw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 05:10:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240887AbiCBKKt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 05:10:49 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2992DE029
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 02:10:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646215806;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5oe0uhGT1oxcqFitX5hOxI+lyaZearD/CJbfdsAWIgE=;
        b=IOH9FW7Fq4jf3v+Ug8MsNMPpht/eELUEfQb4EVIqkRe+UQFFS2weWbP/rzMAmu9QUeSo4L
        hfgIA/azvm9f3EsCJipVcxF3vTAhRl7tapdLkgWLrosoEQILo10SRJYZ8qzsvrrQ2PU7pr
        Z7v0g9ZfoRDk3S4KEsGjw0Ih3Ay3SyA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-498--SYOi-OoN2yQzTplSsSyLg-1; Wed, 02 Mar 2022 05:10:03 -0500
X-MC-Unique: -SYOi-OoN2yQzTplSsSyLg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BB489FC81;
        Wed,  2 Mar 2022 10:10:00 +0000 (UTC)
Received: from localhost (unknown [10.39.194.94])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4C3EE1042A56;
        Wed,  2 Mar 2022 10:09:52 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        bhelgaas@google.com, jgg@nvidia.com, saeedm@nvidia.com
Cc:     linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, yishaih@nvidia.com,
        maorg@nvidia.com, ashok.raj@intel.com, kevin.tian@intel.com,
        shameerali.kolothum.thodi@huawei.com, qemu-devel@nongnu.org
Subject: Re: [PATCH V9 mlx5-next 11/15] vfio: Remove migration protocol v1
 documentation
In-Reply-To: <20220224142024.147653-12-yishaih@nvidia.com>
Organization: Red Hat GmbH
References: <20220224142024.147653-1-yishaih@nvidia.com>
 <20220224142024.147653-12-yishaih@nvidia.com>
User-Agent: Notmuch/0.34 (https://notmuchmail.org)
Date:   Wed, 02 Mar 2022 11:09:50 +0100
Message-ID: <87wnhcis29.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 24 2022, Yishai Hadas <yishaih@nvidia.com> wrote:

> From: Jason Gunthorpe <jgg@nvidia.com>
>
> v1 was never implemented and is replaced by v2.
>
> The old uAPI documentation is removed from the header file.
>
> The old uAPI definitions are still kept in the header file to ease
> transition for userspace copying these headers. They will be fully
> removed down the road.
>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> ---
>  include/uapi/linux/vfio.h | 200 +-------------------------------------
>  1 file changed, 2 insertions(+), 198 deletions(-)
>
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 26a66f68371d..fea86061b44e 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -323,7 +323,7 @@ struct vfio_region_info_cap_type {
>  #define VFIO_REGION_TYPE_PCI_VENDOR_MASK	(0xffff)
>  #define VFIO_REGION_TYPE_GFX                    (1)
>  #define VFIO_REGION_TYPE_CCW			(2)
> -#define VFIO_REGION_TYPE_MIGRATION              (3)
> +#define VFIO_REGION_TYPE_MIGRATION_DEPRECATED   (3)

This means that QEMU will need to do a (simple) rename when it updates
the headers, but that seems easy enough. (cc: to give a heads up.)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

