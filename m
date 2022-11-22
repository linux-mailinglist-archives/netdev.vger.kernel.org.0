Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7C1763492D
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 22:24:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234079AbiKVVY1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 16:24:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234338AbiKVVYZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 16:24:25 -0500
Received: from mail-40136.proton.ch (mail-40136.proton.ch [185.70.40.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD56A8221F;
        Tue, 22 Nov 2022 13:24:21 -0800 (PST)
Date:   Tue, 22 Nov 2022 21:24:15 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=n8pjl.ca;
        s=protonmail; t=1669152259; x=1669411459;
        bh=9ofKl9oHCU42v/48JpRRjgnyMPeMwcajH/4A4AXLFDU=;
        h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
         Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
         Message-ID:BIMI-Selector;
        b=ZDAfSB4DCJAH+65PTSJ3aueEoK8pVz5ogbV5wHTi3jbxaGfnx/1sqO+Rw4BRvly2E
         NRicdFIso1eL5xnFS+cuqbwuQwzScQ+bHBgIj0g5o4QVgwQubWdzCylY/gf4Ql51tI
         63Q+329SOkqP+eHgfTfSIFgjeY36TTnvdzEydFmfyhy0lSP2grmMqfgnXEF95/sOLh
         LrSDRFVL4qNi00jVjmkl/aYW1+dP50Fag/ExpbGW/MLrOaZbJtH3H5K5kQeB3GAkm8
         FRM1RPv+EZKouB9k1OJkBYk2IDjJn7HtPKyNfpJtFPwAkfRvClQ4cQb0WTjfnpVNGz
         0qi7dRT16ObNw==
To:     Peter Lafreniere <peter@n8pjl.ca>,
        syzbot <syzbot+4643bc868f47ad276452@syzkaller.appspotmail.com>,
        "syzbot+b25099bc0c49d0c2962e@syzkaller.appspotmail.com" 
        <syzbot+b25099bc0c49d0c2962e@syzkaller.appspotmail.com>
From:   Peter Lafreniere <peter@n8pjl.ca>
Cc:     davem@davemloft.net, edumazet@google.com, jreuter@yaina.de,
        kuba@kernel.org, linux-hams@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, ralf@linux-mips.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] general protection fault in ax25_send_frame (2)
Message-ID: <JJGUy6QkMUNauicWmgsVM8Q7NyGQpFad_3TlRqZsc0lwyR5e2jaNf6--kUKcNBcBpI2ZQ89SC5KtsuboH3g8PgbJqZsgvvVwxd4mKcMDCMk=@n8pjl.ca>
In-Reply-To: <_EStAmQIIbOHjwEqqb54KlnJy9ltngO0A__i8T4sJISE0rRSCaa8TlYBrwJ9AJPxJtrp27MNaXRISYfABlCoIWA1bze3-o2Oblw7PcCdxM4=@n8pjl.ca>
References: <000000000000da093705edbd2ca4@google.com> <_EStAmQIIbOHjwEqqb54KlnJy9ltngO0A__i8T4sJISE0rRSCaa8TlYBrwJ9AJPxJtrp27MNaXRISYfABlCoIWA1bze3-o2Oblw7PcCdxM4=@n8pjl.ca>
Feedback-ID: 53133685:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Does anyone object to marking syzbot bugs
> "general protection fault in {ax25|rose}_send_frame (2)"
> as fixed?

As nobody seems to object to closing these reports:
#syz fix: rose: Fix NULL pointer dereference in rose_send_frame()

- Peter
