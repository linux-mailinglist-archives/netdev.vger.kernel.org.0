Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52DEA86F6A
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 03:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405132AbfHIBh5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 21:37:57 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54336 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732796AbfHIBh5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 21:37:57 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E1041142D9470;
        Thu,  8 Aug 2019 18:37:56 -0700 (PDT)
Date:   Thu, 08 Aug 2019 18:37:56 -0700 (PDT)
Message-Id: <20190808.183756.2198405327467483431.davem@davemloft.net>
To:     gregkh@linuxfoundation.org
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH 00/17] Networking driver debugfs cleanups
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190806161128.31232-1-gregkh@linuxfoundation.org>
References: <20190806161128.31232-1-gregkh@linuxfoundation.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 08 Aug 2019 18:37:57 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Tue,  6 Aug 2019 18:11:11 +0200

> There is no need to test the result of any debugfs call anymore.  The
> debugfs core warns the user if something fails, and the return value of
> a debugfs call can always be fed back into another debugfs call with no
> problems.
> 
> Also, debugfs is for debugging, so if there are problems with debugfs
> (i.e. the system is out of memory) the rest of the kernel should not
> change behavior, so testing for debugfs calls is pointless and not the
> goal of debugfs at all.
> 
> This series cleans up a lot of networking drivers and some wimax code
> that was calling debugfs and trying to do something with the return
> value that it didn't need to.  Removing this logic makes the code
> smaller, easier to understand, and use less run-time memory in some
> cases, all good things.
> 
> The series is against net-next, and have no dependancies between any of
> them if they want to go through any random tree/order.  Or, if wanted,
> I can take them through my driver-core tree where other debugfs cleanups
> are being slowly fed during major merge windows.

I applied this without patch #17 which you said you would respin in order
to get rid of the now unused local variable.

Thanks.
