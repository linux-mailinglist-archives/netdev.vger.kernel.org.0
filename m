Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17F7B5A162B
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 17:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242631AbiHYPzw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 11:55:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241367AbiHYPzs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 11:55:48 -0400
Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB095958B;
        Thu, 25 Aug 2022 08:55:44 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1661442942; bh=0FRMcklDakhoKTIotvAQFEA0Nu+RJyvVxh4FSvdoKOs=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=Bqlyo6Mdx5rh7/HZESTq9HyRgWND88jZIbrXdR7kscz8SnF9V+DnRx4HmJvytx4W8
         vUfTbHnuD4GXYtdftmQDST/RO7TNicuX3hgarUZaS7fVmUxsMTYVFdhhpEAOfbmXTI
         OiqNflZacamS+6vLkQw78Jc0edaXTT7+1HEYaorBhFVnmQio2U4pvhVzu9lAalp7TC
         px5OHYe/A7e/RIUGbWokDwMG3kElaEu0fOxabfyen7sz+KkHsp7dM0u+2tKRl8jbOy
         rFEj5/lunKMnm4wAjZnKf3f4N5NAHWlZvnQj3OV1FgilakA5L0Z+owpgZh654YkjRp
         DquEke5TEm2fw==
To:     Alexander Potapenko <glider@google.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     phil@philpotter.co.uk, ath9k-devel@qca.qualcomm.com,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Subject: Re: KMSAN: uninit-value in ath9k_htc_rx_msg
In-Reply-To: <CAG_fn=Wq51FMbty4c_RwjBSFWS1oceL1rOAUzCyRnGEzajQRAg@mail.gmail.com>
References: <000000000000c98a7f05ac744f53@google.com>
 <000000000000734fe705acb9f3a2@google.com>
 <a142d63c-7810-40ff-9c24-7160c63bafebn@googlegroups.com>
 <CAG_fn=U=Vfv3ymNM6W++sbivieQoUuXfAxsC9SsmdtQiTjSi8g@mail.gmail.com>
 <1a0b4d24-6903-464f-7af0-65c9788545af@I-love.SAKURA.ne.jp>
 <CAG_fn=Wq51FMbty4c_RwjBSFWS1oceL1rOAUzCyRnGEzajQRAg@mail.gmail.com>
Date:   Thu, 25 Aug 2022 17:55:40 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <878rnc8ghv.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexander Potapenko <glider@google.com> writes:

> On Thu, Aug 25, 2022 at 4:34 PM Tetsuo Handa
> <penguin-kernel@i-love.sakura.ne.jp> wrote:
>>
>> Hello.
> Hi Tetsuo,
>
>> I found that your patch was applied. But since the reproducer tested only 0 byte
>> case, I think that rejecting only less than sizeof(struct htc_frame_hdr) bytes
>> is not sufficient.
>>
>> More complete patch with Ack from Toke is waiting at
>> https://lkml.kernel.org/r/7acfa1be-4b5c-b2ce-de43-95b0593fb3e5@I-love.SAKURA.ne.jp .
>
> Thanks for letting me know! I just checked that your patch indeed
> fixes the issue I am facing.
> If it is more complete, I think we'd indeed better use yours.

FWIW, that patch is just waiting for Kalle to apply it, and I just
noticed this whole thread has used his old email address, so updating
that now as a gentle ping :)

-Toke
