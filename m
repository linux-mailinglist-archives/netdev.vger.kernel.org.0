Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A8B35E262
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 12:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726621AbfGCK6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 06:58:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4006 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725820AbfGCK6C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jul 2019 06:58:02 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E843881DF1;
        Wed,  3 Jul 2019 10:58:01 +0000 (UTC)
Received: from localhost (ovpn-204-28.brq.redhat.com [10.40.204.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 54AAC1001B14;
        Wed,  3 Jul 2019 10:58:01 +0000 (UTC)
Date:   Wed, 3 Jul 2019 12:58:00 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Helmut Schaa <helmut.schaa@googlemail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] rt2x00: no need to check return value of debugfs_create
 functions
Message-ID: <20190703105759.GB30509@redhat.com>
References: <20190703065631.GA28822@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190703065631.GA28822@kroah.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Wed, 03 Jul 2019 10:58:02 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 03, 2019 at 08:56:31AM +0200, Greg Kroah-Hartman wrote:
> When calling debugfs functions, there is no need to ever check the
> return value.  The function can work or not, but the code logic should
> never do something different based on this.
> 
> Because we don't need to save the individual debugfs files and
> directories, remove the local storage of them and just remove the entire
> debugfs directory in a single call, making things a lot simpler.
> 
> Cc: Stanislaw Gruszka <sgruszka@redhat.com>
> Cc: Helmut Schaa <helmut.schaa@googlemail.com>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  .../net/wireless/ralink/rt2x00/rt2x00debug.c  | 100 ++++--------------
>  1 file changed, 23 insertions(+), 77 deletions(-)

This patch will not apply on wireless-drivers-next due to my recent
change which add new debugfs file:

commit e7f15d58dfe43f18199251f430d7713b0b8fad34
Author: Stanislaw Gruszka <sgruszka@redhat.com>
Date:   Thu May 2 11:07:00 2019 +0200

    rt2x00: add restart hw

Could you please rebase the patch ? (I can do this as well
if you want me to).

Stanislaw
