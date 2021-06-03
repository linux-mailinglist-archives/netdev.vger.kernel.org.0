Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 914A739A2F4
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 16:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231371AbhFCOXb convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 3 Jun 2021 10:23:31 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:50503 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230044AbhFCOXa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 10:23:30 -0400
Received: from smtpclient.apple (p4fefc9d6.dip0.t-ipconnect.de [79.239.201.214])
        by mail.holtmann.org (Postfix) with ESMTPSA id 795B4CED1F;
        Thu,  3 Jun 2021 16:29:41 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.100.0.2.22\))
Subject: Re: [PATCH v3 00/12] Bluetooth: correct the use of print format
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1622706065-45409-1-git-send-email-yekai13@huawei.com>
Date:   Thu, 3 Jun 2021 16:21:43 +0200
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <BD2539CA-5475-4FD3-AB79-B4D5FA764AD9@holtmann.org>
References: <1622706065-45409-1-git-send-email-yekai13@huawei.com>
To:     Kai Ye <yekai13@huawei.com>
X-Mailer: Apple Mail (2.3654.100.0.2.22)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kai,

> According to Documentation/core-api/printk-formats.rst,
> Use the correct print format. 
> 1. Printing an unsigned int value should use %u instead of %d.
> 2. Printing an unsigned long value should use %lu instead of %ld.
> Otherwise printk() might end up displaying negative numbers.
> 
> changes v1 -> v2:
> 	fix some style problems
> changes v2 -> v3
> 	fix some commit message style
> 
> Kai Ye (12):
>  Bluetooth: bnep: Use the correct print format
>  Bluetooth: cmtp: Use the correct print format
>  Bluetooth: hidp: Use the correct print format
>  Bluetooth: rfcomm: Use the correct print format
>  Bluetooth: 6lowpan: Use the correct print format
>  Bluetooth: a2mp: Use the correct print format
>  Bluetooth: amp: Use the correct print format
>  Bluetooth: hci: Use the correct print format
>  Bluetooth: mgmt: Use the correct print format
>  Bluetooth: msft: Use the correct print format
>  Bluetooth: sco: Use the correct print format
>  Bluetooth: smp: Use the correct print format
> 
> net/bluetooth/6lowpan.c     | 16 +++++------
> net/bluetooth/a2mp.c        | 24 ++++++++--------
> net/bluetooth/amp.c         |  6 ++--
> net/bluetooth/bnep/core.c   |  8 +++---
> net/bluetooth/cmtp/capi.c   | 22 +++++++--------
> net/bluetooth/hci_conn.c    |  8 +++---
> net/bluetooth/hci_core.c    | 48 ++++++++++++++++----------------
> net/bluetooth/hci_event.c   | 24 ++++++++--------
> net/bluetooth/hci_request.c |  8 +++---
> net/bluetooth/hci_sock.c    |  6 ++--
> net/bluetooth/hci_sysfs.c   |  2 +-
> net/bluetooth/hidp/core.c   |  6 ++--
> net/bluetooth/mgmt.c        | 16 +++++------
> net/bluetooth/mgmt_config.c |  4 +--
> net/bluetooth/msft.c        |  2 +-
> net/bluetooth/rfcomm/core.c | 68 ++++++++++++++++++++++-----------------------
> net/bluetooth/rfcomm/sock.c |  8 +++---
> net/bluetooth/rfcomm/tty.c  | 10 +++----
> net/bluetooth/sco.c         |  8 +++---
> net/bluetooth/smp.c         |  6 ++--
> 20 files changed, 150 insertions(+), 150 deletions(-)

I applied all patches except 04/12 and 08/12 since they no longer apply cleanly against bluetooth-next tree.

Regards

Marcel

