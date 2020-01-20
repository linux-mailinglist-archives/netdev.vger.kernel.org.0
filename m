Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BBF6142699
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 10:06:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbgATJGO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 04:06:14 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:54952 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbgATJGO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 04:06:14 -0500
Received: from localhost (82-95-191-104.ip.xs4all.nl [82.95.191.104])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B741D153D04BF;
        Mon, 20 Jan 2020 01:06:11 -0800 (PST)
Date:   Mon, 20 Jan 2020 10:06:10 +0100 (CET)
Message-Id: <20200120.100610.546818167633238909.davem@davemloft.net>
To:     sgarzare@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jhansen@vmware.com, jasowang@redhat.com, kvm@vger.kernel.org,
        stefanha@redhat.com, virtualization@lists.linux-foundation.org,
        linux-hyperv@vger.kernel.org, mst@redhat.com, decui@microsoft.com
Subject: Re: [PATCH net-next 1/3] vsock: add network namespace support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200116172428.311437-2-sgarzare@redhat.com>
References: <20200116172428.311437-1-sgarzare@redhat.com>
        <20200116172428.311437-2-sgarzare@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 20 Jan 2020 01:06:13 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefano Garzarella <sgarzare@redhat.com>
Date: Thu, 16 Jan 2020 18:24:26 +0100

> This patch adds 'netns' module param to enable this new feature
> (disabled by default), because it changes vsock's behavior with
> network namespaces and could break existing applications.

Sorry, no.

I wonder if you can even design a legitimate, reasonable, use case
where these netns changes could break things.

I am totally against adding a module parameter for this, it's
incredibly confusing for users and will create a test scenerio
that is strongly less likely to be covered.

