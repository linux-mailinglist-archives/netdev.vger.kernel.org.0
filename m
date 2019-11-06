Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05170F0BCF
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 02:56:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730899AbfKFB4D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 20:56:03 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:41870 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727252AbfKFB4D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 20:56:03 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7FA6F150FEF46;
        Tue,  5 Nov 2019 17:56:02 -0800 (PST)
Date:   Tue, 05 Nov 2019 17:56:02 -0800 (PST)
Message-Id: <20191105.175602.1449990154803335127.davem@davemloft.net>
To:     christophe.jaillet@wanadoo.fr
Cc:     stefanha@redhat.com, ytht.net@gmail.com, sunilmut@microsoft.com,
        willemb@google.com, arnd@arndb.de, tglx@linutronix.de,
        decui@microsoft.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        sgarzare@redhat.com
Subject: Re: [PATCH v2] vsock: Simplify '__vsock_release()'
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191103061111.22003-1-christophe.jaillet@wanadoo.fr>
References: <20191103061111.22003-1-christophe.jaillet@wanadoo.fr>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 05 Nov 2019 17:56:02 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Date: Sun,  3 Nov 2019 07:11:11 +0100

> Use 'skb_queue_purge()' instead of re-implementing it.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

Applied to net-next, thanks.
