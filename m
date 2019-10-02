Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2E87C4584
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 03:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729617AbfJBB1c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 21:27:32 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55300 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727880AbfJBB1c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 21:27:32 -0400
Received: from localhost (unknown [IPv6:2603:3023:50c:85e1:b5c5:ae11:3e54:6a07])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AD73414D8BB4A;
        Tue,  1 Oct 2019 18:27:31 -0700 (PDT)
Date:   Tue, 01 Oct 2019 21:27:28 -0400 (EDT)
Message-Id: <20191001.212728.1087995517897062240.davem@davemloft.net>
To:     matiasevara@gmail.com
Cc:     stefanha@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sgarzare@redhat.com,
        eric.dumazet@gmail.com
Subject: Re: [PATCH net-next v2] vsock/virtio: add support for MSG_PEEK
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1569867923-28200-1-git-send-email-matiasevara@gmail.com>
References: <1569867923-28200-1-git-send-email-matiasevara@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 01 Oct 2019 18:27:32 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matias Ezequiel Vara Larsen <matiasevara@gmail.com>
Date: Mon, 30 Sep 2019 18:25:23 +0000

> This patch adds support for MSG_PEEK. In such a case, packets are not
> removed from the rx_queue and credit updates are not sent.
> 
> Signed-off-by: Matias Ezequiel Vara Larsen <matiasevara@gmail.com>
> Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
> Tested-by: Stefano Garzarella <sgarzare@redhat.com>

Applied.
