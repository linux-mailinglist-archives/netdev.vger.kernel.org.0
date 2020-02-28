Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A7A31731D8
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 08:36:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbgB1Hg3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 02:36:29 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:38882 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726682AbgB1Hg3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 02:36:29 -0500
Received: from marcel-macbook.fritz.box (p4FEFC5A7.dip0.t-ipconnect.de [79.239.197.167])
        by mail.holtmann.org (Postfix) with ESMTPSA id 4DE7ACECF5;
        Fri, 28 Feb 2020 08:45:53 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.60.0.2.5\))
Subject: Re: [PATCH] net: bluetooth: hci_core: Use list_for_each_entry_rcu()
 to traverse RCU list in RCU read-side CS
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200225131753.690-1-madhuparnabhowmik10@gmail.com>
Date:   Fri, 28 Feb 2020 08:36:26 +0100
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Bluez mailing list <linux-bluetooth@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, joel@joelfernandes.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        frextrite@gmail.com, paulmck@kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <9F510B61-2047-46BC-A588-333BFB728ED4@holtmann.org>
References: <20200225131753.690-1-madhuparnabhowmik10@gmail.com>
To:     madhuparnabhowmik10@gmail.com
X-Mailer: Apple Mail (2.3608.60.0.2.5)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Madhuparna,

> In function hci_is_blocked_key() RCU list is traversed with
> list_for_each_entry() in RCU read-side CS.
> Use list_for_each_entry_rcu() instead.
> 
> Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
> ---
> net/bluetooth/hci_core.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel

