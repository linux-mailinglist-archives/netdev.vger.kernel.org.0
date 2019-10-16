Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1953DD8708
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 05:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391129AbfJPDzU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 23:55:20 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44234 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391120AbfJPDzU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 23:55:20 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6C4FC12EEA661;
        Tue, 15 Oct 2019 20:55:19 -0700 (PDT)
Date:   Tue, 15 Oct 2019 20:55:18 -0700 (PDT)
Message-Id: <20191015.205518.153556911541594688.davem@davemloft.net>
To:     sgarzare@redhat.com
Cc:     virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        stefanha@redhat.com, mst@redhat.com, jasowang@redhat.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] vsock/virtio: remove unused 'work' field from 'struct
 virtio_vsock_pkt'
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191015150051.104631-1-sgarzare@redhat.com>
References: <20191015150051.104631-1-sgarzare@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 15 Oct 2019 20:55:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefano Garzarella <sgarzare@redhat.com>
Date: Tue, 15 Oct 2019 17:00:51 +0200

> The 'work' field was introduced with commit 06a8fc78367d0
> ("VSOCK: Introduce virtio_vsock_common.ko")
> but it is never used in the code, so we can remove it to save
> memory allocated in the per-packet 'struct virtio_vsock_pkt'
> 
> Suggested-by: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>

Michael, will you take this?  I assume so...

Thanks.
