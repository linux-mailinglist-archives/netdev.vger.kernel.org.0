Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA3AF2DEB24
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 22:33:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726256AbgLRVcW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 16:32:22 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:50487 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725817AbgLRVcW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 16:32:22 -0500
Received: from marcel-macbook.holtmann.net (p4fefcdf9.dip0.t-ipconnect.de [79.239.205.249])
        by mail.holtmann.org (Postfix) with ESMTPSA id 248DECED31;
        Fri, 18 Dec 2020 22:38:57 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.40.0.2.32\))
Subject: Re: [PATCH] Bluetooth: Pause service discovery for suspend
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20201217150346.1.If6feff48e17a881af9cb55526db7f53bf0db40f1@changeid>
Date:   Fri, 18 Dec 2020 22:31:39 +0100
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Content-Transfer-Encoding: 7bit
Message-Id: <E127EABD-FBE2-49E3-910D-6BF922E94EFF@holtmann.org>
References: <20201217150346.1.If6feff48e17a881af9cb55526db7f53bf0db40f1@changeid>
To:     Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
X-Mailer: Apple Mail (2.3654.40.0.2.32)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Abhishek,

> Just like MGMT_OP_START_DISCOVERY, we should reject
> MGMT_OP_START_SERVICE_DISCOVERY with MGMT_STATUS_BUSY when we are paused
> for suspend.
> 
> Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> ---
> On ChromeOS, we started getting reports of scanning failing after
> resuming from suspend. The root cause was that Start Service Discovery
> was being called while discovery was supposed to be paused for suspend
> and it was screwing up some internal state. Adding this check
> immediately fixed it.
> 
> The fix was tested by doing the following:
> * Set Discovery Filter ({'transport': 'auto'})
> * Start Discovery
> * Suspend
> * Resume
> * Check the Discovering property
> 
> Without the fix, this test failed when checking the Discovering
> property above.
> 
> net/bluetooth/mgmt.c | 8 ++++++++
> 1 file changed, 8 insertions(+)

patch has been applied to bluetooth-next tree.

Regards

Marcel

