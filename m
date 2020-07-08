Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9763F218694
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 14:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728902AbgGHMAM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 08:00:12 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:53915 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728723AbgGHMAM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 08:00:12 -0400
Received: from marcel-macbook.fritz.box (p5b3d2638.dip0.t-ipconnect.de [91.61.38.56])
        by mail.holtmann.org (Postfix) with ESMTPSA id CA3CECECFA;
        Wed,  8 Jul 2020 14:10:06 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH] Bluetooth: Use whitelist for scan policy when suspending
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200707155207.1.Id31098b8dbbcf90468fcd7fb07ad0e872b11c36b@changeid>
Date:   Wed, 8 Jul 2020 14:00:09 +0200
Cc:     Bluetooth Kernel Mailing List <linux-bluetooth@vger.kernel.org>,
        Alain Michaud <alainm@chromium.org>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        kernel list <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <ED3D3D2F-98BA-453C-B990-A487EBB5DD6C@holtmann.org>
References: <20200707155207.1.Id31098b8dbbcf90468fcd7fb07ad0e872b11c36b@changeid>
To:     Miao-chen Chou <mcchou@chromium.org>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Miao-chen,

> Even with one advertisement monitor in place, the scan policy should use
> the whitelist while the system is going to suspend to prevent waking by
> random advertisement.
> 
> The following test was performed.
> - With a paired device, register one advertisement monitor, suspend
> the system and verify that the host was not awaken by random
> advertisements.
> 
> Signed-off-by: Miao-chen Chou <mcchou@chromium.org>
> Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> 
> ---
> 
> net/bluetooth/hci_request.c | 5 +++--
> 1 file changed, 3 insertions(+), 2 deletions(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel

