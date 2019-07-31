Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBB957BBD2
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 10:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727941AbfGaIiB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 04:38:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32910 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726168AbfGaIiB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Jul 2019 04:38:01 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CD99FC007359;
        Wed, 31 Jul 2019 08:38:00 +0000 (UTC)
Received: from gondolin (dhcp-192-232.str.redhat.com [10.33.192.232])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 30EE16012E;
        Wed, 31 Jul 2019 08:37:54 +0000 (UTC)
Date:   Wed, 31 Jul 2019 10:37:51 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        devel@driverdev.osuosl.org, linux-input@vger.kernel.org,
        kvm@vger.kernel.org, "Michael S . Tsirkin" <mst@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        virtualization@lists.linux-foundation.org,
        Jason Gunthorpe <jgg@mellanox.com>,
        linux-mtd@lists.infradead.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-fsdevel@vger.kernel.org,
        ceph-devel@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux1394-devel@lists.sourceforge.net,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 12/29] compat_ioctl: move drivers to compat_ptr_ioctl
Message-ID: <20190731103751.3cc53132.cohuck@redhat.com>
In-Reply-To: <20190730195227.742215-1-arnd@arndb.de>
References: <20190730192552.4014288-1-arnd@arndb.de>
        <20190730195227.742215-1-arnd@arndb.de>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Wed, 31 Jul 2019 08:38:01 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Jul 2019 21:50:28 +0200
Arnd Bergmann <arnd@arndb.de> wrote:

> Each of these drivers has a copy of the same trivial helper function to
> convert the pointer argument and then call the native ioctl handler.
> 
> We now have a generic implementation of that, so use it.
> 
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
> Reviewed-by: Jiri Kosina <jkosina@suse.cz>
> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---

>  drivers/vfio/vfio.c               | 39 +++----------------------------

vfio changes:

Reviewed-by: Cornelia Huck <cohuck@redhat.com>
