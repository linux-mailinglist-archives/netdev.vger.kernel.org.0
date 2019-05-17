Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0664021DB7
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 20:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729379AbfEQSrX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 14:47:23 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46380 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729127AbfEQSrW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 May 2019 14:47:22 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 760DB13E2B9D7;
        Fri, 17 May 2019 11:47:21 -0700 (PDT)
Date:   Fri, 17 May 2019 11:47:20 -0700 (PDT)
Message-Id: <20190517.114720.1616258447183708235.davem@davemloft.net>
To:     sgarzare@redhat.com
Cc:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stefanha@redhat.com, stable@vger.kernel.org
Subject: Re: [PATCH v3] vsock/virtio: free packets during the socket release
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190517144543.362935-1-sgarzare@redhat.com>
References: <20190517144543.362935-1-sgarzare@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 17 May 2019 11:47:21 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefano Garzarella <sgarzare@redhat.com>
Date: Fri, 17 May 2019 16:45:43 +0200

> When the socket is released, we should free all packets
> queued in the per-socket list in order to avoid a memory
> leak.
> 
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>

Applied and queued up for -stable.
