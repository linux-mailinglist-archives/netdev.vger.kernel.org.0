Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6262A105A76
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 20:37:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726961AbfKUTht (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 14:37:49 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:52254 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbfKUThs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 14:37:48 -0500
Received: from localhost (unknown [IPv6:2001:558:600a:cc:f9f3:9371:b0b8:cb13])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4E4321503A93E;
        Thu, 21 Nov 2019 11:37:47 -0800 (PST)
Date:   Thu, 21 Nov 2019 11:37:32 -0800 (PST)
Message-Id: <20191121.113732.388996672669686057.davem@davemloft.net>
To:     sgarzare@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+e2e5c07bf353b2f79daa@syzkaller.appspotmail.com,
        stefanha@redhat.com, decui@microsoft.com, jhansen@vmware.com
Subject: Re: [PATCH net-next] vsock: avoid to assign transport if its
 initialization fails
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191121090609.13048-1-sgarzare@redhat.com>
References: <20191121090609.13048-1-sgarzare@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 21 Nov 2019 11:37:47 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefano Garzarella <sgarzare@redhat.com>
Date: Thu, 21 Nov 2019 10:06:09 +0100

> If transport->init() fails, we can't assign the transport to the
> socket, because it's not initialized correctly, and any future
> calls to the transport callbacks would have an unexpected behavior.
> 
> Fixes: c0cfa2d8a788 ("vsock: add multi-transports support")
> Reported-and-tested-by: syzbot+e2e5c07bf353b2f79daa@syzkaller.appspotmail.com
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>

Applied.
