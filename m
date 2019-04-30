Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF4EFC81
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 17:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbfD3PKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 11:10:25 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44020 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726028AbfD3PKY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Apr 2019 11:10:24 -0400
Received: from localhost (adsl-173-228-226-134.prtc.net [173.228.226.134])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 64C1D14076EFF;
        Tue, 30 Apr 2019 08:10:23 -0700 (PDT)
Date:   Tue, 30 Apr 2019 11:10:22 -0400 (EDT)
Message-Id: <20190430.111022.800749031141886400.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] appletalk: Set error code if register_snap_client
 failed
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190430113408.30572-1-yuehaibing@huawei.com>
References: <20190430113408.30572-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 30 Apr 2019 08:10:24 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Tue, 30 Apr 2019 19:34:08 +0800

> If register_snap_client fails in atalk_init,
> error code should be set, otherwise it will
> triggers NULL pointer dereference while unloading
> module.
> 
> Fixes: 9804501fa122 ("appletalk: Fix potential NULL pointer dereference in unregister_snap_client")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied, thanks.
