Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB5194A5B9C
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 12:54:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237508AbiBALyf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 06:54:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:46735 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237302AbiBALye (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 06:54:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643716473;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7O/VpXkJV7uTgutRFtAfzL9AjZn8AV+e4Z1Yqkd/jUk=;
        b=Rg7cAPAL4ZrVUrZjkLJ8rF3svEtllVNGOG/2qPhRQ22FghAGbRUgQirzFVfKDOe3t97KQA
        wOwAPCOaLTYthM40tHYknoK0Z5a3DtvfpNcWAiPMPEdtHU6TlPD4r+TWr91WaaF/uX0ee4
        ncvExhB+RFmop9MGP2/xDCFG027TaZc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-49-y9BO8R6gNnm1fdbsgjgqGg-1; Tue, 01 Feb 2022 06:54:30 -0500
X-MC-Unique: y9BO8R6gNnm1fdbsgjgqGg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 56A09510B6;
        Tue,  1 Feb 2022 11:54:12 +0000 (UTC)
Received: from localhost (unknown [10.39.194.79])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CB4056E1E5;
        Tue,  1 Feb 2022 11:54:11 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        bhelgaas@google.com, jgg@nvidia.com, saeedm@nvidia.com
Cc:     linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, yishaih@nvidia.com,
        maorg@nvidia.com
Subject: Re: [PATCH V6 mlx5-next 09/15] vfio: Extend the device migration
 protocol with RUNNING_P2P
In-Reply-To: <20220130160826.32449-10-yishaih@nvidia.com>
Organization: Red Hat GmbH
References: <20220130160826.32449-1-yishaih@nvidia.com>
 <20220130160826.32449-10-yishaih@nvidia.com>
User-Agent: Notmuch/0.34 (https://notmuchmail.org)
Date:   Tue, 01 Feb 2022 12:54:10 +0100
Message-ID: <871r0mztst.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 30 2022, Yishai Hadas <yishaih@nvidia.com> wrote:

> @@ -44,6 +45,7 @@ struct vfio_device {
>  /**
>   * struct vfio_device_ops - VFIO bus driver device callbacks
>   *
> + * @flags: Global flags from enum vfio_device_ops_flags

You add this here, only to remove it in patch 15 again. Leftover from
some refactoring?

>   * @open_device: Called when the first file descriptor is opened for this device
>   * @close_device: Opposite of open_device
>   * @read: Perform read(2) on device file descriptor

