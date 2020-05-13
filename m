Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 822DD1D09A5
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 09:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732066AbgEMHNR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 03:13:17 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:51825 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726020AbgEMHNR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 03:13:17 -0400
Received: from [192.168.1.91] (p4FEFC5A7.dip0.t-ipconnect.de [79.239.197.167])
        by mail.holtmann.org (Postfix) with ESMTPSA id AA8F5CED07;
        Wed, 13 May 2020 09:22:57 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH 0/3] Bluetooth: Prevent scanning when device is not
 configured for wakeup
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200513021927.115700-1-abhishekpandit@chromium.org>
Date:   Wed, 13 May 2020 09:12:44 +0200
Cc:     BlueZ <linux-bluetooth@vger.kernel.org>,
        ChromeOS Bluetooth Upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Content-Transfer-Encoding: 7bit
Message-Id: <F6E282C4-8688-47A8-946D-70A5ABFB9257@holtmann.org>
References: <20200513021927.115700-1-abhishekpandit@chromium.org>
To:     Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Abhishek,

> This patch series adds a hook to prevent Bluetooth from scanning during
> suspend if it is not configured to wake up. It's not always clear who
> the wakeup owner is from looking at hdev->dev so we need the driver to
> inform us whether to set up scanning.
> 
> By default, when no `prevent_wake` hook is implemented, we always
> configure scanning for wake-up.
> 
> Thanks
> Abhishek
> 
> 
> 
> Abhishek Pandit-Subedi (3):
>  Bluetooth: Rename BT_SUSPEND_COMPLETE
>  Bluetooth: Add hook for driver to prevent wake from suspend
>  Bluetooth: btusb: Implement hdev->prevent_wake
> 
> drivers/bluetooth/btusb.c        | 8 ++++++++
> include/net/bluetooth/hci_core.h | 3 ++-
> net/bluetooth/hci_core.c         | 8 +++++---
> net/bluetooth/hci_request.c      | 2 +-
> 4 files changed, 16 insertions(+), 5 deletions(-)

all 3 patches have been applied to bluetooth-next tree.

Regards

Marcel

