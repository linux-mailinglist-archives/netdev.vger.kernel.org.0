Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9483FB4B7C
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 12:04:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726816AbfIQKE3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 06:04:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48272 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726482AbfIQKE3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Sep 2019 06:04:29 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 87BE910F2E8A;
        Tue, 17 Sep 2019 10:04:29 +0000 (UTC)
Received: from gondolin (dhcp-192-230.str.redhat.com [10.33.192.230])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E39B860BEC;
        Tue, 17 Sep 2019 10:04:24 +0000 (UTC)
Date:   Tue, 17 Sep 2019 12:04:22 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Parav Pandit <parav@mellanox.com>
Cc:     alex.williamson@redhat.com, jiri@mellanox.com,
        kwankhede@nvidia.com, davem@davemloft.net, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 2/5] mdev: Make mdev alias unique among all mdevs
Message-ID: <20190917120422.4d71e406.cohuck@redhat.com>
In-Reply-To: <20190902042436.23294-3-parav@mellanox.com>
References: <20190826204119.54386-1-parav@mellanox.com>
        <20190902042436.23294-1-parav@mellanox.com>
        <20190902042436.23294-3-parav@mellanox.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.66]); Tue, 17 Sep 2019 10:04:29 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun,  1 Sep 2019 23:24:33 -0500
Parav Pandit <parav@mellanox.com> wrote:

> Mdev alias should be unique among all the mdevs, so that when such alias
> is used by the mdev users to derive other objects, there is no
> collision in a given system.
> 
> Signed-off-by: Parav Pandit <parav@mellanox.com>
> 
> ---
> Changelog:
> v2->v3:
>  - Changed strcmp() ==0 to !strcmp()
> v1->v2:
>  - Moved alias NULL check at beginning
> v0->v1:
>  - Fixed inclusiong of alias for NULL check
>  - Added ratelimited debug print for sha1 hash collision error
> ---
>  drivers/vfio/mdev/mdev_core.c | 7 +++++++
>  1 file changed, 7 insertions(+)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>
