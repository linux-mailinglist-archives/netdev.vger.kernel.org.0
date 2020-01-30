Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17F9914D971
	for <lists+netdev@lfdr.de>; Thu, 30 Jan 2020 12:02:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727161AbgA3LCq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 06:02:46 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:48939 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726885AbgA3LCq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jan 2020 06:02:46 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 72D2621C29;
        Thu, 30 Jan 2020 06:02:45 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 30 Jan 2020 06:02:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=vtYdWY
        LZAq1c7RCl4Mx4GaWluW5nfRFIB+W8SD870bI=; b=ZCNC9MubHObovZsp3jq8Kc
        7IhkpIlg3inrxh+5YQptMX5RjzyufM1OzDrIF8BdpXJu8ni+oNSX9z1TgW/fazk1
        WhzzdbPwpVWTdydc8nhgEvXoEusBprDz5Ouj3hOMLzbp+cteQZ3KlmsdMmvYPpuX
        zDOQZuzJnwnNIyKXvlVEWp+3iYhtrSV7wdFMDngDwyf4C5yZRhDNCasEIf75+Ky/
        VdSQ1ElD76DcbF3y6k7uHxy3xjbDcXtuf4PkRjTFRp99RQ2yIu0E12NS6P6VrZZ3
        kCjmlIhnxu6nJzeYAHFT+v39YgpRccAa2b4z0wRQumgyQ8wdRgi5g55I2mikF+Rg
        ==
X-ME-Sender: <xms:1LcyXrqi44RGRdPqfAmwVyb4QNoin6Fu2d9mWQTgqGwvkzHe3Qq_0A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrfeekgddvgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecuogfuuhhsphgvtghtffhomhgrihhnucdlgeelmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuffhomhgrihhnpe
    hkvghrnhgvlhdrohhrghdprghpphhsphhothdrtghomhenucfkphepudelfedrgeejrddu
    ieehrddvhedunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:1LcyXv4XV3WyubHsQZEIZGqNrKz69G2aZGMt_lY9HnPzSAhtM7YsCg>
    <xmx:1LcyXtoG9DRr8qecaee5a4ecw9aRWmlx1HijE8Y1aANOFYS1TSejQA>
    <xmx:1LcyXlLmpXFM6iunKFUsNPpqDj2pYJ6rMWKbcqQODD7kKKBhST1JEg>
    <xmx:1bcyXmNqsvEtog5YFLLWXRmPH2OokcsknGRhbzMq4ifPvb7vnMedvQ>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 66DEE3060A08;
        Thu, 30 Jan 2020 06:02:44 -0500 (EST)
Date:   Thu, 30 Jan 2020 13:02:42 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     syzbot <syzbot+63abe9d5f32ff88090eb@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: WARNING in nsim_fib6_rt_nh_del
Message-ID: <20200130110242.GA108853@splinter>
References: <00000000000097a900059d58700d@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000000000097a900059d58700d@google.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 30, 2020 at 01:54:15AM -0800, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    b3a60822 Merge branch 'for-v5.6' of git://git.kernel.org:/..
> git tree:       net-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=12461f66e00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=614e56d86457f3a7
> dashboard link: https://syzkaller.appspot.com/bug?extid=63abe9d5f32ff88090eb
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> 
> Unfortunately, I don't have any reproducer for this crash yet.
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+63abe9d5f32ff88090eb@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 24083 at drivers/net/netdevsim/fib.c:448 nsim_fib6_rt_nh_del+0x287/0x350 drivers/net/netdevsim/fib.c:448

Will check.

Thanks
