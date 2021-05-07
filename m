Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7129376207
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 10:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236274AbhEGIc6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 04:32:58 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:57013 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231675AbhEGIcy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 04:32:54 -0400
Received: from smtpclient.apple (p4fefc624.dip0.t-ipconnect.de [79.239.198.36])
        by mail.holtmann.org (Postfix) with ESMTPSA id B836FCECDB;
        Fri,  7 May 2021 10:39:42 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.80.0.2.43\))
Subject: Re: [PATCH v4] Bluetooth: Add ncmd=0 recovery handling
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20210429102415.v4.1.I14da3750a343d8d48921fffb7c6561337b6e6082@changeid>
Date:   Fri, 7 May 2021 10:31:51 +0200
Cc:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Bluetooth Kernel Mailing List 
        <linux-bluetooth@vger.kernel.org>,
        Alain Michaud <alainm@chromium.org>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <A59D973F-B135-4943-AA5A-0A9F8FFC3DF0@holtmann.org>
References: <20210429102415.v4.1.I14da3750a343d8d48921fffb7c6561337b6e6082@changeid>
To:     Manish Mandlik <mmandlik@google.com>
X-Mailer: Apple Mail (2.3654.80.0.2.43)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Manish,

> During command status or command complete event, the controller may set
> ncmd=0 indicating that it is not accepting any more commands. In such a
> case, host holds off sending any more commands to the controller. If the
> controller doesn't recover from such condition, host will wait forever,
> until the user decides that the Bluetooth is broken and may power cycles
> the Bluetooth.
> 
> This patch triggers the hardware error to reset the controller and
> driver when it gets into such state as there is no other wat out.
> 
> Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> Signed-off-by: Manish Mandlik <mmandlik@google.com>
> ---
> 
> Changes in v4:
> - Update comment in hci_ncmd_timeout
> - Add a new inline function to handle cmd_cnt and timers
> 
> Changes in v3:
> - Restructure ncmd_timer scheduling in hci_event.c
> - Cancel delayed work in hci_dev_do_close
> - Do not inject hw error during HCI_INIT
> - Update comment, add log message while injecting hw error
> 
> Changes in v2:
> - Emit the hardware error when ncmd=0 occurs
> 
> include/net/bluetooth/hci.h      |  1 +
> include/net/bluetooth/hci_core.h |  1 +
> net/bluetooth/hci_core.c         | 22 ++++++++++++++++++++++
> net/bluetooth/hci_event.c        | 29 +++++++++++++++++++----------
> 4 files changed, 43 insertions(+), 10 deletions(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel

