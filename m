Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15A3C360AAE
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 15:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232795AbhDONmT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 09:42:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54538 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233149AbhDONmR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 09:42:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618494114;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZWBwNvOA3bfYgGwRaFOHTKgSUsx4hve9qhx0Mr44bE8=;
        b=VAbF1XKpeXQhzm8s1D1r+MYIQ286wXXic707kS0Z8ACmG2hVPyczR0SSL6dl/sTVyYZELY
        ETevtHA8+x+kF16whKQTkgv6Ek4ok/WnKsmOqmTsCQwMmfEBI4KhbD/jouBNr9y8lqM0M4
        rzGca7jrtyfluIr6AXCdeQVhMvXmh5k=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-420--6P9fdAsNBKkhFy6jyathA-1; Thu, 15 Apr 2021 09:41:52 -0400
X-MC-Unique: -6P9fdAsNBKkhFy6jyathA-1
Received: by mail-ed1-f70.google.com with SMTP id h13-20020a05640250cdb02903790a9c55acso5200023edb.4
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 06:41:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZWBwNvOA3bfYgGwRaFOHTKgSUsx4hve9qhx0Mr44bE8=;
        b=jdQtvUq0rW0vNVnsp9gdF+uv0O5USuNMSTdFr8MEna7bELuXBVxA+wyYaShn6LJsUp
         qGvJ5CCG80gKwkbnki8uL6Dr2HA+aWkGNisgEFnFloozRIXXc2zLIxrRXzCtZfmXV5VS
         bu+obRI6frKbnRJkuOu4QjZ/MoIA3YQ2cHU7qf6Ay9zEB6xQhv/AlpaLth10gTZzHLhj
         ShURBI6/nQKV6sAkCNjHNy0qVE5wq88y9wkv+oUuAJ9gg5RVb8+3RWQGdnLPmIaMa3Xe
         H79P9pSOWd1pGHN8Pi/yKMiM1ohN75h8Ue+ZzP8IX6uGiLKZOwt+T3XaE36qZjd8FefC
         cxDQ==
X-Gm-Message-State: AOAM530jv61zEOIcdFgFTNADfMRA88orjdobXcaVSQyhcKIQnA8jP4+p
        BVGW1cdfMdc60nRpot8y6Bek1b8+HV9Q5lx4FRJ2+KHlXnsKDzziZCk5xgtIPaB74g7qCqLZiSN
        2EHI72uqryYCoOa5u
X-Received: by 2002:aa7:c7d5:: with SMTP id o21mr4285849eds.166.1618494111620;
        Thu, 15 Apr 2021 06:41:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyemgNsvx8pZ1RlfDQ7s7LT6G11+jyHeg9kKcfvRUnwPB3uY5DW+Uiq1h1T6dV5iO/rg2AG3A==
X-Received: by 2002:aa7:c7d5:: with SMTP id o21mr4285830eds.166.1618494111460;
        Thu, 15 Apr 2021 06:41:51 -0700 (PDT)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id mm8sm1973637ejb.28.2021.04.15.06.41.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 06:41:51 -0700 (PDT)
Date:   Thu, 15 Apr 2021 15:41:48 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     jasowang@redhat.com, mst@redhat.com, lulu@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 2/3] vDPA/ifcvf: enable Intel C5000X-PL virtio-block
 for vDPA
Message-ID: <20210415134148.q53glknhktbjwtzz@steredhat>
References: <20210415095336.4792-1-lingshan.zhu@intel.com>
 <20210415095336.4792-3-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210415095336.4792-3-lingshan.zhu@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 15, 2021 at 05:53:35PM +0800, Zhu Lingshan wrote:
>This commit enabled Intel FPGA SmartNIC C5000X-PL virtio-block
>for vDPA.
>
>Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>---
> drivers/vdpa/ifcvf/ifcvf_base.h |  8 +++++++-
> drivers/vdpa/ifcvf/ifcvf_main.c | 10 +++++++++-
> 2 files changed, 16 insertions(+), 2 deletions(-)
>
>diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h b/drivers/vdpa/ifcvf/ifcvf_base.h
>index 1c04cd256fa7..0111bfdeb342 100644
>--- a/drivers/vdpa/ifcvf/ifcvf_base.h
>+++ b/drivers/vdpa/ifcvf/ifcvf_base.h
>@@ -15,6 +15,7 @@
> #include <linux/pci_regs.h>
> #include <linux/vdpa.h>
> #include <uapi/linux/virtio_net.h>
>+#include <uapi/linux/virtio_blk.h>
> #include <uapi/linux/virtio_config.h>
> #include <uapi/linux/virtio_pci.h>
>
>@@ -28,7 +29,12 @@
> #define C5000X_PL_SUBSYS_VENDOR_ID	0x8086
> #define C5000X_PL_SUBSYS_DEVICE_ID	0x0001
>
>-#define IFCVF_SUPPORTED_FEATURES \
>+#define C5000X_PL_BLK_VENDOR_ID		0x1AF4
>+#define C5000X_PL_BLK_DEVICE_ID		0x1001
>+#define C5000X_PL_BLK_SUBSYS_VENDOR_ID	0x8086
>+#define C5000X_PL_BLK_SUBSYS_DEVICE_ID	0x0002
>+
>+#define IFCVF_NET_SUPPORTED_FEATURES \
> 		((1ULL << VIRTIO_NET_F_MAC)			| \
> 		 (1ULL << VIRTIO_F_ANY_LAYOUT)			| \
> 		 (1ULL << VIRTIO_F_VERSION_1)			| \
>diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
>index 469a9b5737b7..cea1313b1a3f 100644
>--- a/drivers/vdpa/ifcvf/ifcvf_main.c
>+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
>@@ -171,7 +171,11 @@ static u64 ifcvf_vdpa_get_features(struct vdpa_device *vdpa_dev)
> 	struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
> 	u64 features;
>
>-	features = ifcvf_get_features(vf) & IFCVF_SUPPORTED_FEATURES;
>+	if (vf->dev_type == VIRTIO_ID_NET)
>+		features = ifcvf_get_features(vf) & IFCVF_NET_SUPPORTED_FEATURES;
>+
>+	if (vf->dev_type == VIRTIO_ID_BLOCK)
>+		features = ifcvf_get_features(vf);
>

Should we put a warning here too otherwise feature could be seen 
unassigned?

Thanks,
Stefano

> 	return features;
> }
>@@ -517,6 +521,10 @@ static struct pci_device_id ifcvf_pci_ids[] = {
> 			 C5000X_PL_DEVICE_ID,
> 			 C5000X_PL_SUBSYS_VENDOR_ID,
> 			 C5000X_PL_SUBSYS_DEVICE_ID) },
>+	{ PCI_DEVICE_SUB(C5000X_PL_BLK_VENDOR_ID,
>+			 C5000X_PL_BLK_DEVICE_ID,
>+			 C5000X_PL_BLK_SUBSYS_VENDOR_ID,
>+			 C5000X_PL_BLK_SUBSYS_DEVICE_ID) },
>
> 	{ 0 },
> };
>-- 
>2.27.0
>

