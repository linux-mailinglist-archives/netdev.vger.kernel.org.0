Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5235C16961D
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 06:43:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726416AbgBWFnb convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 23 Feb 2020 00:43:31 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:52090 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbgBWFnb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 00:43:31 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::f0c])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 65BDD141C8A55;
        Sat, 22 Feb 2020 21:43:30 -0800 (PST)
Date:   Sat, 22 Feb 2020 21:43:29 -0800 (PST)
Message-Id: <20200222.214329.2179749831482216415.davem@davemloft.net>
To:     eperezma@redhat.com
Cc:     mst@redhat.com, jasowang@redhat.com, kvm@vger.kernel.org,
        netdev@vger.kernel.org, stable@vger.kernel.org, jreuter@yaina.de,
        ralf@linux-mips.org
Subject: Re: [PATCH] vhost: Check docket sk_family instead of call getname
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200221110656.11811-1-eperezma@redhat.com>
References: <20200221110656.11811-1-eperezma@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 22 Feb 2020 21:43:30 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eugenio Pérez <eperezma@redhat.com>
Date: Fri, 21 Feb 2020 12:06:56 +0100

> Doing so, we save one call to get data we already have in the struct.
> 
> Also, since there is no guarantee that getname use sockaddr_ll
> parameter beyond its size, we add a little bit of security here.
> It should do not do beyond MAX_ADDR_LEN, but syzbot found that
> ax25_getname writes more (72 bytes, the size of full_sockaddr_ax25,
> versus 20 + 32 bytes of sockaddr_ll + MAX_ADDR_LEN in syzbot repro).
> 
> Fixes: 3a4d5c94e9593 ("vhost_net: a kernel-level virtio server")
> Reported-by: syzbot+f2a62d07a5198c819c7b@syzkaller.appspotmail.com
> Signed-off-by: Eugenio Pérez <eperezma@redhat.com>

Applied and queued up for -stable, thanks.
