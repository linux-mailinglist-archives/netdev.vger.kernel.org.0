Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC1BE426501
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 09:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230354AbhJHHEb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 03:04:31 -0400
Received: from mout.kundenserver.de ([212.227.126.133]:38899 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbhJHHE1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Oct 2021 03:04:27 -0400
Received: from mail-wr1-f48.google.com ([209.85.221.48]) by
 mrelayeu.kundenserver.de (mreue010 [213.165.67.97]) with ESMTPSA (Nemesis) id
 1Mv3Ds-1mq8IA3ljs-00r2Py; Fri, 08 Oct 2021 09:02:30 +0200
Received: by mail-wr1-f48.google.com with SMTP id t2so26509411wrb.8;
        Fri, 08 Oct 2021 00:02:30 -0700 (PDT)
X-Gm-Message-State: AOAM5339ETJ42LZs6PD5RXIIla3JjpJDPqYfM20sjsZnsCtTKxPMJhpE
        k/uqSVhX5QIj+CnoQxMUefkTwkCi2zWPVcio0kI=
X-Google-Smtp-Source: ABdhPJyM2fHIHpG1ztPQk+gfGEycOmvArSTFBqD5k6RBOlxiuU3e39HwAgUyLiRvXQxzL6kw5BAl+wnnMB4qsoy8z+U=
X-Received: by 2002:adf:ab46:: with SMTP id r6mr1846830wrc.71.1633676550526;
 Fri, 08 Oct 2021 00:02:30 -0700 (PDT)
MIME-Version: 1.0
References: <20211008065830.305057-1-butterflyhuangxx@gmail.com>
In-Reply-To: <20211008065830.305057-1-butterflyhuangxx@gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Fri, 8 Oct 2021 09:02:14 +0200
X-Gmail-Original-Message-ID: <CAK8P3a3A+CxJVt79ogxQn3NuRB01TsFchr-zu30E57xBut_=NQ@mail.gmail.com>
Message-ID: <CAK8P3a3A+CxJVt79ogxQn3NuRB01TsFchr-zu30E57xBut_=NQ@mail.gmail.com>
Subject: Re: [PATCH] isdn: cpai: check ctr->cnr to avoid array index out of bound
To:     Xiaolong Huang <butterflyhuangxx@gmail.com>
Cc:     Karsten Keil <isdn@linux-pingi.de>,
        David Miller <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:O4SpnvId+WiElrx6ZPayE+YW0q/jCN8F+kBopqsnKMYL+KQprke
 hFHSlmSzSlFQIB8O9/ZlracNVjHNLPEH4/spiEJijH8rI3qJ9i0Ae8BHaLDoXb6zFXgliXh
 ajftn9l5bDR/hs/kSGHce8+CKY6FRQh/KdEj9LRt6o5+UfC6B0bWnVn+mITDh+L1+/Thmjn
 ET9Fw92YYBtb9Wpzo8DhQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:JmEQNOjTfA8=:wE19sg8+/3SafTs9404BmO
 WiQQlVnwhblOptOuQHGE/ZewDc9JLa9N4Iwe2zRwMe5m0v4ftfAHclORq2EwCHxV140wO477G
 K54NVk8McY8K11LKN2IEn3dTrRK/8pcPvgdJXK0ZtYaUV0aPGl3OGPRp2/Dc6bPmDzu31K71l
 yyaxn2m1DrxwgVaEr99tdVWBkK0cLegRlcEE5UU+whWdw1OT5wt6VXNBGB/MrHPeftsVDpJTc
 m3FkY6D21bN5VdSX03wjJEgbgJ81ewatSAH7Qmde74oXL7cW4MRObDst/8zrJVwBG+vF8pFG4
 rzd6dUa/P0MfHHVr5WrIlNFXutGA+VXLdgoFUMMK0XPW7iXYcZiy5pjoSQjqRQzpprjD1okK6
 k7DvIwf/CjGSDMmr7deOBLLGgDLOIOfQesRxedVR1ncZWACKpBRchSSf3jc2mrC3bUEwqycjF
 AlSsAcLWmx19lz9HuqAvc6NZqxxQtYBKQvOH/jgN6JcxuJ1iTonKrHKhUEIa00tuXp758UniT
 3Qxgjiz+2jPzp21NF7l684QHS9CQ5XCw3I5x9N7GtvH2eT2aVdXEj4SrMCUv2i5OMB45AxkaW
 9onMu/itLoW3+42dmhTcDlsr7IT7rePFAdli3nLhJ+uR2XLjyL3Xaw/FYPm+/f8pW/czV/2i0
 5TVD3DMHCDomPBMtoL5axB53Xo7egQx0C9hdS6ZHdY9/rOPtEsqrXIxi5ldEDAs7HrLX6BvnF
 gtRvVcag6dMyI3xCmI3K3q7vFlso8b+HQioaRA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 8, 2021 at 8:58 AM Xiaolong Huang
<butterflyhuangxx@gmail.com> wrote:
>
> The cmtp_add_connection() would add a cmtp session to a controller
> and run a kernel thread to process cmtp.
>
>         __module_get(THIS_MODULE);
>         session->task = kthread_run(cmtp_session, session, "kcmtpd_ctr_%d",
>                                                                 session->num);
>
> During this process, the kernel thread would call detach_capi_ctr()
> to detach a register controller. if the controller
> was not attached yet, detach_capi_ctr() would
> trigger an array-index-out-bounds bug.
>
> [   46.866069][ T6479] UBSAN: array-index-out-of-bounds in
> drivers/isdn/capi/kcapi.c:483:21
> [   46.867196][ T6479] index -1 is out of range for type 'capi_ctr *[32]'
> [   46.867982][ T6479] CPU: 1 PID: 6479 Comm: kcmtpd_ctr_0 Not tainted
> 5.15.0-rc2+ #8
> [   46.869002][ T6479] Hardware name: QEMU Standard PC (i440FX + PIIX,
> 1996), BIOS 1.14.0-2 04/01/2014
> [   46.870107][ T6479] Call Trace:
> [   46.870473][ T6479]  dump_stack_lvl+0x57/0x7d
> [   46.870974][ T6479]  ubsan_epilogue+0x5/0x40
> [   46.871458][ T6479]  __ubsan_handle_out_of_bounds.cold+0x43/0x48
> [   46.872135][ T6479]  detach_capi_ctr+0x64/0xc0
> [   46.872639][ T6479]  cmtp_session+0x5c8/0x5d0
> [   46.873131][ T6479]  ? __init_waitqueue_head+0x60/0x60
> [   46.873712][ T6479]  ? cmtp_add_msgpart+0x120/0x120
> [   46.874256][ T6479]  kthread+0x147/0x170
> [   46.874709][ T6479]  ? set_kthread_struct+0x40/0x40
> [   46.875248][ T6479]  ret_from_fork+0x1f/0x30
> [   46.875773][ T6479]
>
> Signed-off-by: Xiaolong Huang <butterflyhuangxx@gmail.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
