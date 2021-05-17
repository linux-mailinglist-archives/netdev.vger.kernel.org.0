Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF797382ADF
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 13:23:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236751AbhEQLYZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 07:24:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236724AbhEQLYY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 07:24:24 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64B90C061756
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 04:23:07 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id o27so5266244qkj.9
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 04:23:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cGXyzC3xCgpRlUaTw4nhuXE8ujIwP8PHRI02BxbUIzk=;
        b=hHnlguesEZvTDV6FOr8biYKXwcmYfPCRrejdnY94HsmRi2/jQTnWUY4HKqmrXf8ozA
         TTjZe/epTZyVJHXPeLl1mpSV0TzB0gxtGp15c8cP8u5caTgj/Z0BDwryv9yU0JgYt/Zi
         VeQZh9Pe4j3DdVPKJAxyHIfONc95kupj3AR2ygeJOk9Py5pZgm3CsfGPq8ODhYpYx6zg
         xMtgAJdMG9IpQr6T/a3G3/GbIfbVnKu6F3qIm6a5xoacOiNBOc9jZW1rar6TCl1wWe8n
         HHRMZYs2AoqT8MOgUGqpdetz8TRZWgNqOVFuGdOTVRHqsx5iyug639wN4Hm2Dy7zHkg+
         rIsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cGXyzC3xCgpRlUaTw4nhuXE8ujIwP8PHRI02BxbUIzk=;
        b=ZWvzrZ8mqZee1xylzsFayR3jq5+UCsmXC6GxDnRw6z28wSwC4Wnm3tHH7EcH8OUiIB
         l/TJv8awcmhT4qT3WZubXXGqkXUdOOd19zGBTx1cEURpS345KwdagU3oU5xBuVC+2CNb
         /mJQqxkDXgikmDd6HQdu8Li8OqFy6tEBvKtqGt2uXfD+rCiy70q5PFgToDpPeGSCw2ZV
         fhSXL6Ql6y2WhkGBhGsFFhjmromTywPh4NnIjhSEyGTRepHVbayFHHiWF6lP5hejH8nq
         BjZlI0hlOZkPY8byBijktsQEm4GTEKNLDAs6NL1ecW4z2z5EwU+YMsTvq7F6Kx+0qW8I
         yRjw==
X-Gm-Message-State: AOAM5336WaM9/mneesdqQnkK2wNL48l3YY3RYmTFSpN2HhCWCZfgz8r9
        48GwSqU1HwQ75THT7rcTd+zCb7MqnfBKAep6Aoe3CQ==
X-Google-Smtp-Source: ABdhPJwgPIEbKldHHF9kAFjl5ptOQnByTRSDuEzK1mg0bz7f2HWmxIgJRgFHN3bsULOZlBTHNecgUD8eHFY2e+kgTlU=
X-Received: by 2002:a37:c20a:: with SMTP id i10mr56682524qkm.350.1621250585598;
 Mon, 17 May 2021 04:23:05 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000005887605c284c0c9@google.com>
In-Reply-To: <00000000000005887605c284c0c9@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Mon, 17 May 2021 13:22:54 +0200
Message-ID: <CACT4Y+YUYhGr9yTmW4ZHYp_Wa6sEoTTwtAD2JSS4kfc-0fcnjA@mail.gmail.com>
Subject: Re: [syzbot] net-next boot error: can't ssh into the instance (4)
To:     syzbot <syzbot+f9386e897a8781058604@syzkaller.appspotmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 17, 2021 at 1:18 PM syzbot
<syzbot+f9386e897a8781058604@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    392c36e5 Merge branch 'ehtool-fec-stats'
> git tree:       net-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=11a7cbf9d00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=a90b0da0842a411c
> dashboard link: https://syzkaller.appspot.com/bug?extid=f9386e897a8781058604
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+f9386e897a8781058604@syzkaller.appspotmail.com


Not sure if this was a flake or not:

[  109.072545][    T1] systemd[1]: Timed out waiting for device
dev-ttyS0.device.
 [K[ [0;1;31m TIME  [0m] Timed out waiting for device dev-ttyS0.device.
[  109.118547][    T1] systemd[1]: Dependency failed for Serial Getty on ttyS0.

but this is very old.

#syz invalid
