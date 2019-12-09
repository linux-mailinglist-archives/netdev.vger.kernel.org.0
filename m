Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CF5B11799A
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 23:43:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbfLIWnm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 17:43:42 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:36778 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726495AbfLIWnm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 17:43:42 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E0F77154A52AE;
        Mon,  9 Dec 2019 14:43:41 -0800 (PST)
Date:   Mon, 09 Dec 2019 14:43:41 -0800 (PST)
Message-Id: <20191209.144341.154593651924539444.davem@davemloft.net>
To:     mst@redhat.com
Cc:     linux-kernel@vger.kernel.org, jcfaracco@gmail.com,
        netdev@vger.kernel.org, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org, dnmendes76@gmail.com
Subject: Re: [PATCH net-next v9 0/3] netdev: ndo_tx_timeout cleanup
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191209162727.10113-1-mst@redhat.com>
References: <20191209162727.10113-1-mst@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 09 Dec 2019 14:43:42 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Mon, 9 Dec 2019 11:28:57 -0500

> A bunch of drivers want to know which tx queue triggered a timeout,
> and virtio wants to do the same.
> We actually have the info to hand, let's just pass it on to drivers.
> Note: tested with an experimental virtio patch by Julio.
> That patch itself isn't ready yet though, so not included.
> Other drivers compiled only.

Besides the "int" --> "unsigned int" typing issue, I never saw patch #2
neither on the mailing list nor directly sent to me.
