Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5C1815123E
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 23:14:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbgBCWON (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 17:14:13 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:59759 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726278AbgBCWOM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Feb 2020 17:14:12 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id ce275c51;
        Mon, 3 Feb 2020 22:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=/H9BqmyJrIzZwcBnE3fI2hBkGKo=; b=RjAxq5
        Nsxqfp/FdA5UP4Na502gTN0eJG/kYnAU9BRtAXbaEx4SrZIeIyppybxmN6QRSkue
        RAJaqE+G74mZt+zdc27gBZ6IZL8Rj1lZlMX5F2+cZmfCO9v1QdSkWvkb104ix/P1
        mzDbNV39zUn2gN873dcyayv9Iqwn477LnBGG4RVYY0vJuRviMg4hGVtcHu1vsmDB
        YViTRN61h1U/Rvk2oikAnIY5AGnJPZoJNmrXOXEjObWApEjNG5zeIKrl2FMAmmiP
        wbB3RKLOrrVzrfYilbxZ7YYSRlx85l4scgO+TrgnbhXAtsTDJ1Sw2MFuWv7OQXq/
        hZG6knDSoU66SvIw==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 42bc6591 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Mon, 3 Feb 2020 22:13:26 +0000 (UTC)
Received: by mail-oi1-f179.google.com with SMTP id l9so12565104oii.5;
        Mon, 03 Feb 2020 14:14:09 -0800 (PST)
X-Gm-Message-State: APjAAAUZnogQKU83OntkWFvMdHGo7Rw7F3r7BSiJUnQ6wTrpqintreNe
        eEmsCjHcolzMyYg7mnufYjJZTBkrEFIwRspV/Ws=
X-Google-Smtp-Source: APXvYqwp7qcam9O/XRdahqvcgbjgeryuw1bVl06gmm1cs4737SOYMENp4X9TZNEMW3oUbevECtkq5jnJRebxIB2Z6/g=
X-Received: by 2002:aca:815:: with SMTP id 21mr941298oii.52.1580768048949;
 Mon, 03 Feb 2020 14:14:08 -0800 (PST)
MIME-Version: 1.0
References: <000000000000c8bcba059db3289b@google.com>
In-Reply-To: <000000000000c8bcba059db3289b@google.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 3 Feb 2020 23:13:57 +0100
X-Gmail-Original-Message-ID: <CAHmME9rR=6Vz=N+53vt+MV6rZabkNUsNpyL7YECrVJu__98dxw@mail.gmail.com>
Message-ID: <CAHmME9rR=6Vz=N+53vt+MV6rZabkNUsNpyL7YECrVJu__98dxw@mail.gmail.com>
Subject: Re: possible deadlock in wg_set_device
To:     syzbot <syzbot+42d05aefd7fce69f968f@syzkaller.appspotmail.com>
Cc:     David Miller <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, syzkaller-bugs@googlegroups.com,
        WireGuard mailing list <wireguard@lists.zx2c4.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Looks like the same bug as before. I have a fix in my tree I'll send
out to netdev sometime soon.

Jason
