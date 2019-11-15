Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 439D9FD2D0
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 03:12:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbfKOCMz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 21:12:55 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:57650 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726549AbfKOCMy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 21:12:54 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 042ED14B79F67;
        Thu, 14 Nov 2019 18:12:51 -0800 (PST)
Date:   Thu, 14 Nov 2019 18:12:51 -0800 (PST)
Message-Id: <20191114.181251.451070581625618487.davem@davemloft.net>
To:     sgarzare@redhat.com
Cc:     netdev@vger.kernel.org, sthemmin@microsoft.com, arnd@arndb.de,
        jhansen@vmware.com, jasowang@redhat.com,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        mst@redhat.com, haiyangz@microsoft.com, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        sashal@kernel.org, kys@microsoft.com, decui@microsoft.com,
        linux-hyperv@vger.kernel.org
Subject: Re: [PATCH net-next v2 00/15] vsock: add multi-transports support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191114095750.59106-1-sgarzare@redhat.com>
References: <20191114095750.59106-1-sgarzare@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 14 Nov 2019 18:12:52 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefano Garzarella <sgarzare@redhat.com>
Date: Thu, 14 Nov 2019 10:57:35 +0100

> Most of the patches are reviewed by Dexuan, Stefan, and Jorgen.
> The following patches need reviews:
> - [11/15] vsock: add multi-transports support
> - [12/15] vsock/vmci: register vmci_transport only when VMCI guest/host
>           are active
> - [15/15] vhost/vsock: refuse CID assigned to the guest->host transport
> 
> RFC: https://patchwork.ozlabs.org/cover/1168442/
> v1: https://patchwork.ozlabs.org/cover/1181986/

I'm applying this as-is, if there is feedback changes required on 11,
12, and 15 please deal with this using follow-up patches.

Thanks.
