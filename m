Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BEF4103105
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 02:15:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727614AbfKTBPC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 20:15:02 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47970 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727545AbfKTBPC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 20:15:02 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A8B3E1454E871;
        Tue, 19 Nov 2019 17:15:01 -0800 (PST)
Date:   Tue, 19 Nov 2019 17:15:01 -0800 (PST)
Message-Id: <20191119.171501.666690660172999834.davem@davemloft.net>
To:     sgarzare@redhat.com
Cc:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        decui@microsoft.com, stefanha@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        jhansen@vmware.com
Subject: Re: [PATCH net-next 4/6] vsock: add vsock_loopback transport
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191119110121.14480-5-sgarzare@redhat.com>
References: <20191119110121.14480-1-sgarzare@redhat.com>
        <20191119110121.14480-5-sgarzare@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 19 Nov 2019 17:15:02 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefano Garzarella <sgarzare@redhat.com>
Date: Tue, 19 Nov 2019 12:01:19 +0100

> +static int vsock_loopback_cancel_pkt(struct vsock_sock *vsk)
> +{
> +	struct vsock_loopback *vsock;
> +	struct virtio_vsock_pkt *pkt, *n;
> +	int ret;
> +	LIST_HEAD(freeme);

Reverse christmas tree ordering of local variables here please.
