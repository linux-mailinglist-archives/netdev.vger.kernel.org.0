Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A410710B643
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 20:00:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727169AbfK0S76 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 13:59:58 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:56304 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727091AbfK0S76 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 13:59:58 -0500
Received: from localhost (c-73-35-209-67.hsd1.wa.comcast.net [73.35.209.67])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 67E25149C9AA4;
        Wed, 27 Nov 2019 10:59:57 -0800 (PST)
Date:   Wed, 27 Nov 2019 10:59:56 -0800 (PST)
Message-Id: <20191127.105956.842685942160278820.davem@davemloft.net>
To:     mst@redhat.com
Cc:     jcfaracco@gmail.com, netdev@vger.kernel.org, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org, dnmendes76@gmail.com
Subject: Re: [net-next V3 0/2] drivers: net: virtio_net: implement
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191127063624-mutt-send-email-mst@kernel.org>
References: <20191126200628.22251-1-jcfaracco@gmail.com>
        <20191126.140630.1195989367614358026.davem@davemloft.net>
        <20191127063624-mutt-send-email-mst@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 27 Nov 2019 10:59:57 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Wed, 27 Nov 2019 06:38:35 -0500

> On Tue, Nov 26, 2019 at 02:06:30PM -0800, David Miller wrote:
>> 
>> net-next is closed
> 
> Could you merge this early when net-next reopens though?
> This way I don't need to keep adding drivers to update.

It simply needs to be reposted this as soon as net-next opens back up.

I fail to understand even what special treatment you want given to
a given change, it doesn't make any sense.  We have a process for
doing this, it's simple, it's straightforward, and is fair to
everyone.

Thanks.
