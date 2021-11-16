Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F742453370
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 15:00:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236972AbhKPODC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 09:03:02 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:44643 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236943AbhKPOC6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 09:02:58 -0500
Received: from smtpclient.apple (p4fefc15c.dip0.t-ipconnect.de [79.239.193.92])
        by mail.holtmann.org (Postfix) with ESMTPSA id EB77ECECD7;
        Tue, 16 Nov 2021 14:59:57 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 15.0 \(3693.20.0.1.32\))
Subject: Re: [PATCH v3] Bluetooth: Don't initialize msft/aosp when using user
 channel
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20211115220021.v3.1.I2a8b2f2e52d05ae9ead3f3dcc1dd90ef47a7acd7@changeid>
Date:   Tue, 16 Nov 2021 14:59:57 +0100
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        Sonny Sasaka <sonnysasaka@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <E810B5F4-6334-4130-A5BD-A21F56ABD71B@holtmann.org>
References: <20211115220021.v3.1.I2a8b2f2e52d05ae9ead3f3dcc1dd90ef47a7acd7@changeid>
To:     Jesse Melhuish <melhuishj@chromium.org>
X-Mailer: Apple Mail (2.3693.20.0.1.32)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jesse,

> A race condition is triggered when usermode control is given to
> userspace before the kernel's MSFT query responds, resulting in an
> unexpected response to userspace's reset command.
> 
> Issue can be observed in btmon:
> < HCI Command: Vendor (0x3f|0x001e) plen 2                    #3 [hci0]
>        05 01                                            ..
> @ USER Open: bt_stack_manage (privileged) version 2.22  {0x0002} [hci0]
> < HCI Command: Reset (0x03|0x0003) plen 0                     #4 [hci0]
>> HCI Event: Command Complete (0x0e) plen 5                   #5 [hci0]
>      Vendor (0x3f|0x001e) ncmd 1
> 	Status: Command Disallowed (0x0c)
> 	05                                               .
>> HCI Event: Command Complete (0x0e) plen 4                   #6 [hci0]
>      Reset (0x03|0x0003) ncmd 2
> 	Status: Success (0x00)
> Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> Reviewed-by: Sonny Sasaka <sonnysasaka@chromium.org>
> Signed-off-by: Jesse Melhuish <melhuishj@chromium.org>
> ---
> 
> Changes in v3:
> - Added guard around *_close calls as well.
> 
> Changes in v2:
> - Moved guard to the new home for this code.
> 
> net/bluetooth/hci_sync.c | 12 ++++++++----
> 1 file changed, 8 insertions(+), 4 deletions(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel

