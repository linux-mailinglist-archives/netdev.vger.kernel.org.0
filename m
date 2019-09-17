Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C560B4B90
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 12:09:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbfIQKI6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 06:08:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35542 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725901AbfIQKI6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Sep 2019 06:08:58 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 23A6110DCC84;
        Tue, 17 Sep 2019 10:08:58 +0000 (UTC)
Received: from gondolin (dhcp-192-230.str.redhat.com [10.33.192.230])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 962E760126;
        Tue, 17 Sep 2019 10:08:54 +0000 (UTC)
Date:   Tue, 17 Sep 2019 12:08:52 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Parav Pandit <parav@mellanox.com>
Cc:     alex.williamson@redhat.com, jiri@mellanox.com,
        kwankhede@nvidia.com, davem@davemloft.net, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 3/5] mdev: Expose mdev alias in sysfs tree
Message-ID: <20190917120852.0f6ec4cc.cohuck@redhat.com>
In-Reply-To: <20190902042436.23294-4-parav@mellanox.com>
References: <20190826204119.54386-1-parav@mellanox.com>
        <20190902042436.23294-1-parav@mellanox.com>
        <20190902042436.23294-4-parav@mellanox.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.64]); Tue, 17 Sep 2019 10:08:58 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun,  1 Sep 2019 23:24:34 -0500
Parav Pandit <parav@mellanox.com> wrote:

> Expose the optional alias for an mdev device as a sysfs attribute.
> This way, userspace tools such as udev may make use of the alias, for
> example to create a netdevice name for the mdev.
> 
> Updated documentation for optional read only sysfs attribute.
> 
> Signed-off-by: Parav Pandit <parav@mellanox.com>
> 
> ---
> Changelog:
> v2->v3:
>  - Merged sysfs documentation patch with sysfs addition
>  - Added more description for alias return value
> v0->v1:
>  - Addressed comments from Cornelia Huck
>  - Updated commit description
> ---
>  Documentation/driver-api/vfio-mediated-device.rst |  9 +++++++++
>  drivers/vfio/mdev/mdev_sysfs.c                    | 13 +++++++++++++
>  2 files changed, 22 insertions(+)
> 

(...)

> @@ -281,6 +282,14 @@ Example::
>  
>  	# echo 1 > /sys/bus/mdev/devices/$mdev_UUID/remove
>  
> +* alias (read only, optional)
> +Whenever a parent requested to generate an alias, each mdev device of such

s/such/that/

> +parent is assigned unique alias by the mdev core.

s/unique alias/a unique alias/

> +This file shows the alias of the mdev device.
> +
> +Reading file either returns valid alias when assigned or returns error code

s/file/this file/
s/valid alias/a valid alias/
s/error code/the error code/

> +-EOPNOTSUPP when unsupported.
> +
>  Mediated device Hot plug
>  ------------------------

With the nits above fixed,
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
