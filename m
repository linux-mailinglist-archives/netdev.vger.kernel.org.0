Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3036C1663A5
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 17:59:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728111AbgBTQ7o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 11:59:44 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:51927 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727915AbgBTQ7o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Feb 2020 11:59:44 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 80e2911d
        for <netdev@vger.kernel.org>;
        Thu, 20 Feb 2020 16:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=R+YQb3a1nwlrCF02ELPS2VBuM2I=; b=QDRSuC
        oorhR0jXS2IS0UMxJ1OLtqf464rwkp4JB5BBLYU6xqZocrwQUmiB/Ry/iUvZQOw0
        O55rbKXDjrxjK16O8Y3x24R8jRxV9zyow7XvRFGDPAnsysO+6taYeV241QdbcdRI
        Pn39kxjPunzfv3nuP7O0PD7BpMX1neyniYu4lIIPY4N3TfuRACG5QUbWfoWsDeLE
        6mGtX/+jAKs6PSg4EyhELP0Ubasnuqrwq+3KvH06SZwQjYqg4dJQ7BojAajea1X9
        a9MUxTrk/ST7G7eDPMcyILG/aFaFGrjBMGBEyeYtmXIPewjKd0e5vqxO/YP9KUJi
        UgdmvcKcapgEZbtQ==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 87caa683 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Thu, 20 Feb 2020 16:56:47 +0000 (UTC)
Received: by mail-ot1-f52.google.com with SMTP id r16so4338406otd.2
        for <netdev@vger.kernel.org>; Thu, 20 Feb 2020 08:59:41 -0800 (PST)
X-Gm-Message-State: APjAAAVpN0VZ3Dv6bKsnTRBg3w1Hdeih4s2gNsv4yNxLZnzem7Y6qiGJ
        d0y9jm3nJJNj0rcAtqNu4N7nwFMge0NSIrls5YM=
X-Google-Smtp-Source: APXvYqzbLPhtbX8MPYW8XUtW0agC6diNeNIh5SiOgfGxMndFp5thxDhxsF0q4o2n6pu7FdCLjwqfAP0tLNytgubjFQc=
X-Received: by 2002:a9d:674f:: with SMTP id w15mr24408261otm.243.1582217980756;
 Thu, 20 Feb 2020 08:59:40 -0800 (PST)
MIME-Version: 1.0
References: <20191208232734.225161-1-Jason@zx2c4.com> <CACT4Y+bsJVmgbD-WogwU=LfWiPN1JgjBrwx4s8Y14hDd7vqqhQ@mail.gmail.com>
 <CAHmME9o0AparjaaOSoZD14RAW8_AJTfKfcx3Y2ndDAPFNC-MeQ@mail.gmail.com>
 <CACT4Y+Zssd6OZ2-U4kjw18mNthQyzPWZV_gkH3uATnSv1SVDfA@mail.gmail.com>
 <CAHmME9oM=YHMZyg23WEzmZAof=7iv-A01VazB3ihhR99f6X1cg@mail.gmail.com>
 <CACT4Y+aCEZm_BA5mmVTnK2cR8CQUky5w1qvmb2KpSR4-Pzp4Ow@mail.gmail.com>
 <CAHmME9rYstVLCBOgdMLqMeVDrX1V-f92vRKDqWsREROWdPbb6g@mail.gmail.com>
 <CAHmME9qUWr69o0r+Mtm8tRSeQq3P780DhWAhpJkNWBfZ+J5OYA@mail.gmail.com>
 <CACT4Y+YfBDvQHdK24ybyyy5p07MXNMnLA7+gq9axq-EizN6jhA@mail.gmail.com>
 <CAHmME9qcv5izLz-_Z2fQefhgxDKwgVU=MkkJmAkAn3O_dXs5fA@mail.gmail.com>
 <CACT4Y+arVNCYpJZsY7vMhBEKQsaig_o6j7E=ib4tF5d25c-cjw@mail.gmail.com>
 <CAHmME9ofmwig2=G+8vc1fbOCawuRzv+CcAE=85spadtbneqGag@mail.gmail.com>
 <CACT4Y+awD47=Q3taT_-yQPfQ4uyW-DRpeWBbSHcG6_=b20PPwg@mail.gmail.com>
 <CAHmME9q3_p_BX0BC6=urj4KeWLN2PvPgvGy3vQLFmd=qkNEkpQ@mail.gmail.com>
 <CACT4Y+bSBD_=rmGCF3mngiRKOfa7cv0odFaadF1wyEV9NVhQcg@mail.gmail.com>
 <CAHmME9pQQhQtg8JymxMbSMgnhZ9BpjEoTb=sSNndjp1rXnzi_Q@mail.gmail.com>
 <CAHmME9or-Wwx63ZtwYzOWV9KQJY1aarx2Eh8iF2P--BXfz6u+g@mail.gmail.com>
 <CACT4Y+a8N7_n4t_vxezKJVkd1+gDHaMzpeG18MuDE04+r3341A@mail.gmail.com>
 <CACT4Y+atqrSfZuquPZcRUKNtVbLdu+B5YN3=YmDb38Ruzj3Pzw@mail.gmail.com>
 <CACT4Y+bMzYZeMvv2DdTuTKtJFzTcHhinp7N7VmSiXqSBDyj8Ug@mail.gmail.com>
 <CACT4Y+bUXAstk41RPSF-EQDh7A8-XkTbc53nQTHt4DS5AUhr-A@mail.gmail.com>
 <CAHmME9pr4=cn5ijSNs05=fjdfQon49kyEzymkUREJ=xzTZ7Q7w@mail.gmail.com>
 <CACT4Y+aTBNZAekX_D+QdofqBdUuG9BkzLq+TFDxr8-sSqL9hdQ@mail.gmail.com>
 <CAHmME9pSWRe8k3+4G45tWE9V+N3A9APN5KFq65S5D0JNvR2xxQ@mail.gmail.com> <CACT4Y+ZZM-nW--q6kzKpw4tJ+tmsS=SK13SChtD__r5-k5hH_Q@mail.gmail.com>
In-Reply-To: <CACT4Y+ZZM-nW--q6kzKpw4tJ+tmsS=SK13SChtD__r5-k5hH_Q@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Thu, 20 Feb 2020 17:59:29 +0100
X-Gmail-Original-Message-ID: <CAHmME9pYGETQUrfTX7CQrHA_Z+oVJU0kAYQpaynaAvD8Pq2-hA@mail.gmail.com>
Message-ID: <CAHmME9pYGETQUrfTX7CQrHA_Z+oVJU0kAYQpaynaAvD8Pq2-hA@mail.gmail.com>
Subject: Re: syzkaller wireguard key situation [was: Re: [PATCH net-next v2]
 net: WireGuard secure network tunnel]
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     netdev <netdev@vger.kernel.org>,
        syzbot <syzkaller@googlegroups.com>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 20, 2020 at 5:45 PM Dmitry Vyukov <dvyukov@google.com> wrote:
> If it's aimed only at, say, wireguard netlink interface, then it's not
> distracted by bugs in other parts. But as you add some ipv4/6 tcp/udp
> sockets, more netlink to change these net namespaces, namespaces
> related syscalls, packet injection, etc, in the end it covers quite a
> significant part of kernel. You know how fuzzing works, right. You
> really need to fix the current layer of bugs to get to the next one.
> And we accumulated 600+ open bugs. It still finds some new ones, but I
> guess these are really primitive ones (as compared to its full bug
> finding potential).

Yea, seems reasonable. I need to get a local syzkaller instance set up
for customization and then start patching the things that seem to be
standing in the way. Either way, so long as there isn't some
implementation issue or logical problem getting in the way of calling
that codepath, I'm satisfied in knowing that syzkaller will get there
eventually.
