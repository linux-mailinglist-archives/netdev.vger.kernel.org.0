Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA7B218FB0
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 20:26:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbgGHS0s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 14:26:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:44932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725937AbgGHS0r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jul 2020 14:26:47 -0400
Received: from embeddedor (unknown [201.162.240.161])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 261E1206F6;
        Wed,  8 Jul 2020 18:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594232806;
        bh=P4cXOjS7XD3EKQggGz2XzeV426YqZpcn9AX6M313xkw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LJXCmf2cjDCxZnRljodId9rJBikTsGOMlIjDlRQ7f8DigAdE9Rv0nsNrc+0HPNGQb
         G5yItZnEO9a3TUHzTYDgwPvuqvCjq3zwH+eYbSo4ulPMzrgKgETloyCCw0BWjhcZZw
         3sdrN/xrED/RSiWoeF04gTc0HQPYmi9cCyxkjFzA=
Date:   Wed, 8 Jul 2020 13:32:15 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Subject: Re: [PATCH][next] Bluetooth: Use fallthrough pseudo-keyword
Message-ID: <20200708183215.GI11533@embeddedor>
References: <20200707203541.GA8972@embeddedor>
 <AA68478E-A46A-4914-BE62-3AC9989E358D@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AA68478E-A46A-4914-BE62-3AC9989E358D@holtmann.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 08, 2020 at 06:49:39AM +0200, Marcel Holtmann wrote:
> Hi Gustavo,
> 
> > Replace the existing /* fall through */ comments and its variants with
> > the new pseudo-keyword macro fallthrough[1]. Also, remove unnecessary
> > fall-through markings when it is the case.
> > 
> > [1] https://www.kernel.org/doc/html/latest/process/deprecated.html?highlight=fallthrough#implicit-switch-case-fall-through
> > 
> > Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> > ---
> > drivers/bluetooth/bcm203x.c     |  2 +-
> > drivers/bluetooth/bluecard_cs.c |  2 --
> > drivers/bluetooth/hci_ll.c      |  2 +-
> > drivers/bluetooth/hci_qca.c     |  8 +-------
> > net/bluetooth/hci_event.c       |  4 ++--
> > net/bluetooth/hci_sock.c        |  3 +--
> > net/bluetooth/l2cap_core.c      | 19 +++++++++----------
> > net/bluetooth/l2cap_sock.c      |  4 ++--
> > net/bluetooth/mgmt.c            |  4 ++--
> > net/bluetooth/rfcomm/core.c     |  2 +-
> > net/bluetooth/rfcomm/sock.c     |  2 +-
> > net/bluetooth/smp.c             |  2 +-
> > 12 files changed, 22 insertions(+), 32 deletions(-)
> 
> can we split these a little bit between drivers, core and rfcomm. Thanks.
> 

Sure thing, no problem. I'll split this up and send again.

Thanks
--
Gustavo
