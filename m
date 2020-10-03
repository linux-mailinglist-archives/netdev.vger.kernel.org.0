Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09F1B282539
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 17:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725803AbgJCPvG convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 3 Oct 2020 11:51:06 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:36780 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725766AbgJCPvG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 11:51:06 -0400
Received: from marcel-macpro.fritz.box (p4fefc7f4.dip0.t-ipconnect.de [79.239.199.244])
        by mail.holtmann.org (Postfix) with ESMTPSA id C28F1CED01;
        Sat,  3 Oct 2020 17:58:04 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: [PATCH] Revert "Bluetooth: Update resolving list when updating
 whitelist"
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20201003135449.GA2691@kroah.com>
Date:   Sat, 3 Oct 2020 17:51:03 +0200
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        Sathish Narsimman <sathish.narasimman@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <A1C95238-CBCB-4FD4-B46D-A62AED0C77E5@holtmann.org>
References: <20201003135449.GA2691@kroah.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Greg,

> This reverts commit 0eee35bdfa3b472cc986ecc6ad76293fdcda59e2 as it
> breaks all bluetooth connections on my machine.
> 
> Cc: Marcel Holtmann <marcel@holtmann.org>
> Cc: Sathish Narsimman <sathish.narasimman@intel.com>
> Fixes: 0eee35bdfa3b ("Bluetooth: Update resolving list when updating whitelist")
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
> net/bluetooth/hci_request.c | 41 ++-----------------------------------
> 1 file changed, 2 insertions(+), 39 deletions(-)
> 
> This has been bugging me for since 5.9-rc1, when all bluetooth devices
> stopped working on my desktop system.  I finally got the time to do
> bisection today, and it came down to this patch.  Reverting it on top of
> 5.9-rc7 restored bluetooth devices and now my input devices properly
> work.
> 
> As it's almost 5.9-final, any chance this can be merged now to fix the
> issue?

can you be specific what breaks since our guys and I also think the ChromeOS guys have been testing these series of patches heavily.

When you run btmon does it indicate any errors?

Do you have a chance to test net-next and see the LL Privacy there might have addressed this?

Regards

Marcel

