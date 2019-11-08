Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED84BF4D83
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 14:46:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729162AbfKHNq2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 08:46:28 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:34994 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726480AbfKHNq2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 08:46:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573220787;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=abFJLQvhwwMDqvaF1flYGUAxUh2Wuo8PpGQBX/mlRlI=;
        b=hHdWqQFHLwKXW5fRIhYV0zVLXjgMgtVxE5jMpdXcFdcaQdnQ2VD4PneZxPmciq0QKKSzLy
        zwdqnt6y9CnHvK0H/3EmMOR0Ww6h48hb58uVrrl0VrhTrB9uvyuoEPboE6fuxFPMtK5wnY
        rLwucNFzCp43B9Yc/LJ6fdc/b7QYcf8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-366-iIZk8fUgO9iSyGwXaeeOog-1; Fri, 08 Nov 2019 08:46:24 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5E28E1800D7B;
        Fri,  8 Nov 2019 13:46:22 +0000 (UTC)
Received: from gondolin (dhcp-192-218.str.redhat.com [10.33.192.218])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 76C5161F36;
        Fri,  8 Nov 2019 13:46:17 +0000 (UTC)
Date:   Fri, 8 Nov 2019 14:46:15 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Parav Pandit <parav@mellanox.com>
Cc:     alex.williamson@redhat.com, davem@davemloft.net,
        kvm@vger.kernel.org, netdev@vger.kernel.org, saeedm@mellanox.com,
        kwankhede@nvidia.com, leon@kernel.org, jiri@mellanox.com,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next 19/19] mtty: Optionally support mtty alias
Message-ID: <20191108144615.3646e9bb.cohuck@redhat.com>
In-Reply-To: <20191107160834.21087-19-parav@mellanox.com>
References: <20191107160448.20962-1-parav@mellanox.com>
        <20191107160834.21087-1-parav@mellanox.com>
        <20191107160834.21087-19-parav@mellanox.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: iIZk8fUgO9iSyGwXaeeOog-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  7 Nov 2019 10:08:34 -0600
Parav Pandit <parav@mellanox.com> wrote:

> Provide a module parameter to set alias length to optionally generate
> mdev alias.
>=20
> Example to request mdev alias.
> $ modprobe mtty alias_length=3D12
>=20
> Make use of mtty_alias() API when alias_length module parameter is set.
>=20
> Signed-off-by: Parav Pandit <parav@mellanox.com>
> ---
>  samples/vfio-mdev/mtty.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)

If you already have code using the alias interface, you probably don't
need to add it to the sample driver here. Especially as the alias looks
kind of pointless here.

