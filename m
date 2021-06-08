Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98A743A040A
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 21:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235244AbhFHTZn convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 8 Jun 2021 15:25:43 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:43325 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239410AbhFHTXT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 15:23:19 -0400
Received: from smtpclient.apple (p4fefc9d6.dip0.t-ipconnect.de [79.239.201.214])
        by mail.holtmann.org (Postfix) with ESMTPSA id A15B6CECC4;
        Tue,  8 Jun 2021 21:29:21 +0200 (CEST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.100.0.2.22\))
Subject: Re: pull request: bluetooth 2021-06-03
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <CABBYNZJqBbq0pMRt9w7XLLw0MnxmavokT2t6_PqwGVf4YfdnNA@mail.gmail.com>
Date:   Tue, 8 Jun 2021 21:21:22 +0200
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <9A9CD860-79EC-4B3C-BF2E-8038352B946B@holtmann.org>
References: <20210603215249.1048521-1-luiz.dentz@gmail.com>
 <CABBYNZJqBbq0pMRt9w7XLLw0MnxmavokT2t6_PqwGVf4YfdnNA@mail.gmail.com>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
X-Mailer: Apple Mail (2.3654.100.0.2.22)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Luiz,

>> The following changes since commit 62f3415db237b8d2aa9a804ff84ce2efa87df179:
>> 
>>  net: phy: Document phydev::dev_flags bits allocation (2021-05-26 13:15:55 -0700)
>> 
>> are available in the Git repository at:
>> 
>>  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth.git tags/for-net-2021-06-03
>> 
>> for you to fetch changes up to 1f14a620f30b01234f8b61df396f513e2ec4887f:
>> 
>>  Bluetooth: btusb: Fix failing to init controllers with operation firmware (2021-06-03 14:02:17 -0700)
>> 
>> ----------------------------------------------------------------
>> bluetooth pull request for net:
>> 
>> - Fixes UAF and CVE-2021-3564
>> - Fix VIRTIO_ID_BT to use an unassigned ID
>> - Fix firmware loading on some Intel Controllers
>> 
>> ----------------------------------------------------------------
>> Lin Ma (2):
>>      Bluetooth: fix the erroneous flush_work() order
>>      Bluetooth: use correct lock to prevent UAF of hdev object
>> 
>> Luiz Augusto von Dentz (1):
>>      Bluetooth: btusb: Fix failing to init controllers with operation firmware
>> 
>> Marcel Holtmann (1):
>>      Bluetooth: Fix VIRTIO_ID_BT assigned number
>> 
>> drivers/bluetooth/btusb.c       | 23 +++++++++++++++++++++--
>> include/uapi/linux/virtio_ids.h |  2 +-
>> net/bluetooth/hci_core.c        |  7 ++++++-
>> net/bluetooth/hci_sock.c        |  4 ++--
>> 4 files changed, 30 insertions(+), 6 deletions(-)
> 
> We are hoping we could merge these before the release.
> 

I think it already reached Linus’ tree.

Regards

Marcel

