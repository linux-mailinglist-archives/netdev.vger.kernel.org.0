Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88B4422373
	for <lists+netdev@lfdr.de>; Sat, 18 May 2019 14:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729838AbfERMGS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 May 2019 08:06:18 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:39593 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729796AbfERMGS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 May 2019 08:06:18 -0400
Received: by mail-qt1-f193.google.com with SMTP id y42so11085683qtk.6
        for <netdev@vger.kernel.org>; Sat, 18 May 2019 05:06:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=04m73gM70KQavhtW7qdWKarBML794oLZhvTsO5kuO4g=;
        b=HGy/l2ukTwfl50iG4B/BelYLIMkuwstJdF+BfFWli27KOa0D+5wCWzuQe+ubNcnQNR
         2sX6Zkl/f87YInw8XykRwU0Pp9xV6hrtmP28FSjK+7OLGGAviSLGWGQX4DU0i3q/nvpL
         mBBN3iXs6jIoSMcw7YPyIsLC7B/buf4hDqGufKusCBRt8jmjgmBj3cEbXzSqjUpqiSMQ
         OD24CdJX7COAv7SxAZ5msT5h8W13t0Od9MQg4htjgq81KBspOaWUhtZGL8hya9PegKud
         HLCYtMC5G5tyXjV3gXh7f3wEB72eTuxXJ3I59pMqHFrfsKYfoMO3YjFTPDdvav6tP6IU
         EdfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=04m73gM70KQavhtW7qdWKarBML794oLZhvTsO5kuO4g=;
        b=HfI6UkQI3G9gVWRFvz3f1wzchlBrGcRiW01TbixWl41lis6BUd8Wak6XOxuExleS97
         x10hlhIF0wzC7fgN17ApMPcs+jj6pKt/DcDo9Xcu2JuJvGfdGCseJRGREv5n7Ou9Ka7R
         cZoQtL27pEg/HgAQ+NLMF4lgroOfWmJZVd33QWYIoCZw67qwF1YvCX3RS4vbc+gPkVEy
         qWrUa7HpWipx2vWvHOOz2uFhb+uebo2Ynyi7lcba2SrOL1fY5xHiQG+FwCrVb5PZWWvQ
         k5jFUWWLIKGvSnU+LWR1AJI75A8Q+vD52PDONq1T5oO9YlpiJbTkBhVtqVsGqbY7MQQD
         OVyw==
X-Gm-Message-State: APjAAAVTG9FtvAwbDgema7xN+dQCitASfG2p2512TWXrMkgts9/VaCcT
        urakNeO9OT/F5faIAYJCUbxQ1a/sUTywOR+tjyo=
X-Google-Smtp-Source: APXvYqwd9L335a4CMRMLAa6yZ8N7DADPguut0sWXo4rzXoA5jHEVrYd49D/K3vBvYG+cU0cy6CDgzsWiiYAWCFgROLE=
X-Received: by 2002:ac8:e81:: with SMTP id v1mr54041955qti.16.1558181176987;
 Sat, 18 May 2019 05:06:16 -0700 (PDT)
MIME-Version: 1.0
References: <066a0d38-2c64-7a1e-d176-04341f0cb6d7@gmail.com>
 <20190512023754.GK4889@lunn.ch> <ae62419b-53f1-395d-eb0e-66d138d294a8@gmail.com>
 <4c6ef3f1-a2c7-f2da-3f2a-cd28624007f8@gmail.com> <CAMdYzYqcg3EXhLguTti2hP-0VVi_vX0XvoDSzTCC84p9aSp7Lg@mail.gmail.com>
 <20190514161957.yq7mw3wccuie6rr3@mobilestation>
In-Reply-To: <20190514161957.yq7mw3wccuie6rr3@mobilestation>
From:   Peter Geis <pgwipeout@gmail.com>
Date:   Sat, 18 May 2019 08:06:08 -0400
Message-ID: <CAMdYzYr_w8Qna4gvuNeNtGd2yZt0Zqu+5fHPwWQ1VgbfU8O0qQ@mail.gmail.com>
Subject: Re: [Regression] "net: phy: realtek: Add rtl8211e rx/tx delays
 config" breaks rk3328-roc-cc networking
To:     Serge Semin <fancer.lancer@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Serge Semin <Sergey.Semin@t-platforms.ru>,
        netdev@vger.kernel.org,
        "linux-rockchip@lists.infradead.org" 
        <linux-rockchip@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 14, 2019 at 12:20 PM Serge Semin <fancer.lancer@gmail.com> wrote:
>
> Hello Peter
>
> On Tue, May 14, 2019 at 07:53:21AM -0400, Peter Geis wrote:
> > On Sun, May 12, 2019 at 3:34 AM Heiner Kallweit <hkallweit1@gmail.com> wrote:
> > >
> > > On 12.05.2019 04:50, Peter Geis wrote:
> > > > On 5/11/2019 10:37 PM, Andrew Lunn wrote:
> > > >> On Sat, May 11, 2019 at 07:17:08PM -0400, Peter Geis wrote:
> > > >>> Good Evening,
> > > >>>
> > > >>> Commit f81dadbcf7fd067baf184b63c179fc392bdb226e "net: phy: realtek: Add
> > > >>> rtl8211e rx/tx delays config" breaks networking completely on the
> > > >>> rk3328-roc-cc.
> > > >>> Reverting the offending commit solves the problem.
> > > >>
> > > >> Hi Peter
> > > >>
> > > >> The fix should be in net, and will soon make its way upwards.
> > > >>
> > > >>      Andrew
> > > >>
> > > >
> > > >
> > > > Good Evening,
> > > >
> > > > Thanks, is there a link to the patch so I may test it?
> > > >
> > > https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git/commit/?id=daf3ddbe11a2ff74c95bc814df8e5fe3201b4cb5
> > >
> > > > Peter
> > > >
> > > Heiner
> >
> > This patch does correct the error message on boot, however networking
> > is still completely broken.
> > The current error is as follows:
> >
> > [  121.829375] kworker/3:1     D    0    67      2 0x00000028
> > [  121.829398] Workqueue: events linkwatch_event
> > [  121.829403] Call trace:
> > [  121.829412]  __switch_to+0xb8/0x1a8
> > [  121.829420]  __schedule+0x220/0x560
> > [  121.829423]  schedule+0x38/0xd8
> > [  121.829429]  schedule_preempt_disabled+0x20/0x38
> > [  121.829435]  __mutex_lock.isra.1+0x1c4/0x500
> > [  121.829438]  __mutex_lock_slowpath+0x10/0x18
> > [  121.829443]  mutex_lock+0x2c/0x38
> > [  121.829449]  rtnl_lock+0x14/0x20
> > [  121.829453]  linkwatch_event+0xc/0x38
> > [  121.829461]  process_one_work+0x1e0/0x320
> > [  121.829466]  worker_thread+0x40/0x428
> > [  121.829473]  kthread+0x120/0x128
> > [  121.829476]  ret_from_fork+0x10/0x18
> > [  121.829533] INFO: task NetworkManager:1833 blocked for more than 61 seconds.
> > [  121.830160]       Not tainted
> > 5.1.0-next-20190510test-00009-g3ed182aaa670-dirty #55
> > [  121.830831] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> > disables this message.
> > [  121.831589] NetworkManager  D    0  1833      1 0x00000028
> > [  121.831601] Call trace:
> > [  121.831614]  __switch_to+0xb8/0x1a8
> > [  121.831623]  __schedule+0x220/0x560
> > [  121.831631]  schedule+0x38/0xd8
> > [  121.831639]  schedule_preempt_disabled+0x20/0x38
> > [  121.831647]  __mutex_lock.isra.1+0x1c4/0x500
> > [  121.831666]  __mutex_lock_slowpath+0x10/0x18
> > [  121.831671]  mutex_lock+0x2c/0x38
> > [  121.831687]  mdiobus_write+0x40/0x80
> > [  121.831698]  rtl8211e_config_init+0x60/0xa0 [realtek]
> > [  121.831706]  phy_init_hw+0x54/0x70
> > [  121.831714]  phy_attach_direct+0xd4/0x250
> > [  121.831720]  phy_connect_direct+0x20/0x70
> > [  121.831728]  phy_connect+0x54/0xa0
> > [  121.831741]  stmmac_init_phy+0x17c/0x200
> > [  121.831748]  stmmac_open+0x124/0xac0
> > [  121.831759]  __dev_open+0xd8/0x158
> > [  121.831762]  __dev_change_flags+0x164/0x1c8
> > [  121.831766]  dev_change_flags+0x20/0x60
> > [  121.831774]  do_setlink+0x288/0xba8
> > [  121.831778]  __rtnl_newlink+0x5cc/0x6e8
> > [  121.831783]  rtnl_newlink+0x48/0x70
> > [  121.831786]  rtnetlink_rcv_msg+0x120/0x368
> > [  121.831807]  netlink_rcv_skb+0x58/0x118
> > [  121.831811]  rtnetlink_rcv+0x14/0x20
> > [  121.831816]  netlink_unicast+0x180/0x1f8
> > [  121.831822]  netlink_sendmsg+0x190/0x330
> > [  121.831837]  sock_sendmsg+0x3c/0x58
> > [  121.831844]  ___sys_sendmsg+0x268/0x2a0
> > [  121.831849]  __sys_sendmsg+0x68/0xb8
> > [  121.831855]  __arm64_sys_sendmsg+0x20/0x28
> > [  121.831864]  el0_svc_common.constprop.0+0x7c/0xe8
> > [  121.831870]  el0_svc_handler+0x28/0x78
> > [  121.831875]  el0_svc+0x8/0xc
>
> Thanks for sending the report. The fix has already been found and applied
> to the net-next:
> https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/commit/?id=dffe7d2e04670ff98e4dacf258df30446e2e80d4
>
> -Sergey

Thanks, this fixes networking, but there are now complaints about
leaking references.

[   59.504597] ------------[ cut here ]------------
[   59.504613] remove_proc_entry: removing non-empty directory
'net/rpc', leaking at least 'use-gss-proxy'
[   59.504677] WARNING: CPU: 3 PID: 7 at fs/proc/generic.c:683
remove_proc_entry+0x178/0x188
[   59.504682] Modules linked in: fuse bridge stp llc
snd_soc_hdmi_codec dw_hdmi_i2s_audio aes_ce_blk crypto_simd
aes_ce_cipher crct10dif_ce ghash_ce aes_arm64 sha2_ce sha256_arm64
sha1_ce rockchipdrm pwm_fan dw_hdmi lima snd_soc_simple_card
snd_soc_simple_card_utils drm_kms_helper gpu_sched drm
snd_soc_rockchip_i2s drm_panel_orientation_quirks snd_soc_rockchip_pcm
squashfs sch_fq_codel ip_tables x_tables ipv6 crc_ccitt btrfs xor
xor_neon zstd_compress raid6_pq libcrc32c zstd_decompress rtc_rk808
realtek
[   59.504768] CPU: 3 PID: 7 Comm: kworker/u8:0 Not tainted
5.1.0-next-20190514test-13354-gfd862c6fd105 #57
[   59.504770] Hardware name: Firefly roc-rk3328-cc (DT)
[   59.504790] Workqueue: netns cleanup_net
[   59.504794] pstate: 40400005 (nZcv daif +PAN -UAO)
[   59.504801] pc : remove_proc_entry+0x178/0x188
[   59.504805] lr : remove_proc_entry+0x178/0x188
[   59.504807] sp : ffff00001120fc80
[   59.504809] x29: ffff00001120fc80 x28: 0000000000000000
[   59.504814] x27: ffff800003284b38 x26: ffff000010c2ba00
[   59.504818] x25: 0000000000000000 x24: ffff80000ababc50
[   59.504822] x23: ffff8000036e5640 x22: ffff8000036e56eb
[   59.504825] x21: ffff8000036e8feb x20: ffff000010f03688
[   59.504829] x19: ffff8000036e8f40 x18: ffff000010f17000
[   59.504833] x17: 0000000000000001 x16: 0000000000000007
[   59.504836] x15: 00000000fffffff0 x14: 696b61656c202c27
[   59.504840] x13: 6370722f74656e27 x12: 2079726f74636572
[   59.504845] x11: 6964207974706d65 x10: 2d6e6f6e20676e69
[   59.504849] x9 : 0000000000000000 x8 : 0000000000000004
[   59.504853] x7 : 00000000000001c0 x6 : ffff000010ff5000
[   59.504856] x5 : 0000000000000001 x4 : ffff8000fead22a8
[   59.504860] x3 : ffff8000fead22a8 x2 : 0000000000000007
[   59.504864] x1 : e5b404e852ff9000 x0 : 0000000000000000
[   59.504868] Call trace:
[   59.504874]  remove_proc_entry+0x178/0x188
[   59.504884]  rpc_proc_exit+0x18/0x20
[   59.504906]  sunrpc_exit_net+0x48/0x70
[   59.504915]  ops_exit_list.isra.0+0x44/0x78
[   59.504918]  cleanup_net+0x1a8/0x2c0
[   59.504934]  process_one_work+0x1e0/0x320
[   59.504939]  worker_thread+0x40/0x428
[   59.504948]  kthread+0x120/0x128
[   59.504955]  ret_from_fork+0x10/0x18
[   59.504962] ---[ end trace 66885a1575002df1 ]---
