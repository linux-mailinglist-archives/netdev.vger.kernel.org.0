Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3216146DBF
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 04:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbfFOCUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 22:20:39 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57372 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725812AbfFOCUj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 22:20:39 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DC3BF134116D6;
        Fri, 14 Jun 2019 19:20:38 -0700 (PDT)
Date:   Fri, 14 Jun 2019 19:20:38 -0700 (PDT)
Message-Id: <20190614.192038.685198515789181601.davem@davemloft.net>
To:     sunilmut@microsoft.com
Cc:     stefanha@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        decui@microsoft.com
Subject: Re: [PATCH net-next] vsock: correct removal of socket from the list
From:   David Miller <davem@davemloft.net>
In-Reply-To: <MW2PR2101MB11162BBAEC52B232A7B1EFAFC0EF0@MW2PR2101MB1116.namprd21.prod.outlook.com>
References: <MW2PR2101MB11162BBAEC52B232A7B1EFAFC0EF0@MW2PR2101MB1116.namprd21.prod.outlook.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 14 Jun 2019 19:20:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sunil Muthuswamy <sunilmut@microsoft.com>
Date: Thu, 13 Jun 2019 03:52:27 +0000

> The current vsock code for removal of socket from the list is both
> subject to race and inefficient. It takes the lock, checks whether
> the socket is in the list, drops the lock and if the socket was on the
> list, deletes it from the list. This is subject to race because as soon
> as the lock is dropped once it is checked for presence, that condition
> cannot be relied upon for any decision. It is also inefficient because
> if the socket is present in the list, it takes the lock twice.
> 
> Signed-off-by: Sunil Muthuswamy <sunilmut@microsoft.com>

Applied.
