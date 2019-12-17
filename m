Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADDF8121F36
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 01:07:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727393AbfLQAHh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 19:07:37 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:57546 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726655AbfLQAHh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 19:07:37 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 60F511556D1C4;
        Mon, 16 Dec 2019 16:07:36 -0800 (PST)
Date:   Mon, 16 Dec 2019 16:07:35 -0800 (PST)
Message-Id: <20191216.160735.2178914413882940281.davem@davemloft.net>
To:     sgarzare@redhat.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        stefanha@redhat.com
Subject: Re: [PATCH net 0/2] vsock/virtio: fix null-pointer dereference and
 related precautions
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191213184801.486675-1-sgarzare@redhat.com>
References: <20191213184801.486675-1-sgarzare@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 16 Dec 2019 16:07:36 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefano Garzarella <sgarzare@redhat.com>
Date: Fri, 13 Dec 2019 19:47:59 +0100

> This series mainly solves a possible null-pointer dereference in
> virtio_transport_recv_listen() introduced with the multi-transport
> support [PATCH 1].
> 
> PATCH 2 adds a WARN_ON check for the same potential issue
> and a returned error in the virtio_transport_send_pkt_info() function
> to avoid crashing the kernel.

Series applied, thanks.
