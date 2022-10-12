Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06CC15FCB71
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 21:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbiJLTZf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 15:25:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiJLTZc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 15:25:32 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2672A9270;
        Wed, 12 Oct 2022 12:25:30 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id bh13so16372498pgb.4;
        Wed, 12 Oct 2022 12:25:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JU4iFsmkA7c59DVj4lvuXOf2e1cBcviOySP5r4D9uOE=;
        b=dULc3C4lRmCUG5WCg+T3wWERwzxj+J5pvCczh/NybsDlDO/cqOG8rGOkfJ0yQJw4RM
         s6dsyZJkEcrSGntjNz4P9JbwzHg+urVeBoqkHWWDm2sSlqptOsuv8zwFkfRoFOFYabJB
         QRvGnDV9Aw99C3knQL2hCIo84ivRthJzL+aJNpTgYGgpl/xzYjSF1B99XnHjoTEE79Bt
         nJC7YwIN8FWGGJ1TCuKOQaVTvWk9T03UNGNb2JDbFMB7JLOlICyxuYxrWU94qBi8pMrM
         lgQ2kf+cJkdshuj+TJ39pxkde7mgATV1PSXw5KP60Pr6CyeKr3aki9wWW0XOhOH7Cysa
         kLHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JU4iFsmkA7c59DVj4lvuXOf2e1cBcviOySP5r4D9uOE=;
        b=wBxflFTV25DH3hokHg2/Urn+MqYiUt878RHWM6FcNAbtMezTwLWAm4ooYOoagRED2t
         snZvJ5XRZNCn2j8ptrf+hgbENtgOyX9CRzPAA84mIGx7fI/hdzu+0Z8jQO37FM3Uwy1V
         u6IexFhvC0QY2SS+NL3S2wyuxXYfdEaGGW7fCSzQmBX1XAwzLDfyAmq1Yq5jVmfB9FON
         5TNytILk6V78gx8hTARfEeo3Cm2NcNIKMOcinxvi6adv2dbyny2dAbJvKwzugYoped2M
         jCGFO9M746b0WcSUkqeQl2QINac7FpaNBD4zmZyR+m5FTwgEfuzjZQTyzdDBchRo92aF
         YADQ==
X-Gm-Message-State: ACrzQf1Boz+DWLarfgNTwvXbkMsRmN+6lHGW4ELJBpKTqyxVQo6MY802
        f1bDYHS+SBumq0YbW99q0/E=
X-Google-Smtp-Source: AMsMyM76Edw5jMi5RhJUN8UMjwF6dT51haR8pl2cglmY1dwz7hCEC25cXtRwYlAsvGUZltQKM5axqg==
X-Received: by 2002:a63:4b4c:0:b0:45a:5f8:b49d with SMTP id k12-20020a634b4c000000b0045a05f8b49dmr26572725pgl.490.1665602730424;
        Wed, 12 Oct 2022 12:25:30 -0700 (PDT)
Received: from ?IPV6:2620:15c:2c1:200:9517:7fc4:6b3f:85b4? ([2620:15c:2c1:200:9517:7fc4:6b3f:85b4])
        by smtp.gmail.com with ESMTPSA id j14-20020a170903024e00b0017c7376ac9csm11213408plh.206.2022.10.12.12.25.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Oct 2022 12:25:29 -0700 (PDT)
Message-ID: <960459eb-c8c3-bb75-f1ea-8995e511f826@gmail.com>
Date:   Wed, 12 Oct 2022 12:25:27 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [syzbot] KMSAN: uninit-value in hsr_fill_frame_info (2)
Content-Language: en-US
To:     syzbot <syzbot+b11c500e990cac6ba129@syzkaller.appspotmail.com>,
        claudiajkang@gmail.com, davem@davemloft.net,
        ennoerlangen@gmail.com, george.mccollister@gmail.com,
        glider@google.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com,
        George McCollister <george.mccollister@gmail.com>,
        Eric Dumazet <edumazet@google.com>
References: <000000000000d7639205eadb267a@google.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <000000000000d7639205eadb267a@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/12/22 12:10, syzbot wrote:
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    d6e2c8c7eb40 x86: kmsan: enable KMSAN builds for x86
> git tree:       https://github.com/google/kmsan.git master
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=143fe3c6f00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=65d9eb7bfd2865c9
> dashboard link: https://syzkaller.appspot.com/bug?extid=b11c500e990cac6ba129
> compiler:       clang version 14.0.0 (/usr/local/google/src/llvm-git-monorepo 2b554920f11c8b763cd9ed9003f4e19b919b8e1f), GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1257629ef00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17959c21f00000


Might be related to


commit 48b491a5cc74333c4a6a82fe21cea42c055a3b0b
Author: George McCollister <george.mccollister@gmail.com>
Date:   Mon May 24 13:50:54 2021 -0500

     net: hsr: fix mac_len checks

     Commit 2e9f60932a2c ("net: hsr: check skb can contain struct hsr_ethhdr
     in fill_frame_info") added the following which resulted in -EINVAL
     always being returned:
             if (skb->mac_len < sizeof(struct hsr_ethhdr))
                     return -EINVAL;

     mac_len was not being set correctly so this check completely broke
     HSR/PRP since it was always 14, not 20.

     Set mac_len correctly and modify the mac_len checks to test in the
     correct places since sometimes it is legitimately 14.

     Fixes: 2e9f60932a2c ("net: hsr: check skb can contain struct 
hsr_ethhdr in fill_frame_info")
     Signed-off-by: George McCollister <george.mccollister@gmail.com>
     Signed-off-by: David S. Miller <davem@davemloft.net>

>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+b11c500e990cac6ba129@syzkaller.appspotmail.com
>
> hsr0: VLAN not yet supported
> =====================================================
> BUG: KMSAN: uninit-value in hsr_fill_frame_info+0x495/0x770 net/hsr/hsr_forward.c:526
>   hsr_fill_frame_info+0x495/0x770 net/hsr/hsr_forward.c:526
>   fill_frame_info net/hsr/hsr_forward.c:605 [inline]
>   hsr_forward_skb+0x7c4/0x3630 net/hsr/hsr_forward.c:619
>   hsr_dev_xmit+0x23a/0x530 net/hsr/hsr_device.c:222
>   __netdev_start_xmit include/linux/netdevice.h:4778 [inline]
>   netdev_start_xmit include/linux/netdevice.h:4792 [inline]
>   xmit_one+0x2f4/0x840 net/core/dev.c:3532
>   dev_hard_start_xmit+0x186/0x440 net/core/dev.c:3548
>   __dev_queue_xmit+0x22ee/0x3500 net/core/dev.c:4176
>   dev_queue_xmit+0x4b/0x60 net/core/dev.c:4209
>   packet_snd net/packet/af_packet.c:3063 [inline]
>   packet_sendmsg+0x6671/0x7d60 net/packet/af_packet.c:3094
>   sock_sendmsg_nosec net/socket.c:705 [inline]
>   sock_sendmsg net/socket.c:725 [inline]
>   __sys_sendto+0x9ef/0xc70 net/socket.c:2040
>   __do_sys_sendto net/socket.c:2052 [inline]
>   __se_sys_sendto net/socket.c:2048 [inline]
>   __x64_sys_sendto+0x19c/0x210 net/socket.c:2048
>   do_syscall_x64 arch/x86/entry/common.c:51 [inline]
>   do_syscall_64+0x51/0xa0 arch/x86/entry/common.c:81
>   entry_SYSCALL_64_after_hwframe+0x44/0xae
>
> Uninit was created at:
>   slab_post_alloc_hook mm/slab.h:754 [inline]
>   slab_alloc_node mm/slub.c:3231 [inline]
>   __kmalloc_node_track_caller+0xde3/0x14f0 mm/slub.c:4962
>   kmalloc_reserve net/core/skbuff.c:354 [inline]
>   __alloc_skb+0x545/0xf90 net/core/skbuff.c:426
>   alloc_skb include/linux/skbuff.h:1300 [inline]
>   alloc_skb_with_frags+0x1df/0xd60 net/core/skbuff.c:5995
>   sock_alloc_send_pskb+0xdf4/0xfc0 net/core/sock.c:2600
>   packet_alloc_skb net/packet/af_packet.c:2911 [inline]
>   packet_snd net/packet/af_packet.c:3006 [inline]
>   packet_sendmsg+0x506f/0x7d60 net/packet/af_packet.c:3094
>   sock_sendmsg_nosec net/socket.c:705 [inline]
>   sock_sendmsg net/socket.c:725 [inline]
>   __sys_sendto+0x9ef/0xc70 net/socket.c:2040
>   __do_sys_sendto net/socket.c:2052 [inline]
>   __se_sys_sendto net/socket.c:2048 [inline]
>   __x64_sys_sendto+0x19c/0x210 net/socket.c:2048
>   do_syscall_x64 arch/x86/entry/common.c:51 [inline]
>   do_syscall_64+0x51/0xa0 arch/x86/entry/common.c:81
>   entry_SYSCALL_64_after_hwframe+0x44/0xae
>
> CPU: 1 PID: 3506 Comm: syz-executor134 Not tainted 5.18.0-rc4-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> =====================================================
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches
