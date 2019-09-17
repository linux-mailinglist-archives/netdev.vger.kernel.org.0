Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D4BCB4B9C
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 12:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbfIQKKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 06:10:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60394 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726250AbfIQKKN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Sep 2019 06:10:13 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6E4B98666C;
        Tue, 17 Sep 2019 10:10:13 +0000 (UTC)
Received: from gondolin (dhcp-192-230.str.redhat.com [10.33.192.230])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9929460BEC;
        Tue, 17 Sep 2019 10:10:09 +0000 (UTC)
Date:   Tue, 17 Sep 2019 12:10:07 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Parav Pandit <parav@mellanox.com>
Cc:     alex.williamson@redhat.com, jiri@mellanox.com,
        kwankhede@nvidia.com, davem@davemloft.net, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 4/5] mdev: Introduce an API mdev_alias
Message-ID: <20190917121007.31a7817c.cohuck@redhat.com>
In-Reply-To: <20190902042436.23294-5-parav@mellanox.com>
References: <20190826204119.54386-1-parav@mellanox.com>
        <20190902042436.23294-1-parav@mellanox.com>
        <20190902042436.23294-5-parav@mellanox.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Tue, 17 Sep 2019 10:10:13 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun,  1 Sep 2019 23:24:35 -0500
Parav Pandit <parav@mellanox.com> wrote:

> Introduce an API mdev_alias() to provide access to optionally generated
> alias.
> 
> Signed-off-by: Parav Pandit <parav@mellanox.com>
> ---
>  drivers/vfio/mdev/mdev_core.c | 12 ++++++++++++
>  include/linux/mdev.h          |  1 +
>  2 files changed, 13 insertions(+)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>
