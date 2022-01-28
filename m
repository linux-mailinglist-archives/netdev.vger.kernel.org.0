Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ECB14A03AA
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 23:30:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351677AbiA1WaS convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 28 Jan 2022 17:30:18 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:58120 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351647AbiA1WaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 17:30:17 -0500
Received: from smtpclient.apple (p4ff9fc34.dip0.t-ipconnect.de [79.249.252.52])
        by mail.holtmann.org (Postfix) with ESMTPSA id 0E659CED40;
        Fri, 28 Jan 2022 23:30:15 +0100 (CET)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 15.0 \(3693.60.0.1.1\))
Subject: Re: pull request: bluetooth 2022-01-28
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20220128134951.3452f557@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Date:   Fri, 28 Jan 2022 23:30:14 +0100
Cc:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        BlueZ <linux-bluetooth@vger.kernel.org>, netdev@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <11903531-644D-434D-95CB-6F679368475C@holtmann.org>
References: <20220128205915.3995760-1-luiz.dentz@gmail.com>
 <20220128134951.3452f557@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
To:     Jakub Kicinski <kuba@kernel.org>
X-Mailer: Apple Mail (2.3693.60.0.1.1)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

>> The following changes since commit 8aaaf2f3af2ae212428f4db1af34214225f5cec3:
>> 
>>  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2022-01-09 17:00:17 -0800)
>> 
>> are available in the Git repository at:
>> 
>>  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git tags/for-net-next-2022-01-28
>> 
>> for you to fetch changes up to 91cb4c19118a19470a9d7d6dbdf64763bbbadcde:
>> 
>>  Bluetooth: Increment management interface revision (2022-01-27 12:35:13 -0800)
>> 
>> ----------------------------------------------------------------
>> bluetooth-next pull request for net-next:
>> 
>> - Add support for RTL8822C hci_ver 0x08
>> - Add support for RTL8852AE part 0bda:2852
>> - Fix WBS setting for Intel legacy ROM products
>> - Enable SCO over I2S ib mt7921s
>> - Increment management interface revision
> 
> Thanks for fixing the warnings! :)
> 
> I presume this is for the net-next given the name of your tree, but 
> a lot of patches here have fixes tags. What's your methodology on
> separating fixes from new features?
> 
> I think it may be worth adjusting the filter there and send more 
> stuff earlier to Linus's tree. Especially fixes with the right mix 
> of confidence and impact or pure device ID additions.
> 
> To be clear - happy to pull this PR as is, I was meaning to ask about
> this for a while.

we started to add Fixes: tag whenever you can identify a faulty commit or
can track down the original issue. This way we can later easily go back
and check. It have to note that a lot of vendor trees cherrypick patches
and this helps them picking the right ones.

I reviewed the list of patches again, and frankly none of them are super
critical to go to Linus right away. So if you don’t mind, please pull.

Regards

Marcel

