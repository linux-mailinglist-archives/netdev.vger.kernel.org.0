Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8467EFA86
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 15:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbfD3NfZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 09:35:25 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42336 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725938AbfD3NfZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Apr 2019 09:35:25 -0400
Received: from localhost (adsl-173-228-226-134.prtc.net [173.228.226.134])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3D3A813D2CDDB;
        Tue, 30 Apr 2019 06:35:24 -0700 (PDT)
Date:   Tue, 30 Apr 2019 09:35:23 -0400 (EDT)
Message-Id: <20190430.093523.204248117754328815.davem@davemloft.net>
To:     steffen.klassert@secunet.com
Cc:     herbert@gondor.apana.org.au, netdev@vger.kernel.org
Subject: Re: pull request (net-next): ipsec-next 2019-04-30
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190430063727.10908-1-steffen.klassert@secunet.com>
References: <20190430063727.10908-1-steffen.klassert@secunet.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 30 Apr 2019 06:35:25 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Steffen Klassert <steffen.klassert@secunet.com>
Date: Tue, 30 Apr 2019 08:37:09 +0200

> 1) A lot of work to remove indirections from the xfrm code.
>    From Florian Westphal.
> 
> 2) Support ESP offload in combination with gso partial.
>    From Boris Pismenny.
> 
> 3) Remove some duplicated code from vti4.
>    From Jeremy Sowden.
> 
> Please note that there is merge conflict
 ...

Thank you for the merge conflict info.

>   git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec-next.git master

Pulled, thanks a lot.
