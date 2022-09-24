Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7285F5E8BD2
	for <lists+netdev@lfdr.de>; Sat, 24 Sep 2022 13:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233578AbiIXLoh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Sep 2022 07:44:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233571AbiIXLoe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Sep 2022 07:44:34 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B657EE56;
        Sat, 24 Sep 2022 04:44:31 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id w20so2308552ply.12;
        Sat, 24 Sep 2022 04:44:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=yo07PqkzGc/Ak91EyADpr56EyPsnZrX2A8n7RvC5xMQ=;
        b=fYjpXY+OEAvd9gZe2y0ZW1kvV5tBKhwHkzoFiLZf4MZ2jfikSbhMPAwSLHEqC6QhTV
         ICKGxooCbie/kaL3IqkqeiRCfGHpBYUN0YHAip0Ik1vWC1a+HO8oF2m4cCAOW0kqg/D2
         wM8mmcWs2xBJNPKPAQCek5Ky4DvP45OpA+YqZrEURQVk6v/584Cxd8YyUb1mp8yD3tU9
         CZQl+sFN73ViWLrIomHI/boX60srmpqF67k0SK03RsebUIh7y6AEwTD3a5pY/tyrUCwM
         UJjo+SBOpV1NRCvcoMuqGoJuXhDO53h8JxULHQNB1rSFlM1QhlLz7KdrkeTR4irBw0/W
         Tkjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=yo07PqkzGc/Ak91EyADpr56EyPsnZrX2A8n7RvC5xMQ=;
        b=EsvYfPJSP9Siabj1RlOxFkE/sYtuy4Cy33Cb2an5wFIWrcBYVgZAG0Yh6iKDaEAQtF
         kp5ULYr22sjVTzU2ld3vuzdR8sIoeVpSH19fxP5xOABZ/akrG3Qwowd5FC89mDhcBlr9
         IPNCudjXRe5yguk7PTrLBIbliRvngKQe6O2ZMAfa5zOw/o90L1EcCRGtbKJw6HEpXU43
         dZMMtz3o/0KemVuCxrapeK4pqZvgFrUq4/GOW/WdKxm+m8BeloqOk3+2kX/F/YaLqpey
         nJkzstCFIksUiJUndOuo7wdsCn8wM/y11KxLkYc3Vck8jaI1fqr9ocYA5833EEzzFizf
         5jJw==
X-Gm-Message-State: ACrzQf2A8vwTpXeM0cs0OOFM+ocWehJ/gMiX5kK9CmOafaLcxWru66Ll
        qz8smaexK5uD1xl+UgYL1Tg=
X-Google-Smtp-Source: AMsMyM7AQR0pYlvb0Hccep3U2Y6LhTfgD5nufTXAeG9Tz1hCLxBcZWS4A9HaS58TB0VOqgB1MJbGOw==
X-Received: by 2002:a17:90b:3850:b0:200:b1fd:891f with SMTP id nl16-20020a17090b385000b00200b1fd891fmr15142314pjb.144.1664019871056;
        Sat, 24 Sep 2022 04:44:31 -0700 (PDT)
Received: from localhost ([36.112.206.177])
        by smtp.gmail.com with ESMTPSA id w68-20020a628247000000b0053e75395705sm8239785pfd.127.2022.09.24.04.44.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Sep 2022 04:44:30 -0700 (PDT)
From:   Hawkins Jiawei <yin31149@gmail.com>
To:     keescook@chromium.org
Cc:     18801353760@163.com, davem@davemloft.net, edumazet@google.com,
        johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, sfr@canb.auug.org.au,
        syzbot+473754e5af963cf014cf@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com, yin31149@gmail.com
Subject: Re: [PATCH] Add linux-next specific files for 20220923
Date:   Sat, 24 Sep 2022 19:44:25 +0800
Message-Id: <20220924114425.95553-1-yin31149@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <202209240014.C7B6E929A@keescook>
References: <202209240014.C7B6E929A@keescook>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kees,
On Sat, 24 Sept 2022 at 15:26, Kees Cook <keescook@chromium.org> wrote:
>
> On Sat, Sep 24, 2022 at 03:10:34PM +0800, Hawkins Jiawei wrote:
> > From: Stephen Rothwell <sfr@canb.auug.org.au>
> >
> > > Hello,
> > >
> > > syzbot found the following issue on:
> > >
> > > HEAD commit:    483fed3b5dc8 Add linux-next specific files for 20220921
> > > git tree:       linux-next
> > > console+strace: https://syzkaller.appspot.com/x/log.txt?x=1154ddd5080000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=849cb9f70f15b1ba
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=473754e5af963cf014cf
> > > compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=157c196f080000
> > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11f12618880000
> > >
> > > Downloadable assets:
> > > disk image: https://storage.googleapis.com/syzbot-assets/1cb3f4618323/disk-483fed3b.raw.xz
> > > vmlinux: https://storage.googleapis.com/syzbot-assets/cc02cb30b495/vmlinux-483fed3b.xz
> > >
> > > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > > Reported-by: syzbot+473754e5af963cf014cf@syzkaller.appspotmail.com
> > >
> > > ------------[ cut here ]------------
> > > memcpy: detected field-spanning write (size 8) of single field "&compat_event->pointer" at net/wireless/wext-core.c:623 (size 4)
> > > WARNING: CPU: 0 PID: 3607 at net/wireless/wext-core.c:623 wireless_send_event+0xab5/0xca0 net/wireless/wext-core.c:623
> > > Modules linked in:
> > > CPU: 1 PID: 3607 Comm: syz-executor659 Not tainted 6.0.0-rc6-next-20220921-syzkaller #0
> > > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/16/2022
> > > RIP: 0010:wireless_send_event+0xab5/0xca0 net/wireless/wext-core.c:623
> > > Code: fa ff ff e8 cd b9 db f8 b9 04 00 00 00 4c 89 e6 48 c7 c2 e0 56 11 8b 48 c7 c7 20 56 11 8b c6 05 94 8e 2a 05 01 e8 b8 b0 a6 00 <0f> 0b e9 9b fa ff ff e8 6f ef 27 f9 e9 a6 fd ff ff e8 c5 ef 27 f9
> > > RSP: 0018:ffffc90003b2fbc0 EFLAGS: 00010286
> > > RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> > > RDX: ffff888021d157c0 RSI: ffffffff81620348 RDI: fffff52000765f6a
> > > RBP: ffff88801e15c780 R08: 0000000000000005 R09: 0000000000000000
> > > R10: 0000000080000000 R11: 20676e696e6e6170 R12: 0000000000000008
> > > R13: ffff888025a72640 R14: ffff8880225d402c R15: ffff8880225d4034
> > > FS:  0000555556bd9300(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
> > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > CR2: 00007fbda677dfb8 CR3: 000000007b976000 CR4: 00000000003506e0
> > > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > > Call Trace:
> > >  <TASK>
> > >  ioctl_standard_call+0x155/0x1f0 net/wireless/wext-core.c:1022
> > >  wireless_process_ioctl+0xc8/0x4c0 net/wireless/wext-core.c:955
> > >  wext_ioctl_dispatch net/wireless/wext-core.c:988 [inline]
> > >  wext_ioctl_dispatch net/wireless/wext-core.c:976 [inline]
> > >  wext_handle_ioctl+0x26b/0x280 net/wireless/wext-core.c:1049
> > >  sock_ioctl+0x285/0x640 net/socket.c:1220
> > >  vfs_ioctl fs/ioctl.c:51 [inline]
> > >  __do_sys_ioctl fs/ioctl.c:870 [inline]
> > >  __se_sys_ioctl fs/ioctl.c:856 [inline]
> > >  __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:856
> > >  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> > >  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
> > >  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> > > RIP: 0033:0x7fbda6736af9
> > > Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> > > RSP: 002b:00007ffd45e80138 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> > > RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fbda6736af9
> > > RDX: 0000000020000000 RSI: 0000000000008b04 RDI: 0000000000000003
> > > RBP: 00007fbda66faca0 R08: 0000000000000000 R09: 0000000000000000
> > > R10: 0000000000000000 R11: 0000000000000246 R12: 00007fbda66fad30
> > > R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> > >  </TASK>
> >
> > I think this is the samiliar problem as what Kees Cook pointed out in
> > https://lore.kernel.org/linux-next/202209211250.3049C29@keescook/
> >
> > It seems that memcpy() will performs run-time buffer bounds
> > checking, which triggers this warning.
> >
> > #syz test git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
> > master
> >
> >
> > diff --git a/include/linux/wireless.h b/include/linux/wireless.h
> > index 2d1b54556eff..81603848b0aa 100644
> > --- a/include/linux/wireless.h
> > +++ b/include/linux/wireless.h
> > @@ -26,7 +26,10 @@ struct compat_iw_point {
> >  struct __compat_iw_event {
> >       __u16           len;                    /* Real length of this stuff */
> >       __u16           cmd;                    /* Wireless IOCTL */
> > -     compat_caddr_t  pointer;
> > +     union {
> > +             compat_caddr_t  pointer;
> > +             __DECLARE_FLEX_ARRAY(__u8, pointer_flex);
> > +     };
>
> Is this expected to be dynamically sized? I assume so, given the "Real
> length" comment. :)
I think this is dynamically sized.

	hdr_len = compat_event_type_size[descr->header_type];
	event_len = hdr_len + extra_len;

	[...]

	/* Add the wireless events in the netlink packet */
	nla = nla_reserve(compskb, IFLA_WIRELESS, event_len);
	if (!nla) {
		kfree_skb(skb);
		kfree_skb(compskb);
		return;
	}
	compat_event = nla_data(nla);

	[...]

	if (descr->header_type == IW_HEADER_TYPE_POINT) {
		compat_wrqu.length = wrqu->data.length;
		compat_wrqu.flags = wrqu->data.flags;
		memcpy(&compat_event->pointer,
			((char *) &compat_wrqu) + IW_EV_COMPAT_POINT_OFF,
			hdr_len - IW_EV_COMPAT_LCP_LEN);
		if (extra_len)
			memcpy(((char *) compat_event) + hdr_len,
				extra, extra_len);
	} else {
		/* extra_len must be zero, so no if (extra) needed */
		memcpy(&compat_event->pointer, wrqu,
			hdr_len - IW_EV_COMPAT_LCP_LEN);
	}

according to the above code, it seems that this structure is used to
parse ths payload from buffer, so the field **pointer** should just
be a position label to the unused bytes in buffer. Its unused bytes will be
parsed as different structure according to event type.

>
> >  };
> >  #define IW_EV_COMPAT_LCP_LEN offsetof(struct __compat_iw_event, pointer)
> >  #define IW_EV_COMPAT_POINT_OFF offsetof(struct compat_iw_point, length)
> > diff --git a/net/wireless/wext-core.c b/net/wireless/wext-core.c
> > index 76a80a41615b..9d0b50abbe09 100644
> > --- a/net/wireless/wext-core.c
> > +++ b/net/wireless/wext-core.c
> > @@ -620,7 +620,7 @@ void wireless_send_event(struct net_device *      dev,
>
> adding in more context code:
>
>                 memcpy(&compat_event->pointer,
>                         ((char *) &compat_wrqu) + IW_EV_COMPAT_POINT_OFF,
>                         hdr_len - IW_EV_COMPAT_LCP_LEN);
>                 if (extra_len)
>                         memcpy(((char *) compat_event) + hdr_len,
>                                 extra, extra_len);
>
> The code above has "pointer" as a memcpy destination as well. I think
> that should be changed to pointer_flex as well, as the length calculation
> is the same. I wonder what FORTIFY will think about the second memcpy
> above. If I'm reading the math correctly, it might need to be:
>
>                 if (extra_len) {
>                         size_t offset = hdr_len - offsetof(typeof(*compat_event), pointer_flex);
>                         memcpy(&compat_event->pointer_flex[offset], extra, extra_len);
>                 }
>
I agree with you. It seems that in this situation,
the event type has been cleared, the unuesd bytes start from **pointer**
field should be parsed as struct iw_point type as below, which is a bigger
structure than **pointer**, it will also triggers the memcpy() warning.
/*
	 * The problem for 64/32 bit.
	 *
	 * On 64-bit, a regular event is laid out as follows:
	 * An iw_point event is laid out like this instead:
	 *      |  0  |  1  |  2  |  3  |  4  |  5  |  6  |  7  |
	 *      | event.len | event.cmd |     p a d d i n g     |
	 *      | iwpnt.len | iwpnt.flg |     p a d d i n g     |
	 *      | extra data  ...
	 *
	 * The second padding exists because struct iw_point is extended,
	 * but this depends on the platform...
	 *
	 * On 32-bit, all the padding shouldn't be there.
	 */

And as for the value of offsetof in calculating **offset**,
I wonder if we can use the macro defined in
include/linux/wireless.h as below, which makes code simplier:
#define IW_EV_COMPAT_LCP_LEN offsetof(struct __compat_iw_event, pointer)


>
> >       } else {
> >               /* extra_len must be zero, so no if (extra) needed */
> > -             memcpy(&compat_event->pointer, wrqu,
> > +             memcpy(&compat_event->pointer_flex, wrqu,
> >                       hdr_len - IW_EV_COMPAT_LCP_LEN);
> >       }
> >
>
> But otherwise, yes, looks like the right modification. Thanks for tackling
> this! It is quite a weird structure! :)
>
> -Kees
>
> --
> Kees Cook
