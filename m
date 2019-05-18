Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 951BB22458
	for <lists+netdev@lfdr.de>; Sat, 18 May 2019 19:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729517AbfERRvu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 May 2019 13:51:50 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:58516 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726050AbfERRvu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 May 2019 13:51:50 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C611214DD9232;
        Sat, 18 May 2019 10:51:48 -0700 (PDT)
Date:   Sat, 18 May 2019 10:51:48 -0700 (PDT)
Message-Id: <20190518.105148.796052200759156053.davem@davemloft.net>
To:     jemoreira@google.com
Cc:     linux-kernel@vger.kernel.org, stefanha@redhat.com,
        sgarzare@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kernel-team@android.com, stable@vger.kernel.org
Subject: Re: [PATCH RESEND] vsock/virtio: Initialize core virtio vsock
 before registering the driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190516205107.222003-1-jemoreira@google.com>
References: <20190516205107.222003-1-jemoreira@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 18 May 2019 10:51:49 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Jorge E. Moreira" <jemoreira@google.com>
Date: Thu, 16 May 2019 13:51:07 -0700

> Avoid a race in which static variables in net/vmw_vsock/af_vsock.c are
> accessed (while handling interrupts) before they are initialized.
 ...
> Fixes: 22b5c0b63f32 ("vsock/virtio: fix kernel panic after device hot-unplug")
> Cc: Stefan Hajnoczi <stefanha@redhat.com>
> Cc: Stefano Garzarella <sgarzare@redhat.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: kvm@vger.kernel.org
> Cc: virtualization@lists.linux-foundation.org
> Cc: netdev@vger.kernel.org
> Cc: kernel-team@android.com
> Cc: stable@vger.kernel.org [4.9+]
> Signed-off-by: Jorge E. Moreira <jemoreira@google.com>
> Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

Applied and queued up for -stable, thanks.
