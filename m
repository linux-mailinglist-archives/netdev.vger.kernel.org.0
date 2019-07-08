Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B31462B9C
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 00:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728129AbfGHWfi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 18:35:38 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59632 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728097AbfGHWfh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 18:35:37 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CD2AC12D6BBEF;
        Mon,  8 Jul 2019 15:35:36 -0700 (PDT)
Date:   Mon, 08 Jul 2019 15:35:36 -0700 (PDT)
Message-Id: <20190708.153536.95559795393042220.davem@davemloft.net>
To:     sgarzare@redhat.com
Cc:     netdev@vger.kernel.org, kvm@vger.kernel.org, mst@redhat.com,
        linux-kernel@vger.kernel.org, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org, stefanha@redhat.com
Subject: Re: [PATCH v3 0/3] vsock/virtio: several fixes in the .probe() and
 .remove()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190705110454.95302-1-sgarzare@redhat.com>
References: <20190705110454.95302-1-sgarzare@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 08 Jul 2019 15:35:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefano Garzarella <sgarzare@redhat.com>
Date: Fri,  5 Jul 2019 13:04:51 +0200

> During the review of "[PATCH] vsock/virtio: Initialize core virtio vsock
> before registering the driver", Stefan pointed out some possible issues
> in the .probe() and .remove() callbacks of the virtio-vsock driver.
 ...

Series applied to net-next, thanks.
