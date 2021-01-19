Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B9822FBE19
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 18:45:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728117AbhASPII (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 10:08:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391947AbhASOzy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 09:55:54 -0500
Received: from ms.lwn.net (ms.lwn.net [IPv6:2600:3c01:e000:3a1::42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5388FC061795;
        Tue, 19 Jan 2021 06:54:02 -0800 (PST)
Received: from lwn.net (unknown [IPv6:2601:281:8300:104d::5f6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id 2A03C3A54;
        Tue, 19 Jan 2021 14:54:01 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 2A03C3A54
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
        t=1611068041; bh=cm0jvBHD4WTdeCztpNJxNQO2lLCKodXdCW5ZFrmgPJ4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iX51HpPWA296zR5nlSf398dDim+1220dwMLfRTF5kRgoFjI+S6/JtTUDwQ8Tbpfty
         DIOPBgcQMqobZC4WF4QaITKGQBF41HTkPD4iDrQOUWodtVZ+xuoAyPOyhTSTOKEAgE
         C7nELS/+B7NXr/9myjRQ/fr11yufDa4Vd5riijST7Gnn5VRZoygapjWyNm711AarAA
         PgvNgz7mbpJxZ8ckyL3ntA5yxJem6FAwxOXE7atQOjvnsUBuYrH5l5hIsnumvRr8Hd
         5h/L8aSD7Shl9P+yABLO+v5R7x1sSxq+9C02Cn+OzYI0pIg1SdE/MKqc210d+RwZn4
         Jo7h4YFGM5nAQ==
Date:   Tue, 19 Jan 2021 07:53:59 -0700
From:   Jonathan Corbet <corbet@lwn.net>
To:     Xie Yongji <xieyongji@bytedance.com>
Cc:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, bob.liu@oracle.com,
        hch@infradead.org, rdunlap@infradead.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, axboe@kernel.dk, bcrl@kvack.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [RFC v3 08/11] vduse: Introduce VDUSE - vDPA Device in
 Userspace
Message-ID: <20210119075359.00204ca6@lwn.net>
In-Reply-To: <20210119050756.600-2-xieyongji@bytedance.com>
References: <20210119045920.447-1-xieyongji@bytedance.com>
        <20210119050756.600-1-xieyongji@bytedance.com>
        <20210119050756.600-2-xieyongji@bytedance.com>
Organization: LWN.net
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 Jan 2021 13:07:53 +0800
Xie Yongji <xieyongji@bytedance.com> wrote:

> diff --git a/Documentation/driver-api/vduse.rst b/Documentation/driver-api/vduse.rst
> new file mode 100644
> index 000000000000..9418a7f6646b
> --- /dev/null
> +++ b/Documentation/driver-api/vduse.rst
> @@ -0,0 +1,85 @@
> +==================================
> +VDUSE - "vDPA Device in Userspace"
> +==================================

Thanks for documenting this feature!  You will, though, need to add this
new document to Documentation/driver-api/index.rst for it to be included
in the docs build.

That said, this would appear to be documentation for user space, right?
So the userspace-api manual is probably a more appropriate place for it.

Thanks,

jon
