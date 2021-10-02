Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 991C941FAA2
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 11:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232705AbhJBJdv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 2 Oct 2021 05:33:51 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:56583 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232611AbhJBJdu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Oct 2021 05:33:50 -0400
Received: from smtpclient.apple (p5b3d2185.dip0.t-ipconnect.de [91.61.33.133])
        by mail.holtmann.org (Postfix) with ESMTPSA id 94FC5CEC82;
        Sat,  2 Oct 2021 11:32:03 +0200 (CEST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: pull request: bluetooth 2021-10-01
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20211001210832.5902ea53@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Date:   Sat, 2 Oct 2021 11:32:03 +0200
Cc:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <CD773E87-F8E5-47E8-B21A-07EAD6007519@holtmann.org>
References: <20211001230850.3635543-1-luiz.dentz@gmail.com>
 <20211001201128.7737a4ef@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CABBYNZLE-iVAT0Tt1aJK9VqYhWPYJeSTiWh6s2HTeqyQczMbVQ@mail.gmail.com>
 <20211001210832.5902ea53@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
To:     Jakub Kicinski <kuba@kernel.org>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

>>>> bluetooth-next pull request for net-next:
>>>> 
>>>> - Add support for MediaTek MT7922 and MT7921
>>>> - Enable support for AOSP extention in Qualcomm WCN399x and Realtek
>>>>   8822C/8852A.
>>>> - Add initial support for link quality and audio/codec offload.
>>>> - Rework of sockets sendmsg to avoid locking issues.
>>>> - Add vhci suspend/resume emulation.  
> 
>>> Commit 0b59e272f932 ("Bluetooth: reorganize functions from hci_sock_sendmsg()")
>>>        committer Signed-off-by missing
>>>        author email:    penguin-kernel@I-love.SAKURA.ne.jp
>>>        committer email: marcel@holtmann.org
>>>        Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
>>>        Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>  
>> 
>> I suspect those fixed and force pushed since I originally applied them
>> given them all have my sign-offs, is this a blocker though?
> 
> I'm not an expert on SoB semantics so not sure if it's a deal breaker.
> Stephen's checker will definitely notice and send us warnings.
> I think it's worth the hassle to rebase and resubmit for 7 bad commits.

at some point, I had to fix one commit via git rebase —interactive. Looks like it
then made me committer for all commits. Originally Luiz applied all these patches
and my Signed-off-by should be in it.

I can fix this for sure and get the right committer back, I am just curious what
git rebase did here.

Regards

Marcel

