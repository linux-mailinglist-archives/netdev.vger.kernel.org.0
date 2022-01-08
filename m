Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D7FA488400
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 15:41:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234408AbiAHOlB convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 8 Jan 2022 09:41:01 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:59260 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbiAHOlB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jan 2022 09:41:01 -0500
Received: from smtpclient.apple (p4fefca45.dip0.t-ipconnect.de [79.239.202.69])
        by mail.holtmann.org (Postfix) with ESMTPSA id F228BCED09;
        Sat,  8 Jan 2022 15:40:59 +0100 (CET)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 15.0 \(3693.40.0.1.81\))
Subject: Re: pull request: bluetooth 2022-01-07
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20220107182712.7549a8eb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Date:   Sat, 8 Jan 2022 15:40:59 +0100
Cc:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Tedd Ho-Jeong An <hj.tedd.an@gmail.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <6FFD2498-E81C-49DA-9B3E-4833241382EE@holtmann.org>
References: <20220107210942.3750887-1-luiz.dentz@gmail.com>
 <20220107182712.7549a8eb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
To:     Jakub Kicinski <kuba@kernel.org>
X-Mailer: Apple Mail (2.3693.40.0.1.81)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

>> The following changes since commit 710ad98c363a66a0cd8526465426c5c5f8377ee0:
>> 
>>  veth: Do not record rx queue hint in veth_xmit (2022-01-06 13:49:54 +0000)
>> 
>> are available in the Git repository at:
>> 
>>  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git tags/for-net-next-2022-01-07
>> 
>> for you to fetch changes up to b9f9dbad0bd1c302d357fdd327c398f51f5fc2b1:
>> 
>>  Bluetooth: hci_sock: fix endian bug in hci_sock_setsockopt() (2022-01-07 08:41:38 +0100)
>> 
>> ----------------------------------------------------------------
>> bluetooth-next pull request for net-next:
>> 
>> - Add support for Foxconn QCA 0xe0d0
>> - Fix HCI init sequence on MacBook Air 8,1 and 8,2
>> - Fix Intel firmware loading on legacy ROM devices
> 
> A few warnings here that may be worth addressing - in particular this
> one makes me feel that kbuild bot hasn't looked at the patches:
> 
> net/bluetooth/hci_sync.c:5143:5: warning: no previous prototype for ‘hci_le_ext_create_conn_sync’ [-Wmissing-prototypes]
> 5143 | int hci_le_ext_create_conn_sync(struct hci_dev *hdev, struct hci_conn *conn,
>      |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~

this we have to fix with a patch since none of the commits were touching this. It really must have slipped through earlier.

> Also this Fixes tag could be mended:
> 
> Commit: 6845667146a2 ("Bluetooth: hci_qca: Fix NULL vs IS_ERR_OR_NULL check in qca_serdev_probe")
> 	Fixes tag: Fixes: 77131dfe ("Bluetooth: hci_qca: Replace devm_gpiod_get() with devm_gpiod_get_optional()")
> 	Has these problem(s):
> 		- SHA1 should be at least 12 digits long
> 		  Can be fixed by setting core.abbrev to 12 (or more) or (for git v2.11
> 		  or later) just making sure it is not set (or set to "auto").

I fixed that now and re-pushed the tree. Funny part is that I always check that the Fixes SHA1 is actually valid, but I never thought about checking that it is at least 12 digits long. I totally missed that and keep it in mind going forward.

Regards

Marcel

