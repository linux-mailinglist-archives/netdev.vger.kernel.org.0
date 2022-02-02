Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FB594A7006
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 12:34:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245225AbiBBLek (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 06:34:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:25327 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231363AbiBBLej (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 06:34:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643801678;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zxJP7Iev1jF129Z7QvLz9cNQ21+tXUQ7Hkjq91PkZsk=;
        b=KRijNyL2psPGzs/QyilaFILy8++b660VtHPaKAADVfrgprc2zTmsRqHABetzknSCWfk7VI
        +TEGFfymTcs3LtiFPN1HvwX2Lkc4nBs/1EGWzvv8w5FHsIejQOsrhxxDPIZaVAjo2e+CpG
        Gv4lXoZbkVdLDZcQuCLNpca0VPKwcZY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-251-J0ef2edTO7uCJfqVWmCKJA-1; Wed, 02 Feb 2022 06:34:35 -0500
X-MC-Unique: J0ef2edTO7uCJfqVWmCKJA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A4489196632A;
        Wed,  2 Feb 2022 11:34:33 +0000 (UTC)
Received: from localhost (unknown [10.39.194.123])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 352FFA22D;
        Wed,  2 Feb 2022 11:34:33 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        bhelgaas@google.com, saeedm@nvidia.com, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, netdev@vger.kernel.org, kuba@kernel.org,
        leonro@nvidia.com, kwankhede@nvidia.com, mgurtovoy@nvidia.com,
        maorg@nvidia.com
Subject: Re: [PATCH V6 mlx5-next 10/15] vfio: Remove migration protocol v1
In-Reply-To: <20220201142930.GG1786498@nvidia.com>
Organization: Red Hat GmbH
References: <20220130160826.32449-1-yishaih@nvidia.com>
 <20220130160826.32449-11-yishaih@nvidia.com> <874k5izv8m.fsf@redhat.com>
 <20220201121325.GB1786498@nvidia.com> <87sft2yd50.fsf@redhat.com>
 <20220201125444.GE1786498@nvidia.com> <87mtjayayi.fsf@redhat.com>
 <20220201135231.GF1786498@nvidia.com> <87k0eey8ih.fsf@redhat.com>
 <20220201142930.GG1786498@nvidia.com>
User-Agent: Notmuch/0.34 (https://notmuchmail.org)
Date:   Wed, 02 Feb 2022 12:34:31 +0100
Message-ID: <878ruty01k.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 01 2022, Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Feb 01, 2022 at 03:19:18PM +0100, Cornelia Huck wrote:
>> (- also continue to get the documentation into good shape)
>
> Which items do you see here?

Well, it still needs to be updated, no?

>
>> - have an RFC for QEMU that contains a provisional update of the
>>   relevant vfio headers so that we can discuss the QEMU side (and maybe
>>   shoot down any potential problems in the uapi before they are merged
>>   in the kernel)
>
> This qemu patch is linked in the cover letter.

The QEMU changes need to be discussed on qemu-devel, a link to a git
tree with work in progress only goes so far.

(From my quick look there, this needs to have any headers changes split
out into a separate patch. The changes in migration.c are hard to
review; is there any chance to split the error path cleanups from the
interface changes?)

