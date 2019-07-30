Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D2F47B52F
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 23:43:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387730AbfG3Vnc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 17:43:32 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55774 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbfG3Vnb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 17:43:31 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3BC1314E89C44;
        Tue, 30 Jul 2019 14:43:30 -0700 (PDT)
Date:   Tue, 30 Jul 2019 14:43:29 -0700 (PDT)
Message-Id: <20190730.144329.2267958732987589628.davem@davemloft.net>
To:     arnd@arndb.de
Cc:     viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        mst@redhat.com, jarkko.sakkinen@linux.intel.com, jgg@mellanox.com,
        jkosina@suse.cz, stefanha@redhat.com,
        linux-integrity@vger.kernel.org,
        linux1394-devel@lists.sourceforge.net, linux-usb@vger.kernel.org,
        linux-input@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        linux-mtd@lists.infradead.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        ceph-devel@vger.kernel.org
Subject: Re: [PATCH v5 12/29] compat_ioctl: move drivers to compat_ptr_ioctl
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190730195227.742215-1-arnd@arndb.de>
References: <20190730192552.4014288-1-arnd@arndb.de>
        <20190730195227.742215-1-arnd@arndb.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 30 Jul 2019 14:43:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Tue, 30 Jul 2019 21:50:28 +0200

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

I assume this has to go via your series, thus:

Acked-by: David S. Miller <davem@davemloft.net>
