Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E51E22DDDD
	for <lists+netdev@lfdr.de>; Sun, 26 Jul 2020 12:03:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726732AbgGZKDe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jul 2020 06:03:34 -0400
Received: from wnew4-smtp.messagingengine.com ([64.147.123.18]:44421 "EHLO
        wnew4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725794AbgGZKDe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jul 2020 06:03:34 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.west.internal (Postfix) with ESMTP id 5B3EB421;
        Sun, 26 Jul 2020 06:03:32 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Sun, 26 Jul 2020 06:03:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=ikh5EhlXdXfOdkGPnk+YSAzZanx
        ICZj0juCCIW7pJDQ=; b=QEZLnA8NZc2dqPwo1bSHWUW8hwRo67Tnpjq39Cua5jt
        iIKRbIrsGMZfnKC50AVNL2OZGeqcFFZE8Flz1Qe6U0CDO8tL4pwJbID/728eV9/B
        zS+imhVJcVA1f9rMNkngBWSorYe/UfHdUK7HmO3sesKc7IOHUC1eS8oWNa9mDZoi
        Pyx9ywCGqfrSr4SHeGqFm7522K29UNOfma5oAU+t0g6u+vY9XFEOdrv/wd5mMhhs
        IAvOC/EQXzx4UmetiIJE7AIC1NkCZwrysy4Bmz7WJHkk3aiXZhtsrbsH7zAkqQ5Q
        Ult/jMCWzF+OV5RHG1AyyUH20laEpd8A+QdXfEpD78w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=ikh5Eh
        lXdXfOdkGPnk+YSAzZanxICZj0juCCIW7pJDQ=; b=MnOjouk60pWPOqNAH2Wurv
        zCkmFsmyHmVzfJLDi0wTLP8nL5Es6sV7JuggK4ztrZ6/emPax49BTsN6qJ4KJdB6
        QwTmLdge/1buiytAhiWE6i9QV8A/FFf3DfHg5SBmHtBS3L2SEjH+u6zvfVnrbPD1
        rQ0KsKU/gi1rYOha6HLFlODeUYb5+ocUDzsZ7Pm2RrpEskLIrETeMGs2qIKkwG5w
        PHmkKa4Cb270lbEZ37KPjOzjTBgnyHZSfu/r3QBMxUU0carwqMeKPEYe/Y4q9FMD
        wrSOzBJpTPIOYph+qYlPO8DLq2XolBFdIqoz6b8FicD/Dt9Lxh16u8BB+iEt+mYg
        ==
X-ME-Sender: <xms:8lQdXx1zfIQBxubA83d1KJk6-VloNMhvJfhxtyZM9IzZfnDf-T5QTg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrheejgddvfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecuogfuuhhsphgvtghtffhomhgrihhnucdlgeelmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepteelgfelff
    evlefhheegffdtleefhfetudeutdelfedvheeuhfekgeduudeuhedunecuffhomhgrihhn
    pegrphhpshhpohhtrdgtohhmpdhkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrke
    elrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhho
    mhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:8lQdX4EtG8V4LuQQmUQY46Q8PI4a-aeA_IodyG5ag2BHGP9CFTvQZw>
    <xmx:8lQdXx6ewB8dboQh_l8XNl_EMq4-4RgYHMjmyk9cCYVcMKGsNo1F6g>
    <xmx:8lQdX-2ynZ_tMiEndJv2CmRwZKV8cVfxRdrnOrWBg7j_fdgapKHl8A>
    <xmx:81QdX3-7xnEovtqHl3qb-VztHfe4D2q-Dmx_d2ah36cbgEab2DAuU3DXqIc>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id DA2D6328005A;
        Sun, 26 Jul 2020 06:03:29 -0400 (EDT)
Date:   Sun, 26 Jul 2020 12:03:28 +0200
From:   Greg KH <greg@kroah.com>
To:     syzbot <syzbot+a7ebdb01bb2cc165cab6@syzkaller.appspotmail.com>
Cc:     Markus.Elfring@web.de, UNGLinuxDriver@microchip.com,
        davem@davemloft.net, dingxiang@cmss.chinamobile.com,
        hdanton@sina.com, kuba@kernel.org, linus.walleij@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, steve.glendinning@shawell.net,
        syzkaller-bugs@googlegroups.com
Subject: Re: KASAN: use-after-free Read in __smsc95xx_mdio_read
Message-ID: <20200726100328.GA1273266@kroah.com>
References: <000000000000a376c105a8313901@google.com>
 <00000000000083581705ab553aab@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000000000083581705ab553aab@google.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 26, 2020 at 02:57:05AM -0700, syzbot wrote:
> syzbot suspects this issue was fixed by commit:
> 
> commit 7e23ab72e73bc601b4cf2983382691d9f165c8d1
> Author: Ding Xiang <dingxiang@cmss.chinamobile.com>
> Date:   Mon Mar 30 07:56:26 2020 +0000
> 
>     pinctrl: nomadik:remove unneeded variable
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13cfe3a0900000
> start commit:   7ae77150 Merge tag 'powerpc-5.8-1' of git://git.kernel.org..
> git tree:       upstream
> kernel config:  https://syzkaller.appspot.com/x/.config?x=d195fe572fb15312
> dashboard link: https://syzkaller.appspot.com/bug?extid=a7ebdb01bb2cc165cab6
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17046c66100000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=140a8a3e100000
> 
> If the result looks correct, please mark the issue as fixed by replying with:

I think the bisection logic needs to be worked on a bit better, as how
can this patch resolve the reported problem?

thanks,

greg k-h
