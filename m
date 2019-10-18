Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CD72DCC7D
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 19:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409264AbfJRRUG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 13:20:06 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55278 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405285AbfJRRUG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 13:20:06 -0400
Received: from localhost (unknown [IPv6:2603:3023:50c:85e1:5314:1b70:2a53:887e])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 66A9C11D4071A;
        Fri, 18 Oct 2019 10:20:05 -0700 (PDT)
Date:   Fri, 18 Oct 2019 13:20:04 -0400 (EDT)
Message-Id: <20191018.132004.44442251462291428.davem@davemloft.net>
To:     sgarzare@redhat.com
Cc:     netdev@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH net 0/2] vsock/virtio: make the credit mechanism more
 robust
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191017124403.266242-1-sgarzare@redhat.com>
References: <20191017124403.266242-1-sgarzare@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 18 Oct 2019 10:20:05 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefano Garzarella <sgarzare@redhat.com>
Date: Thu, 17 Oct 2019 14:44:01 +0200

> This series makes the credit mechanism implemented in the
> virtio-vsock devices more robust.
> Patch 1 sends an update to the remote peer when the buf_alloc
> change.
> Patch 2 prevents a malicious peer (especially the guest) can
> consume all the memory of the other peer, discarding packets
> when the credit available is not respected.

Series applied, thanks.
