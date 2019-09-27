Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39F32BFDCB
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 05:51:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729147AbfI0Dvs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 23:51:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57093 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728995AbfI0Dvs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Sep 2019 23:51:48 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7FA283B58C;
        Fri, 27 Sep 2019 03:51:48 +0000 (UTC)
Received: from [10.72.12.160] (ovpn-12-160.pek2.redhat.com [10.72.12.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 295B1614C1;
        Fri, 27 Sep 2019 03:51:37 +0000 (UTC)
Subject: Re: [PATCH] vhost: introduce mdev based hardware backend
From:   Jason Wang <jasowang@redhat.com>
To:     Tiwei Bie <tiwei.bie@intel.com>, mst@redhat.com,
        alex.williamson@redhat.com, maxime.coquelin@redhat.com
Cc:     kvm@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, zhihong.wang@intel.com,
        lingshan.zhu@intel.com
References: <20190926045427.4973-1-tiwei.bie@intel.com>
 <1b4b8891-8c14-1c85-1d6a-2eed1c90bcde@redhat.com>
Message-ID: <996bcaa3-1b13-2520-5be4-8a8f9c8c71d6@redhat.com>
Date:   Fri, 27 Sep 2019 11:51:35 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1b4b8891-8c14-1c85-1d6a-2eed1c90bcde@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Fri, 27 Sep 2019 03:51:48 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/9/27 上午11:46, Jason Wang wrote:
> +
> +static struct mdev_class_id id_table[] = {
> +    { MDEV_ID_VHOST },
> +    { 0 },
> +};
> +
> +static struct mdev_driver vhost_mdev_driver = {
> +    .name    = "vhost_mdev",
> +    .probe    = vhost_mdev_probe,
> +    .remove    = vhost_mdev_remove,
> +    .id_table = id_table,
> +};
> + 


And you probably need to add MODULE_DEVICE_TABLE() as well.

Thanks

